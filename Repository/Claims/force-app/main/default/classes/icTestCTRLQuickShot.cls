/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestCTRLQuickShot {

    public static testMethod void test_CTRLQuickshot(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicUser', new icLogicUserMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicAccount', new icLogicAccountMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicLead', new icLogicLeadMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicOpportunity', new icLogicOpportunityMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicInvoice', new icLogicInvoiceMock());

        icTestMockUtilities.Tracer.SetReturnValue('icLogicUserMock', 'getAccountIdFromPartnerUser', 'customerId');
        icTestMockUtilities.Tracer.SetReturnValue('icLogicLeadMock', 'getNewLeadsCountByAccountId', 1);
        Account a = new Account();
        a.IKOPRO_QueueID__c = 'test';
        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountMock', 'getAcountInfoById', a);

        icCTRLQuickShot.getQuickShotInfo();

    }

}