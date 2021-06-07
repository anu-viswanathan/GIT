@isTest
public with sharing class icHandlerBidderMock implements icHandlerBidder.IClass{

    public void onBeforeInsert(List<Bidder__c> newBidders) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onBeforeInsert');
        params.put('newBidders', newBidders);
    }

    public void onBeforeUpdate(List<Bidder__c> oldBidders, List<Bidder__c> newBidders, Map<Id, Bidder__c> biddersMap) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onBeforeUpdate');
        params.put('oldBidders', oldBidders);
        params.put('newBidders', newBidders);
        params.put('biddersMap', biddersMap);
    }

    public void onAfterInsert(List<Bidder__c> newBidders, Map<Id, Bidder__c> biddersMap) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onAfterInsert');
        params.put('newBidders', newBidders);
        params.put('biddersMap', biddersMap);
    }

}