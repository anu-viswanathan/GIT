/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestServiceEagleViewFileDelivery {

    public static testMethod void test_doPost(){
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicAttachment', new icLogicAttachmentMock());
        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());

        icServiceEagleViewFileDelivery.doPost();

    }

}