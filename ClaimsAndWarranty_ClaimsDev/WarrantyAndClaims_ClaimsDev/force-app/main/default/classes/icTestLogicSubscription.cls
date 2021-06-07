/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestLogicSubscription {

    static void initTest() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoSubscription', new icRepoSubscriptionMock());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoSubscriptionMock', 'getSubscriptionsByAccountIdAndRecordTypeId', new List<IKOPRO_Contractor_Subscription__c>{});
        icTestMockUtilities.Tracer.SetReturnValue('icRepoSubscriptionMock', 'createSubscription', new Account());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoSubscriptionMock', 'updateSubscription',new Account());


    }

    public static testMethod void test_getEagleViewSubscriptionForCustomer(){
        icLogicSubscription.IClass BL = (icLogicSubscription.IClass) icObjectFactory.GetSingletonInstance('icLogicSubscription');
        initTest();

        BL.getEagleViewSubscriptionForCustomer('');
    }

    public static testMethod void test_createEagleViewSubscription(){
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoSubscription', new icREPOSubscriptionMOck());

        icLogicSubscription.IClass BL = (icLogicSubscription.IClass) icObjectFactory.GetSingletonInstance('icLogicSubscription');


        BL.createEagleViewSubscription(icTestHelperUtility.getFakeId(Account.SObjectType),'');

    }

    public static testMethod void test_updateEagleViewSubscription(){
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoSubscription', new icREPOSubscriptionMOck());

        icLogicSubscription.IClass BL = (icLogicSubscription.IClass) icObjectFactory.GetSingletonInstance('icLogicSubscription');


        IKOPRO_Contractor_Subscription__c s = new IKOPRO_Contractor_Subscription__c();
        s.Id = icTestHelperUtility.getFakeId(IKOPRO_Contractor_Subscription__c.SObjectType);

        BL.updateEagleViewSubscription(s);

    }

}