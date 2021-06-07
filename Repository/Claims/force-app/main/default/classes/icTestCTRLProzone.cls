/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestCTRLProzone {

    public static testMethod void test_userCTRL(){
        Map<String, Schema.RecordTypeInfo> mapContractorRecordTypes = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        Id contractorRecordTypeId = mapContractorRecordTypes.get('IKOPRO_Contractor').getRecordTypeId();
        Tier__c tier3 = new Tier__c();
        //tier3.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier3.Tier_Label__c = '3';
        tier3.Minimum_Squares__c = 6000;
        tier3.Maximum_Squares__c = 1000000;
        insert tier3;
        Account prorated = new Account(Name = 'prorated'
            ,IKOPRO_Approved_On__c = Date.newInstance(2019, 11, 24)
            ,Override_Tier_Movement__c = false
            ,Present_Tier_Lookup__c = tier3.Id
            ,IsPartner__c = true
            ,RecordTypeId = contractorRecordTypeId
            ,BillingPostalCode = 'h0h 0h0');
        insert new List<Account>{prorated};
            prorated.IsPartner = true;
        update prorated;
        icCTRLProzone.getCurrentTheme();
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicUser', new icLogicUserMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicUserMock', 'getAccountIdFromPartnerUser', 'test');
		icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicAccount', new icLogicAccountMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountMock', 'getAcountInfoById', prorated);
        icCTRLProzone.getProzoneRemoteAuthDetails(prorated.Id);
    }

}