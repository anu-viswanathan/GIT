@isTest
private class ContentDocumentLinkServiceTest {
    @future
    private static void createUsers() {

        // ORDER OF PARAMETERS
        // firstName, lastName, userName, email, profile, role, alias, timeZoneSidKey, localeSidKey, emailEncodingKey, languageLocaleKey, country, manager,Boolean isInsert
		// 2020-04-15
        // roles are pulled from Map that's created by the TestFactory class. That map didn't contain all roles orignially--it now does.

        List<User> toInsertUsers = new List<User>();

        toInsertUsers.add(TestFactory.createUser('Unit', 'Tests', 'salesrsmmgr@iko.com', 'salesrsmmgr@iko.com', 'USRS Manager',
                'RSM West', 'salesmgr', 'GMT', 'en_US', 'UTF-8', 'en_US', null, null, false));
        toInsertUsers.add(TestFactory.createUser('Unit', 'Tests', 'testuser@iko.com', 'testuser@iko.com', 'Commercial Claims Rep',
                'Commercial Claims Rep', 'testuser', 'GMT', 'en_US', 'UTF-8', 'en_US', 'United States', null, false));
        // 2020-4-15 Formerly TSR West
        toInsertUsers.add(TestFactory.createUser('Unit', 'Tests', 'salesrep@iko1.com', 'salesrep@iko.com', 'USRS Sales Rep',
                'RSM West', 'salesrep', 'GMT', 'en_US', 'UTF-8', 'en_US', null, null, false));

        insert toInsertUsers;

    }

