@isTest
private class AuraDataTableControllerTest {
	@testSetup
    private static void setupTestData() {
        initTestData();
    } 
    
    private static void initTestData() {
        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();
        List<Account> toInsertAccounts = new List<Account>();

        toInsertAccounts.addAll(TestFactory.createAccounts(baRt,'CaseServiceTest','9 King St E','Toronto','ON','CA','M4S 2H4',
                'Verified',UserInfo.getUserId(),TRUE,TRUE,1,false));
        insert toInsertAccounts;
        
        //create contact
        List<Contact> con = TestFactory.createContacts(toInsertAccounts[0].Id,'CaseServiceTest',UserInfo.getUserId(),1,false);
        insert con;
        
        //create Cases
        List<Case> toInsertCases = new List<Case>();

        toInsertCases.addAll(TestFactory.createCases(ccRt,toInsertAccounts[0].Id,con[0].Id,'Owner','CaseServiceTest',null,'Commercial','Draft',1,false));
        Insert toInsertCases;
        
        List<Lab_Sample__c> toInsertLabSamples = new List<Lab_Sample__c>();
        toInsertLabSamples.addAll(TestFactory.createLabSamples(toInsertCases[0], 1, false));
        Insert toInsertLabSamples;

        List<Warranty__c> toInsertWarranties = new List<Warranty__c>();
        toInsertWarranties.addAll(TestFactory.createWarranties(toInsertAccounts[0].Id, 1, false));
        insert toInsertWarranties;

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

    private static testMethod void getFiles_ContentVersionAttachedToCase_ReturnedListOfContentVersions() {

        // Insert the data
        Case caseRecord = [SELECT Id FROM Case WHERE Subject = 'CaseServiceTest' LIMIT 1];
        ContentVersion contentVersion = createTestFile(caseRecord.Id);
        insert contentVersion;

        // Start the test
        Test.startTest();
        List<ContentVersion> contentVersions = AuraDataTableController.getFiles(caseRecord.Id, 'Case');
        Test.stopTest();

        // Assert the data
        System.assertEquals(1, contentVersions.size(), 'Expected one content version is linked to the Case');

    }

    private static testMethod void getFiles_ContentVersionAttachedToLabSample_ReturnedListOfContentVersions() {

        // Insert the data
        Lab_Sample__c labSample = [SELECT Id, Case__c FROM Lab_Sample__c WHERE Case__r.Subject = 'CaseServiceTest'];

        ContentVersion contentVersion = createTestFile(labSample.Case__c);
        insert contentVersion;

        // Start the test
        Test.startTest();
        List<ContentVersion> contentVersions = AuraDataTableController.getFiles(labSample.Id, 'Lab_Sample__c');
        Test.stopTest();

        // Assert the data
        System.assertEquals(1, contentVersions.size(), 'Expected one content version is linked to the Lab Sample');

    }

    private static testMethod void getFiles_ContentVersionAttachedToWarranty_ReturnedListOfContentVersions() {

        // Insert the data
        Warranty__c warranty = [SELECT Id FROM Warranty__c WHERE Name LIKE 'Test Warranty%' LIMIT 1];
        ContentVersion contentVersion = createTestFile(warranty.Id);
        insert contentVersion;

        // Start the test
        Test.startTest();
        List<ContentVersion> contentVersions = AuraDataTableController.getFiles(warranty.Id, 'Warranty__c');
        Test.stopTest();

        // Assert the data
        System.assertEquals(1, contentVersions.size(), 'Expected one content version is linked to the Lab Sample');

    }

    private static testMethod void updateFiles_ContentVersionAttachedToCaseWithApprovalIKOType_FielNameShouldBeModified() {

        // Insert the data
        Case caseRecord = [SELECT Id FROM Case WHERE Subject = 'CaseServiceTest' LIMIT 1];
        ContentVersion contentVersion = createTestFile(caseRecord.Id);
        insert contentVersion;

        // Start the test
        Test.startTest();
        contentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion];
        AuraDataTableController.updateFiles(contentVersion.ContentDocumentId, caseRecord.Id,  'Approval', 'Case');
        Test.stopTest();

        // Assert the data
        contentVersion = [SELECT Id, Title FROM ContentVersion];
        System.assert(contentVersion.Title.contains('Approval'), 'Expected ContentVersion Title contains Approval : CaseNumber : Original File Name');

    }

    private static testMethod void updateFiles_ContentVersionAttachedToLabSampleWithApprovalIKOType_FielNameShouldBeModified() {

        // Insert the data
        Lab_Sample__c labSample = [SELECT Id, Case__c FROM Lab_Sample__c WHERE Case__r.Subject = 'CaseServiceTest'];

        ContentVersion contentVersion = createTestFile(labSample.Case__c);
        insert contentVersion;

        // Start the test
        Test.startTest();
        contentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion];
        AuraDataTableController.updateFiles(contentVersion.ContentDocumentId, labSample.Id,  'Approval', 'Lab_Sample__c');
        Test.stopTest();

