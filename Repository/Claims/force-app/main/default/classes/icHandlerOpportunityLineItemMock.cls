@isTest
public with sharing class icHandlerOpportunityLineItemMock implements icHandlerOpportunityLineItem.IClass{

    public void onBeforeInsert(List<OpportunityLineItem> newOpportunityLineItems) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onBeforeInsert');
        params.put('newOpportunityLineItems', newOpportunityLineItems);
    }

    public void onBeforeDelete(List<OpportunityLineItem> oldOpportunityLineItems, Map<Id, OpportunityLineItem> OpportunityLineItemsMap) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onBeforeDelete');
        params.put('oldOpportunityLineItems', oldOpportunityLineItems);
        params.put('OpportunityLineItemsMap', OpportunityLineItemsMap);
    }
}