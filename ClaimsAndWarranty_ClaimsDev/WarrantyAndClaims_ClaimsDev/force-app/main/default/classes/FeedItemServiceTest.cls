/**
 * Created by sinan.bunni on 2019-09-19.
 */
@IsTest
public with sharing class FeedItemServiceTest {

    @TestSetup
    private static void setupTestData() {
        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();
        Id daRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();


        //create Account
        List<Account> toInsertAccounts = new List<Account>();

        toInsertAccounts.addAll(TestFactory.createAccounts(baRt,'CaseServiceTest','9 King St E','Toronto','ON','CA','M4S 2H4',
                'Verified',UserInfo.getUserId(),TRUE,TRUE,1,false));
        insert toInsertAccounts;


         //create contact
        List<Contact> toInsertContacts = new List<Contact>();

        toInsertContacts.addAll(TestFactory.createContacts(toInsertAccounts[0].Id,'CaseServiceTest',UserInfo.getUserId(),1,false));

        insert toInsertContacts;

        Map<String,Account> mapAccounts = new Map<String, Account>();

        for(Account act : [SELECT Id,Name FROM Account]){
            mapAccounts.put(act.Name,act);
        }

        //create products
        List<Product2> toInsertProducts = new List<Product2>();
        toInsertProducts.addAll(TestFactory.createProducts('IkoSampleProduct',TRUE,'IkoSampleProduct','US;CA;Commercial;Blair',null,1,false));

        insert toInsertProducts;

        //create Cases
        List<Case> toInsertCases = new List<Case>();

 	    toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTest1',null,'Commercial','Draft',1,false));
 
        insert toInsertCases;
        
          //insert LabSamples
        List<Lab_Sample__c> toInsertlabSamples = new List<Lab_Sample__c>();
        toInsertlabSamples.addAll(TestFactory.createLabSamples(toInsertCases[0],1,false));

        insert toInsertlabSamples;
    }

    private static testMethod void bringDownCaseChatterFeedToLabSample_ChatterFeedInsertedOnCase_ChatterFeedCopiedDownToLabSampleRecord() {

        // Prepare the test
        Lab_Sample__c testLabSample = [SELECT Id, Case__c FROM Lab_Sample__c  WHERE Case__r.Subject = 'CaseServiceTest1' LIMIT 1];

        // Start the test
        Test.startTest();

        FeedItem feedItem = new FeedItem();
        feedItem.ParentId = testLabSample.Case__c;
        feedItem.Body = 'Claims App is great!';
        insert(feedItem);

        Test.stopTest();

        // Assert the test
        feedItem = [SELECT Id, Body FROM FeedItem WHERE ParentId = :testLabSample.Id];
        System.assertEquals('Claims App is great!', feedItem.Body, 'Expected Feed Item Body is brought down from Case to Lab Sample.');
    }

} // end FeedItemServiceTest class