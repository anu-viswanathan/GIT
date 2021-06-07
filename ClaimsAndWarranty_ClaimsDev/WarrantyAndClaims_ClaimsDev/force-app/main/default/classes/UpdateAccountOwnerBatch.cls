/**
* @Version: 1.0
* @Author:Maarten Devos
* @Copyright: 2020 4C Consulting
* @Uses:
* -----------------------------------------------------------------------------------------------
* Description: Batch class to update Account owner field for EU RecordTypes based on Windows Id field on Account

* Unit tests: 
*
* Created: 17/01/2020
* Last Updated: 17/01/2020
*
* Change log:
* -----------------------------------------------------------------------------------------------
*/

global class UpdateAccountOwnerBatch implements Database.Batchable<sObject> {

    global UpdateAccountOwnerBatch() {}

    global Database.QueryLocator start(Database.BatchableContext ctx) {
        // Get recordTypeIds
        Map<String, RecordTypeInfo> recordTypes = Account.getSObjectType().getDescribe().getRecordTypeInfosByDeveloperName();
        Set<Id> recordTypeIds = new Set<Id>();
        Set<String> allowedRecordTypes = new Set<String> { 'EU_Customer' };
        for (String recordTypeDevName : recordTypes.keySet()) {
            RecordTypeInfo recordTypeInfo = recordTypes.get(recordTypeDevName);
            if (allowedRecordTypes.contains(recordTypeDevName)) {
                recordTypeIds.add(recordTypeInfo.recordTypeId);
            }
        }
        // Search for all accounts where External Sales Rep Id is filled and in the EU recordTypes
        String soql = 'SELECT Id, EU_ERP_Sales_Rep_ID__c, OwnerId, Owner.EU_Windows_User_Id__c FROM Account WHERE EU_ERP_Sales_Rep_ID__c != null AND RecordTypeId IN :recordTypeIds';
        return Database.getQueryLocator(soql);
    }

    global void execute(Database.BatchableContext ctx, List<Account> scope) {
        String unassignedWindowsUserId = 'UNASSIGN';
        // Get windows User Ids
        Set<String> windowsUserIds = new Set<String> { unassignedWindowsUserId };
        for(Account account : scope) {
            if (account.Owner.EU_Windows_User_Id__c != account.EU_ERP_Sales_Rep_ID__c && account.EU_ERP_Sales_Rep_ID__c != null) {
                windowsUserIds.add(account.EU_ERP_Sales_Rep_ID__c);
            }
        }
        // Get users based on windows Id and put them in a map
        List<User> users = [SELECT Id, EU_Windows_User_Id__c FROM User WHERE EU_Windows_User_Id__c IN :windowsUserIds AND EU_Windows_User_Id__c != null];
        Map<String, User> userMap = new Map<String, User>();
        for (User user : users) {
            userMap.put(user.EU_Windows_User_Id__c, user);
        }

        List<Account> accountsToUpdate = new List<Account>();
        // Get Unassigned user
        User unassignedUser = userMap.get(unassignedWindowsUserId);
        // Assign the new owners
        for (Account account : scope) {
            if (account.EU_ERP_Sales_Rep_ID__c != null && account.EU_ERP_Sales_Rep_ID__c != account.Owner.EU_Windows_User_Id__c) {
                User user = userMap.get(account.EU_ERP_Sales_Rep_ID__c);
                if (user == null) {
                    user = unassignedUser;
                }
                account.OwnerId = user.Id;
                accountsToUpdate.add(account);
            }
        }
        update accountsToUpdate;
    }

    global void finish(Database.BatchableContext ctx) {}

}