        // Assert the data
        contentVersion = [SELECT Id, Title FROM ContentVersion];
        System.assert(contentVersion.Title.contains('Approval'), 'Expected ContentVersion Title contains Approval : CaseNumber : Original File Name');

    }

    private static testMethod void updateFiles_ContentVersionAttachedToWarrantyWithApprovalIKOType_FielNameShouldBeModified() {

        // Insert the data
        Warranty__c warranty = [SELECT Id FROM Warranty__c WHERE Name LIKE 'Test Warranty%' LIMIT 1];
        ContentVersion contentVersion = createTestFile(warranty.Id);
        insert contentVersion;

        // Start the test
        Test.startTest();
        contentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion];
        AuraDataTableController.updateFiles(contentVersion.ContentDocumentId, warranty.Id,  'Approval', 'Warranty__c');
        Test.stopTest();

        // Assert the data
        contentVersion = [SELECT Id, Title FROM ContentVersion];
        System.assert(contentVersion.Title.contains('Approval'), 'Expected ContentVersion Title contains Approval : CaseNumber : Original File Name');

    }

    private static testMethod void getListOfFileTypesTest() {

        Test.startTest();
        Map<String, String> fileTypeLabeMap = AuraDataTableController.getListOfFileTypes();
        Test.stopTest();

        System.assert(fileTypeLabeMap.size() > 0, 'Expected return Map of IKO File Type to IKO File Abbreviation');

    }
    
    private static testMethod void testMultipleFilesLinkedToLabSample() {
        List<ContentVersion> filesToInsert = new List<ContentVersion>();
        Lab_Sample__c lbToTest = [SELECT Id, Case__r.Subject 
                                  FROM Lab_Sample__c 
                                  WHERE Case__r.Subject = 'CaseServiceTest'
                                  LIMIT 1
                                 ];
        ContentVersion contentFile1 = new ContentVersion();
        contentFile1.Title='Test Lab Sample Attach';
        contentFile1.PathOnClient = 'Fred.jpg';
        contentFile1.VersionData = Blob.valueOf('A Generic Text');
        contentFile1.IsMajorVersion=true;
        contentFile1.FirstPublishLocationId=lbToTest.Id;
        
        filesToInsert.add(contentFile1);
        
        ContentVersion contentFile2 = new ContentVersion();
        contentFile2.Title='Test Lab Sample Attach 2';
        contentFile2.PathOnClient = 'Freddykreuger.jpg';
        contentFile2.VersionData = Blob.valueOf('An Imaginary Text');
        contentFile2.IsMajorVersion=true;
        contentFile2.FirstPublishLocationId=lbToTest.Id;
        
        filesToInsert.add(contentFile2);
        
        Insert filesToInsert;
        
        Test.startTest();
        ContentVersion contentFileToTest = new ContentVersion();
        contentFileToTest.Title='Test Lab Sample Attach 3';
        contentFileToTest.PathOnClient = 'Ronaland.jpg';
        contentFileToTest.VersionData = Blob.valueOf('Infinity Gauntlet');
        contentFileToTest.IsMajorVersion=true;
        contentFileToTest.FirstPublishLocationId=lbToTest.Id;
        
        Insert contentFileToTest;
        
        ContentVersion cvToTest = [Select Id, ContentDocumentId From ContentVersion
                                  WHERE Id = :contentFileToTest.Id Limit 1];
        
        AuraDataTableController.updateFiles(cvToTest.ContentDocumentId, lbToTest.Id,  'Approval', 'Lab_Sample__c');
        Test.stopTest();   
    }
    
    private static testMethod void testMultipleFilesLinkedToLabSampleWithSimilarTitleAndFileType() {
        List<ContentVersion> filesToInsert = new List<ContentVersion>();
        Lab_Sample__c lbToTest = [SELECT Id, Case__r.Subject 
                                  FROM Lab_Sample__c 
                                  WHERE Case__r.Subject = 'CaseServiceTest'
                                  LIMIT 1
                                 ];
        
        Test.startTest();
        ContentVersion contentFileToTest = new ContentVersion();
        contentFileToTest.Title='Test Lab Sample Attach 4';
        contentFileToTest.PathOnClient = 'Ronaland.jpg';
        contentFileToTest.VersionData = Blob.valueOf('I\'m Inevitable');
        contentFileToTest.IsMajorVersion=true;
        contentFileToTest.FirstPublishLocationId=lbToTest.Id;
        
        Insert contentFileToTest;
        
        ContentVersion cvToTest = [Select Id, ContentDocumentId From ContentVersion
                                  WHERE Id = :contentFileToTest.Id Limit 1];
        
        AuraDataTableController.updateFiles(cvToTest.ContentDocumentId, lbToTest.Id,  'Test Lab Sample', 'Lab_Sample__c');
        Test.stopTest();
        
        
    }
}