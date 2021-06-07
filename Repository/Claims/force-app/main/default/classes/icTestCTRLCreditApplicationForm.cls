/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestCTRLCreditApplicationForm {

    public static testMethod void test_CTRLCreditApplicationForm(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicGreenSky', new icLogicGreenSkyMock());
        //icTestMockUtilities.Tracer.SetReturnValue('icLogicUserMock', 'getAccountIdFromPartnerUser', 'test');

        icCTRLCreditApplicationForm.getLists();
        icCTRLCreditApplicationForm.initializeDTO('{"string":""}',icTestHelperUtility.getFakeId(Opportunity.SObjectType));
    }

}