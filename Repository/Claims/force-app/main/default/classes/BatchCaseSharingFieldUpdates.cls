global with sharing class BatchCaseSharingFieldUpdates implements Database.Batchable<sObject>, Database.Stateful {

    global Set<Id> distributorIds{get;set;}
    global Map<Id, Set<Id>> userOrGroupIdsByAccountIds{get;set;}
    global Set<CaseSharingRulesUtility.AccountIdToUserOrGroupIdsWrapper> wrappers{get;set;}
    global Set<CaseSharingRulesUtility.AccountIdToGroupNameWrapper> groupWrappers{get;set;}

    global BatchCaseSharingFieldUpdates(Set<Id> distIds, Map<Id, Set<Id>> userOrGrpIdsByAcctIds, Set<CaseSharingRulesUtility.AccountIdToUserOrGroupIdsWrapper> wrp, Set<CaseSharingRulesUtility.AccountIdToGroupNameWrapper> grpWrappers) {
            this.distributorIds = distIds;
            this.userOrGroupIdsByAccountIds = userOrGrpIdsByAcctIds;
            this.wrappers = wrp;
            this.groupWrappers = grpWrappers;
    }

    global Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([SELECT Id, Distributor__c, Distributor_Shared_With__c FROM Case WHERE Distributor__c IN : distributorIds]);
    }

    global void execute(Database.BatchableContext context, List<Case> caseScope) {

        system.debug('====> BatchCaseSharingFieldUpdates');
        List<Case> allCases = new List<Case>();
        for(case eachCase : caseScope){

            for (CaseSharingRulesUtility.AccountIdToGroupNameWrapper wrapper : groupWrappers) {
                if (eachCase.Distributor__c == wrapper.accountId) {
                    eachCase.Distributor_Shared_With__c = '';
                    eachCase.Distributor_Shared_With__c = wrapper.roleOrGroupByGroupString;
                }
            }
            allCases.add(eachCase);
        }

        if (!allCases.isEmpty()) {
            Database.update(allCases, false);
        }
    }

    global void finish(Database.BatchableContext context) {
    }

}