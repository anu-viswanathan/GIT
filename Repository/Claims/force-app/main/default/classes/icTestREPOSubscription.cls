/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icTestREPOSubscription {

    public static testMethod void test_getSubscriptionsByAccountIdAndRecordTypeId(){

        icRepoSubscription.IClass repository = (icRepoSubscription.IClass) icObjectFactory.GetSingletonInstance('icRepoSubscription');

        Account contractor = icTestHelperUtility.generateContractorAccount();
        insert contractor;

        IKOPRO_Contractor_Subscription__c s = new IKOPRO_Contractor_Subscription__c();
        s.Contractor_Account__c = contractor.Id;

        Id recTypeId = [SELECT id from RecordType where Name ='EagleView'].Id;

        repository.getSubscriptionsByAccountIdAndRecordTypeId(contractor.Id,recTypeId);

    }

    public static testMethod void test_createSubscription(){
        icRepoSubscription.IClass repository = (icRepoSubscription.IClass) icObjectFactory.GetSingletonInstance('icRepoSubscription');

        Account contractor = icTestHelperUtility.generateContractorAccount();
        contractor.Lead_Administrator__c = UserInfo.getUserId();
        contractor.BillingPostalCode = '10034';
        contractor.ShippingPostalCode = '10034';
        insert contractor;

        IKOPRO_Contractor_Subscription__c s = new IKOPRO_Contractor_Subscription__c();
        s.Contractor_Account__c = contractor.Id;

        repository.createSubscription(s);

    }

    public static testMethod void test_updateSubscription(){
        icRepoSubscription.IClass repository = (icRepoSubscription.IClass) icObjectFactory.GetSingletonInstance('icRepoSubscription');

        Account contractor = icTestHelperUtility.generateContractorAccount();
        contractor.Lead_Administrator__c = UserInfo.getUserId();
        contractor.BillingPostalCode = '10034';
        contractor.ShippingPostalCode = '10034';
        insert contractor;

        IKOPRO_Contractor_Subscription__c s = new IKOPRO_Contractor_Subscription__c();
        s.Contractor_Account__c = contractor.Id;

        insert s;

        repository.updateSubscription(s);

    }

}