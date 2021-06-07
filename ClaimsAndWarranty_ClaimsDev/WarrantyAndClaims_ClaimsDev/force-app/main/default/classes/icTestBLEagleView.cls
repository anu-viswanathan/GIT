/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestBLEagleView {

    static void initTest() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoAccount', new icRepoAccountMock());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoAccountMock', 'getPersonAcountInfoById', new Contact());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoAccountMock', 'getAcountInfoById', new Account());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoAccountMock', 'getAcountByHARefKey',new Account());

    }

    public static testMethod void test_getAvailableProducts(){

        initTest();
        icBLeagleView.IClass BL = (icBLeagleView.IClass) icObjectFactory.GetSingletonInstance('icBLeagleView');
        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());

        BL.getAvailableProducts();

    }

    public static testMethod void test_grantUserOrderDelegation(){

        initTest();
        icBLeagleView.IClass BL = (icBLeagleView.IClass) icObjectFactory.GetSingletonInstance('icBLeagleView');
        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());

        BL.grantUserOrderDelegation('','');

    }

    public static testMethod void test_grantUserOrderDelegationErr(){

        initTest();
        icBLeagleView.IClass BL = (icBLeagleView.IClass) icObjectFactory.GetSingletonInstance('icBLeagleView');
        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceErrMock());

        BL.grantUserOrderDelegation('','');

    }
    public static testMethod void test_grantUserOrderDelegationErr505(){

        initTest();
        icBLeagleView.IClass BL = (icBLeagleView.IClass) icObjectFactory.GetSingletonInstance('icBLeagleView');
        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceErrorMock());

        BL.grantUserOrderDelegation('','');

    }

    public static testMethod void test_placeOrder(){

        initTest();
        icBLeagleView.IClass BL = (icBLeagleView.IClass) icObjectFactory.GetSingletonInstance('icBLeagleView');
        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());

        BL.placeOrder('','');

    }

    public static testMethod void test_placeOrderErr(){

        initTest();
        icBLeagleView.IClass BL = (icBLeagleView.IClass) icObjectFactory.GetSingletonInstance('icBLeagleView');
        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceErrMock());

        BL.placeOrder('','');

    }

    public static testMethod void test_getDownloadLink(){

        initTest();
        icBLeagleView.IClass BL = (icBLeagleView.IClass) icObjectFactory.GetSingletonInstance('icBLeagleView');
        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceErrMock());

        BL.getDownloadLink('');

    }

    public static testMethod void test_cancelOrder(){

        initTest();
        icBLeagleView.IClass BL = (icBLeagleView.IClass) icObjectFactory.GetSingletonInstance('icBLeagleView');
        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());

        BL.cancelOrder('');

    }

    public static testMethod void test_cancelOrderErr500(){

        initTest();
        icBLeagleView.IClass BL = (icBLeagleView.IClass) icObjectFactory.GetSingletonInstance('icBLeagleView');
        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceErrorMock());

        BL.cancelOrder('');

    }

}