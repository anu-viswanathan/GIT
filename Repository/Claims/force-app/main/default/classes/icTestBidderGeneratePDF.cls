/**
 * Created by Anil Mannem (Incloud) on 25-Aug-2020
 */
@isTest
public with sharing class icTestBidderGeneratePDF {

    static testMethod void test_generatePDF(){
        Test.startTest();
        Id buildingLocationRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Building_Location').getRecordTypeId();
        Id distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('US_Distributor').getRecordTypeId();
        Id contractorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('US_Contractor').getRecordTypeId();
        
        List<Id> opportunityIdList = new List<Id>();

        Account testBuildingLocation = new Account();
        testBuildingLocation.Name = 'Test Building Location';
        testBuildingLocation.RecordTypeId = buildingLocationRecordTypeId;
        insert testBuildingLocation;
        Opportunity testOpportunity = icTestHelperDataCreator.generateOpportunityByRecordType('US Sales Bid', testBuildingLocation.Id);
        testOpportunity.Quote_Approved__c = true;
        insert testOpportunity;
        opportunityIdList.add(testOpportunity.Id);
        
        Account testBuildingLocation1 = new Account();
        testBuildingLocation1.Name = 'Test Building Location1';
        testBuildingLocation1.RecordTypeId = buildingLocationRecordTypeId;
        insert testBuildingLocation1;

        Opportunity testOpportunity1 = icTestHelperDataCreator.generateOpportunityByRecordType('US Sales Bid', testBuildingLocation1.Id);
        insert testOpportunity1;
        opportunityIdList.add(testOpportunity1.Id);
        
        Account testDistributor = new Account();
        testDistributor.Name = 'Test Distributor';
        testDistributor.RecordTypeId = distributorRecordTypeId;
        insert testDistributor;

        Account testContractor = new Account();
        testContractor.Name = 'Test Contrator';
        testContractor.RecordTypeId = contractorRecordTypeId;
        insert testContractor;
        
        Bidder__c newBidder = new Bidder__c(Opportunity__c = testOpportunity.Id, Distributor_Account__c = testDistributor.Id, Contractor_Account__c = testContractor.Id);
        insert newBidder;
        Bidder__c newBidder1 = new Bidder__c(Opportunity__c = testOpportunity.Id, Distributor_Account__c = testDistributor.Id);
        insert newBidder1;

        icBidderGeneratePDF.bidderOpportunityGeneratePDF(opportunityIdList);
        Test.stopTest();
    }
}