/**
 * Created by Dominic Boivin on 2020-08-25.
 */
@isTest
public with sharing class icRepoOpportunityLineItemsMock implements icRepoOpportunityLineItems.IClass{
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
    
    public List<Product2> getProductUnitOfMeasure(List<Id> productIdList){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getProductUnitOfMeasure');
        params.put('productIdList', productIdList);
        return (List<Product2>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getProductUnitOfMeasure');
    }

}