@isTest
public with sharing class icRepoTierMock implements icRepoTier.IClass{

    public List<Tier__c> getAllTiers() {
        //Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAllTiers');
        //params.put('param', param);
        return (List<Tier__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAllTiers');
    }
}