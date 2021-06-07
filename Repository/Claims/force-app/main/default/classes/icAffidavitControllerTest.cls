@isTest
public with sharing class icAffidavitControllerTest {
    private final static String INSTALLATION_FUNDAMENTALS = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('IF_Course_Affirmation__c').getDescribe().getLabel();
    private final static String SAFETY_FUNDAMENTALS = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Safety_Fundamentals_Completed__c').getDescribe().getLabel();
    @testSetup
    static void setup() {
        Profile profileId = [
                SELECT Id
                FROM Profile
                WHERE Name = 'IKOPRO Contractor'
                LIMIT 1
        ];
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IKO ROOFPRO APPLICANTS').getRecordTypeId();
        Account account = new Account(
                Name = generateRandomString(5) +'(ROOFPRO)',
                BillingCountryCode = 'CA',
                BillingStateCode = 'ON',
                BillingPostalCode = 'L7Y 6T5',
                BillingCity = 'Brampton',
                BillingStreet = '123 street',
                Phone = '555-555-5555',
                RecordTypeId = recordTypeId
        );
        insert account;
        Contact contact = new Contact(
                LastName = generateRandomString(7),
                AccountId = account.Id,
                FirstName = generateRandomString(7)
        );
        insert contact;
        User user = new User(
                LastName = 'Tester',
                FirstName = 'Tester',
                Alias = 'testtes',
                Email = UserInfo.getUserId().substring(8) + String.valueOf(Date.today()) + '@test.com',
                Username = UserInfo.getUserId().substring(8) + String.valueOf(Date.today()) + '@test.com',
                ProfileId = profileId.id,
                TimeZoneSidKey = 'GMT',
                LanguageLocaleKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LocaleSidKey = 'en_US',
                ContactId = contact.Id
        );
        insert user;
    }

    @isTest
    static void submitAffidavitIFTest() {
        User user = [
                SELECT Id, User.AccountId
                FROM User
                WHERE Username = :UserInfo.getUserId().substring(8) + String.valueOf(Date.today()) + '@test.com'
        ];
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'LMS_External_User'];
        insert new PermissionSetAssignment(AssigneeId = user.id, PermissionSetId = ps.Id);

        System.runAs(user) {
            redwing__Training_Plan__c trainingPlan = new redwing__Training_Plan__c(
                    Name = INSTALLATION_FUNDAMENTALS
            );
            insert trainingPlan;
            redwing__Learning_Assignment__c learningAssignment = new redwing__Learning_Assignment__c (
                    redwing__Training_Plan__c = trainingPlan.Id
            );
            insert learningAssignment;
            Test.startTest();
            icAffidavitController.submitAffidavit(learningAssignment.Id, 'Test', 'Test', 'Test');
            Test.stopTest();
            Account account = [
                    SELECT IF_Course_Affirmation__c
                    FROM Account
                    WHERE Id = :user.AccountId
            ];
			learningAssignment = [
                SELECT redwing__Progress__c
                FROM redwing__Learning_Assignment__c
                WHERE Id = :learningAssignment.Id
        	];
            System.assertEquals(true, account.IF_Course_Affirmation__c);
            System.assertEquals('Completed', learningAssignment.redwing__Progress__c);
        }
    }
    @isTest
    static void submitAffidavitSFTest() {
        User user = [
                SELECT Id, User.AccountId
                FROM User
                WHERE Username = :UserInfo.getUserId().substring(8) + String.valueOf(Date.today()) + '@test.com'
        ];
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'LMS_External_User'];
        insert new PermissionSetAssignment(AssigneeId = user.id, PermissionSetId = ps.Id);

        System.runAs(user) {
            redwing__Training_Plan__c trainingPlan = new redwing__Training_Plan__c(
                    Name = SAFETY_FUNDAMENTALS
            );
            insert trainingPlan;
            redwing__Learning_Assignment__c learningAssignment = new redwing__Learning_Assignment__c (redwing__Training_Plan__c = trainingPlan.Id);
            insert learningAssignment;
            Test.startTest();
            icAffidavitController.submitAffidavit(learningAssignment.Id, 'Test', 'Test', 'Test');
            Test.stopTest();
            Account account = [
                    SELECT Safety_Fundamentals_Completed__c
                    FROM Account
                    WHERE Id = :user.AccountId
            ];
            learningAssignment = [
                SELECT redwing__Progress__c
                FROM redwing__Learning_Assignment__c
                WHERE Id = :learningAssignment.Id
        	];
            System.assertEquals(true, account.Safety_Fundamentals_Completed__c);
            System.assertEquals('Completed', learningAssignment.redwing__Progress__c);
        }
    }

    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }
}