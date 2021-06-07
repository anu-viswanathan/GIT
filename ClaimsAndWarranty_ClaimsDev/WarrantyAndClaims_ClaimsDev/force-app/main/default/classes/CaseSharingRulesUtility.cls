/**
 * Created by sinan.bunni on 2019-09-24.
 */
public with sharing class CaseSharingRulesUtility {

    /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application - START */
    private static Map<Id, RecordType> claimRecordTypes;
    
    public static Map<Id, RecordType> getClaimRecordTypes() {
        if (CaseSharingRulesUtility.claimRecordTypes == null)
            CaseSharingRulesUtility.claimRecordTypes = new Map<Id, RecordType>([select Id, Name, DeveloperName from RecordType where SobjectType = 'Case' and Name like '%Claim%']);
        return claimRecordTypes;
    }
    /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application - END */
    
    public static void beforeInsertCases(List<Case> newCases) {

        System.debug('****Entered caseSharingUtilities onBeforeInsertcases');
        Set<Id> accountIds = getAccountIdsBeforeInsert(newCases);
        system.debug('*****populateAccountSharedWithFields method called');
        //populateAccountSharedWithFields(accountIds, newCases);
        
       	if (!accountIds.isEmpty())
        {
            populateAccountSharedWithFields(accountIds, newCases);
            UpdateCaseOwnerRegionForChangedAccount(accountIds, newCases);
        }
    }// end beforeInsert

    public static void beforeUpdateCases(List<Case> newCases, Map<Id, Case> oldCasesByIds) {

        Set<Id> accountIds = getAccountIdsBeforeUpdate(newCases, oldCasesByIds);
        //populateAccountSharedWithFields(accountIds, newCases);
        if (!accountIds.isEmpty())
        {
            populateAccountSharedWithFields(accountIds, newCases);
            UpdateCaseOwnerRegionForChangedAccount(accountIds, newCases);
        }

    }// end beforeInsert method
    
    //Vicki Tran update case region sharing fields
    //ClaimsV2-954
    public static void UpdateCaseOwnerRegionForChangedAccount(Set<Id> accountIds, List<Case> newCases)
    {
        List<Account> allAccounts = new List<Account>([SELECT Id, Name, Account_Owner_Region__c FROM Account WHERE Id IN :accountIds]);
        System.Debug(allAccounts);
        Map<Id, Account> accountsByAccountId = new Map<Id, Account>();
        for(Account a : allAccounts) {
            accountsByAccountId.put(a.Id, a);
        }
        
        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
        Map<Id, RecordType> claimRecordTypes = Case_TriggerHandler.getClaimRecordTypes();
        
        for (Case c : newCases)
        {
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
            if (claimRecordTypes.get(c.RecordTypeId) <> null){
                if(accountsByAccountId.containsKey(c.AccountId) == true ) 
                {
                    c.Account_Owner_Region__c = accountsByAccountId.get(c.AccountId).Account_Owner_Region__c;
                    System.Debug(accountsByAccountId.get(c.AccountId).Account_Owner_Region__c);
                }
                if (accountsByAccountId.containsKey(c.Contractor__c) == true)
                {
                    c.Contractor_Owner_Region__c = accountsByAccountId.get(c.Contractor__c).Account_Owner_Region__c;
                }
                if (accountsByAccountId.containsKey(c.Distributor__c) == true)
                {
                    c.Distributor_Owner_Region__c = accountsByAccountId.get(c.Distributor__c).Account_Owner_Region__c;
                }
        	}
        }             
    }

    public static void afterUpdateAccounts(List<Account> newAccounts, Map<Id, Account> oldAccountsByIds) {

        Map<Id, RecordType> recordTypesByIds = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account']);

        Set<Id> accountIds = new Set<Id>();
        Set<Id> contractorIds = new Set<Id>();
        Set<Id> distributorIds = new Set<Id>();

        for (Account newAccount : [SELECT Id, OwnerId, RecordTypeId, RecordType.Name FROM Account WHERE Id IN :newAccounts]) {

            String recordTypeName = recordTypesByIds.get(newAccount.RecordTypeId).Name;
            Id oldOwnerId = oldAccountsByIds.get(newAccount.Id).OwnerId;

            if (newAccount.OwnerId != oldOwnerId) {
                if (recordTypeName.contains('Building')) {
                    accountIds.add(newAccount.Id);
                }

                if (recordTypeName.contains('Contractor')) {
                    contractorIds.add(newAccount.Id);
                }

                if (recordTypeName.contains('Distributor')) {
                    distributorIds.add(newAccount.Id);
                }
            }
        }

        // Collect all the cases associated with the Contractor/ Distributor and Building Location records
        List<Case> allCases = new List<Case>();

        if (!accountIds.isEmpty()) {
            allCases.addAll(getBuildingLocationCases(accountIds));
        }

        if (!contractorIds.isEmpty()) {
            allCases.addAll(getContractorCases(contractorIds));
        }

        if (!distributorIds.isEmpty()) {
            allCases.addAll(getDistributorCases(distributorIds));
        }

        if (!allCases.isEmpty()) {
            Database.update(allCases, false);
        }
    } // end populateCaseAccountsSharedWithFieldsUponUpdate method

    private static void populateAccountSharedWithFields(Set<Id> accountIds, List<Case> newCases) {

        system.debug('*****Entered populateAccountSharedWithFields method');
        Map<Id, String> defaultAccountSharingRolesMap = getDefaultAccountSharingRolesMap(accountIds);
        Map<Id, Set<Id>> userOrGroupIdsByAccountIds = getUserOrGroupIdByAccountIds(accountIds);
        Set<AccountIdToUserOrGroupIdsWrapper> wrappers = populateAccountIdToUserOrGroupIdsWrapper(userOrGroupIdsByAccountIds);
        Set<AccountIdToGroupNameWrapper> groupWrappers = populateGroupsWrapper(wrappers);
        
         /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
        Map<Id, RecordType> claimRecordTypes = Case_TriggerHandler.getClaimRecordTypes();
        
        for (Case caseRecord : newCases) {
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
                if (claimRecordTypes.get(caseRecord.RecordTypeId) <> null){
                for (AccountIdToGroupNameWrapper wrapper : groupWrappers) {
                    if (caseRecord.AccountId == wrapper.accountId) {
                        system.debug('***Entered populateAccountSharedWithFields AccountSharedWith Before :'+caseRecord.Account_Shared_With__c);
                        caseRecord.Account_Shared_With__c = '';
                        caseRecord.Account_Shared_With__c = wrapper.roleOrGroupByGroupString + ',' + defaultAccountSharingRolesMap.get(caseRecord.AccountId);
                        system.debug('***Entered populateAccountSharedWithFields AccountSharedWith After :'+caseRecord.Account_Shared_With__c);
                    }
    
                    if (caseRecord.Contractor__c == wrapper.accountId) {
                        caseRecord.Contractor_Shared_With__c = '';
                        caseRecord.Contractor_Shared_With__c = wrapper.roleOrGroupByGroupString + ',' + defaultAccountSharingRolesMap.get(caseRecord.Contractor__c);
    
                    }
    
                    if (caseRecord.Distributor__c == wrapper.accountId) {
                        caseRecord.Distributor_Shared_With__c = '';
                        caseRecord.Distributor_Shared_With__c = wrapper.roleOrGroupByGroupString + ',' + defaultAccountSharingRolesMap.get(caseRecord.Distributor__c);
                    }
                }
        	}
        }
    } // end populateAccountSharedWithFields method

    private static Set<Id> getAccountIdsBeforeUpdate(final List<Case> newCases, Map<Id, Case> oldCasesByIds) {

        Set<Id> accountIds = new Set<Id>();

        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
        Map<Id, RecordType> claimRecordTypes = Case_TriggerHandler.getClaimRecordTypes();
        
        for (Case caseRecord : newCases) {
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
            if (claimRecordTypes.get(caseRecord.RecordTypeId) <> null){
                Id buildingAccountId = oldCasesByIds.get(caseRecord.Id).AccountId;
                Id contractorAccountId = oldCasesByIds.get(caseRecord.Id).Contractor__c;
                Id distributorAccountId = oldCasesByIds.get(caseRecord.Id).Distributor__c;
    
                if (buildingAccountId != caseRecord.AccountId) {
                    caseRecord.Account_Shared_With__c = '';
                    accountIds.add(caseRecord.AccountId);
                }
    
                if (contractorAccountId != caseRecord.Contractor__c) {
                    caseRecord.Contractor_Shared_With__c = '';
                    accountIds.add(caseRecord.Contractor__c);
                }
    
                if (distributorAccountId != caseRecord.Distributor__c) {
                    caseRecord.Distributor_Shared_With__c = '';
                    accountIds.add(caseRecord.Distributor__c);
                }
        	}
        }

        return accountIds;
    } // end getAccountIdsBeforeUpdate method

    private static Set<Id> getAccountIdsBeforeInsert(final List<Case> newCases) {

        Set<Id> accountIds = new Set<Id>();
        
        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
        Map<Id, RecordType> claimRecordTypes = Case_TriggerHandler.getClaimRecordTypes();
        
        for (Case newCase : newCases) {
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
            if (claimRecordTypes.get(newCase.RecordTypeId) <> null){
                if (newCase.AccountId != NULL) {
                    accountIds.add(newCase.AccountId);
                }
    
                if (newCase.Contractor__c != NULL) {
                    accountIds.add(newCase.Contractor__c);
                }
    
                if (newCase.Distributor__c != NULL) {
                    accountIds.add(newCase.Distributor__c);
                }
        	}
        }

        return accountIds;
    } // end getAccountIds method

    /**
     * @description retrieve all Distributor Case records
     * @param distributorIds Set of Account Id with Record Type contains distributor
     * @return List of Case records
     */
    private static List<Case> getDistributorCases(Set<Id> distributorIds) {
        List<Case> allCases = new List<Case>();

        Map<Id, Set<Id>> userOrGroupIdsByAccountIds = getUserOrGroupIdByAccountIds(distributorIds);
        Set<AccountIdToUserOrGroupIdsWrapper> wrappers = populateAccountIdToUserOrGroupIdsWrapper(userOrGroupIdsByAccountIds);
        Set<AccountIdToGroupNameWrapper> groupWrappers = populateGroupsWrapper(wrappers);

        for (Case caseRecord : [
                SELECT Id, Distributor__c, Distributor_Shared_With__c
                FROM Case
                WHERE Distributor__c IN :distributorIds
        ]) {

            for (AccountIdToGroupNameWrapper wrapper : groupWrappers) {
                if (caseRecord.Distributor__c == wrapper.accountId) {
                    caseRecord.Distributor_Shared_With__c = '';
                    caseRecord.Distributor_Shared_With__c = wrapper.roleOrGroupByGroupString;
                }
            }
            allCases.add(caseRecord);
        }

        return allCases;
    } // end get DistributorCases method

    /**
     * @description retrieve all Contractor Case records
     * @param contractorIds Set of Account Id with Record Type contains contractor
     * @return  List of Case records
     */
    private static List<Case> getContractorCases(Set<Id> contractorIds) {

        List<Case> allCases = new List<Case>();

        Map<Id, Set<Id>> userOrGroupIdsByAccountIds = getUserOrGroupIdByAccountIds(contractorIds);
        Set<AccountIdToUserOrGroupIdsWrapper> wrappers = populateAccountIdToUserOrGroupIdsWrapper(userOrGroupIdsByAccountIds);
        Set<AccountIdToGroupNameWrapper> groupWrappers = populateGroupsWrapper(wrappers);

        for (Case caseRecord : [
                SELECT Id, Contractor__c, Contractor_Shared_With__c
                FROM Case
                WHERE Contractor__c IN :contractorIds
        ]) {

            for (AccountIdToGroupNameWrapper wrapper : groupWrappers) {
                if (caseRecord.Contractor__c == wrapper.accountId) {
                    caseRecord.Contractor_Shared_With__c = '';
                    caseRecord.Contractor_Shared_With__c = wrapper.roleOrGroupByGroupString;

                }
            }
            allCases.add(caseRecord);
        }

        return allCases;
    }// end getContractorCases method

    /**
     * @description retrieve all Building Location Case records
     * @param contractorIds Set of Account Id with Record Type contains Building
     * @return  List of Case records
     */
    private static List<Case> getBuildingLocationCases(Set<Id> accountIds) {
        List<Case> allCases = new List<Case>();

        Map<Id, Set<Id>> userOrGroupIdsByAccountIds = getUserOrGroupIdByAccountIds(accountIds);
        Set<AccountIdToUserOrGroupIdsWrapper> wrappers = populateAccountIdToUserOrGroupIdsWrapper(userOrGroupIdsByAccountIds);
        Set<AccountIdToGroupNameWrapper> groupWrappers = populateGroupsWrapper(wrappers);

        for (Case caseRecord : [
                SELECT Id, AccountId, Account_Shared_With__c
                FROM Case
                WHERE AccountId IN :accountIds
        ]) {
            for (AccountIdToGroupNameWrapper wrapper : groupWrappers) {
                if (caseRecord.AccountId == wrapper.accountId) {
                    caseRecord.Account_Shared_With__c = '';
                    caseRecord.Account_Shared_With__c = wrapper.roleOrGroupByGroupString;
                }
            }
            allCases.add(caseRecord);
        }

        return allCases;
    } // end getBuildingLocationCases method

    private static Map<Id, String> getRoleOrGroupByGroupIds(final Set<Id> roleOrGroupIds) {

        Map<Id, String> roleOrGroupByGroupIds = new Map<Id, String>();
        if (!roleOrGroupIds.isEmpty()) {
            for (Group roleOrGroupName : [SELECT Id, DeveloperName FROM Group WHERE Id IN :roleOrGroupIds]) {
                if (!roleOrGroupByGroupIds.containsKey(roleOrGroupName.Id)) {
                    roleOrGroupByGroupIds.put(roleOrGroupName.Id, roleOrGroupName.DeveloperName);
                }
            }
        }

        return roleOrGroupByGroupIds;

    } // end getRoleOrGroupByGroupIds method

    private static Map<Id, Set<Id>> getUserOrGroupIdByAccountIds(final Set<Id> accountIds) {

        Map<Id, Set<Id>> userOrGroupIdsByAccountIds = new Map<Id, Set<Id>>();

        for (AccountShare share : [
                SELECT Id, AccountId, UserOrGroupId
                FROM AccountShare
                WHERE AccountId IN :accountIds AND RowCause != 'ImplicitParent'
        ]) {
            if (!userOrGroupIdsByAccountIds.containsKey(share.AccountId)) {
                userOrGroupIdsByAccountIds.put(share.AccountId, new Set<Id>{
                        share.UserOrGroupId
                });
            } else {
                userOrGroupIdsByAccountIds.get(share.AccountId).add(share.UserOrGroupId);
            }
        }

        return userOrGroupIdsByAccountIds;
    } // end getUserOrGroupIdByAccountIds method

    private static Set<AccountIdToUserOrGroupIdsWrapper> populateAccountIdToUserOrGroupIdsWrapper(Map<Id, Set<Id>> userOrGroupIdsByAccountIds) {
        Set<AccountIdToUserOrGroupIdsWrapper> wrappers = new Set<AccountIdToUserOrGroupIdsWrapper>();

        for (Id accountId : userOrGroupIdsByAccountIds.keySet()) {
            wrappers.add(new accountIdToUserOrGroupIdsWrapper(userOrGroupIdsByAccountIds.get(accountId), accountId));
        }
        return wrappers;
    } // end populateAccountIdToUserOrGroupIdsWrapper method

    private static Set<AccountIdToGroupNameWrapper> populateGroupsWrapper(Set<AccountIdToUserOrGroupIdsWrapper> wrappers) {

        Set<AccountIdToGroupNameWrapper> groupWrappers = new Set<AccountIdToGroupNameWrapper>();

        /**
         * ClaimsV2-953
         * By Anil Mannem (Incloud)
         * for loop refactored as method in loop has SOQL query
         */

        Set<Id> userIdSet = new Set<Id>();
        for (AccountIdToUserOrGroupIdsWrapper wrapper : wrappers) {
            userIdSet.addAll(wrapper.userOrGroupIds);
        }
        
        Map<Id, String> roleOrGroupByGroupMap = getRoleOrGroupByGroupIds(userIdSet);

        for (AccountIdToUserOrGroupIdsWrapper wrapper : wrappers) {
            String roleOrGroupByString = '';
            for (Id userOrGroupId : wrapper.userOrGroupIds) {
                if (roleOrGroupByGroupMap.containsKey(userOrGroupId)) {
                    String roleOrGroupName = roleOrGroupByGroupMap.get(userOrGroupId);
                    roleOrGroupByString = String.join(new List<String> {roleOrGroupName}, ',');
                }
            }
            groupWrappers.add(new AccountIdToGroupNameWrapper(roleOrGroupByString, wrapper.accountId));
        }

        return groupWrappers;

    } // end populateGroupsWrapper method

    /**
     * @description retrieve the Account Record Type which then will be used to see which
     *      Account Sharing Rules to used in @see getAccountShareToByAccountIds
     *      to put in all the Account Sharing rules that use Record Type
     *
     * @param accountIds Set of Account Ids collected by the inserted Case records
     * @return Map of account Id to account record type name
     */
    public static Map<Id, String> getRecordTypesByAccountIds(final Set<Id> accountIds) {
        Map<Id, String> recordTypesByAccountIds = new Map<Id, String>();

        for (Account accountRecord : [SELECT Id, RecordType.Name FROM Account WHERE Id IN :accountIds]) {
            recordTypesByAccountIds.put(accountRecord.Id, accountRecord.RecordType.Name);
        }

        return recordTypesByAccountIds;
    } // end getRecordTypesByAccountIds method

    public static Map<Id, String> getDefaultAccountSharingRolesMap(final Set<Id> accountIds) {

        Map<Id, String> accountIdToDefaultAccountSharingRoles = new Map<Id, String>();

        // Get all the Account Sharing Rules that are not triggered when the Account/ Case is created
        Map<Id, String> recordTypeByAccountIds = getRecordTypesByAccountIds(accountIds);

        for (Id accountId : recordTypeByAccountIds.keySet()) {
            String recordTypeName = recordTypeByAccountIds.get(accountId);

            if (recordTypeName == 'Building Location') {
                accountIdToDefaultAccountSharingRoles.put(accountId, 'Claims_Manager,AllInternalUsers');
            } else if (recordTypeName == 'Designer' || recordTypeName == 'Contractor' || recordTypeName == 'Distributor' || recordTypeName == 'Other') {
                accountIdToDefaultAccountSharingRoles.put(accountId, 'VP_Commercial_Division,Claims_Manager');
            } else if (recordTypeName == 'US Contractor' || recordTypeName == 'US Distributor' || recordTypeName == 'Residential Account' || recordTypeName == 'US Architect') {
                accountIdToDefaultAccountSharingRoles.put(accountId, 'Claims_Manager');
            }
        }

        return accountIdToDefaultAccountSharingRoles;
    }

    private class AccountIdToUserOrGroupIdsWrapper {
        public Set<Id> userOrGroupIds;
        public Id accountId;

        public accountIdToUserOrGroupIdsWrapper(Set<Id> userOrGroupIds, Id accountId) {
            this.userOrGroupIds = userOrGroupIds;
            this.accountId = accountId;
        }
    }

    private class AccountIdToGroupNameWrapper {
        public String roleOrGroupByGroupString;
        public Id accountId;

        public accountIdToGroupNameWrapper(String roleOrGroupByGroupString, Id accountId) {
            this.roleOrGroupByGroupString = roleOrGroupByGroupString;
            this.accountId = accountId;
        }
    }

} // end CaseSharingRulesUtility class