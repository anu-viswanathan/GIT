@isTest
public with sharing class icLogicTierMock implements icLogicTier.IClass{

    public List<Tier__c> getAllTiers() {
        //Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAllTiers');
        //params.put('param', param);
        return (List<Tier__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAllTiers');
    }

    public Map<String, Tier__c> getMapTiersByName(List<Tier__c> tiers) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getMapTiersByName');
        params.put('tiers', tiers);
        return (Map<String, Tier__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getMapTiersByName');
    }
}