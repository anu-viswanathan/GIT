/**
 * Created by Anil Mannem (Incloud) on 31-July-2020
 */
@isTest
public with sharing class icTestHandlerBidder {

    static void initTest() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicBidder', new icLogicBidderMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicBidderMock', 'getBidderInfo', new List<Bidder__c>());
    }

    @isTest
    static void test_onBeforeInsert(){
        initTest();

        icHandlerBidder.IClass handler = (icHandlerBidder.IClass) icObjectFactory.GetSingletonInstance('icHandlerBidder');

        List<Bidder__c> bidderList = new List<Bidder__c>();
        Bidder__c newBidder = new Bidder__c();
        newBidder.Unique_ID__c = '1';
        bidderList.add(NewBidder);
        try {
	        handler.onBeforeInsert(bidderList);
        } catch (Exception e) {            
        }
    }

    @isTest
    static void test_onBeforeUpdate(){
        initTest();

        icHandlerBidder.IClass handler = (icHandlerBidder.IClass) icObjectFactory.GetSingletonInstance('icHandlerBidder');

        List<Bidder__c> oldBidderList = new List<Bidder__c>();
        List<Bidder__c> newBidderList = new List<Bidder__c>();

        Bidder__c oldBidder = new Bidder__c();
        oldBidder.Unique_ID__c = '1';
        oldBidderList.add(oldBidder);
        Bidder__c newBidder = new Bidder__c();
        newBidder.Unique_ID__c = '123';
        newBidderList.add(newBidder);
        
        try {
	        handler.onBeforeUpdate(oldBidderList, newBidderList, new Map<Id, Bidder__c>());
        } catch (Exception e) {
            
        }

    }
}