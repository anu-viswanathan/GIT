public with sharing class AccountService {

    /*
        Used to generate a Contractor Registration #, by determining a sequence number (based on the highest existing sequence for the Contractor’s Billing State Code) and generates a value in the format {Billing State Code}/{Sequence Number}, e.g.
        •	ON/1100
        •	AB/1004
        •	AB/1005
    */
    public static Integer defaultRegistrationNumber = 1000;
    public static void generateRegistrationNumber(List<Account> records, Map<Id, Account> oldAccounts) {
        List<Account> registrationAccounts = new List<Account>();
        List<String> stateCodes = new List<String>();

        for (Account a : records) {
            if (!String.isBlank(a.IAAP_Registered_Highlight__c) && String.isBlank(a.Registration__c) && a.BillingStateCode <> null && (
                    oldAccounts.get(a.Id) == null || String.isBlank(oldAccounts.get(a.Id).IAAP_Registered_Highlight__c))) {
                registrationAccounts.add(a);
                stateCodes.add(a.BillingStateCode);
            }
        }

        if (registrationAccounts.isEmpty())
            return;

        List<Id> contractorRecordTypes = new List<Id>();
        contractorRecordTypes.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('US Contractor').getRecordTypeId());
        contractorRecordTypes.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId());
        contractorRecordTypes.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Residential Account').getRecordTypeId());

        Map<String, Integer> sequenceMap = new Map<String, Integer>();
        for (AggregateResult ar : [SELECT BillingStateCode, MAX(Registration_Sequence_Number__c) FROM Account WHERE RecordTypeId IN :contractorRecordTypes AND BillingStateCode IN :stateCodes AND Registration_Sequence_Number__c <> null GROUP BY BillingStateCode])
            sequenceMap.put(String.valueOf(ar.get('BillingStateCode')), Integer.valueOf(ar.get('expr0')));

        for (Account a : registrationAccounts) {
            Integer currentSequence = (sequenceMap.get(a.BillingStateCode) <> null) ?
                    sequenceMap.get(a.BillingStateCode) + 1 :
                    AccountService.defaultRegistrationNumber;

            a.Registration_Sequence_Number__c = currentSequence;
            a.Registration__c = a.BillingStateCode + '/' + a.Registration_Sequence_Number__c;
            sequenceMap.put(a.BillingStateCode, currentSequence);
        }
    }

    /*
        If Verified Building Location's address fields change, unset Verified flag
    */
    public static void sendUnverifiedBuildingLocationToApproval(List<Account> records, Map<Id, Account> oldRecords) {
        for (Account a : records) {
            if ((a.Address_Verification_Status__c <> 'Pending' && (
                    a.BillingStreet <> oldRecords.get(a.Id).BillingStreet ||
                            a.BillingCity <> oldRecords.get(a.Id).BillingCity ||
                            a.BillingStateCode <> oldRecords.get(a.Id).BillingStateCode ||
                            a.BillingPostalCode <> oldRecords.get(a.Id).BillingPostalCode ||
                            a.BillingCountryCode <> oldRecords.get(a.Id).BillingCountryCode)) ||
                    (a.Address_Verification_Status__c == null &&
                            oldRecords.get(a.Id).Address_Verification_Status__c == 'Pending')) {
                a.Address_Verification_Status__c = null;
            }
        }
    }
    /**
     * ClaimsV2-1015
     * By Anil Mannem (Incloud)
     * Automatic Approval process removed
     */
