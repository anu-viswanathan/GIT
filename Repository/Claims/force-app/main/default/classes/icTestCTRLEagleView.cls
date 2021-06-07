/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestCTRLEagleView {

    static void initTest(){
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicUser', new icLogicUserMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicSubscription', new icLogicSubscriptionMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icBLeagleView', new icBLeagleViewMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicEagleViewReport', new icLogicEagleViewReportMock());

        icTestMockUtilities.Tracer.SetReturnValue('icLogicSubscriptionMock', 'getEagleViewSubscriptionForCustomer', new List<IKOPRO_Contractor_Subscription__c>{new IKOPRO_Contractor_Subscription__c()});
        icTestMockUtilities.Tracer.SetReturnValue('icBLeagleViewMock', 'getAvailableProducts', new List<icDTOEagleViewProduct>{new icDTOEagleViewProduct()});
        icTestMockUtilities.Tracer.SetReturnValue('icLogicSubscriptionMock', 'getEagleViewSubscriptionForCustomer', new List<IKOPRO_Contractor_Subscription__c>{new IKOPRO_Contractor_Subscription__c()});
        icDTOGenericResult gr = new icDTOGenericResult();
        gr.isSuccess = true;
        gr.message = 'test';
        icTestMockUtilities.Tracer.SetReturnValue('icBLeagleViewMock', 'grantUserOrderDelegation', gr);
    }

    public static testMethod void test_isCustomerSubscribed(){

        initTest();


        icCTRLEagleview.isCustomerSubscribed();
    }

    public static testMethod void test_getAvailableProducts(){
        initTest();


        icCTRLEagleview.getAvailableProducts();
    }

    public static testMethod void test_placeOrder(){

        initTest();

        icCTRLEagleview.placeOrder('');
        icCTRLEagleview.createOrder('{"order":"order"}',icTestHelperUtility.getFakeId(Opportunity.SObjectType));
        icCTRLEagleview.setOrderIds('','{"order":"order"}');
        icCTRLEagleview.cancelOrder('');
    }

    public static testMethod void test_subscribe(){

        initTest();



        icCTRLEagleview.subscribe('test','test');
    }
}