@isTest
public with sharing class icTestTriggerOpportunity {

    public static testMethod void test_triggerOnAfterUpdate(){
    	icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerOpportunity', new icHandlerOpportunityMock());
        Account newAccount = icTestHelperDataCreator.generateAccountByRecordType('Building Location');
        Insert newAccount;
        Opportunity newOpportunity = icTestHelperDataCreator.generateOpportunityByRecordType('US Sales Bid', newAccount.Id);
      
        insert newOpportunity;
        newOpportunity.StageName = 'In Approval';
        update newOpportunity;
    }
}