/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icREPOOpportunityMock implements icRepoOpportunity.IClass{

    public List<Opportunity> getCurrentOpportunitiesByAccountId(String recordId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getCurrentOpportunitiesByAccountId');
        params.put('recordId', recordId);
        return (List<Opportunity>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getCurrentOpportunitiesByAccountId');
    }

    public Opportunity getOpportunityDataForGreenSky(Id opportunityId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getOpportunityDataForGreenSky');
        params.put('opportunityId', opportunityId);
        return (Opportunity) icTestMockUtilities.Tracer.GetReturnValue(this, 'getOpportunityDataForGreenSky');
    }
    
    public List<Opportunity> getApprovedOpportunitiesByListID(Set<Id> opportunityIds, Id recordTypeId){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getApprovedOpportunitiesByListID');
        params.put('opportunityIds', opportunityIds);
        params.put('recordTypeId', recordTypeId);
        return (List<Opportunity>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getApprovedOpportunitiesByListID');
    }
    public List<Opportunity> getBidderForOpportunity(List<Id> opportunityIdList){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getBidderForOpportunity');
        params.put('opportunityIdList', opportunityIdList);
        return (List<Opportunity>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getBidderForOpportunity');
    }
    public List<Opportunity> getOpportunityByAccountsIdsIsClosedAndRecordTypeId(Set<Id> accountIds,Boolean isClosed,Id recordTypeId){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getOpportunityByAccountsIdsIsClosedAndRecordTypeId');
        params.put('accountIds', accountIds);
        params.put('isClosed', isClosed);
        params.put('recordTypeId', recordTypeId);
        return (List<Opportunity>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getOpportunityByAccountsIdsIsClosedAndRecordTypeId');
    }
}