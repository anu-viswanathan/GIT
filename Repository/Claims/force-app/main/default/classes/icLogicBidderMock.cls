/**
 * Created by Dominic Boivin  on 2020-08-12.
 */

@isTest
public with sharing class icLogicBidderMock implements icLogicBidder.IClass {

    public List<Bidder__c> getBidderInfo(){

        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getBidderInfo');
        return (List<Bidder__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getBidderInfo');

    }

    public List<Bidder__c> getBidderDetailsforPDF(String recordId){

        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getBidderDetailsforPDF');
        params.put('recordId', recordId);
        return (List<Bidder__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getBidderDetailsforPDF');

    }
    public List<Bidder__c> getBidderDetailsforPDFAutomation(List<Id> bidderIdList){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getBidderDetailsforPDFAutomation');
        params.put('bidderIdList', bidderIdList);
        return (List<Bidder__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getBidderDetailsforPDFAutomation');

    }

    public void updateBidderStatus(List<Bidder__c> bidderList){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'updateBidderStatus');
        params.put('bidderList', bidderList);
        
    }
}