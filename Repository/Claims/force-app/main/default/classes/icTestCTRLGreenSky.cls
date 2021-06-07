/**
 * Created by Andrea Pissinis on 2018-09-27.
 */
@isTest
public with sharing class icTestCTRLGreenSky {

    public static testMethod void test_merchantValidation(){

        Test.startTest();
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicGreenSky', new icLogicGreenSkyMock());
        icCTRLGreenSky.merchantValidation();
        Test.stopTest();
    }

    public static testMethod void test_iscustomersubscribed(){

        Test.startTest();
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicGreenSky', new icLogicGreenSkyMock());
        icCTRLGreenSky.isCustomerSubscribed();
        Test.stopTest();

    }

    public static testMethod void test_createcustomersubscription(){

        Test.startTest();
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicGreenSky', new icLogicGreenSkyMock());
        icCTRLGreenSky.createGreenSkySubscription('test');
        Test.stopTest();

    }

    public static testMethod void test_asynchSubmit(){

        Test.startTest();
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicGreenSky', new icLogicGreenSkyMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicGreenSkyMock', 'asynchronousSubmit', new icDTOGreenSkyApplication());
        icCTRLGreenSky.asyncSubmit('{"test":"test"}', '');
        Test.stopTest();
    }

    public static testMethod void test_state(){

        Test.startTest();
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicGreenSky', new icLogicGreenSkyMock());
        icCTRLGreenSky.state('{"test": "application"}');
        Test.stopTest();
    }

    public static testMethod void test_decision(){

        Test.startTest();
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicGreenSky', new icLogicGreenSkyMock());
        icCTRLGreenSky.decision('{"test": "application"}');
        Test.stopTest();
    }

    public static testMethod void test_offer(){

        Test.startTest();
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicGreenSky', new icLogicGreenSkyMock());
        icCTRLGreenSky.offer('{"test": "application"}');
        Test.stopTest();
    }

    public static testMethod void test_create(){

        Test.startTest();
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicGreenSky', new icLogicGreenSkyMock());
        icCTRLGreenSky.create('{"test": "application"}','{"test": "offer"}');
        Test.stopTest();
    }

    public static testMethod void test_loanagreement(){

        Test.startTest();
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicGreenSky', new icLogicGreenSkyMock());
        icCTRLGreenSky.loanagreement('{"test": "application"}');
        Test.stopTest();
    }

    public static testMethod void test_email(){

        Test.startTest();
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicGreenSky', new icLogicGreenSkyMock());
        icCTRLGreenSky.email('{"test": "application"}','{"test": "offer"}');
        Test.stopTest();
    }

}