/**
 * Created by Dominic Boivin on 2020-08-25.
 */
@isTest
public with sharing class icLogicOpportunityLineItemsMock implements icLogicOpportunityLineItems.Iclass {
    
    public List<OpportunityLineItem> getOpportunityLineItemForOpportunity(String recordId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getOpportunityLineItemForOpportunity');
        params.put('recordId', recordId);
        return (List<OpportunityLineItem>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getOpportunityLineItemForOpportunity');
    }
    public List<OpportunityLineItem> getOpportunityLineItemsByOpportunities(List<Opportunity> opportunities) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getOpportunityLineItemsByOpportunities');
        params.put('opportunities', opportunities);
        return (List<OpportunityLineItem>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getOpportunityLineItemsByOpportunities');
    }
    public Map<Id,List<OpportunityLineItem>> getMapForOpportunityLineItemByOpportunities(List<Opportunity> opportunities){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getMapForOpportunityLineItemByOpportunities');
        params.put('opportunities', opportunities);
        return (Map<Id,List<OpportunityLineItem>>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getMapForOpportunityLineItemByOpportunities');
    }
    
    public Map<Id, Product2> getProductUnitOfMeasure(List<OpportunityLineItem> opportunityLineItemList){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getProductUnitOfMeasure');
        params.put('opportunityLineItemList', opportunityLineItemList);
        return (Map<Id, Product2>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getProductUnitOfMeasure');
    }
}