/**
 * Created by Francois Poirier on 2018-12-17.
 */

@isTest
public with sharing class icTestLogicAccountPayment {

    static icLogicAccountPayment.IClass accountPaymentLogic {get;set;}

    static void setup(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoAccountPayment', new icRepoAccountPaymentMock());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoAccountPayment', 'getAccountPaymentById', new IKOPRO_Account_Payment__c());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoAccountPayment', 'getPaidAccountPaymentByYearAndContractorIds', new List<IKOPRO_Account_Payment__c>());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoAccountPayment', 'updateAccountPayment', new IKOPRO_Account_Payment__c());
        accountPaymentLogic = (icLogicAccountPayment.IClass) icObjectFactory.GetSingletonInstance('icLogicAccountPayment');
    }

    @isTest static void testGetAccountPaymentById(){
        setup();
        accountPaymentLogic.getAccountPaymentById(icTestHelperUtility.getFakeId(IKOPRO_Account_Payment__c.SObjectType));

    }

    @isTest static void test_getPaidAccountPaymentByYearAndContractorIds(){
        setup();
        List<IKOPRO_Account_Payment__c> listResult = accountPaymentLogic.getPaidAccountPaymentByYearAndContractorIds('2020', new List<String>());
    }

    @isTest static void test_getMapPaidRenewalByContractorId(){
        setup();

        List<IKOPRO_Account_Payment__c> mockPayments = new List<IKOPRO_Account_Payment__c>();
        IKOPRO_Account_Payment__c mockPayment = new IKOPRO_Account_Payment__c(Contractor__c = icTestHelperUtility.getFakeId(Account.SObjectType));
        mockPayments.add(mockPayment);
        Map<String, IKOPRO_Account_Payment__c> mapResult = accountPaymentLogic.getMapPaidRenewalByContractorId(mockPayments);

    }

    @isTest static void testUpdateAccountPayment(){

        setup();
        IKOPRO_Account_Payment__c testAccountPayment = new IKOPRO_Account_Payment__c();
        testAccountPayment.Id = icTestHelperUtility.getFakeId(IKOPRO_Account_Payment__c.SObjectType);

        accountPaymentLogic.updateAccountPayment(testAccountPayment);

    }
}