/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icLogicSubscriptionMock implements icLogicSubscription.IClass{

    public List<IKOPRO_Contractor_Subscription__c> getEagleViewSubscriptionForCustomer(String accountId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getEagleViewSubscriptionForCustomer');
        params.put('accountId', accountId);
        return (List<IKOPRO_Contractor_Subscription__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getEagleViewSubscriptionForCustomer');
    }

    public void createEagleViewSubscription(String customerId, String eagleviewUsername) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createEagleViewSubscription');
        params.put('customerId', customerId);
        params.put('eagleviewUsername', eagleviewUsername);
    }

    public void updateEagleViewSubscription(IKOPRO_Contractor_Subscription__c subscription) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'updateEagleViewSubscription');
        params.put('subscription', subscription);
    }

    public IKOPRO_Contractor_Subscription__c getGreenSkySubscriptionForCustomer(String accountId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getGreenSkySubscriptionForCustomer');
        params.put('accountId', accountId);
        return (IKOPRO_Contractor_Subscription__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'getGreenSkySubscriptionForCustomer');
    }

    public void createGreenSkySubscription(icDTOGreenSkySubscription gsSubscription) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createGreenSkySubscription');
        params.put('gsSubscription', gsSubscription);
    }
}