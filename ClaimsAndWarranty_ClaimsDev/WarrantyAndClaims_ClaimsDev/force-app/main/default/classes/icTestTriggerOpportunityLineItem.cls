@isTest
public with sharing class icTestTriggerOpportunityLineItem {

    public static testMethod void test_triggerOnBeforeDelete(){
    	icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerOpportunityLineItem', new icHandlerOpportunityLineItemMock());
        //Create Opportunity with the Helper Classed
        Account newAccount = icTestHelperDataCreator.generateAccountByRecordType('Building Location');
        Insert newAccount;
        Opportunity newOpportunity = icTestHelperDataCreator.generateOpportunityByRecordType('US Sales Bid', newAccount.Id);
        insert newOpportunity;
        OpportunityLineItem newOpportunityLI = icTestHelperDataCreator.createOpportunityLineItemWithoutPriceStructure(newOpportunity,true);

        delete newOpportunityLI;
    }
}