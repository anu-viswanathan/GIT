/**
 * @description Test Handler for ContactService class
 * @author Sinan Bunni
 * @date 26/04/2019
 */
@IsTest
private class ContactServiceTest {

    private static void createUsers() {

        List<User> toInsertUsers = new List<User>();
        toInsertUsers.add(TestFactory.createUser('UnitClaim', 'TestsClaim', 'claimsManagerUsr@iko.com', 'claimsManagerUsr@iko.com', 'Claims Manager',
                'Claims Manager', 'tclu', 'GMT', 'en_US', 'UTF-8', 'en_US', 'United States', null, false));
        toInsertUsers.add(TestFactory.createUser('Unit', 'Tests', 'testuser@iko.com', 'testuser@iko.com', 'Commercial Claims Rep',
                'Commercial Claims Rep', 'testuser', 'GMT', 'en_US', 'UTF-8', 'en_US', 'United States', null, false));
        toInsertUsers.add(TestFactory.createUser('Unit', 'Tests', 'rtestuser@iko.com', 'rtestuser@iko.com', 'Residential Claims Rep',
                'Residential Claims Rep', 'test2', 'GMT', 'en_US', 'UTF-8', 'en_US', 'United States', null, false));
        toInsertUsers.add(TestFactory.createUser('Unit', 'Tests', 'salesrsmmgr@iko.com', 'salesrsmmgr@iko.com', 'USRS Manager',
                'RSM West', 'salesmgr', 'GMT', 'en_US', 'UTF-8', 'en_US', null, null, false));

        insert toInsertUsers;

    }

    @TestSetup static void setupTestData() {
        createUsers();
    }

