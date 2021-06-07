@isTest
public with sharing class icHandlerOpportunityMock implements icHandlerOpportunity.IClass{

    public void onAfterUpdate(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id, Opportunity> OpportunitiesMap) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onAfterUpdate');
        params.put('oldOpportunities', oldOpportunities);
        params.put('newOpportunities', newOpportunities);
        params.put('OpportunitiesMap', OpportunitiesMap);
    }
    public void onBeforeUpdate(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id, Opportunity> OpportunitiesMap) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onBeforeUpdate');
        params.put('oldOpportunities', oldOpportunities);
        params.put('newOpportunities', newOpportunities);
        params.put('OpportunitiesMap', OpportunitiesMap);
    }
    public void onBeforeInsert(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id, Opportunity> OpportunitiesMap) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onBeforeInsert');
        params.put('oldOpportunities', oldOpportunities);
        params.put('newOpportunities', newOpportunities);
        params.put('OpportunitiesMap', OpportunitiesMap);
    }
}