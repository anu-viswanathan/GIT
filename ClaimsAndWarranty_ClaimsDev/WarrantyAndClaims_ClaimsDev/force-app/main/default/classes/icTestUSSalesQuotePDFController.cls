/**
 * Created by Anil Mannem (Incloud) on 25-Aug-2020
 */
@isTest
public with sharing class icTestUSSalesQuotePDFController {
    public static testMethod void test_icTestUSSalesQuotePDFControllerWithContrator() {
		Test.startTest();
        Id buildingLocationRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Building_Location').getRecordTypeId();
        Id distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('US_Distributor').getRecordTypeId();
        Id contractorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('US_Contractor').getRecordTypeId();
        
        Account testBuildingLocation = new Account();
        testBuildingLocation.Name = ' Test Building Location';
        testBuildingLocation.RecordTypeId = buildingLocationRecordTypeId;
        insert testBuildingLocation;
        Opportunity testOpportunity = icTestHelperDataCreator.generateOpportunityByRecordType('US Sales Bid', testBuildingLocation.Id);
        insert testOpportunity;
        
        Account testDistributor = new Account();
        testDistributor.Name = 'Test Distributor';
        testDistributor.RecordTypeId = distributorRecordTypeId;
        insert testDistributor;

        Account testContractor = new Account();
        testContractor.Name = 'Test Contrator';
        testContractor.RecordTypeId = contractorRecordTypeId;
        insert testContractor;

        PageReference thisPageReference = Page.US_Sales_Quote_PDF;
        Test.setCurrentPage(thisPageReference);
        
        // With Contractor
        Bidder__c newBidder = new Bidder__c(Opportunity__c = testOpportunity.Id, Distributor_Account__c = testDistributor.Id, Contractor_Account__c = testContractor.Id);
        insert newBidder;

        thisPageReference.getParameters().put('bidderID', newBidder.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(newBidder);
        icUSSalesQuotePDFController testCall = new icUSSalesQuotePDFController(controller);
        
        // Without Contractor
        Bidder__c newBidder2 = new Bidder__c(Opportunity__c = testOpportunity.Id, Distributor_Account__c = testDistributor.Id);
        insert newBidder2;

        thisPageReference.getParameters().put('bidderID', newBidder2.Id);
        ApexPages.StandardController controller2 = new ApexPages.StandardController(newBidder2);
        icUSSalesQuotePDFController testCall2 = new icUSSalesQuotePDFController(controller2);
        Test.stopTest();
    }
}