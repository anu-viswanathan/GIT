/**
* @Version: 1.0
* @Author: Maarten Devos
* @Copyright: 2020 4C Consulting
* @Uses:
* -----------------------------------------------------------------------------------------------
* Description: Unit tests for UpdateAccountOwnerBatch

* Unit tests: 
*
* Created: 17/01/2020
* Last Updated: 17/01/2020
*
* Change log:
* -----------------------------------------------------------------------------------------------
*/
@isTest
public class UpdateAccountOwnerBatchTest {

    @isTest
    public static void start() {
        UpdateAccountOwnerBatch batch = new UpdateAccountOwnerBatch();

        System.Test.startTest();
        Database.QueryLocator queryLocator = batch.start(null);
        System.Test.stopTest();

        System.assertEquals('SELECT Id, EU_ERP_Sales_Rep_ID__c, OwnerId, Owner.EU_Windows_User_Id__c FROM Account WHERE EU_ERP_Sales_Rep_ID__c != null AND RecordTypeId IN :recordTypeIds', queryLocator.getQuery());
    }

    @isTest
    public static void execute() {
        List<Profile> profiles = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        List<User> userList = new List<User>();
        User user1 = new User();
        user1.EU_Windows_User_Id__c = 'AA11BB';
        user1.Username = 'testUSer1@iko.com.sbx';
        user1.LastName = 'User 1';
        user1.Email = 'test@iko.com';
        user1.Alias = 'AA11BB';
        user1.TimeZoneSidKey = 'Europe/Brussels';
        user1.LocaleSidKey = 'en_US';
        user1.EmailEncodingKey = 'ISO-8859-1';
        user1.ProfileId = profiles[0].Id;
        user1.LanguageLocaleKey = 'en_US';
        userList.add(user1);

        User user2 = new User();
        user2.EU_Windows_User_Id__c = 'AA22BB';
        user2.Username = 'testUSer2@iko.com.sbx';
        user2.LastName = 'User 2';
        user2.Email = 'test@iko.com';
        user2.Alias = 'AA22BB';
        user2.TimeZoneSidKey = 'Europe/Brussels';
        user2.LocaleSidKey = 'en_US';
        user2.EmailEncodingKey = 'ISO-8859-1';
        user2.ProfileId = profiles[0].Id;
        user2.LanguageLocaleKey = 'en_US';
        userList.add(user2);

        // Check if Unassigned user exists
        List<User> unassignedUsers = [SELECT Id FROM User WHERE EU_Windows_User_Id__c = 'UNASSIGN'];
        User unassignedUser;
        if (unassignedUsers.size() == 0) {
            unassignedUser = new User();
            unassignedUser.EU_Windows_User_Id__c = 'UNASSIGN';
            unassignedUser.Username = 'unassigned@iko.com.sbx';
            unassignedUser.LastName = 'Unassigned';
            unassignedUser.Email = 'test@iko.com';
            unassignedUser.Alias = 'UNASSIGN';
            unassignedUser.TimeZoneSidKey = 'Europe/Brussels';
            unassignedUser.LocaleSidKey = 'en_US';
            unassignedUser.EmailEncodingKey = 'ISO-8859-1';
            unassignedUser.ProfileId = profiles[0].Id;
            unassignedUser.LanguageLocaleKey = 'en_US';
            unassignedUser.ProfileId = profiles[0].Id;
            userList.add(unassignedUser);
        } else {
            unassignedUser = unassignedUsers[0];
        }

        insert userList;

        Id euDeveloperRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'EU_Customer'][0].Id;

        /*
        Account 1 Owner should change to user1
        Account 2 Owner should change to user2
        Account 3 Owner should change to unassigned user
        Account 4 Owner shouldn't change (because of different recordType)
        Account 5 Owner shouldn't change (already in correct owner)
         */
        Account account1 = new Account(EU_ERP_Sales_Rep_ID__c='AA11BB', RecordTypeId=euDeveloperRecordTypeId, Name='Test Account 1');
        Account account2 = new Account(EU_ERP_Sales_Rep_ID__c='AA22BB', RecordTypeId=euDeveloperRecordTypeId, Name='Test Account 2');
        Account account3 = new Account(EU_ERP_Sales_Rep_ID__c='AA22XX', RecordTypeId=euDeveloperRecordTypeId, Name='Test Account 3');
        Account account4 = new Account(EU_ERP_Sales_Rep_ID__c='AA11BB', Name='Test Account 4');
        Account account5 = new Account(EU_ERP_Sales_Rep_ID__c='AA11BB', RecordTypeId=euDeveloperRecordTypeId, Name='Test Account 4', OwnerId = user1.Id);
        List<Account> accounts = new List<Account> { account1, account2, account3, account4, account5 };
        insert accounts;
        Set<Id> accountIds = new Set<Id> { account1.Id, account2.Id, account3.Id, account4.Id, account5.Id };

        System.Test.startTest();
        UpdateAccountOwnerBatch batch = new UpdateAccountOwnerBatch();
        Database.QueryLocator queryLocator = batch.start(null);
        Set<Id> recordTypeIds = new Set<Id> { euDeveloperRecordTypeId };
        batch.execute(null, (List<Account>)Database.query(queryLocator.getQuery()));
        System.Test.stopTest();

        List<Account> accountsAfter = [SELECT Id, OwnerId, Owner.Name, RecordType.DeveloperName FROM Account WHERE Id IN :accountIds];
        Account account1After;
        Account account2After;
        Account account3After;
        Account account4After;
        Account account5After;
        for (Account account: accountsAfter) {
            if (account.Id == account1.Id) {
                account1After = account;
            }
            if (account.Id == account2.Id) {
                account2After = account;
            }
            if (account.Id == account3.Id) {
                account3After = account;
            }
            if (account.Id == account4.Id) {
                account4After = account;
            }
            if (account.Id == account5.Id) {
                account5After = account;
            }
        }

        System.debug(account1After.Owner.Name);
        System.debug(account2After.Owner.Name);
        System.debug(account3After.Owner.Name);
        System.debug(account4After.Owner.Name);

        System.debug(account1After.RecordType.DeveloperName);
        System.debug(account2After.RecordType.DeveloperName);
        System.debug(account3After.RecordType.DeveloperName);
        System.debug(account4After.RecordType.DeveloperName);

        System.assertEquals(account1After.OwnerId, user1.Id);
        System.assertEquals(account2After.OwnerId, user2.Id);
        System.assertEquals(account3After.OwnerId, unassignedUser.Id);
        System.assertNotEquals(account4After.OwnerId, user1.Id);
        System.assertEquals(account5After.OwnerId, user1.Id);
    }
}