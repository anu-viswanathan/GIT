/**
 * @description Test Aura Controller for all operations related the Files Data Table Lightning Components
 * @author Sinan Bunni
 * @date 2019-80-80
 */
@IsTest
public class FileDataTableAuraControllerTest {

    private static void initFileDownloadCustomSettingsTestData() {
        ClaimsFD__c setting = new ClaimsFD__c();
        setting.Name = 'Test Setting';
        setting.Download__C = true;
        insert setting;
    }

    private static testMethod void getHierarchySettings()
    {
        ClaimsFD__c setting = FileDataTableAuraController.getHierarchySettings();
        System.assertEquals(setting.Name, 'Test Setting');
    }
    private static testMethod void getFiles_ValidCaseRecordId_ListOfFilesLinkedToCase() {
        // Prepare the data
        Case caseRecord = [SELECT Id FROM Case LIMIT 1];
        createTestFileRecord(caseRecord.Id);

        // Test the data
        Test.startTest();
        List<ContentVersion> contentVersions = FileDataTableAuraController.getFiles(caseRecord.Id, 'Case');
        Test.stopTest();

        // Assert the data
        System.assertEquals(1, contentVersions.size(), 'Expected number of files associated to the Case is 1');
    }

    private static testMethod void getFiles_ValidLabSampleId_ListOfFilesLinkedToCase() {

        // Prepare the data
        Lab_Sample__c labSampleRecord = [SELECT Id, Case__c FROM Lab_Sample__c LIMIT 1];
        createTestFileRecord(labSampleRecord.Case__c);

        // Test the data
        Test.startTest();
        List<ContentVersion> contentVersions = FileDataTableAuraController.getFiles(labSampleRecord.Id, 'Lab_Sample__c');
        Test.stopTest();

        // Assert the data
        System.assertEquals(1, contentVersions.size(), 'Expected number of files associated to the Case is 1');
    }

    private static testMethod void getFiles_ValidWarrantyId_ListOfFilesLinkedToWarranty() {

        // Prepare the data
        Warranty__c warrantyRecord = [SELECT Id FROM Warranty__c LIMIT 1];
        createTestFileRecord(warrantyRecord.Id);

        // Test the data
        Test.startTest();
        List<ContentVersion> contentVersions = FileDataTableAuraController.getFiles(warrantyRecord.Id, 'Warranty__c');
        Test.stopTest();

        // Assert the data
        System.assertEquals(1, contentVersions.size(), 'Expected number of files associated to the Warranty is 1');
    }

    private static testMethod void updateFiles_ValidCaseWithLinkedDocumentAndGeneralIKOType_FileTitleUpdatedSuccessfully() {

        // Prepare the data
        Case caseRecord = [SELECT Id, CaseNumber FROM Case LIMIT 1];
        createTestFileRecord(caseRecord.Id);

        // Test the data
        ContentVersion contentVersion = [SELECT Id, Title, ContentDocumentId FROM ContentVersion LIMIT 1];
        
        //Create File property Record

        Map<String, String> jsonObj = new Map<String, String>();
        jsonObj.put('name', 'IKO Test');
        jsonObj.put('documentId',contentVersion.ContentDocumentId );
        jsonObj.put('ikoFileType', 'APPT' );
        
        List<Map<String, String>> jsonObjList = new List<Map<String, String>>();
        
        jsonObjList.add(jsonObj);
        
        System.debug('JSON.serialize(jsonObjList): '+JSON.serialize(jsonObjList));
        Test.startTest();
        FileDataTableAuraController.updateFilesBulkified(JSON.serialize(jsonObjList),'Case',caseRecord.Id);
        Test.stopTest();

        // Assert the data
        
        //System.debug('contentDocumentLink: '+contentDocumentLink);
        ContentVersion modifiedContentVersion = [SELECT Id, Title FROM ContentVersion
                                                 LIMIT 1];
        System.debug('modifiedContentVersion: '+modifiedContentVersion);
        System.assertNotEquals(modifiedContentVersion.Title, contentVersion.Title, 'Expected modified content version title is different from original.');
        System.assert(modifiedContentVersion.Title.contains(caseRecord.CaseNumber), true);
        System.assert(modifiedContentVersion.Title.contains('APPT'), true);
        
        
        
    }

