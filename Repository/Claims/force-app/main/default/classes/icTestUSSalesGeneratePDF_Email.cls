/**
 * Created by Anil Mannem (Incloud) on 25-Aug-2020
 */
@isTest
public with sharing class icTestUSSalesGeneratePDF_Email {
    static Id buildingLocationRecordTypeId;
    static Id distributorRecordTypeId;
    static Id contractorRecordTypeId;
    static Account testContractor;
    static Account testDistributor;
    static Opportunity testOpportunity;
    static Opportunity testOpportunity1;
    static User currentUser;

    static void CreateTestData(){
        currentUser = TestFactory.createUser('Unit', 'Test', 'sysAdminUsr@iko.com', 'sysAdminUsr@iko.com', 'System Administrator',
                'CEO', 'tsAdmU', 'GMT', 'en_US', 'UTF-8', 'en_US', 'United States', null, true);
        System.runAs(currentUser){
            buildingLocationRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Building_Location').getRecordTypeId();
            distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('US_Distributor').getRecordTypeId();
            contractorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('US_Contractor').getRecordTypeId();
            
            Account testBuildingLocation = new Account();
            testBuildingLocation.Name = ' Test Building Location';
            testBuildingLocation.RecordTypeId = buildingLocationRecordTypeId;
            insert testBuildingLocation;
            testOpportunity = icTestHelperDataCreator.generateOpportunityByRecordType('US Sales Bid', testBuildingLocation.Id);
            testOpportunity.Quote_Approved__c = true;
            insert testOpportunity;
            
            Account testBuildingLocation1 = new Account();
            testBuildingLocation1.Name = ' Test Building Location 1';
            testBuildingLocation1.RecordTypeId = buildingLocationRecordTypeId;
            insert testBuildingLocation1;
            testOpportunity1 = icTestHelperDataCreator.generateOpportunityByRecordType('US Sales Bid', testBuildingLocation1.Id);
            insert testOpportunity1;
    
            testDistributor = new Account();
            testDistributor.Name = 'Test Distributor';
            testDistributor.RecordTypeId = distributorRecordTypeId;
            insert testDistributor;
    
            testContractor = new Account();
            testContractor.Name = 'Test Contrator';
            testContractor.RecordTypeId = contractorRecordTypeId;
            insert testContractor;
        }
    }
    
    static testMethod void test_generatePDF_With_Contractor_and_Quote_Approved(){       
        CreateTestData();
        System.runAs(currentUser){
            // With Contractor and Quote Approved
            Bidder__c newBidder = new Bidder__c(Opportunity__c = testOpportunity.Id, Distributor_Account__c = testDistributor.Id, Contractor_Account__c = testContractor.Id);
            insert newBidder;
            Test.startTest();
            icUSSalesGeneratePDF_Email.generatePDFandEmail(newBidder.Id);
            Test.stopTest();            
        }
    }

    static testMethod void test_generatePDF_Without_Contractor_and_Quote_Approved(){       
        CreateTestData();
        System.runAs(currentUser){
            // Without Contractor and Quote Approved
            Bidder__c newBidder1 = new Bidder__c(Opportunity__c = testOpportunity.Id, Distributor_Account__c = testDistributor.Id);
            insert newBidder1;
            Test.startTest();
            icUSSalesGeneratePDF_Email.generatePDFandEmail(newBidder1.Id);
            Test.stopTest();
        }
    }

    static testMethod void test_generatePDF_Without_Contractor_and_Quote_not_Approved(){
        Test.startTest();
        CreateTestData();
        System.runAs(currentUser){
            // Without Contractor and Quote not Approved
            Bidder__c newBidder2 = new Bidder__c(Opportunity__c = testOpportunity1.Id, Distributor_Account__c = testDistributor.Id);
            insert newBidder2;
            icUSSalesGeneratePDF_Email.generatePDFandEmail(newBidder2.Id);
            Test.stopTest();
        }
    }
}