/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestCTRLContactUs {

    public static testMethod void test_CTRLContactUs(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicUser', new icLogicUserMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicAccount', new icLogicAccountMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicUserMock', 'getAccountIdFromPartnerUser', 'test');


        icCTRLContactUs.getContactUsInfo();
    }

}