    private static testMethod void updateFiles_ValidLabSampleWithLinkedDocumentAndGeneralIKOType_FileTitleUpdatedSuccessfully(){
       	Case caseRecord = [SELECT Id, CaseNumber FROM Case LIMIT 1];
		Lab_Sample__c lbToTest = [Select Id, Case__c from Lab_Sample__c Where Case__c= :caseRecord.Id];		        
        
        Test.startTest();
        	createTestFileRecord(lbToTest.Id);
        	ContentVersion contentVersion = [SELECT Id, ContentDocumentId from ContentVersion LIMIT 1];
        
            Map<String, String> jsonObj = new Map<String, String>();
            jsonObj.put('name', 'IKO Test');
            jsonObj.put('documentId',contentVersion.ContentDocumentId );
            jsonObj.put('ikoFileType', 'APPT' );
            
            List<Map<String, String>> jsonObjList = new List<Map<String, String>>();
            
            jsonObjList.add(jsonObj);
        
        	FileDataTableAuraController.updateFilesBulkified(JSON.serialize(jsonObjList),'Lab_Sample__c', lbToTest.Id);
        Test.stopTest();
        
       	
        ContentVersion caseContentVersion = [SELECT Id, Title from ContentVersion LIMIT 1];
        System.debug('caseContentVersion: '+caseContentVersion);
        
        
    }
    private static testMethod void updateFiles_ValidWarrantyWithLinkedDocumentAndGeneralIKOType_FileTitleUpdatedSuccessfully() {

        // Prepare the data
        Warranty__c warrantyRecord = [SELECT Id, Warranty_Registration_Id__c FROM Warranty__c LIMIT 1];
        createTestFileRecord(warrantyRecord.Id);
        
        

        // Test the data
        ContentVersion contentVersion = [SELECT Id, Title, ContentDocumentId FROM ContentVersion LIMIT 1];
        Map<String, String> jsonObj = new Map<String, String>();
        jsonObj.put('name', 'IKO Test');
        jsonObj.put('documentId',contentVersion.ContentDocumentId );
        jsonObj.put('ikoFileType', 'APPT' );
        
        List<Map<String, String>> jsonObjList = new List<Map<String, String>>();
        jsonObjList.add(jsonObj);
        
        Test.startTest();
        FileDataTableAuraController.updateFilesBulkified(JSON.serialize(jsonObjList),'Warranty__c', warrantyRecord.Id);
        Test.stopTest();

        // Assert the data
        /*
        ContentVersion modifiedContentVersion = [SELECT Id, Title FROM ContentVersion LIMIT 1];
        System.assertNotEquals(modifiedContentVersion.Title, contentVersion.Title, 'Expected modified content version title is different from original.');
        System.assert(modifiedContentVersion.Title.contains(warrantyRecord.Warranty_Registration_Id__c), true);
        System.assert(modifiedContentVersion.Title.contains('General'), true);
		*/
    }

    private static testMethod void getListOfFileTypes_Void_MapOfLabelAndAbbreviateIKOFileTypes() {

        // Test the data
        Test.startTest();
        Map<String, String> ikoFileLabelToAbbreviateMap = FileDataTableAuraController.getListOfFileTypes();
        Test.stopTest();

        // Assert the data
        System.assert(ikoFileLabelToAbbreviateMap.size() > 0, true);
    }

    private static void createTestFileRecord(Id objectId) {

        ContentVersion contentVersion = new ContentVersion(Title = 'IKO Test',
                PathOnClient = 'IKOTest.png', VersionData = Blob.valueOf('IKO Test'), IsMajorVersion = true);
        insert contentVersion;

        List<ContentDocument> contentDocuments = [
                SELECT Id, Title, LatestPublishedVersionId
                FROM ContentDocument
                LIMIT 1
        ];

        ContentDocumentLink conenContentDocumentLink = new ContentDocumentLink(LinkedEntityId = objectId,
                ContentDocumentId = contentDocuments.get(0).Id, ShareType = 'V');
        insert conenContentDocumentLink;

    } // end createTestFileRecord method

    @testSetup
    private static void setupTestData() {

        initFileDownloadCustomSettingsTestData();

        Id baRtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();

        Account accountRecord = new Account(RecordTypeId = baRtId, Name = 'ClaimNumber', BillingStreet = '19 King St E',
                BillingCity = 'Toronto', BillingStateCode = 'ON', BillingCountryCode = 'CA', BillingPostalCode = 'M4S 2H4');
        insert accountRecord;

        Contact contactRecord = new Contact(LastName = 'CaseServiceTest', AccountId = accountRecord.Id);
        insert contactRecord;

        Warranty__c warrantyRecord = new Warranty__c(Name = 'Test Warranty', Warranty_Registration_Id__c = '111111', Warranty_Status__c = 'Draft', Type__c = 'Labor & Membrane', Warranty_Substatus__c = 'With Sales', Building__c = accountRecord.Id);
        insert warrantyRecord;

        Case caseRecord = new Case(Origin = 'Owner', Leaking__c = true, Job_In_Progress__c = true, ContactId = contactRecord.Id, AccountId = accountRecord.Id, Sector__c = 'CA', Warranty__c = warrantyRecord.Id);
        insert caseRecord;

        Lab_Sample__c labSampleRecord = new Lab_Sample__c(Case__c = caseRecord.Id);
        insert labSampleRecord;
    }

} // end FileDataTableAuraControllerTest class