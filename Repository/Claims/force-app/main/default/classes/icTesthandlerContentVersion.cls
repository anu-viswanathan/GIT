/**
 * Created by Anil Mannem on 27-Aug-2020.
 */

@isTest
public with sharing class icTesthandlerContentVersion {

    @isTest
    public static void testOnAfterInsert(){
        Test.startTest();
	    Contractor_Invoice__c newUploadedInvoice = new Contractor_Invoice__c(Uploaded_Files_Long__c = 'test');
        insert newUploadedInvoice;
        
        ContentVersion testVersion = new ContentVersion();
        testVersion.Title = 'Test';
        testVersion.PathOnClient = 'test.jpg';
        testVersion.VersionData = Blob.valueOf('test content Data');
        testVersion.IsMajorVersion = true;
        testVersion.FirstPublishLocationId = newUploadedInvoice.Id;
        insert testVersion;
        
        testVersion.Title = 'TestUpdate';
        update testVersion;
        
        Test.stopTest();
    }

    @isTest(SeeAllData=true)
    public static void testOnBeforeUpdate(){
        Test.startTest();
	    
        Profile p = [SELECT Id FROM Profile WHERE Name='CARS Sales Rep'];
        User u = new User(Alias = 'standt', Email='testuser@iko.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
         UserName='testuser@iko.com');
 
        System.runAs(u) {
            Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
            Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();
            Id daRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
    
            //create Account
            // Order of Parameters
            // recordTypeId, accountName, bStreet, bCity, bStateCode, bCountryCode, bPostalCode, AddVerifiedStatus, ownerId, Boolean nmVerificationStatus, Boolean actVerifiedStatus, numOfAccounts, isInsert
            List<Account> toInsertAccounts = new List<Account>();		
            toInsertAccounts.addAll(TestFactory.createAccounts(baRt, 'CaseServiceTest', '9 King St E', 'Toronto', 'ON', 'CA', 'M4S 2H4',
                    'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));
            toInsertAccounts.addAll(TestFactory.createAccounts(daRt, 'Slalom Distribution', '8 King St E', 'Toronto', 'ON', 'CA', 'M4S 2H4',
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
            //create products
            List<Product2> toInsertProducts = new List<Product2>();
            toInsertProducts.addAll(TestFactory.createProducts('IkoSampleProduct', TRUE, 'IkoSampleProduct', 'US;CA;Commercial;Blair', null, 1, false));
            insert toInsertProducts;

            //create Cases
            List<Case> toInsertCases = new List<Case>();
            toInsertCases.addAll(TestFactory.createCases(ccRt, mapAccounts.get('CaseServiceTest').Id, toInsertContacts[0].Id, 'Distributor', 'CaseServiceTestClosed', null, 'Commercial', 'Draft', 1, false));
            toInsertCases[0].Origin = 'Owner';
			toInsertCases[0].Samples_Collected__c = 'Not Required';
            toInsertCases[0].All_Claim_Photos_Attached__c = true;
            toInsertCases[0].Distributor__c = mapAccounts.get('Slalom Distribution').Id;
            toInsertCases[0].Product__c = toInsertProducts[0].Id;
            toInsertCases[0].Type_Of_Structure__c = 'Barn';
            toInsertCases[0].OwnerId = UserInfo.getUserId();
            insert toInsertCases;

            ContentVersion testVersion = new ContentVersion();
            testVersion.Title = 'Test';
            testVersion.PathOnClient = 'test.jpg';
            testVersion.VersionData = Blob.valueOf('test content Data');
            testVersion.IsMajorVersion = true;
            testVersion.FirstPublishLocationId = toInsertCases[0].Id;
            insert testVersion;                
        }
        Test.stopTest();
        
    }
}