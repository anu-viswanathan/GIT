/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icREPOSubscriptionMOck implements icRepoSubscription.IClass{

    public List<IKOPRO_Contractor_Subscription__c> getSubscriptionsByAccountIdAndRecordTypeId(String accountId, String recordTypeId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getSubscriptionsByAccountIdAndRecordTypeId');
        params.put('accountId', accountId);
        params.put('recordTypeId', recordTypeId);
        return (List<IKOPRO_Contractor_Subscription__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getSubscriptionsByAccountIdAndRecordTypeId');
    }

    public void createSubscription(IKOPRO_Contractor_Subscription__c subscription) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createSubscription');
        params.put('subscription', subscription);
    }

    public void updateSubscription(IKOPRO_Contractor_Subscription__c subscription) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'updateSubscription');
        params.put('subscription', subscription);
    }
}