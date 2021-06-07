/**
 * Created by Dominic Boivin on 2020-08-26
 */
@isTest
public with sharing class icTestRepoOpportunityLineItems {
    static Opportunity testOpportunity;
    public static void CreateTestData(){
        Account newAccountBL = icTestHelperDataCreator.generateAccountByRecordType('Building Location');
        Insert newAccountBL;
        testOpportunity = icTestHelperDataCreator.generateOpportunityByRecordType('US Sales Bid', newAccountBL.Id);
        Insert testOpportunity; 
        OpportunityLineItem opportunityLineItem = icTestHelperDataCreator.createOpportunityLineItemWithoutPriceStructure(testOpportunity,true);
    }
    public static testMethod void test_getOpportunityLineItemForOpportunity(){
        icRepoOpportunityLineItems.IClass repoOpportunityLineItems = (icRepoOpportunityLineItems.IClass) icObjectFactory.GetSingletonInstance('icRepoOpportunityLineItems');
        CreateTestData();

       repoOpportunityLineItems.getOpportunityLineItemForOpportunity(testOpportunity.Id);
    }
 
    public static testMethod void test_getOpportunityLineItemsByOpportunities(){
        icRepoOpportunityLineItems.IClass repoOpportunityLineItems = (icRepoOpportunityLineItems.IClass) icObjectFactory.GetSingletonInstance('icRepoOpportunityLineItems');
        CreateTestData();
        repoOpportunityLineItems.getOpportunityLineItemsByOpportunities(new List<Opportunity> { testOpportunity });
    }
}