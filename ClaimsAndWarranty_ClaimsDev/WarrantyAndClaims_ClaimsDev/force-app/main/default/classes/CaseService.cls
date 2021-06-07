public without sharing class CaseService {

    private static final String CANADA = 'Canada';
    private static final String UNITED_STATES = 'United States';
    private static final String COMMERCIAL = 'Commercial';
    private static final String ISO_CA = 'CA';
    private static final String ISO_USA = 'US';
    private static final String base64Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' + 'abcdefghijklmnopqrstuvwxyz' + '0123456789+/';

    private static Map<Id, RecordType> claimRecordTypes;
    public static Map<Id, RecordType> getClaimRecordTypes() {
        if (CaseService.claimRecordTypes == null)
            CaseService.claimRecordTypes = new Map<Id, RecordType>([select Id, Name, DeveloperName from RecordType where SobjectType = 'Case' and Name like '%Claim%']);
        return claimRecordTypes;
    }
    
     
  
    private static User runningUser;
    private static User getRunningUser() {
        if (runningUser == NULL) {
            runningUser = [SELECT Id, Profile.Name, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId()];
        }
        return runningUser;
    }

    /*
        SECURITY METHODS
    */

    /*
        Block all updates for Case when the Claim_Stage__c is Closed, *unless* it is being re-opened
    */
    public static void blockCaseUpdate(List<Case> records, Map<Id, Case> oldRecords) {
        User runningUser = getRunningUser();

        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        for (Case c : records) {
            if (claimRecordTypes.get(c.RecordTypeId) <> null) {
                 if (oldRecords.get(c.Id).Claim_Stage__c == 'Closed' &&
                        c.Re_Open_Date_Time__c == oldRecords.get(c.Id).Re_Open_Date_Time__c &&
                      FeatureManagement.checkPermission('Can_Update_Closed_Cases') == false) {
//              2020-04-20 This use exemption used to be based on Profile. This is a very bad idea. 
//                        runningUser.Profile.Name != 'System Administrator') {
                    c.addError('This case is closed and cannot be updated');
                }
            }
        }
    }

    /*
        Security: Ensure that Claim Case cannot be deleted
    */
    public static void blockClaimCaseDeletion(List<Case> records) {
        User runningUser = getRunningUser();

        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        for (Case c : records) {
            if (claimRecordTypes.get(c.RecordTypeId) <> null &&
                    runningUser.Profile.Name != 'System Administrator')
                c.addError('Claim Cases cannot be deleted');
        }
    }

    /*
        Custom Duplicate Check (Duplicate/Matching Rules not supported for Cases)
        - do not allow a subsequent Case (Record Type = Residential CLaim) for a given Account
            - exception - allow Child cases of the original parent case
            - exception - Case.Account is a Distributor/US Distributor/Residential Account
    */
    public static void catchDuplicate(List<Case> records) {

        Set<Id> accountIds = new Set<Id>();
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        for (Case c : records)
            if (
                    c.ParentId == null &&
                            claimRecordTypes.get(c.RecordTypeId) <> null &&
                            claimRecordTypes.get(c.RecordTypeId).Name == 'Residential Claim'
                    )
                accountIds.add(c.AccountId);

        if (accountIds.isEmpty())
            return;

        /*
            For the related Account(s), retrieve existing parent 'Residential Claim' Cases
        */
        Map<Id, Case> accountCaseMap = new Map<Id, Case>();
        Map<Id, Case> decraAccountCaseMap = new Map<Id, Case>();
        for (Case c : [
                SELECT Id, AccountId, Claim_Number__c, Sector__c
                FROM Case
                WHERE AccountId IN :accountIds AND
                ParentId = NULL AND
                Account.RecordType.Name <> 'Distributor' AND
                Account.RecordType.Name <> 'US Distributor' AND
                Account.RecordTYpe.Name <> 'Residential Account' AND
                Case.RecordType.Name = 'Residential Claim'
        ]){
             //CLAIMSV2-890-- Adding Decra case here 
            if(c.Sector__c == 'Decra'){
                decraAccountCaseMap.put(c.AccountId, c);
                
            }else{
                accountCaseMap.put(c.AccountId, c);
            }   
        }
        /*
            If an existing 'Residential Claim' Case is present, block creation of new Case
        */
        for (Case c : records) {
            if (c.ParentId == null && claimRecordTypes.get(c.RecordTypeId) <> null &&
                    claimRecordTypes.get(c.RecordTypeId).Name == 'Residential Claim')
            {
                /*
                   CLAIMSV2-890--If the 'Decra' case exists for the location, block creation of new cases and giving error
                */
                if(c.Sector__c == 'Decra'){

                    if (decraAccountCaseMap.get(c.AccountId) <> null && decraAccountCaseMap.get(c.AccountId).Id <> c.Id && !System.Test.isRunningTest()) {
                        c.addError('There is an existing Case, ' +
                        decraAccountCaseMap.get(c.AccountId).Claim_Number__c +
                            ', that exists for this location; please navigate to the Case and if a new investigation is required, use the New Child Case action');
                    }

                }else{
                    /*
                        If the 'Non-Decra' case exists for the location, block creation of new cases and giving error
                    */

                    if (accountCaseMap.get(c.AccountId) <> null && accountCaseMap.get(c.AccountId).Id <> c.Id && !System.Test.isRunningTest()) {
                        c.addError('There is an existing Case, ' +
                        accountCaseMap.get(c.AccountId).Claim_Number__c +
                                ', that exists for this location; please navigate to the Case and if a new investigation is required, use the New Child Case action');
                    }
                }         
            }
        }
    }
    /*
        TRIGGERED FIELD UPDATES
    */

    /*
        Writes to 3 user lookup fields to determine who the approvers should be
        for a goodwill case.

        Based on the user who created the case. If the user who created the
        case is not a sales user in the US the approval will fail as Goodwill doesn't apply.

        We can’t simply use the Manager field, since approvals are role-based,
        and the running user’s manager may not fit that role
        (so may have to look up the hierarchy to their manager)
    */
    public static void setGoodwillHierarchy(List<Case> records) {
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        List<Case> goodwillCases = new List<Case>();

        for (Case c : records)
            if (claimRecordTypes.get(c.RecordTypeId) <> null &&
                    claimRecordTypes.get(c.RecordTypeId).Name == 'Residential Claim' &&
                    c.Sector__c == 'US' && c.GoodwillClaimAmount__c > 0 && (c.Goodwill_Approval_Director__c == null ||
                    c.Goodwill_Approval_VP__c == null ||
                    c.Goodwill_Approval_Manager__c == null)) {
                goodwillCases.add(c);
            }

        if (goodwillCases.isEmpty())
            return;

        List<Id> creatorIds = new List<Id>();
        for (Case c : goodwillCases)
            creatorIds.add(c.CreatedById);

        Map<Id, User> userMap = new Map<Id, User>([
                SELECT Id, Profile.Name, UserRole.Name, ManagerId, Manager.UserRole.Name, Manager.ManagerId, Manager.Manager.ManagerId, Manager.Manager.Manager.ManagerId
                FROM User
                WHERE Id IN :creatorIds
        ]);

        /**
         * ClaimsV2-926
         * By Anil Mannem(Incloud) on 16-Jun-2020
         * Added logic to assign users in a way that Approval Hierarchy was assigned properly based on the users manager.
         */
        if (!userMap.isEmpty()) {
            for (Case c : goodwillCases) {
                User u = userMap.get(c.CreatedById);
                if (u.Profile.Name.contains('USRS')) {
                    if (u.Manager.UserRole.Name <> null) {
                        if (u.UserRole.Name.contains('TSR')
                         && u.UserRole.Name != 'TSR Leetland' ) {
                            c.Goodwill_Approval_Manager__c = u.ManagerId;
                            c.Goodwill_Approval_Director__c = u.Manager.ManagerId;
                            c.Goodwill_Approval_VP__c = u.Manager.Manager.ManagerId;
                        } 
                        if (u.UserRole.Name.contains('DSM')
                         && u.UserRole.Name != 'DSM Leetland' 
                         || u.UserRole.Name == 'TSR Leetland') {
                            c.Goodwill_Approval_Manager__c = u.Id;
                            c.Goodwill_Approval_Director__c = u.ManagerId;
                            c.Goodwill_Approval_VP__c = u.Manager.ManagerId;
                        }
                        if (u.UserRole.Name.contains('RSM')
                         || u.UserRole.Name.contains('NAM') 
                         || u.UserRole.Name == 'DSM Leetland') {
                            c.Goodwill_Approval_Director__c = u.Id;
                            c.Goodwill_Approval_VP__c = u.ManagerId;
                        }
                        if (u.UserRole.Name.equals('VP Sales East')
                         || u.UserRole.Name.equals('VP Sales West')) {
                            c.Goodwill_Approval_VP__c = u.Id;
                        }
                    } else {
                        System.debug('have a problem - no role!');
                    }
                }
            }
        }


    }

    /*
        Set Status to Closed when Claim_STage__c = Closed
    */
    public static void closeClaimCase(List<Case> records, Map<Id, Case> oldRecords) {
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();

        for (Case c : records)
            if (claimRecordTypes.get(c.RecordTypeId) <> null)
                if (c.Claim_Stage__c == 'Closed' && oldRecords.get(c.Id).Claim_Stage__c <> 'Closed')
                    c.Status = 'Closed';
    }
    /*
        CLAIMSV2-890
        Vivek Bobba- Incloud
        Using this method we are validating that If the case sector is decra then we are allowing only decra distributer,  contracor, account and contacts 
    */
    public static void checkValidationForDecra(List<Case> cases, Map<Id, Case> oldCaseMap, Boolean isCreate){

        set<Id> accountIds = new Set<Id>();
        set<Id> contactIds = new Set<Id>();
        Map<Id, Account> accountsMap = new Map<Id, Account>();
        Map<Id, Contact> contactsMap = new Map<Id, Contact>();
        List<Case> casesToProcess = new List<Case>();
        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        
        for(Case caseObj : cases){
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
            if (claimRecordTypes.get(caseObj.RecordTypeId) <> null)
            {
                 if(isCreate){
                    if(caseObj.Origin == 'Distributor'){
                        if(caseObj.Distributor__c != null){
                            accountIds.add(caseObj.Distributor__c);
                        }
                        casesToProcess.add(caseObj);
                    }                  
                } else if(oldCaseMap != null || (oldCaseMap.get(caseObj.Id).Distributor__c != caseObj.Distributor__c 
                                        || oldCaseMap.get(caseObj.Id).Contractor__c != caseObj.Contractor__c 
                                        || oldCaseMap.get(caseObj.Id).Alternate_Contact__c != caseObj.Alternate_Contact__c 
                                        || oldCaseMap.get(caseObj.Id).ContactId != caseObj.ContactId  
                                        || oldCaseMap.get(caseObj.Id).AccountId != caseObj.AccountId ))
                {
                    if(caseObj.Distributor__c != null){
                        accountIds.add(caseObj.Distributor__c);
                    }
                    if(caseObj.Contractor__c != null){
                        accountIds.add(caseObj.Contractor__c);
                    }
                    if(caseObj.Alternate_Contact__c != null){
                        contactIds.add(caseObj.Alternate_Contact__c);
                    }
                    if(caseObj.ContactId != null){
                        contactIds.add(caseObj.ContactId);
                    }
                    if(caseObj.AccountId != null){
                        accountIds.add(caseObj.AccountId);
                    }
                    casesToProcess.add(caseObj);
                }
        	}
        }

        if(!accountIds.isEmpty()){
            accountsMap = new Map<Id, Account>([SELECT Id, Iko_Division_Visible_To__c FROM Account WHERE Id IN :accountIds]);
        }
        if(!contactIds.isEmpty()){
            contactsMap = new Map<Id, Contact>([SELECT Id, Account.Iko_Division_Visible_To__c, AccountId FROM Contact WHERE Id IN :contactIds]);
        }
		
        if(casesToProcess.isEmpty())
            return;
        
        for(Case caseObj : casesToProcess){
            if(!String.isBlank(caseObj.Sector__c)){
                if(caseObj.Sector__c == 'Decra' ){
                    if(caseObj.Distributor__c != null){
                        if(accountsMap.get(caseObj.Distributor__c).Iko_Division_Visible_To__c != 'Decra'){
                            caseObj.addError('Please select decra Distributor');
                        }
                    }
                    if(!isCreate){
                        if(caseObj.Contractor__c != null){
                            if(accountsMap.get(caseObj.Contractor__c).Iko_Division_Visible_To__c != 'Decra'){
                                caseObj.addError('Please select decra Contractor');
                            }
                        }
                        if(caseObj.Alternate_Contact__c != null){
                            if(contactsMap.get(caseObj.Alternate_Contact__c).AccountId != null && contactsMap.get(caseObj.Alternate_Contact__c).Account.Iko_Division_Visible_To__c != 'Decra'){
                                caseObj.addError('Please select decra Alternate Contact');
                            }
                        }
                        if(caseObj.ContactId != null){
                            if(contactsMap.get(caseObj.ContactId).AccountId != null && contactsMap.get(caseObj.ContactId).Account.Iko_Division_Visible_To__c != 'Decra'){
                                caseObj.addError('Please select decra Contact');
                            }
                        }
                        if(caseObj.AccountId != null){
                            if(accountsMap.get(caseObj.AccountId).Iko_Division_Visible_To__c != 'Decra'){
                                caseObj.addError('Please select decra Account');
                            }
                        }
                    }
                }else{
                    if(caseObj.Distributor__c != null){
                        if(accountsMap.get(caseObj.Distributor__c).Iko_Division_Visible_To__c == 'Decra'){
                            caseObj.addError('Please select non decra Distributor');
                        }
                    }
                    if(!isCreate){
                        if(caseObj.Contractor__c != null){
                            if(accountsMap.get(caseObj.Contractor__c).Iko_Division_Visible_To__c == 'Decra'){
                                caseObj.addError('Please select non decra Contractor');
                            }
                        }
                        if(caseObj.Alternate_Contact__c != null){
                            if(contactsMap.get(caseObj.Alternate_Contact__c).AccountId != null && contactsMap.get(caseObj.Alternate_Contact__c).Account.Iko_Division_Visible_To__c == 'Decra'){
                                caseObj.addError('Please select non decra Alternate Contact');
                            }
                        }
                        if(caseObj.ContactId != null){
                            if(contactsMap.get(caseObj.ContactId).AccountId != null && contactsMap.get(caseObj.ContactId).Account.Iko_Division_Visible_To__c == 'Decra'){
                                caseObj.addError('Please select non decra Contact');
                            }
                        }
                        if(caseObj.AccountId != null){
                            if(accountsMap.get(caseObj.AccountId).Iko_Division_Visible_To__c == 'Decra'){
                                caseObj.addError('Please select non decra Account');
                            }
                        }
                    }
                }
            }
        }
    }

    /*
        Security: whoever is submitting the approval process is not the same as the person approving
    */
    public static void blockSelfApprovalOfClaim(List<Case> records, Map<Id, Case> oldRecords, Map<Id, Case> newRecords) {
        List<Id> caseIds = new List<Id>();
        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        for (Case c : records) {
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
            if (claimRecordTypes.get(c.RecordTypeId) <> null && c.ClaimApproved__c && c.ClaimApproved__c <> oldRecords.get(c.Id).ClaimApproved__c) {
                caseIds.add(c.Id);
            }
        }

        if (caseIds.isEmpty())
            return;

        // Retrieve list of ProcessInstance that shows who is the original submitter
        List<ProcessInstance> lstProcessInstance = [
                SELECT TargetObjectId, SubmittedById
                FROM ProcessInstance
                WHERE TargetObjectId IN:caseIds
                ORDER BY CreatedDate DESC
                LIMIT 1
        ];

        for (ProcessInstance pi : lstProcessInstance) {
            // Add error message of trying to self-approve an offer
            if (pi.SubmittedById == UserInfo.getUserId()) {
                newRecords.get(pi.TargetObjectId).addError('Submitters cannot approve their own records');
            }
        }
    }

    /*
        Security: Ensure the ClaimsApprover__c and Claim_Approver_Id__c are in sync;
        this is done as part of the Approval Process, which can't write to a User lookup, so writes to a text field instead
    */
    public static void updateClaimApprover(List<Case> records, Map<Id, Case> oldRecords) {
        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        for (Case c : records)
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
            if (claimRecordTypes.get(c.RecordTypeId) <> null && c.Claim_Approver_Id__c <> oldRecords.get(c.Id).Claim_Approver_Id__c){
               c.ClaimsApprover__c = c.Claim_Approver_Id__c;
            }
    }
    /*
        * ClaimsV2-980
        * By Vivek Bobba(Incloud)
        *  assigning the LabourRate to Zero if we do not have a record with sector and pitch values in the labourRateMap
        */
    public static void setLabourRate(List<Case> cases) {
        List<Case> labourCases = new List<Case>();
        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        for (Case c: cases){
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
            if(claimRecordTypes.get(c.RecordTypeId) <> null){
               if (c.Settlement_Type__c == 'Cash Settlement - Material Only') {
                    c.Labour_Rate__c = 0;
                    c.Actual_Labour_Rate__c = null;
                } else if (!String.isBlank(c.Pitch__c)) {
                    labourCases.add(c);
                } else {
                    //IF pitch value is none
                    c.Labour_Rate__c = 0;
                	}
            	}
	       }
    
        if (labourCases.isEmpty())
            return;
    
        Map <String, Decimal> labourRateMap = new Map <String, Decimal> ();
        for (Labour_Rate__mdt labourRate: [select Id, Label, MasterLabel, Pitch__c, Sector__c, Rate__c from Labour_Rate__mdt where Active__c = true LIMIT 2000])
            labourRateMap.put(labourRate.Label, labourRate.Rate__c);
    
        for (Case c: labourCases)
            if (labourRateMap.get(c.Pitch__c + '-' + c.Sector__c) <> null)
                c.Labour_Rate__c = labourRateMap.get(c.Pitch__c + '-' + c.Sector__c);
            else 
                c.Labour_Rate__c = 0;
    }
    
    /**
     * ClaimsV2-1010
     * By Anil Mannem (Incloud)
     * Added method to update tax rates as soon as Account Billing State updated
     */
    public static void updateTaxRateOnBillingStateChange(List<Account> newAccounts, Map<Id, Account> oldAccountMap){
        Set<Id> accountIdSet = new Set<Id>();
        for(Account thisAccount : newAccounts){
            if((thisAccount.BillingStateCode != oldAccountMap.get(thisAccount.Id).BillingStateCode) || thisAccount.BillingStateCode == null){
                accountIdSet.add(thisAccount.Id);
            }
        }
        if(!accountIdSet.isEmpty()){
            List<Case> casesList = [SELECT  ID,
                                            AccountId,
                                            Account_State_Province__c,
                                            Installation_Date__c,
                                            RecordTypeId,
                                            Tax_Rate__c,
                                            Secondary_Tax_Rate__c,
                                            Taxes_Additive__c
                                    FROM Case
                                    WHERE AccountId IN :accountIdSet];
            if(!casesList.isEmpty()){
                Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
                List<Case> taxCases = new List<Case>();
                List<Case> casesWithNoBillingState = new List<Case>();
                Set<Id> accountIds = new Set<Id>();
        
                for (Case c : casesList) {
                    if (claimRecordTypes.get(c.RecordTypeId) <> null) {
                        if (c.Account_State_Province__c != null) {
                            taxCases.add(c);
                            accountIds.add(c.AccountId);
                        } else {
                            c.Tax_Rate__c = 0;
                            c.Secondary_Tax_Rate__c = 0;
                            c.Taxes_Additive__c = true;
                            casesWithNoBillingState.add(c);
                        }
                    }
                }

                if(!casesWithNoBillingState.isEmpty()){
                    update casesWithNoBillingState;
                }

                if (!taxCases.isEmpty()) {
                    Map<String, List<Tax_Rate__mdt>> stateTaxes = new Map<String, List<Tax_Rate__mdt>>();
                    for (Tax_Rate__mdt taxRate : [SELECT Id,
                                                         Taxes_Additive__c,
                                                         Start_Date__c,
                                                         End_Date__c,
                                                         State_Province_Code__c,
                                                         Primary_Rate__c,
                                                         Secondary_Rate__c
                                                    FROM Tax_Rate__mdt]) {
                        List<Tax_Rate__mdt> taxList = (stateTaxes.get(taxRate.State_Province_Code__c) <> null) ?
                                                                stateTaxes.get(taxRate.State_Province_Code__c) : new List<Tax_Rate__mdt>();
                        taxList.add(taxRate);
                        stateTaxes.put(taxRate.State_Province_Code__c, taxList);
                    }
            
                    Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, BillingStateCode FROM Account WHERE Id = :accountIds]);
            
                    for (Case c : taxCases) {
                        if (stateTaxes.get(accountMap.get(c.AccountId).BillingStateCode) <> null) {
                            for (Tax_Rate__mdt tr : stateTaxes.get(accountMap.get(c.AccountId).BillingStateCode)) {
                                Date startDate = tr.Start_Date__c <> null ? tr.Start_Date__c : Date.today().addYears(-2000);
                                Date endDate = tr.End_Date__c <> null ? tr.End_Date__c : Date.today().addYears(2000);
                                if (c.Installation_Date__c >= startDate && c.Installation_Date__c < endDate) {
                                    c.Tax_Rate__c = (tr.Primary_Rate__c <> null) ? tr.Primary_Rate__c : 0 ;
                                    c.Secondary_Tax_Rate__c = (tr.Secondary_Rate__c <> null) ? tr.Secondary_Rate__c : 0;
                                    c.Taxes_Additive__c = tr.Taxes_Additive__c;
                                    continue;
                                }
                            }
                        } else {
                            c.Tax_Rate__c = 0;
                            c.Secondary_Tax_Rate__c = 0;
                            c.Taxes_Additive__c = true;  //ClaimsV2-1010, by Anil Mannem(Incloud), changed value from false to true
                        }
                    }
                    update taxCases;
                }
            }
        }
    }

    /*
        Set a Tax Rate based on the Account's State Code
        - sets a Primary and Secondary Tax Rate on a Case based on the Account's Province/State
        - uses the Tax_Rate__mdt custom metadata
        - leverages the appropriate Tax Rate for the Installation Date of the product

        For the state of Washington, only the primary tax rate is stored and
        applied automatically.
        The localized tax (for the 4-digit local zip code) can be applied
        manually (this is due to the volume of these tax rates).
        If Iko starts applying labour and taxes to other states,
        it would be worthwhile investigating an Appexchange service to manage this.
    */
    public static void setTaxRate(List<Case> records, Map<Id, Case> oldRecords) {
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        List<Case> taxCases = new List<Case>();
        Set<Id> accountIds = new Set<Id>();

        for (Case c : records) {
            if (claimRecordTypes.get(c.RecordTypeId) <> null) {
                if ( c.AccountId != null && c.Installation_Date__c <> null &&
                     (c.Tax_Rate__c == null || (oldRecords <> null && c.Installation_Date__c <> oldRecords.get(c.Id).Installation_Date__c))) { //Condition simplified and updated
                         taxCases.add(c);
                         accountIds.add(c.AccountId);
                } else if (c.AccountId != null && c.Installation_Date__c == null) {
                    c.Tax_Rate__c = 0;
                    c.Secondary_Tax_Rate__c = 0;
                    c.Taxes_Additive__c = true;
                }
            }
        }
        if (taxCases.isEmpty()) {
            return;
        }

        Map<String, List<Tax_Rate__mdt>> stateTaxes = new Map<String, List<Tax_Rate__mdt>>();
        for (Tax_Rate__mdt taxRate : [
                SELECT Id, Taxes_Additive__c, Start_Date__c, End_Date__c, State_Province_Code__c, Primary_Rate__c, Secondary_Rate__c
                FROM Tax_Rate__mdt
        ]) {
            List<Tax_Rate__mdt> taxList = (stateTaxes.get(taxRate.State_Province_Code__c) <> null) ?
                    stateTaxes.get(taxRate.State_Province_Code__c) : new List<Tax_Rate__mdt>();
            taxList.add(taxRate);
            stateTaxes.put(taxRate.State_Province_Code__c, taxList);
        }

        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, BillingStateCode FROM Account WHERE Id = :accountIds]);

        for (Case c : taxCases) {
            if (stateTaxes.get(accountMap.get(c.AccountId).BillingStateCode) <> null) {
                for (Tax_Rate__mdt tr : stateTaxes.get(accountMap.get(c.AccountId).BillingStateCode)) {
                    Date startDate = tr.Start_Date__c <> null ? tr.Start_Date__c : Date.today().addYears(-2000);
                    Date endDate = tr.End_Date__c <> null ? tr.End_Date__c : Date.today().addYears(2000);
                    if (c.Installation_Date__c >= startDate && c.Installation_Date__c < endDate) {
                        c.Tax_Rate__c = (tr.Primary_Rate__c <> null) ? tr.Primary_Rate__c : 0 ;
                        c.Secondary_Tax_Rate__c = (tr.Secondary_Rate__c <> null) ? tr.Secondary_Rate__c : 0;
                        c.Taxes_Additive__c = tr.Taxes_Additive__c;
                        continue;
                    }
                }
            } else {
                c.Tax_Rate__c = 0;
                c.Secondary_Tax_Rate__c = 0;
                c.Taxes_Additive__c = true;  //ClaimsV2-1010, by Anil Mannem(Incloud), changed value from false to true
            }
        }
    }

    /*
        When the Product__c value is changed and the Settlement_Type__c = 'Manual Calculation',
        we need to clear the override fields and reset the Settlement_Type__c to Default to try to capture the normal calculations
    */
    public static void resetSettlementTypeToDefault(List<Case> records, Map<Id, Case> oldRecords) {
        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        for (Case c : records) {
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
            if (claimRecordTypes.get(c.RecordTypeId) <> null){
                    if (c.Settlement_Type__c == 'Manual Calculation' && (
                        c.Product__c <> oldRecords.get(c.Id).Product__c || c.Installation_Date__c <> oldRecords.get(c.Id).Installation_Date__c)) {
                    c.Settlement_Type__c = 'Default';
                    c.Actual_Labour_Rate__c = null;
                    c.Actual_Labour_Settlement__c = null;
                    c.Num_of_Bundles_for_Settlement__c = null;
                    c.Settlement_Amount__c = null;
                }
            }
        }
    }

    /*
        ASSIGNMENT HELPERS
    */

    /*
        Reset the Claim Case to the appropriate queue after an update;
        exclude update where the owner is changed from a queue to a user

        Used as a failsafe to ensure a Claims Rep doesn’t hold onto a Case
        record after finishing with it, when the Claim Stage or
        Claim Sub Stage is changed, a @future method is called to run the
        Case Assignment rules to send the Case back to the appropriate queue
        based on the Record Type / Sector.
    */
    public static Boolean assignmentRulesRun = false;
    public static void resetClaimCaseOwnerToQueue(List<Case> records, Map<Id, Case> oldRecords) {
        List<Case> claimRecords = new List<Case>();
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        for (Case c : records) {
            if (claimRecordTypes.get(c.RecordTypeId) <> null && (c.Claim_Stage__c <> oldRecords.get(c.Id).Claim_Stage__c ||
                    c.Claim_Sub_Stage__c <> oldRecords.get(c.Id).Claim_Sub_Stage__c))
                claimRecords.add(c);
        }

        if (claimRecords.isEmpty())
            return;
        CaseService.runAssignmentRules(records, oldRecords);
    }

    public static void runAssignmentRules(List<Case> records, Map<Id, Case> oldRecords) {
        if (!CaseService.assignmentRulesRun) {
            AssignmentRule caseAssignmentRule = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId = caseAssignmentRule.id;
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
			Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
            
            Set<Id> caseIds = new Set<Id>();
            for (Case c : records)
            {
                /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
                if (claimRecordTypes.get(c.RecordTypeId) <> null){
                   	caseIds.add(c.Id);
                }
            }

            if (!caseIds.isEmpty())
                futureCaseReassign(caseIds);
        }
    }

    @future
    public static void futureCaseReassign(Set<Id> caseIds) {
        List<Case> caseList = [
                SELECT Id, ParentId, Claim_Number__c, Legacy_External_Id__c
                FROM Case
                WHERE Id IN:caseIds AND Claim_Stage__c <> 'Closed'
        ];

        for (Case c : caseList) {
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;
            c.setOptions(dmo);
        }
        CaseService.assignmentRulesRun = true;

        try {
            update(caseList);
        } catch (DmlException e) {
            System.debug('It is breaking right here');
        }
    }

    /*
        Ensure Case is sent to correct queue on submission, in case the user doesn't check off the 'run assignment rules' checkbox
    */
    public static void sendCaseToQueueOnSubmission(List<Case> records, Map<Id, Case> oldRecords) {
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();

        List<Case> commercialClaims = new List<Case>();
        List<Case> residentialClaims = new List<Case>();
        List<Case> blairHyloadClaims = new List<Case>();

        for (Case c : records) {
            if (
                    claimRecordTypes.get(c.RecordTypeId) <> null &&
                            c.Claim_Stage__c <> 'Draft' && oldRecords.get(c.Id).Claim_Stage__c == 'Draft'
                    ) {
                if (c.Sector__c == 'Blair' || c.Sector__c == 'Hyload')
                    blairHyloadClaims.add(c); else if (claimRecordTypes.get(c.RecordTypeId).Name == 'Commercial Claim')
                    commercialClaims.add(c); else
                        residentialClaims.add(c);
            }
        }

        if (blairHyloadClaims.isEmpty() && commercialClaims.isEmpty() && residentialClaims.isEmpty())
            return;

        Map<String, Group> groupMap = new Map<String, Group>();
        for (Group g : [select Id, DeveloperName from Group where Type = 'Queue' and DeveloperName IN ('Commercial_Claims', 'Residential_Claims', 'Blair_Hyload_Claims')])
            groupMap.put(g.DeveloperName, g);

        for (Case c : blairHyloadClaims)
            c.OwnerId = groupMap.get('Blair_Hyload_Claims').Id;
        for (Case c : commercialClaims)
            c.OwnerId = groupMap.get('Commercial_Claims').Id;
        for (Case c : residentialClaims)
            c.OwnerId = groupMap.get('Residential_Claims').Id;
    }

    /**
    @AuraEnabled
    public static String getExpressTokenWrapper() {
        return MDPersonator.MD_ExpressEntry.getExpressToken();
    }

    @AuraEnabled
    public static String getResponseWrapper(String request)
        return MDPersonator.MD_ExpressEntry.getResponse(request);
    }
    **/

    /*
        Creates a draft Claim Case, by creating an Account, Contact, and Case record

            Note: we are wrapping the MDPersonator.MD_ExpressEntry call in a try/catch block, as Duplicate rules can cause an error,
            and the class does not handle this gracefully itself
            If an error is thrown, we will search the error to determine if it is due to a duplicate rule, and pull
            the Account Id in the error string to reference within the Case
    */
    @AuraEnabled
    public static Case createClaimDraft(String street, String fieldMap, Case c, 
                                        String contactSalutation, String contactFirstName, String contactLastName, 
                                        String contactOfInterest,
                                        Boolean addressVerified) 
    {
        
        if((c.Origin == 'Contractor' || c.Origin == 'Builder' ) &&  
            (c.Contractor__c != null || c.Builder__c != null ) && 
            String.isNotBlank(contactOfInterest) && c.Contact_of_Interest__c == null)
            {
                throw new AuraHandledException('Please select from the existing contacts');
        }   

        if( c.Origin == 'Distributor' &&  c.Distributor__c != null && String.isNotBlank(contactOfInterest) && c.ContactId == null){
            throw new AuraHandledException('Please select from the existing contacts');
        }

        if((c.Origin == 'Contractor' || c.Origin == 'Builder' ) &&  
            ((c.Contractor__c != null || c.Builder__c != null ) && 
            (c.Contact_of_Interest__c == null && String.isBlank(contactLastName) ) )){
            throw new AuraHandledException('Please select a contact or Home Owner Information');
        }
        if (c.Origin == 'Distributor') {
            if (c.Distributor__c == null)
                throw new AuraHandledException('A Distributor is required to enter for a Draft Claim Case'); 
            else
                    c.AccountId = c.Distributor__c;
            if(c.ContactId == null){
                throw new AuraHandledException('Please select distributor contact'); 
            }
        } else {
            c = CaseService.initClaimCaseDraftAccount(street, fieldMap, c, addressVerified);
        }

        Account aCheck = [
                SELECT Id, BillingStreet, BillingCity, BillingCountry, BillingCountryCode, BillingState,
                        Address_Verification_Status__c, RecordType.Name
                FROM Account
                WHERE Id = :c.AccountId
        ];

        /*
            CLAIMSV2-990
            Vivek Bobba- Incloud    
            Wrapper to call static MDPERSONATOR.MD_ExpressEntry - String updateRecord(Id recordId, String fieldMap)
        */
        String contactName = '';
        if (c.ContactId == null && String.isBlank(contactLastName) && (c.Contact_of_Interest__c == null && String.isBlank(contactOfInterest) && contactOfInterest.split(' ').size() < 2)){
            throw new AuraHandledException('A contact or Contact of Interest is required to enter for a Draft Claim Case');
        }else{
            if(c.Origin != 'Distributor'){
                contactName += String.isBlank(contactSalutation) ? '' : contactSalutation;
                contactName += String.isBlank(contactFirstName) ? '' : contactFirstName;
                contactName += String.isBlank(contactLastName) ? '' : contactLastName;

                if(String.isNotBlank(contactOfInterest) && (c.Contact_of_Interest__c == null && String.isBlank(contactOfInterest) && contactOfInterest.split('').size() > 2)){
                    List<String> contactOfInterests = contactOfInterest.split(' ');
                    String lastName = contactOfInterests[contactOfInterests.size() - 1];
                    contactOfInterests.remove(contactOfInterests.size() - 1);
                    String firstName = String.join(contactOfInterests, ' ');
                    Contact caseContact = new Contact(AccountId = c.AccountId,
                        FirstName = firstName,
                        LastName = lastName,
                        RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Claim Homeowner').getRecordTypeId()
                    );
                    insert caseContact;
                    c.Contact_of_Interest__c = caseContact.Id;
                }

                if(String.isNotBlank(contactName)){
                    List<Contact> contacts = [SELECT Id FROM Contact WHERE Name = : contactName AND AccountId = :c.AccountId];
                    
                    if(!contacts.isEmpty()){
                        throw new AuraHandledException('Contact already exists with this name');
                    }
                }else{
                    //if(c.Contact_of_Interest__c == null){
                        c.ContactId = c.Contact_of_Interest__c;
                    //}
                }
            }            
        }
        if (aCheck.RecordType.Name.contains('Distributor') || aCheck.RecordType.Name.contains('Designer')) {
            c.Distributor__c = aCheck.Id;
        } else if (aCheck.RecordType.Name.contains('Contractor')) {
            c.Contractor__c = aCheck.Id;
        }

        if (c.ContactId == null) {
            try {
                /*List<String> contactNames = contactName.split(' ');
                String lastName = contactNames[contactNames.size() - 1];
                contactNames.remove(contactNames.size() - 1);
                String firstName = String.join(contactNames, ' ');*/
                Contact caseContact = new Contact(AccountId = c.AccountId,
                                                  FirstName = contactFirstName,
                                                  LastName = contactLastName,
                                                  Salutation = contactSalutation,
                                                  RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Claim Homeowner').getRecordTypeId()
                                                 );
                insert caseContact;
                c.ContactId = caseContact.Id;
            } catch (DmlException e) {
                throw new AuraHandledException(e.getMessage());
            }
        }

        try {
            insert c;
        } catch (DmlException e) {
            throw new AuraHandledException(e.getMessage());
        }
        return c;
    }

    public static Case initClaimCaseDraftAccount(String street, String fieldMap, Case claimCase, Boolean addressVerified) {
        List<Id> duplicateAccountIds = new List<Id>();
        Id accountId = NULL;

        Id buildingLocatoinRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        mdAddressFields fields = (mdAddressFields) JSON.deserializeStrict(fieldMap, mdAddressFields.class);

        Account newClaimAccount = new Account(
                Name = street,
                BillingStreet = street,
                BillingCountryCode = fields.BillingCountryCode,
                BillingStateCode = fields.BillingStateCode,
                BillingPostalCode = fields.BillingPostalCode,
                BillingCity = fields.BillingCity,
                RecordTypeId = buildingLocatoinRecordTypeId,
                Iko_Division_Visible_To__c = claimCase.Sector__c,
                Address_Verification_Status__c = 'Pending', // initialize as in verification while melissadata update runs, to avoid approval process locking
                SYS_IsNewClaimCaseAccount__c = true, // indicate that the account record is created from the NewClaimCase tab.
            	Record_Type_Family__c = ''
        );

        Database.SaveResult saveResult = Database.insert(newClaimAccount, false);

        if (!saveResult.isSuccess()) {
            for (Database.Error error : saveResult.getErrors()) {
                if (error instanceof Database.DuplicateError) {
                    Database.DuplicateError duplicateError = (Database.DuplicateError) error;
                    Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();

                    Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                    Datacloud.MatchResult matchResult = matchResults[0];

                    Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();

                    for (Datacloud.MatchRecord matchRecord : matchRecords) {
                        duplicateAccountIds.add((Id) matchRecord.getRecord().get('Id'));
                    }
                }
            }

            if (!duplicateAccountIds.isEmpty()) {
                accountId = duplicateAccountIds[0];
            }            
        } else {
            newClaimAccount.Address_Verification_Status__c = (addressVerified) ? 'Verified' : null;
            accountId = newClaimAccount.Id;           
            update newClaimAccount;
        }

        claimCase.AccountId = accountId;
        return claimCase;
    }
    public class mdAddressFields {
        public String BillingStreet;
        public String BillingCity;
        public String BillingStateCode;
        public String BillingPostalCode;
        public String BillingCountryCode;

        public mdAddressFields() {
        }
    }

    /*
        return picklist options for a given field on the Case object
    */
    @AuraEnabled
    public static Case initClaimCaseDraft() {
        Schema.RecordTypeInfo rtInfo = CaseService.getDefaultRecordType('Case');

        User userRecord = [
                SELECT Id, Country, Profile.Name, Profile.Id, UserRoleId, UserRole.Name
                FROM User
                WHERE Id = :UserInfo.getUserId()
        ];

        String sector = ISO_CA;
        String brand = 'IKO Industries Ltd.';
        if (userRecord.UserRole.Name == 'Blair' || userRecord.UserRole.Name == 'Hyload') {
            sector = userRecord.UserRole.Name;
        } else if (rtInfo.getName().contains(COMMERCIAL)) {
            sector = COMMERCIAL;
        } else {
            if (userRecord.Profile.Name.contains('USRS') || (userRecord.Country <> null && userRecord.Country.contains(UNITED_STATES))) {
                sector = ISO_USA;
                brand = 'IKO Industries Inc.';
            } else if (userRecord.Profile.Name.contains(CANADA)) {
                sector = ISO_CA;
            }
        }

        Case c = new Case(
                Subject = '',
                RecordTypeId = rtInfo.getRecordTypeId(),
                Sector__c = sector,
                Brand__c = brand
        );

        return c;
    }

    /*
        return picklist options for a given field on the Case object
    */
    @AuraEnabled
    public static List<LtngSelectOption> getPicklistOptions(String objectName, String fieldName) {
        return CaseService.getLexPicklistValues(objectName, fieldName);
    }

    /*
      Query the Schema for the picklist options for a given SObject and Field
    */
    @AuraEnabled
    public static List<LtngSelectOption> getRecordTypePicklistValues() {
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        List<ltngSelectOption> options = new List<ltngSelectOption>();
        for (RecordType rt : claimRecordTypes.values())
            options.add(new ltngSelectOption(rt.Id, rt.Name));

        return options;
    }

    /*
        SETTLEMENT CALCULATIONS
    */

    /*
        Calculate the Suggested Settlement amount
            - leverage the Plant, Installation Year, and query Custom Metadata objects to
            determine proper warranty

        This is one of the more complex methods in the entire project,
        as the calculated settlement relies on several inputs and metadata tables.

        When the Case moves to the "Assessment" or "File Preparation" Claim Stage, the
        appropriate Warranty_Lookup__mdt record is found for the given Sector__c,
        nstallation_Date__c and Product__c’s family.

        This then determines the appropriate Producing_Plant_Warranty__mdt record
        to determine the reduction to apply for the Settlement
        (i.e. based on how long the product has been used).

        It calls methods (beneath this one) to determine both the suggested amount
        of material should be paid out, as well as the suggested labour, and
        applies CPI and tax rates as appropriate.
    */
    private static Map<String, CPI_Index__mdt> cpiMap { get; set; }
    public static void calculateSettlementPayment(List<Case> cases) {
        List<String> productFamilies = new List<String>();
        List<String> sectors = new List<String>();
        List<Integer> claimYears = new List<Integer>();
        List<Integer> installedYears = new List<Integer>();
        Map<Id, Case> settlementCases = new Map<Id, Case>();

        Set<String> plantList = new Set<String>();
        Boolean hasSettlementCases = false;
		/* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        
        for (Case c : cases) {
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
            if (claimRecordTypes.get(c.RecordTypeId) <> null){
                /*
                    only calculate the settlement if we have the required fields populated to query the metadata tables
                */
                if (
                        c.Sector__c <> null &&
                                c.Installation_Date__c <> null &&
                                c.Bundles_Causing_Concern__c > 0 &&
                                (
                                        c.Claim_Stage__c == 'Assessment' ||
                                                c.Claim_Stage__c == 'File Preparation'
                                ) &&
                                c.Settlement_Type__c <> 'Manual Calculation'
                        ) {
                    /* reset the calculated fields to ensure none are left with a stale value */
                    c.Calculated_Warranty_Percentage_Used__c = 0;
                    c.Suggested_Bundles_for_Settlement__c = 0;
                    c.Suggested_Labour_Settlement__c = 0;
                    c.Suggested_Labour_Settlement_Pre_CPI__c = 0;
                    c.Suggested_Settlement__c = 0;
    
                    /*
                        GL 2019-07-16
                        Following two fields are created for Conga templates. Default to zeroes.
                    */
                    c.Iron_Clad_Period_Years__c = 0;
                    c.Warranty_Term_Years__c = 0;
    
                    if (c.Product_Family__c <> null)
                        productFamilies.add(c.Product_Family__c);
                    settlementCases.put(c.Id, c);
                    sectors.add(c.Sector__c);
                    installedYears.add(c.Installation_Date__c.year());
                    claimYears.add(c.Call_Received_Date__c.year());
                    hasSettlementCases = true;
                } else if (c.Settlement_Type__c == 'Manual Calculation' && c.Claim_Stage__c == 'Assessment') {
                    hasSettlementCases = true;
                }
            }
        }

        if (!hasSettlementCases)
            return;

        if (!settlementCases.isEmpty()) {

            /* pull the CPI Index rates based on the year of the claim, installation years, and sectors involved */
            cpiMap = new Map<String, CPI_Index__mdt>();
            for (CPI_Index__mdt cpi : [select Id, Claim_Year__c, Sector__c, Year_Applied__c, Factor__c from CPI_Index__mdt where Claim_Year__c IN :claimYears AND Year_Applied__c IN :installedYears AND Sector__c IN :sectors])
                cpiMap.put(Integer.valueOf(cpi.Claim_Year__c) + '-' + Integer.valueOf(cpi.Year_Applied__c) + '-' + cpi.Sector__c, cpi);

            /*
                query the Warranty Lookup metadata to map the Product Family and Sector
                to the appropriate warranty reduction; may get multiple records back per combo Pr*/
            Map<String, List<Warranty_Lookup__mdt>> warrantyLookupMap = new Map<String, List<Warranty_Lookup__mdt>>();
            List<String> warrantyNames = new List<String>();
            for (Warranty_Lookup__mdt warrantyLookup : [
                    select
                            Id, DeveloperName, Warranty_Reduction__c, Warranty_Type__c, Warranty_Term__c, Start_Date__c, End_Date__c, Product_Family__c, Sector__c
                    from Warranty_Lookup__mdt
                    where Sector__c = :sectors AND Product_Family__c IN :productFamilies
                    ORDER BY Start_Date__c
            ]) {
                String key = warrantyLookup.Product_Family__c + '-' + warrantyLookup.Sector__c;

                List<Warranty_Lookup__mdt> warrantyLookups = (warrantyLookupMap.get(key) <> null) ?
                        warrantyLookupMap.get(key) : new List<Warranty_Lookup__mdt>();
                warrantyLookups.add(warrantyLookup);
                warrantyLookupMap.put(key, warrantyLookups);

                warrantyNames.add(warrantyLookup.Warranty_Reduction__c);
            }

            /* query for the Warranty reductions */
            Map<String, Producing_Plant_Warranty__mdt> warrantyNameMap = new Map<String, Producing_Plant_Warranty__mdt>();
            for (Producing_Plant_Warranty__mdt ppw : [
                    select
                            Id, Reduction_Type__c, Iron_Clad_Period__c, Period_1_End__c, Period_2_End__c, Period_3_End__c,
                            Period_1_Rate__c, Period_2_Rate__c, Period_3_Rate__c, DeveloperName
                    from Producing_Plant_Warranty__mdt
                    where DeveloperName IN :warrantyNames
            ])
                warrantyNameMap.put(ppw.DeveloperName, ppw);

            /*
                Now that we have all the related metadata to calculate the settlement,
                iterate over each Case and calculate the % of the warranty used, and what the material and labour settlements should be
            */

            for (Case c : settlementCases.values()) {
                /*
                    retrieve the Producting Plant Warranty based on the:
                        - Installation Year
                        - Product Family
                        - Sector
                */
                String key = c.Product_Family__c + '-' + c.Sector__c;

                Warranty_Lookup__mdt warrantyLookup = getWarrantyLookup(c, warrantyLookupMap);

                if (warrantyLookup <> null) {
                    c.Warranty_Lookup_Id__c = warrantyLookup.Id;

                    //Check the Warranty Term against the Num_of_Months_Product_Used__c value
                    if (warrantyLookup.Warranty_Type__c == 'NW') {
                        c.Calculated_Warranty_Percentage_Used__c = 1;
                        /*
                            GL 2019-07-16
                            If Warranty Type is NW (No Warranty), both Iron Clad Period and Warranty Term in Years should be zero.
                        */
                        c.Iron_Clad_Period_Years__c = 0;
                        c.Warranty_Term_Years__c = 0;
                    }

                    /* No longer go through the following branch as even if it's over the warranty term, it needs the Iron Clad
                        Period retrieve if applicable. I have the logic to check if over the warranty term in the else context
                    else if( warrantyLookup.Warranty_Type__c == 'Term' &&
                                                    c.Num_of_Months_Product_Used__c > (warrantyLookup.Warranty_Term__c * 12)) {

                        c.Calculated_Warranty_Percentage_Used__c = 1;
                    }*/

                    else {
                        /*
                            GL 2019-07-16
                            Warranty Term in Years comes from the Warranty Lookup.
                        */
                        c.Warranty_Term_Years__c = warrantyLookup.Warranty_Term__c;

                        // Find Warranty
                        Producing_Plant_Warranty__mdt warranty;
                        if (warrantyLookup.Warranty_Reduction__c != null && warrantyNameMap.get(warrantyLookup.Warranty_Reduction__c) != null) {
                            warranty = warrantyNameMap.get(warrantyLookup.Warranty_Reduction__c);
                        }

                        /*
                            if we have a Warranty reduction, call calculateWarrantyReductionSettlement
                            to calculate the labour and material portions of the settlement
                        */
                        if (warranty <> null) {

                            /*
                                GL 2019-07-16
                                Now we can populate the Iron Clad Period field
                            */
                            c.Iron_Clad_Period_Years__c = warranty.Iron_Clad_Period__c;
                            if (warrantyLookup.Warranty_Type__c == 'Term'
                                    && c.Num_of_Months_Product_Used__c > (warrantyLookup.Warranty_Term__c * 12)) // Over the warranty Term
                            {
                                c.Calculated_Warranty_Percentage_Used__c = 1;
                            } else {
                                CaseService.calculateWarrantyReductionSettlement(c, warranty);
                            }

                        } else {
                            if (warrantyLookup.Warranty_Type__c == 'Term'
                                    && c.Num_of_Months_Product_Used__c > (warrantyLookup.Warranty_Term__c * 12)) // Over the warranty Term
                            {
                                c.Calculated_Warranty_Percentage_Used__c = 1;
                            } else {
                                // if no warranty reduction, need to leverage Warranty Type and Warranty Term fields
                                if (warrantyLookup.Warranty_Reduction__c <> null) {
                                    if (warrantyLookup.Warranty_Type__c == 'Term' && warrantyLookup.Warranty_Term__c <> null) {
                                        CaseService.calculateWarrantyTermSettlement(c, warrantyLookup);
                                    } else {
                                        // need to calculate l
                                    }
                                }
                            }
                        }
                    }
                } else {
                    c.Settlement_Type__c = 'Manual Calculation';
                }
            }
        }

        for (Case c : cases) {
            /*
                only calculate the settlement if we have the required fields populated to query the metadata tables
            */
            if (
                /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
                    claimRecordTypes.get(c.RecordTypeId) <> null && c.Claim_Stage__c == 'Assessment' &&
                            c.Settlement_Type__c == 'Manual Calculation'
                    ) {
                CaseService.calculateLabourSettlement(c);
            }
        }
    }

    /*
        This method is called when there is no Producing_Plant_Warranty__mdt
        referenced in the Warranty_Lookup__mdt custom metadata for the product
        family / sector / installation period.

        It determines the percentage of the warranty that has been used (based on the # of months the product has been in use at the time of the start of the claim), and then determines the appropriate number of bundles to suggest for the settlement.

        For example, if there are 200 bundles causing concern, and 55% of the warranty has been used, then 90 bundles are suggested for the settlement (45% x 200).
        The method then calls calculateLabourSettlement to determine any labour that would apply.
    */
    public static void calculateWarrantyTermSettlement(Case c, Warranty_Lookup__mdt warrantyLookup) {
        Integer monthsUsed = Integer.valueOf(Math.ceil(c.Num_of_Months_Product_Used__c));
        c.Calculated_Warranty_Percentage_Used__c = Math.min(1, monthsUsed / (warrantyLookup.Warranty_Term__c * 12));
        c.Suggested_Bundles_for_Settlement__c = Math.ceil(c.Bundles_Causing_Concern__c * (1 - c.Calculated_Warranty_Percentage_Used__c));
        CaseService.calculateLabourSettlement(c);
    }

    /*
        This method is called when the Warranty_Lookup__mdt has a reference
        to a Producing_Plant_Warranty__mdt.

        The method will determine if the Iron Clad period has passed, and
        if not, will set that 100% of the warranty remains
        (e.g. if Iron Clad Period is 5 years, and used for 49 months,
        then 100% of the warranty remains), and thus,
        the suggested number of bundles will be the same value as
        # of Bundles Causing Concern.

        The calculateLabourSettlement method will then be called to
        determine what labour to apply.

        Otherwise, the Producing_Plant_Warranty__mdt record will
        determine whether to apply the AddRanges or SpecificRange
        should apply and will call either the calculateWarrantyAddRanges
        or calculateWarrantySpecificRanges respectively.
    */
    public static void calculateWarrantyReductionSettlement(Case c, Producing_Plant_Warranty__mdt warranty) {
        Integer monthsUsed = Integer.valueOf(Math.ceil(c.Num_of_Months_Product_Used__c));
        Integer ironCladMonths = Integer.valueOf(warranty.Iron_Clad_Period__c) * 12;

        c.Suggested_Labour_Settlement__c = 0;
        c.Suggested_Settlement__c = 0;
        c.Bundle_Rate__c = (c.Bundle_Rate__c <> null) ? c.Bundle_Rate__c : 20;
        c.Producing_Plant_Warranty__c = warranty.Id;

        // if used less than the iron clad period, then Settlement should be 100% of Bundles
        if (monthsUsed <= ironCladMonths) {
            c.Calculated_Warranty_Percentage_Used__c = 0;
            c.Suggested_Bundles_for_Settlement__c = c.Bundles_Causing_Concern__c;

            CaseService.calculateLabourSettlement(c);
        } else {
            c.Suggested_Labour_Settlement__c = 0;
            if (warranty.Reduction_Type__c == 'AddRanges') {
                CaseService.calculateWarrantyAddRanges(c, warranty);
            } else if (warranty.Reduction_Type__c == 'SpecificRange') {
                CaseService.calculateWarrantySpecificRanges(c, warranty);
            }
            c.Suggested_Bundles_for_Settlement__c = Math.ceil(c.Bundles_Causing_Concern__c * (1 - c.Calculated_Warranty_Percentage_Used__c));
        }
    }

    /*
        3  5  2  SpecificRanges  61-180  n/225  181+  m/600  NULL  NULL  NULL  NULL  NULL  NULL  1

        A manufacturing defect resulting in leaks is found in January 2018 in
        Shingles Purchased with a Lifetime limited warranty.
        The Shingles were purchased in January 1998;
        250 months have elapsed since Purchase. 100 bundles are involved.
        IKO’s warranty obligation will be reduced by (384/480 = .80.
        So IKO’s maximum obligation would be 20% (100 - 80) of the cost of the
        replacement Shingles. 100 * .20 = 20 bundles
    */
    public static void calculateWarrantySpecificRanges(Case c, Producing_Plant_Warranty__mdt warranty) {
        if (c.Num_of_Months_Product_Used__c < warranty.Period_1_End__c) {
            c.Calculated_Warranty_Percentage_Used__c = (c.Num_of_Months_Product_Used__c * warranty.Period_1_Rate__c).setScale(4);
        } else if (warranty.Period_2_End__c == null || c.Num_of_Months_Product_Used__c < warranty.Period_2_End__c) {
            c.Calculated_Warranty_Percentage_Used__c = warranty.Period_2_Rate__c.setScale(4);
        } else if (warranty.Period_3_End__c == null || c.Num_of_Months_Product_Used__c < warranty.Period_3_End__c) {
            c.Calculated_Warranty_Percentage_Used__c = warranty.Period_3_Rate__c.setScale(4);
        } else {
            c.Calculated_Warranty_Percentage_Used__c = 0;
        }
    }

    /*
        3  5  2  AddRanges  61-180  n/225  181+  m/600  NULL  NULL  NULL  NULL  NULL  NULL  1

        A manufacturing defect resulting in leaks is found in January 2034 in
        Shingles Purchased with a 25 year limited warranty.
        The Shingles were purchased in January 2016;
        18 years, or a total of 216 months have elapsed since Purchase.
        100 bundles are involved.
        IKO’s warranty obligation will be reduced by (180/225 = .80) + (36/600 = .06) = .86.
        So IKO’s maximum obligation would be 14% (100 - 86) of the cost of the
        replacement Shingles. 100 * .14 = 14 bundles
    */
    public static void calculateWarrantyAddRanges(Case c, Producing_Plant_Warranty__mdt warranty) {
        Integer runningMonthsUsed = Integer.valueOf(Math.ceil(c.Num_of_Months_Product_Used__c));

        Integer period1Cap = Integer.valueOf(warranty.Period_1_End__c);
        Integer period1Months = Math.min(runningMonthsUsed, period1Cap);

        Decimal runningPercentage = period1Months * warranty.Period_1_Rate__c;

        if (period1Months < runningMonthsUsed) {
            runningMonthsUsed = runningMonthsUsed - period1Months;

            Integer period2Cap = (warranty.Period_2_End__c <> null) ? Integer.valueOf(warranty.Period_2_End__c) : 10000000;
            Integer period2Months = Math.min(runningMonthsUsed, period2Cap);

            runningPercentage = runningPercentage + (period2Months * warranty.Period_2_Rate__c);

            if (period2Months < runningMonthsUsed) {
                runningMonthsUsed = runningMonthsUsed - period2Months;

                Integer period3Cap = (warranty.Period_3_End__c <> null) ? Integer.valueOf(warranty.Period_3_End__c) : 10000000;
                Integer period3Months = Math.min(runningMonthsUsed, period3Cap);

                runningPercentage = runningPercentage + (period3Months * warranty.Period_3_Rate__c);
            }
        }
        c.Calculated_Warranty_Percentage_Used__c = runningPercentage.setScale(4);
    }

    /*
        The labour rate considers both the suggested # of bundles
        (as determined in methods above) and the overrides, as well as
        the pre-determined labour rate (from setLabourRate method)
        and the override field.

        If the Settlement Type is set to ‘Hand Seal’, no labour is applied.

        If the Settlement Type is Manual Calculation, the suggested
        labour settlement is simply # bundles x labour rate;
        no CPI Index or taxes.

        If there is 100% remaining on the Warranty (i.e. Iron Clad period),
        then the labour would also be # bundles x labour rate, with no
        CPI index.

        Otherwise, for a Canadian Residential case, the Pre-CPI Index value
        is determined by # bundles x labour rate; the CPI Index
        (from the CPI Index metadata) is applied based on the date of
        the claim and the installation date.

        Finally, cacluateSettlementWithTax is called to add appropriate taxes.
    */
    public static void calculateLabourSettlement(Case c) {
        Decimal numBundles;
        if (c.Num_of_Bundles_for_Settlement__c <> null)
            numBundles = c.Num_of_Bundles_for_Settlement__c; else
                numBundles = c.Suggested_Bundles_for_Settlement__c;

        Decimal labourRate;
        if (c.Actual_Labour_Rate__c <> null)
            labourRate = c.Actual_Labour_Rate__c; else
                labourRate = c.Labour_Rate__c;

        if (c.Settlement_Type__c == 'Hand Seal') {
            c.Suggested_Labour_Settlement__c = 0;
            c.Suggested_Labour_Settlement_Pre_CPI__c = 0;
            c.Suggested_Settlement__c = 0;
            return;
        }

        if (c.Settlement_Type__c == 'Manual Calculation') {
            c.Suggested_Labour_Settlement_Pre_CPI__c = numBundles * labourRate;
            c.Suggested_Labour_Settlement__c = c.Suggested_Labour_Settlement_Pre_CPI__c;
        } else {
            if (c.Calculated_Warranty_Percentage_Used__c == 0) {
                c.Suggested_Labour_Settlement_Pre_CPI__c = numBundles * labourRate;
                c.Suggested_Labour_Settlement__c = c.Suggested_Labour_Settlement_Pre_CPI__c;
            } else if (c.Sector__c == 'CA') {
                if (CaseService.cpiMap.get(c.Call_Received_Date__c.year() + '-' + c.Installation_Date__c.year() + '-' + c.Sector__c) <> null) {
                    c.Suggested_Labour_Settlement_Pre_CPI__c = numBundles * labourRate;
                    c.Suggested_Labour_Settlement__c =
                            (c.Suggested_Labour_Settlement_Pre_CPI__c *
                                    CaseService.cpiMap.get(c.Call_Received_Date__c.year() + '-' + c.Installation_Date__c.year() + '-' + c.Sector__c).Factor__c).setScale(2);
                } else {
                    c.addError('A CPI Index Rate could not be found');
                }
            } else {
                c.Suggested_Labour_Settlement_Pre_CPI__c = 0;
                c.Suggested_Labour_Settlement__c = 0;
            }
        }

        CaseService.cacluateSettlementWithTax(c);
    }

    /*
        Calculate Settlement based on Taxes
            - the secondary tax may either be added to the primary tax to create the total, OR applied to the subtotal (amount + primary tax amount)
    */
    public static void cacluateSettlementWithTax(Case c) {
        Decimal labourSettlement;
        if (c.Actual_Labour_Settlement__c <> null)
            labourSettlement = c.Actual_Labour_Settlement__c; else
                labourSettlement = c.Suggested_Labour_Settlement__c;

        if (c.Tax_Rate__c == null) {
            c.Suggested_Settlement__c = labourSettlement;
            return;
        }

        Decimal taxRate = (c.Secondary_Tax_Rate__c <> null && c.Taxes_Additive__c) ?
                c.Tax_Rate__c + c.Secondary_Tax_Rate__c : c.Tax_Rate__c;

        Decimal taxAmount = (labourSettlement * taxRate / 100).setScale(2);

        if (c.Secondary_Tax_Rate__c <> null && !c.Taxes_Additive__c) {
            Decimal secondTaxAmount = ((labourSettlement + taxAmount) * c.Secondary_Tax_Rate__c / 100).setScale(2);
            taxAmount += secondTaxAmount;
        }
        c.Suggested_Settlement__c = labourSettlement + taxAmount;
    }

    private static Warranty_Lookup__mdt getWarrantyLookup(Case c, Map<String, List<Warranty_Lookup__mdt>> warrantyLookupMap) {
        String key = c.Product_Family__c + '-' + c.Sector__c;

        if (warrantyLookupMap.get(key) == null)
            return null;

        for (Warranty_Lookup__mdt warrantyLookup : warrantyLookupMap.get(key)) {
            if (
                    c.Installation_Date__c >= warrantyLookup.Start_Date__c &&
                            (
                                    warrantyLookup.End_Date__c == null ||
                                            warrantyLookup.End_Date__c >= c.Installation_Date__c
                            )
                    )
                return warrantyLookup;
        }
        return null;
    }

    /*
        To return the default record type for a given Sobject
    */
    public static Schema.RecordTypeInfo getDefaultRecordType(String sobjectType) {
        List<Schema.DescribeSobjectResult> results = Schema.describeSObjects(new List<String>{
                sobjectType
        });
        Schema.RecordTypeInfo defaultRecordType;

        for (Schema.RecordTypeInfo rti : results[0].getRecordTypeInfos()) {
            if (rti.isDefaultRecordTypeMapping()) {
                defaultRecordType = rti;
                break;
            }
        }
        return defaultRecordType;
    }

    /*
      Query the Schema for the picklist options for a given SObject and Field
    */
    public static List<LtngSelectOption> getLexPicklistValues(String sObjectName, String fieldName) {
        Schema.DescribeSObjectResult sObjectDescribe = Schema.getGlobalDescribe().get(sObjectName).newSObject().getSObjectType().getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> fieldMap = sObjectDescribe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> picklistValues = fieldMap.get(fieldName).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject

        List<ltngSelectOption> options = new List<ltngSelectOption>();
        for (Schema.PicklistEntry a : picklistValues)
            options.add(new ltngSelectOption(a.getValue(), a.getLabel()));
        return options;
    }

    /**
     * @description populate the Case Priority Score based on the sum of the following conditions
     * Job In Progress is checked then score = 4
     * CreatedBy Profile Name is Sales Rep or Sales Managers then score = 2
     * Leaking is checked then score = 1
     * @param newCases List data structure of newly created or updated Case records
     */
    public static void calculateCasePriorityScore(final List<Case> newCases) {

        // Get the User Profile Names
        Map<Id, String> profileNamesByCaseIds = getCaseIdToProfileNamesMap(newCases);
        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
		Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        
        Integer score = 0;
        for (Case caseRecord : newCases) {
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
            if (claimRecordTypes.get(caseRecord.RecordTypeId) <> null) {
                if (caseRecord.Job_In_Progress__c) {
                    score += 4;
                } else {
                    score += 0;
                }
    
                String ownerProfileName = profileNamesByCaseIds.get(caseRecord.Id);
                if (ownerProfileName == 'CACS Manager' || ownerProfileName == 'CACS Sales Rep' ||
                        ownerProfileName == 'CARS Manager' || ownerProfileName == 'CARS Sales Rep' ||
                        ownerProfileName == 'USRS Read Only' || ownerProfileName == 'USRS Sales Rep' ||
                        ownerProfileName == 'USRS Manager' || ownerProfileName == 'CACS Sales Admin' ||
                        ownerProfileName == 'CARS Sales Admin' || ownerProfileName == 'USRS Sales Admin') {
                    score += 2;
                } else {
                    score += 0;
                }
    
                if (caseRecord.Leaking__c) {
                    score += 1;
                } else {
                    score += 0;
                }
    
                caseRecord.Priority_Score__c = score; // update the record
            }
        }

    } // end calculateCaseScore method

    /**
     * @description prepare a Map of Case Id to Case Owner Profile Name
     * @param newCases List data structure of newly created or updated Case records
     * @return Map of Case Id to Case Owner Profile Name
     */
    private static Map<Id, String> getCaseIdToProfileNamesMap(final List<Case> newCases) {

        Map<Id, String> profileNamesByCaseIds = new Map<Id, String>();
        Map<Id, Id> caseIdsByCaseCreatedbyUsers = new Map<Id, Id>();

        for (Case caseRecord : newCases) {
            caseIdsByCaseCreatedbyUsers.put(caseRecord.CreatedById, caseRecord.Id);
        }

        for (User userRecord : [SELECT Id, Profile.Name FROM User WHERE Id IN :caseIdsByCaseCreatedbyUsers.keySet()]) {
            profileNamesByCaseIds.put(caseIdsByCaseCreatedbyUsers.get(userRecord.Id), userRecord.Profile.Name);
        }

        return profileNamesByCaseIds;
    } // end getCaseIdToProfileNamesMap method

    /**
  * @description Get the controlling and dependent picklist values
  *      @see https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_calls_describesobjects_describesobjectresult.htm
  *      @see http://titancronus.com/blog/2014/05/01/salesforce-acquiring-dependent-picklists-in-apex/
  *
  * @param objectName the name of object where Controlling and Dependent picklist fields sits
  * @param parentField the API name of the controlling picklist field
  * @param childField the API name of the dependent picklist field
  *
  * @return Wrapper contains the the Controlling field value associated with the Dependent field values
  */
    @AuraEnabled
    public static Map<String, Object> getDependentPicklist(String objectName, String parentField, String childField) {
        Map<String, StatePickList> picklistMap = new Map<String, StatePickList>();
        PicklistWrapper picklistWrapper = new PicklistWrapper();
        picklistWrapper.picklistMap = JSON.serialize(picklistMap);
        Map<String, Object> returnValues = new Map<String, Object>();

        returnValues.put('salutations', getSalutationsFromMetaData());
        returnValues.put('picklistWrapper', picklistWrapper);

        if (Schema.getGlobalDescribe().get(objectName) == NULL ||
                String.isBlank(parentField) || String.isBlank(childField)) {
            return returnValues;
        }

        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName).newSObject().getSObjectType();

        Map<String, Schema.SObjectField> objectFieldMap = objectType.getDescribe().fields.getMap();

        if (!objectFieldMap.containsKey(parentField) || !objectFieldMap.containsKey(childField)) {
            return returnValues;
        }
        List<PicklistEntryWrapper> picklistEntryWrappers = (List<PicklistEntryWrapper>) JSON.deserialize(JSON.serialize(objectFieldMap.get(childField).getDescribe().getPicklistValues()), List<PicklistEntryWrapper>.class);
        List<String> controllingValues = new List<String>();

        List<picklistEntry> entries = objectFieldMap.get(parentField).getDescribe().getPicklistValues();

        for (Schema.PicklistEntry picklistEntry : entries) {
            /* CLAIM V2 - 1033 & 1039 - Getting the country codes and state codes into the return Map object 'returnValues' */
            picklistMap.put(picklistEntry.getLabel(), new StatePickList(picklistEntry.getValue(), new List<state>()));
            controllingValues.add(picklistEntry.getLabel());
        }
        for (PicklistEntryWrapper picklistEntryWrapper : picklistEntryWrappers) {
            String validForBits = base64ToBits(picklistEntryWrapper.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                     /* CLAIM V2 - 1039 - Getting the state code and state name */
                    picklistMap.get(controllingValues.get(i)).states.add(new state(picklistEntryWrapper.label,picklistEntryWrapper.value));
                }
            }
        }
         /* CLAIM V2 - 1033 & 1039 - JSON serialize to send the complex object to JavaScript */
        picklistWrapper.picklistMap = JSON.serialize(picklistMap);
        return returnValues;

    } // end getDependentPicklist method

    private static List<contactSalutation__mdt> getSalutationsFromMetaData(){
        List<contactSalutation__mdt> salutations  = [Select DeveloperName, Label FROM contactSalutation__mdt];
        return salutations;
    }
    /**
     * @description
     * @param validFor a set of bits where each bit indicates a controlling value for which PicklistEntry is valid
     * @return String contains sets of bits for the controlling value of a PicklistEntry
     */
    private static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) {
            return '';
        }

        String validForBits = '';
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, 'o');
            validForBits += bits;
        }

        return validForBits;
    }

    /**
     * @description convert a decimal value to its binary format
     * @param val decimal value
     * @return String contains the binary format of a decimal value
     */
    private static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer reminder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(reminder) + bits;
        }

        return bits;
    } // end decimalToBinary method

    /**
     * @description Wrapper Class to hold the controlling and dependent picklist value api fields
     *      and map of a controlling value to its associated list of dependent values
     */
    public class PicklistWrapper {
        @AuraEnabled
        public string picklistMap;

        @AuraEnabled
        public String parentFieldLabel;

        @AuraEnabled
        public String childFieldLabel;
    } // end PicklistWrapper class
    
    /* CLAIM V2 - 1033 & 1039 - Class to store the country code and list of states with state code  */
    public class StatePickList
    {
        public StatePickList(string ctryCode, List<state> stateList)
        {
            countryCode = ctryCode;
            states = stateList;
        }
        public string countryCode;
        public List<state> states;
    }

     /* CLAIM V2 - 1033 & 1039 - Class to store the state name and state code */
    public class state
    {
        public state(string stateCode, string stateValue)
        {
            label = stateCode;
            value = stateValue;
        }
        public String label;
        public String value; 
    }

    /**
     * @description Properties of PicklistEntry class as described in
     *      @see https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_calls_describesobjects_describesobjectresult.htm
     */
    public class PicklistEntryWrapper {
        public String active;
        public String label;
        public String value;
        public String validFor;
    } // end PicklistEntryWrapper class

    public static void populateCaseCreatedByUserRoleField(final List<Case> newCases) {

        User runningUser = getRunningUser(); //[SELECT Id, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId()];
        
        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        
        for (Case caseRecord : newCases) {
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
            if (claimRecordTypes.get(caseRecord.RecordTypeId) <> null){
	           	caseRecord.SYS_UserRole__c = runningUser.UserRole.Name;
            }
        }
    } // end populateCaseCreatedByUserRoleField method

    /**
     * @description populate the Lab Sample PRM field when the Installation Date is modified
     *
     * @param newCasesByIds Map data structure of newly created or updated Case records
     * @param oldCasesByIds Map data structure of old Case records
     */
    public static void populateLabSamplePRMField(final Map<Id, Case> newCasesByIds, final Map<Id, Case> oldCasesByIds) {

        Set<Id> caseIds = new Set<Id>();
        
        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        
        for (Case newCase : newCasesByIds.values()) {
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
            if (claimRecordTypes.get(newCase.RecordTypeId) <> null)
            {
                Date oldInstallationDate = oldCasesByIds.get(newCase.Id).Installation_Date__c;
                Date newInstallationDate = newCasesByIds.get(newCase.Id).Installation_Date__c;
    
                Date caseOpenDate = Date.newInstance(newCase.CreatedDate.year(), newCase.CreatedDate.month(), newCase.CreatedDate.day());
    
                if ((oldInstallationDate != newInstallationDate) && newInstallationDate <= caseOpenDate) {
                    caseIds.add(newCase.Id);
                }
            }
        }

        // retrieve all the children Lab Samples
        List<Lab_Sample__c> labSamples = [
                SELECT Id, PRM__c, Case_Open_Date__c, Case_Installation_Date__c
                FROM Lab_Sample__c
                WHERE Case__c IN :caseIds
        ];

        if (labSamples.isEmpty()) {
            return;
        }

        LabSampleService.populateLabSamplePRMField(labSamples, 'Case');

    } // end populateLabSamplePRMField method

    /**
     * @description Send a chatter post when the Claim is approved or declined
     *
     * @param newCasesByIds Map data structure of newly updated Case records
     * @param oldCasesByIds Map data structure of old updated Case records
     */
    public static void postChatterForClaimApprovalProcesses(final Map<Id, Case> newCasesByIds, final Map<Id, Case> oldCasesByIds) {

        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        
        for (Case newCase : newCasesByIds.values()) {
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
            if (claimRecordTypes.get(newCase.RecordTypeId) <> null)
            {
                String newClaimStage = newCase.Claim_Stage__c;
                String newClaimSubStage = newCase.Claim_Sub_Stage__c;
                String oldClaimSubStage = oldCasesByIds.get(newCase.Id).Claim_Sub_Stage__c;
    
                List<Case> chatterPostCases = new List<Case>();
    
                if (newClaimStage == 'Assessment' && (
                        oldClaimSubStage == 'In Approval' && (
                                newClaimSubStage == 'Approved' || newClaimSubStage == 'Declined'))) {
                    chatterPostCases.add(newCase);
                }
    
                if (chatterPostCases.isEmpty()) {
                    return;
                }
    
                for (Case chatterPostCase : chatterPostCases) {
    
                    ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                    ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                    ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                    ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
    
                    messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
    
                    mentionSegmentInput.id = chatterPostCase.CreatedById;
                    messageBodyInput.messageSegments.add(mentionSegmentInput);
    
                    if (chatterPostCase.Claim_Sub_Stage__c == 'Approved') {
                        textSegmentInput.text = ' Your Case, ' + chatterPostCase.CaseNumber + ', has been Approved.\n\nThanks';
                    } else if (chatterPostCase.Claim_Sub_Stage__c == 'Declined') {
                        textSegmentInput.text = ' Your Case, ' + chatterPostCase.CaseNumber + ', has been Declined.\n\nThanks';
                    }
    
                    messageBodyInput.messageSegments.add(textSegmentInput);
    
                    feedItemInput.body = messageBodyInput;
                    feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                    feedItemInput.subjectId = chatterPostCase.Id;
    
                    ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
                }
            }
        }

    } // end postChatterForClaimApprovalProcesses method

    /**
     * @description populate the Lab Sample Case Description field when the Description field on the Case is updated
     *
     * @param newCasesByIds Map data structure of newly created or updated Case records
     * @param oldCasesByIds Map data structure of old Case records
     */
    public static void populateCaseDescriptionOnLabSample(final Map<Id, Case> newCasesByIds, final Map<Id, Case> oldCasesByIds) {

        Map<Id, Case> casesWithUpdatedDescription = new Map<Id, Case>();
        
        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        
        // if the trigger was due to an update
        if (oldCasesByIds != null && newCasesByIds != null) {
            for (Case eachNewCase : newCasesByIds.values()) {
            	/* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
                if (claimRecordTypes.get(eachNewCase.RecordTypeId) <> null)
                {
                    String oldCaseDescription = oldCasesByIds.get(eachNewCase.Id).Description;
                    String newCaseDescription = newCasesByIds.get(eachNewCase.Id).Description;
    
                    if (newCaseDescription != oldCaseDescription) {
                        casesWithUpdatedDescription.put(eachNewCase.Id, eachNewCase);
                    }
                }
            }
        }// trigger was due to an insert
        else if (oldCasesByIds == null) {
            for (Case eachNewCase : newCasesByIds.values()) {
                /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
                if (claimRecordTypes.get(eachNewCase.RecordTypeId) <> null)
                {
                    String newCaseDescription = newCasesByIds.get(eachNewCase.Id).Description;
    
                    if (newCaseDescription != null || newCaseDescription != '') {
                        casesWithUpdatedDescription.put(eachNewCase.Id, eachNewCase);
                    }
                }
            }
        }

        if (casesWithUpdatedDescription.isEmpty()) {
            return;
        }

        // retrieve all the children Lab Samples
        List<Lab_Sample__c> labSamples = [
                SELECT Id, Case_Description__c,Case__r.Description
                FROM Lab_Sample__c
                WHERE Case__c IN :casesWithUpdatedDescription.keySet()
        ];

        if (labSamples.isEmpty()) {
            return;
        }

        List<Lab_Sample__c> samples = new List<Lab_Sample__c>();

        for (Lab_Sample__c eachLabSample : labSamples) {
            eachLabSample.Case_Description__c = eachLabSample.Case__r.Description;
            samples.add(eachLabSample);
        }

        Database.update(samples, false);
    }

    /** CLAIMS - 83
     * @description only the Claims Manager and System Administrator will be able to update the Claim Stage to 'In Lab'
     *
     * @param newCases List of newly created or updated Case records
     * @param oldCases Map data structure of old Case records
     */
    public static void allowOnlyClaimsManagerToUpdateClaimsStage(List<Case> newCases, Map<Id, Case> oldCases) {

        User loggedInUser = getRunningUser(); // [SELECT Id,Profile.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
		
        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        
        for (Case eachNewCase : newCases) {
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
            if (claimRecordTypes.get(eachNewCase.RecordTypeId) <> null){
                    if (eachNewCase.Claim_Stage__c != oldCases.get(eachNewCase.Id).Claim_Stage__c &&
                        eachNewCase.Claim_Stage__c == 'In Lab' &&
                        loggedInUser.Profile.Name != 'Claims Manager' &&
                        loggedInUser.Profile.Name != 'System Administrator' &&
                        !loggedInUser.Profile.Name.contains('Lab')) {
                    eachNewCase.addError('Stage can only be moved to In Lab automatically, please update the Lab Sample');
                }
            }
        }
    }

    public static void changeCaseOwnerWhenClaimInLitigation(List<Case> newCases, Map<Id, Case> oldCasesByIds) {

        Id commercialRTId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();
        Id residentialRTId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId();


        /**
         * CliamsV2-953
         * By Anil Mannem (Incloud)
         * Removed SOQL statements in for loop
         */
        Set<String> queueSet = new set<String> {'Commercial Claims', 'Residential Claims'};
        String commercialQueueId;
        String residentialQueueId;
        for (QueueSobject queueRetrieved : [SELECT QueueId, Queue.Name FROM QueueSobject WHERE Queue.Name IN :queueSet]) {
            if (queueRetrieved.Queue.Name == 'Commercial Claims') {
                commercialQueueId = queueRetrieved.QueueId;
            } else if (queueRetrieved.Queue.Name == 'Residential Claims') {
                residentialQueueId = queueRetrieved.QueueId;
            }        
        }

        for (Case newCase : newCases) {
            Boolean oldLegal = oldCasesByIds.get(newCase.Id).Legal__c;
            if (newCase.Claim_Stage__c == 'Draft' && (oldLegal != newCase.Legal__c && newCase.Legal__c)) {
                if (newCase.RecordTypeId == commercialRTId) {
                    newCase.OwnerId = commercialQueueId;
                } else if (newCase.RecordTypeId == residentialRTId) {
                    newCase.OwnerId = residentialQueueId;
                }
            }
        }

    } // end changeCaseOwnerWhenClaimInLitigation method

    public static void preventUserNotOnClaimsTeamFromUpdatingSubmittedCase(List<Case> newCases, Map<Id, Case> oldCasesMap) {

        User runningUser = getRunningUser(); //[SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		
        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        
        for (Case caseRecord : newCases) {
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
            if (claimRecordTypes.get(caseRecord.RecordTypeId) <> null){
                Case oldCase = oldCasesMap.get(caseRecord.Id);
                if (runningUser.Profile.Name == 'System Administrator' ||
                        runningUser.Profile.Name.contains('Claims')) {
                    return;
                } else if (oldCase.Claim_Stage__c == 'Draft' && caseRecord.Claim_Stage__c == 'Submitted') {
                    return;
                } else if (caseRecord.Claim_Stage__c == 'Submitted' &&
                        (caseRecord.Origin == 'Owner' || caseRecord.Origin == 'Contractor') &&
                        (oldCase.AccountId != caseRecord.AccountId ||
                                oldCase.ContactId != caseRecord.ContactId ||
                                oldCase.Alternate_Contact__c != caseRecord.Alternate_Contact__c)) {
                    caseRecord.addError('This record cannot be edited because it is associated with a submitted Case');
                }
            }
        }
    }
 
    //CLAIMS - 667
    // populates the Parent_Building_Account__c field on Case with ParentId of the related Account
    public static void populateParentBuildingAccountFieldOnCase(List<Case> newCasesList){

        Set<Id> recordTypeIds = new Set<Id>();
        //recordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Homeowner').getRecordTypeId());
        recordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId());
        recordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Owner').getRecordTypeId());
        recordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId());
        recordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId());
        recordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Board').getRecordTypeId());
        recordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Other').getRecordTypeId());
        recordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Residential Account').getRecordTypeId());
        recordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('US Contractor').getRecordTypeId());
        recordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('US Distributor').getRecordTypeId());

        Set<Id> accountIds = new Set<Id>();
		
        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        
        for(Case eachNewCase : newCasesList){
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
            if (claimRecordTypes.get(eachNewCase.RecordTypeId) <> null)
            {
                accountIds.add(eachNewCase.AccountId);
            }
        }
		
        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
        if(accountIds.isEmpty()){
            return;
        }
        Map<Id,Account> parentAccounts = new Map<Id,Account>([SELECT Id,ParentId,RecordTypeId
                                                                FROM Account WHERE Id IN :accountIds AND ParentId != NULL
                                                                AND RecordTypeId IN :recordTypeIds]);

        for (Case eachNewCase : newCasesList){
            if(parentAccounts.get(eachNewCase.AccountId) != NULL){
                eachNewCase.Parent_Building_Account__c = parentAccounts.get(eachNewCase.AccountId).ParentId;
            }else{
                eachNewCase.Parent_Building_Account__c = NULL;
            }
        }
    }
    
    static icLogicAccount.IClass logicAccount = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');	
	static icLogicAttachment.IClass logicAttachment = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');
	static icLogicEmail.IClass logicEmail = (icLogicEmail.IClass) icObjectFactory.GetSingletonInstance('icLogicEmail');
     
    //April 26, 2021
    //Vicki Tran
    //Convert Process Builder Claim Submission Email Notification to Apex class method
    //The goal is to reduce the CPU time from Prcoess Builder
    public static void claimSubmissionEmailNotification(List<Case> newCasesList, Map<Id, Case> oldCasesMap){
     	System.Debug('Entering Claim Submission Email Notification');
        //Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes(); 
        //List<Task> tstList = new List<Task>();
        string emailFolderName = 'Claims and Warranty';
        List<EmailTemplate> etList = [SELECT Id, Name, Subject, Body FROM EmailTemplate WHERE Folder.Name =: emailFolderName];
        EmailTemplate template = new EmailTemplate();
        Map<String, EmailTemplate> etMap = new Map<String, EmailTemplate>();
        for (EmailTemplate e : etList)
        {
            etMap.put (e.Name, e);
        }
        //List<Task> lstTask = new List<Task>();
        for (Case caseRecord : newCasesList)
        {
         	System.Debug('Loop');
            Case oldCase = oldCasesMap.get(caseRecord.Id);
            System.Debug('old case claim stage ' + oldCase.Claim_Stage__c);
            System.Debug(' case claim stage ' + caseRecord.Claim_Stage__c);
            if (oldCase.Claim_Stage__c != caseRecord.Claim_Stage__c) 
            {
            	System.Debug('Claim Stage Changed');
                if (claimRecordTypes.get(caseRecord.RecordTypeId).Name == 'Residential Claim')
                {
                    System.Debug('Residential Claim');
                    if (caseRecord.ContactEmail != null && caseRecord.Claim_Stage__c == 'Submitted')
                    {
                            System.Debug('Submitted');
                        	/*
                        	switch on caseRecord.Brand__c
                            {
                                when 'CanRoof Corporation'
                                {
                                    if (caseRecord.Sector__c == 'CA' && caseRecord.Preferred_Language__c == 'French')
                                    {
                                        template = etMap.get('Claim Submission Notification French CRC');
                                        System.Debug('Email Template ' + template);
                                    }
                                    else
                                    {
                                        template = etMap.get('Claim Submission Notification English CRC');
                                        System.Debug('Email Template ' + template);    
                                    }
                                         
                                }
                                when 'Blair Sales Inc.'
                                {
                                    if (caseRecord.Sector__c == 'CA' && caseRecord.Preferred_Language__c == 'French')
                                    {
                                        template = etMap.get('Claim Submission Notification French Blair');
                                        System.Debug('Email Template ' + template);
                                    }
                                    else
                                    {
                                        template = etMap.get('Claim Submission Notification English Blair');
                                        System.Debug('Email Template ' + template);    
                                    }
                                    
                                }
                                when 'Hyload Sales Inc.'
                                {
                                    if (caseRecord.Sector__c == 'CA' && caseRecord.Preferred_Language__c == 'French')
                                    {
                                        template = etMap.get('Claim Submission Notification French Hyload');
                                        System.Debug('Email Template ' + template);
                                    }
                                    else
                                    {
                                        template = etMap.get('Claim Submission Notification English Hyload');
                                        System.Debug('Email Template ' + template);    
                                    }
                                }
                                when 'IKO Industries Inc.'
                                {
                                   if (caseRecord.Sector__c == 'CA' && caseRecord.Preferred_Language__c == 'French')
                                    {
                                        template = etMap.get('Claim Submission Notification French IKO');
                                        System.Debug('Email Template ' + template);
                                    }
                                    else
                                    {
                                        template = etMap.get('Claim Submission Notification English IKO');
                                        System.Debug('Email Template ' + template);    
                                    }
                                }
                                when 'IKO Industries Ltd.' 
                                {
                                    if (caseRecord.Sector__c == 'CA' && caseRecord.Preferred_Language__c == 'French')
                                    {
                                        template = etMap.get('Claim Submission Notification French IKO');
                                        System.Debug('Email Template ' + template);
                                    }
                                    else
                                    {
                                        template = etMap.get('Claim Submission Notification English IKO');
                                        System.Debug('Email Template ' + template);    
                                    }
                                }
                                when 'IKO Manufacturing Ltd.'
                                {
                                    if (caseRecord.Sector__c == 'US')
                                    {
                                         template = etMap.get('Claim Submission Notification English US IKOM');
                                         System.Debug('Email Template ' + template);
                                    }
                                }
                                when else
                                {
                                   	template = etMap.get('Claim Submission Notification English');
                                    System.Debug('Email Template ' + template); 
                                }
                                
                            }
							*/
                		if (caseRecord.Sector__c == 'CA' && caseRecord.Preferred_Language__c == 'French')
                        {
                            template = etMap.get('Claim Submission Notification French');
                        }
                        else
                        {
                            template = etMap.get('Claim Submission Notification English');
                        }
                        System.Debug('Email Template ' + template); 
                        String fromEmailAddress = 'do_not_reply_warrantyservice@iko.com <do_not_reply_warrantyservice@iko.com>';
                        logicEmail.sendTemplateEmailActivity(template, caseRecord.ContactId, caseRecord.Id, fromEmailAddress, new List<String>(), new List<Messaging.EmailFileAttachment>(), true);
                            
                        }
                    }
                }
              
         } 
	   
    }
    
	    
    
} // end CaseService Class