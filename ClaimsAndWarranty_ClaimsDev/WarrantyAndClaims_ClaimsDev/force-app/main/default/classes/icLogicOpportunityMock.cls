/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icLogicOpportunityMock implements icLogicOpportunity.IClass{

    public Integer getCurrentOpportunitiesCountByAccountId(String recordId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getCurrentOpportunitiesCountByAccountId');
        params.put('recordId', recordId);
        return (Integer) icTestMockUtilities.Tracer.GetReturnValue(this, 'getCurrentOpportunitiesCountByAccountId');
    }

    public Opportunity getOpportunityDataForGreenSky(Id opportunityId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getOpportunityDataForGreenSky');
        params.put('opportunityId', opportunityId);
        return (Opportunity) icTestMockUtilities.Tracer.GetReturnValue(this, 'getOpportunityDataForGreenSky');
    }
    
    public Map<Id,Opportunity>  getApprovedOpportunitiesByListId(Set<Id> opportunityIds,Id recordTypeId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getApprovedOpportunitiesByListId');
        params.put('opportunityIds', opportunityIds);
        params.put('recordTypeId', recordTypeId);
        return (Map<Id,Opportunity>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getApprovedOpportunitiesByListId');
    }

    public List<Opportunity> getBidderForOpportunity(List<Id> opportunityIdList) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getBidderForOpportunity');
        params.put('opportunityIdList', opportunityIdList);
        return (List<Opportunity>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getBidderForOpportunity');
    }

    public Map<Id,List<Opportunity>> getOpportunityByAccountsIdsIsClosedAndRecordTypeId(Set<Id> accountIds,Boolean isClosed,Id recordTypeId){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getOpportunityByAccountsIdsIsClosedAndRecordTypeId');
        params.put('accountIds', accountIds);
        params.put('isClosed', isClosed);
        params.put('recordTypeId', recordTypeId);
        return (Map<Id,List<Opportunity>>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getOpportunityByAccountsIdsIsClosedAndRecordTypeId');
    }
    public Map<Id,List<Opportunity>>  createMapAccountIdToOpportunityList(List<Opportunity> opportunityResultList) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createMapAccountIdToOpportunityList');
        params.put('opportunityResultList', opportunityResultList);
        return (Map<Id,List<Opportunity>>) icTestMockUtilities.Tracer.GetReturnValue(this, 'createMapAccountIdToOpportunityList');
    }
   
}