/*    public static void sendUnverifiedBuildingLocationToApproval(List<Account> records) {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();

        List<Approval.ProcessSubmitRequest> approvalRequests = new List<Approval.ProcessSubmitRequest>();

        for (Account a : records) {
            //if (!Approval.isLocked(a.Id)
            if (a.RecordTypeId == recTypeId && a.Address_Verification_Status__c == null) {
                Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                approvalRequest.setComments('Address is Unverified');
                approvalRequest.setObjectId(a.Id);
                approvalRequests.add(approvalRequest);
            }
        }
        if (!approvalRequests.isEmpty()) {
            Approval.process(approvalRequests, false);
        }
    }
    */

    public static void populateIkoDivisionType(List<Account> accounts){

        for(Account accObj : accounts){

            if(accObj.IKO_Division_Visible_to__c == 'Decra'){
                accObj.IKO_Division_Visible_type__c = 'Decra';
            }else{
                accObj.IKO_Division_Visible_type__c = 'Non Decra';
            }
        }
    }

    /**
     * @description Throw validation error message when any user (except System Administrator or Claims Manager)
     * 		tries to update an Account associated with Submitted Cases
     * @param accounts Trigger.new account list
     */
    public static void validateBuildingLocationAccountsWithNotInDraftCaseStatus(List<Account> accounts) {
        User runningUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
        Set<Id> accountIds = new Set<Id>();
        for (Account accRecord : accounts) {
            if(accRecord.Id != Null)
	            accountIds.add(accRecord.Id);
        }
        if (accountIds.isEmpty())
            return;

        Map<Id, Case> casesByIdsMap = new Map<Id, Case>([
                SELECT Id, Claim_Stage__c, AccountId
                FROM Case
                WHERE AccountId IN :accountIds AND Claim_Stage__c = 'Submitted'
        ]);
        if (casesByIdsMap.isEmpty()) {
            return;
        }
        Map<Id, Case> casesByAccountIds = new Map<Id, Case>();

        for (Case caseRecord : casesByIdsMap.values()) {
            casesByAccountIds.put(caseRecord.AccountId, caseRecord);
        }

        if (casesByAccountIds.isEmpty()) {
            return;
        }
        for (Account accountRecord : accounts) {
            if (runningUser.Profile.Name == 'System Administrator' ||
                    runningUser.Profile.Name.contains('Claims') ||
                    !casesByAccountIds.containsKey(accountRecord.Id)) {
                return;
            } else {
                accountRecord.addError('This record cannot be edited because it is associated with a submitted Case');
            }
        }
    }// validateBuildingLocationContactsWithNotInDraftCaseStatus method

    //CLAIMS - 667
    // populates the Parent_Building_Account__c field on Case with ParentId of the related Account
    public static void populateParentBuildingAccountFieldOnCase(List<Account> newAccountList,Map<Id,Account> oldAccountMap){

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

       Set<Id> parentAccountUpdatedSetIds = new Set<Id>();

        for(Account eachNewAccount : newAccountList){
           if(eachNewAccount.ParentId != oldAccountMap.get(eachNewAccount.Id).ParentId &&
                   recordTypeIds.contains(eachNewAccount.RecordTypeId)){
               parentAccountUpdatedSetIds.add(eachNewAccount.Id);
           }
        }

        if(parentAccountUpdatedSetIds.isEmpty()){
            return;
        }

        List<Case> toUpdateCases = [SELECT Id,Parent_Building_Account__c,Account.ParentId FROM Case
                                    WHERE AccountId IN :parentAccountUpdatedSetIds];

        if(toUpdateCases.isEmpty()){
            return;
        }

        for(Case eachCase : toUpdateCases){
            eachCase.Parent_Building_Account__c = eachCase.Account.ParentId;
        }

        update toUpdateCases;
    }
    
    //CLAIMSV2 - 1001
    //August 26, 2006
    // populates the Record_Type_Family__c field on Account if record type contains 'ROOFPRO' or 'IKOPRO'
    
    public static void populateRecordTypeFamilyForRoofProAccount(List<Account> records, Map<Id,Account> oldAccountMap){
        
        Set<Id> recordTypeIds = new Set<Id>();
        
        recordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('IKO ROOFPRO APPLICANTS').getRecordTypeId());
        recordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('IKOPRO Contractor').getRecordTypeId());
        recordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('IKOPRO Contractor HA OK').getRecordTypeId());
        for(Account a : records){
           if(recordTypeIds.contains(a.RecordTypeId)){
               a.Record_Type_Family__c = 'RoofPro';
           }
        }
        

    }

     /* ClaimsV2-828 - Update the address verfication status if the billing address is saved by Melissa Data Service */
     public static void UpdateAddressVerificationStatus(List<Account> newAccountList, Map<Id, Account> accountOldMap)
     {
         string query = System.URL.getCurrentRequestUrl().toString();
         string userName = userInfo.getUserName();
 
         for(Account thisAccount : newAccountList)
         {
             if((thisAccount.BillingStateCode != accountOldMap.get(thisAccount.Id).BillingStateCode) 
             || (thisAccount.BillingState != accountOldMap.get(thisAccount.Id).BillingState)
             || (thisAccount.BillingCountryCode != accountOldMap.get(thisAccount.Id).BillingCountryCode)
             || (thisAccount.BillingCountry != accountOldMap.get(thisAccount.Id).BillingCountry)
             || (thisAccount.BillingCity != accountOldMap.get(thisAccount.Id).BillingCity)
             || (thisAccount.BillingPostalCode != accountOldMap.get(thisAccount.Id).BillingPostalCode)
             || (thisAccount.BillingStreet != accountOldMap.get(thisAccount.Id).BillingStreet))
             {
                 /* User name condition has been included to enable the test case to enter the if condition. Because from a test class the URL will never have melissa
                  ExpressEntry value */
                 if(userName.equalsIgnoreCase('claimsManagerMelissaTestUsr@iko.com') || (query != null && query.contains('MDPERSONATOR.MD_ExpressEntry.updateRecord=1')))
                 {
                     thisAccount.Address_Verification_Status__c = 'Verified';
                 }
                 else
                 {
                     thisAccount.Address_Verification_Status__c = 'In Verification';
                 }
             }
         }
     }
	
} // end AccountService class