    @testSetup static void setupTestData() {

        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();

        //create Account
        List<Account> toInsertAccounts = new List<Account>();

        toInsertAccounts.addAll(TestFactory.createAccounts(baRt, 'CaseServiceTest', '9 King St E', 'Toronto', 'ON', 'CA', 'M4S 2H4',
                'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));

        insert toInsertAccounts;


        //create contact
        List<Contact> toInsertContacts = new List<Contact>();

        toInsertContacts.addAll(TestFactory.createContacts(toInsertAccounts[0].Id, 'CaseServiceTest', UserInfo.getUserId(), 1, false));
        insert toInsertContacts;

        Map<String, Account> mapAccounts = new Map<String, Account>();

        for (Account act : [SELECT Id,Name FROM Account]) {
            mapAccounts.put(act.Name, act);
        }

        //create Cases
        List<Case> toInsertCases = new List<Case>();

        toInsertCases.addAll(TestFactory.createCases(ccRt, mapAccounts.get('CaseServiceTest').Id, toInsertContacts[0].Id, 'Distributor', 'CaseServiceTestClosed', null, 'Commercial', 'Closed', 1, false));
        toInsertCases.addAll(TestFactory.createCases(ccRt, mapAccounts.get('CaseServiceTest').Id, toInsertContacts[0].Id, 'Distributor', 'CaseServiceTest', null, 'Commercial', 'Draft', 1, false));
        toInsertCases.addAll(TestFactory.createCases(ccRt, mapAccounts.get('CaseServiceTest').Id, toInsertContacts[0].Id, 'Distributor', 'CaseServiceTest1', null, 'Commercial', 'Draft', 1, false));

        insert toInsertCases;

        //insert LabSamples
        List<Lab_Sample__c> toInsertlabSamples = new List<Lab_Sample__c>();
        toInsertlabSamples.addAll(TestFactory.createLabSamples(toInsertCases[0], 1, false));

        insert toInsertlabSamples;

        Warranty__c warranty = new Warranty__c(Name = 'Test Warranty');
        insert warranty;
        createUsers();
    }

    @isTest static void testThatLabSampleCannotHaveNewFileAfterCaseClosed() {
        //createUsers();
        User u = [SELECT Id FROM User WHERE Username = 'testuser@iko.com'];
        Lab_Sample__c ls = [SELECT Id FROM Lab_Sample__c WHERE Case__r.Subject = 'CaseServiceTestClosed'];
        Boolean caughtError = false;

        Test.startTest();
        System.runAs(u) {
            ContentVersion newFile = createTestFile(ls.Id);

            try {
                insert newFile;
            } catch (DmlException e) {
                if (e.getMessage().contains('Files cannot be uploaded for Lab Samples for Closed Cases')) {
                    caughtError = true;
                } else {
                    caughtError = false;
                }
            }
        }
        Test.stopTest();

        System.assertEquals(caughtError, true, 'Files cannot be uploaded for Lab Samples');
    }

    @isTest static void blockUploadDocumentsOnCases_FilesToUploadAsClaimsRep_ExceptionThrown() {

		//Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();
        User commRepUser = [SELECT Id FROM User WHERE Username = 'testuser@iko.com'];
		system.debug('@@@@ commRepUser: ' + commRepUser);
        Case closedCase=[Select Id, RecordTypeId, AccountId, Subject,ContactId from Case where Subject='CaseServiceTestClosed' Limit 1];

		//List<Case> draftCases = TestFactory.createCases(closedCase.RecordTypeId, closedCase.AccountId, closedCase.ContactId, 'Owner', 'CaseServiceTestClosed2', null, 'Commercial', 'Draft', 1, false);
		//System.debug('@@@@ draftCases: ' + draftCases);
		
        Boolean caughtError = false;
		//insert draftCases;

        //closedCase.Claim_Stage__c='Closed';
        //update draftCases[0];
        
        Test.startTest();

		System.runAs(commRepUser) {
            
			ContentVersion newFile = createTestFile(closedCase.Id);
			try {
                insert newFile;
            } catch (DmlException e) {
                if (e.getMessage().contains('Files cannot be uploaded for Closed Cases')) {
                    caughtError = true;
                } else {
                    caughtError = false;
                }
            }

		}
		System.debug('Caught Error: '+caughtError);
        Test.stopTest();

    }

    @isTest static void blockUploadDocumentOnWarrantyProfileBased_FilesToUploadAsClaimsRep_NoException() {

        User u = [SELECT Id FROM User WHERE Username = 'testuser@iko.com'];
        Warranty__c warranty = [SELECT Id FROM Warranty__c WHERE Name = 'Test Warranty'];
        Boolean caughtError = false;

        Test.startTest();
        System.runAs(u) {
            ContentVersion newFile = createTestFile(warranty.Id);

            try {
                insert newFile;
            } catch (DmlException exp) {
                if (exp.getMessage().contains('Files cannot be uploaded')) {
                    caughtError = true;
                } else {
                    caughtError = false;
                }
            }
        }
        Test.stopTest();

        System.assertEquals(caughtError, false, 'Claims Rep can upload files to Warranty record');
    }

    @isTEst static void blockUploadDocumentOnWarrantyProfileBased_FilesToUploadAsUSRSSalesRep_ExceptionThrown() {
        //createUsers();
        User u = [SELECT Id,Name FROM User WHERE Username = 'salesrep@iko1.com'];
        Warranty__c warranty = [SELECT Id FROM Warranty__c WHERE Name = 'Test Warranty'];

        Boolean caughtError = false;

        Test.startTest();
        System.runAs(u) {
            ContentVersion newFile = createTestFile(warranty.Id);

            try {
                insert newFile;
            } catch (DmlException exp) {
                if (exp.getMessage().contains('Files cannot be uploaded')) {
                    caughtError = true;
                } else {
                    caughtError = false;
                }
            }
        }
        Test.stopTest();

        System.assertEquals(caughtError, true, 'Sales rep cannot upload files to Warranty record');
    }

    private static ContentVersion createTestFile(Id objectId) {
        ContentVersion newFile = new ContentVersion();
        newFile.Title = 'Some File';
        newFile.PathOnClient = 'SomeFile.jpg';
        newFile.VersionData = Blob.valueOf('Lorem Ipsum');
        newFile.IsMajorVersion = true;
        newFile.FirstPublishLocationId = objectId;

        return newFile;
    } // end createTestFile method
}