    @isTest static void validateBuildingLocationContactsWithNotInDraftCaseStatus_SystemAdminUserWithLinkedToClaimIsTrue_NoValidationThrown() {

        Test.startTest();
        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();

        List<Account> acts = TestFactory.createAccounts(baRt, 'CaseServiceTestWashington', '9 King St E', 'Seattle', 'WA', 'US', '12111',
                'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false);
        acts[0].Linked_to_Claim__c = TRUE;

        insert acts;

        Contact testContact = new Contact(LastName = 'Test', FirstName = 'Test', AccountId = acts[0].Id, Linked_to_Claim__c = true);
        insert testContact;

        Boolean isValidationThrown = false;

        try {
            ContactService.validateBuildingLocationContactsWithNotInDraftCaseStatus(new List<Contact>{
                    testContact
            });
        } catch (System.Exception e) {
            isValidationThrown = true;
        }
        Test.stopTest();

        System.assertEquals(isValidationThrown, false, 'System Admin users are allowed to edit contact records.');

    }

    @isTest static void validateBuildingLocationContactsWithNotInDraftCaseStatus_ClaimsManagerUserWithLinkedToClaimIsTrue_NoValidationThrown() {

        User u = [SELECT Id FROM User WHERE Username = 'claimsManagerUsr@iko.com'];
        System.runAs(u) {
            Test.startTest();
            Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
            Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();

            //create Account
            List<Account> toInsertAccounts = new List<Account>();

            List<Account> acts = TestFactory.createAccounts(baRt, 'CaseServiceTestWashington', '9 King St E', 'Seattle', 'WA', 'US', '12111',
                    'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false);
            acts[0].Linked_to_Claim__c = TRUE;
            toInsertAccounts.addAll(acts);
            insert toInsertAccounts;

            //create contact
            List<Contact> toInsertContacts = new List<Contact>();
            List<Contact> con = TestFactory.createContacts(toInsertAccounts[0].Id, 'CaseServiceTest', UserInfo.getUserId(), 1, false);
            con[0].Linked_to_Claim__c = TRUE;
            con[0].FirstName = 'Test';
            toInsertContacts.addAll(con);
            insert toInsertContacts;

            //create Cases
            List<Case> toInsertCases = new List<Case>();
            toInsertCases.addAll(TestFactory.createCases(ccRt, toInsertAccounts[0].Id, toInsertContacts[0].Id, 'Distributor', 'CaseServiceWashington', date.newInstance(2006, 5, 5), 'US', 'Draft', 1, false));
            insert toInsertCases;

            Account testAccount = toInsertAccounts[0];

            Contact testContact = toInsertContacts[0];

            Boolean isValidationThrown = false;

            try {

                ContactService.validateBuildingLocationContactsWithNotInDraftCaseStatus(new List<Contact>{
                        testContact
                });

            } catch (System.Exception e) {
                isValidationThrown = true;
            }
            Test.stopTest();
            System.assertEquals(isValidationThrown, false, 'Claims Manager users are allowed to edit contact records.');

        }

    }

    @isTest static void validateBuildingLocationContactsWithNotInDraftCaseStatus_CommercialUserWithLinkedToClaimIsTrue_NoValidationThrown() {

        User u = [SELECT Id FROM User WHERE Username = 'testuser@iko.com'];

        System.runAs(u) {
            Test.startTest();
            Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
            Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();

            //create Account
            List<Account> toInsertAccounts = new List<Account>();

            List<Account> acts = TestFactory.createAccounts(baRt, 'CaseServiceTestWashington', '9 King St E', 'Seattle', 'WA', 'US', '12111',
                    'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false);
            acts[0].Linked_to_Claim__c = TRUE;
            toInsertAccounts.addAll(acts);
            insert toInsertAccounts;

            //create contact
            List<Contact> toInsertContacts = new List<Contact>();
            List<Contact> con = TestFactory.createContacts(toInsertAccounts[0].Id, 'CaseServiceTest', UserInfo.getUserId(), 1, false);
            con[0].Linked_to_Claim__c = TRUE;
            con[0].FirstName = 'Test';
            toInsertContacts.addAll(con);
            insert toInsertContacts;

            //create Cases
            List<Case> toInsertCases = new List<Case>();
            toInsertCases.addAll(TestFactory.createCases(ccRt, toInsertAccounts[0].Id, toInsertContacts[0].Id, 'Distributor', 'CaseServiceWashington', date.newInstance(2006, 5, 5), 'US', 'Draft', 1, false));
            insert toInsertCases;

            Account testAccount = toInsertAccounts[0];

            Contact testContact = toInsertContacts[0];

            Boolean isValidationThrown = false;

            try {

                ContactService.validateBuildingLocationContactsWithNotInDraftCaseStatus(new List<Contact>{
                        testContact
                });

            } catch (System.Exception e) {
                isValidationThrown = true;
            }
            Test.stopTest();
            System.assertEquals(isValidationThrown, false, 'Commercial Manager users are allowed to edit contact records.');

        }
    }
    @isTest static void validateBuildingLocationContactsWithNotInDraftCaseStatus_ResidentialUserWithLinkedToClaimIsTrue_NoValidationThrown() {

        User u = [SELECT Id,Profile.Name FROM User WHERE Username = 'rtestuser@iko.com'];
        System.runAs(u) {
            Test.startTest();
            Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
            Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();

            //create Account
            List<Account> toInsertAccounts = new List<Account>();

            List<Account> acts = TestFactory.createAccounts(baRt, 'CaseServiceTestWashington', '9 King St E', 'Seattle', 'WA', 'US', '12111',
                    'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false);
            acts[0].Linked_to_Claim__c = TRUE;
            toInsertAccounts.addAll(acts);
            insert toInsertAccounts;

            //create contact
            List<Contact> toInsertContacts = new List<Contact>();
            List<Contact> con = TestFactory.createContacts(toInsertAccounts[0].Id, 'CaseServiceTest', UserInfo.getUserId(), 1, false);
            con[0].Linked_to_Claim__c = TRUE;
            con[0].FirstName = 'Test';
            toInsertContacts.addAll(con);
            insert toInsertContacts;

            //create Cases
            List<Case> toInsertCases = new List<Case>();
            toInsertCases.addAll(TestFactory.createCases(ccRt, toInsertAccounts[0].Id, toInsertContacts[0].Id, 'Distributor', 'CaseServiceWashington', date.newInstance(2006, 5, 5), 'US', 'Draft', 1, false));
            insert toInsertCases;

            Account testAccount = toInsertAccounts[0];

            Contact testContact = toInsertContacts[0];

            Boolean isValidationThrown = false;

            try {

                ContactService.validateBuildingLocationContactsWithNotInDraftCaseStatus(new List<Contact>{
                        testContact
                });

            } catch (System.Exception e) {
                isValidationThrown = true;
            }
            Test.stopTest();
            System.assertEquals(isValidationThrown, false, 'Residential Manager users are allowed to edit contact records.');

        }

    }

    @isTest static void validateBuildingLocationAccountsWithNotInDraftCaseStatus_ContactLinkedToClaimCannotModify_ValidationThrown() {
        User u = [SELECT Id FROM User WHERE Username = 'salesrsmmgr@iko.com'];
        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId();

        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();

        System.runAs(u) {
            TestFactory.createAccounts(baRt, 'CaseServiceTestWashington', '9 King St E', 'Seattle', 'WA', 'US', '12111',
                    'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, true);
            Account testAccount = [SELECT Id, Name FROM Account WHERE name = 'CaseServiceTestWashington' LIMIT 1];
            List<Contact> toInsertContacts = TestFactory.createContacts(testAccount.Id, 'CaseServiceTest', UserInfo.getUserId(), 1, false);
            toInsertContacts[0].FirstName = 'Test';
            //toInsertContacts.addAll(con);
            insert toInsertContacts;

            List<Product2> newProduct = TestFactory.createProducts('TestProd', true, '1111', 'US', '12345', 1, true);

            Boolean isValidationThrown = false;
            String validationMsg = '';

            //Claim_Type__c claimType = new Claim_Type__c(n)
            List<Case> toInsertCases = TestFactory.createCases(ccRt, testAccount.Id, toInsertContacts[0].Id, 'Owner', 'CaseServiceTest', null, 'US', 'Draft', 1, false);
            toInsertCases[0].Samples_Collected__c = 'Yes';
            toInsertCases[0].All_Claim_Photos_Attached__c = true;
            toInsertCases[0].Product__c = newProduct[0].Id;
            toInsertCases[0].Type_of_Structure__c = 'Garage';

            Insert toInsertCases;

            List<Claim_Type__c> newClaimType = TestFactory.createClaimTypes(toInsertCases[0], 1, false);
            newClaimType[0].Is_Primary__c = true;
            Insert newClaimType;

        }

        Test.startTest();
        Case caseRecordTest = [SELECT Id, Claim_Stage__c, AccountId, ContactId from Case where Subject = 'CaseServiceTest' LIMIT 1];
        caseRecordTest.Claim_Stage__c = 'Submitted';

        CaseService.assignmentRulesRun = true;
        Contact testContact = [SELECT Id, LastName FROM Contact WHERE Id = :caseRecordTest.ContactId LIMIT 1];
        try {
            update caseRecordTest;
            System.debug('Updating...');
        } catch (System.Exception ex) {
            System.debug('Exception Printed: ' + ex.getMessage());
        }

        Case caseRecordQuery = [SELECT Id, Subject, Claim_Stage__c, Contact.Name from Case where Id = :caseRecordTest.Id LIMIT 1];
        System.debug('caseRecordQuery: ' + caseRecordQuery);

        try {
            testContact.LastName += 'edited';
            update testContact;
        } Catch (System.Exception ex) {
            System.debug('Exception Caught: ' + ex.getMessage());
        }

        System.runAs(u) {
            Contact testContactUs = [SELECT Id, LastName FROM Contact WHERE Id = :caseRecordTest.ContactId LIMIT 1];

            try {
                testContactUs.LastName += 'edited';
                update testContactUs;
            } Catch (System.Exception ex) {
                System.debug('Exception Caught: ' + ex.getMessage());
            }
        }
        Test.stopTest();

        //System.assertEquals(true, isValidationThrown, 'System Admin users are allowed to edit account records.');
        //System.assertEquals('System Admin users are allowed to edit account records.',validationMsg );

    }

    @isTest static void validateBuildingLocationAccountsWithSubmittedStatus_ContactLinkedToClaimCannotModify_ValidationThrownAsNonSysAdmin() {
        User u = [SELECT Id FROM User WHERE Username = 'claimsManagerUsr@iko.com'];
        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId();

        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();

        System.runAs(u) {
            TestFactory.createAccounts(baRt, 'CaseServiceTestNewUser', '9 King St E', 'Seattle', 'WA', 'US', '12111',
                    'Verified', u.Id, TRUE, TRUE, 1, true);
            Account testAccount = [SELECT Id, Name FROM Account WHERE name = 'CaseServiceTestNewUser' LIMIT 1];
            List<Contact> toInsertContacts = TestFactory.createContacts(testAccount.Id, 'CaseServiceTestNewUser', u.Id, 1, false);
            toInsertContacts[0].FirstName = 'Test';
            //toInsertContacts.addAll(con);
            insert toInsertContacts;

            List<Product2> newProduct = TestFactory.createProducts('TestProdNewUser', true, '1111', 'US', '12345', 1, true);

            Boolean isValidationThrown = false;
            String validationMsg = '';

            //Claim_Type__c claimType = new Claim_Type__c(n)
            List<Case> toInsertCases = TestFactory.createCases(ccRt, testAccount.Id, toInsertContacts[0].Id, 'Owner', 'CaseServiceTestNewUser', null, 'US', 'Draft', 1, false);
            toInsertCases[0].Samples_Collected__c = 'Yes';
            toInsertCases[0].All_Claim_Photos_Attached__c = true;
            toInsertCases[0].Product__c = newProduct[0].Id;
            toInsertCases[0].Type_of_Structure__c = 'Garage';

            Insert toInsertCases;

            List<Claim_Type__c> newClaimType = TestFactory.createClaimTypes(toInsertCases[0], 1, false);
            newClaimType[0].Is_Primary__c = true;
            Insert newClaimType;

            //Test.startTest();
            Case caseRecordTest = [SELECT Id, Claim_Stage__c, AccountId, ContactId from Case where Subject = 'CaseServiceTestNewUser' LIMIT 1];
            caseRecordTest.Claim_Stage__c = 'Submitted';
            update caseRecordTest;

            Contact contactToUpdate = [SELECT Id, LastName from Contact where LastName = 'CaseServiceTestNewUser' LIMIT 1];
            contactToUpdate.LastName += 'Edited';
            Update contactToUpdate;

            //Test.stopTest();

        }

        //System.assertEquals(true, isValidationThrown, 'System Admin users are allowed to edit account records.');
        //System.assertEquals('System Admin users are allowed to edit account records.',validationMsg );

    }

} // end ContatServiceTest class