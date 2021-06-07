/**
 * Created by Anil Mannem on 13-Oct-2020
 */
@isTest
public with sharing class icTestRepoBidder {
    public static testMethod void test_getBidderInfo(){
        icRepoBidder.IClass repository = (icRepoBidder.IClass) icObjectFactory.GetSingletonInstance('icRepoBidder');
        List<Bidder__c> testResult = repository.getBidderInfo();
    }

    public static testMethod void test_getBidderDetailsforPDF(){
        icRepoBidder.IClass repository = (icRepoBidder.IClass) icObjectFactory.GetSingletonInstance('icRepoBidder');
        List<Bidder__c> testResult = repository.getBidderDetailsforPDF(icTestHelperUtility.getFakeId(Bidder__c.SObjectType));
    }

    public static testMethod void test_getBidderDetailsforPDFAutomation(){
        icRepoBidder.IClass repository = (icRepoBidder.IClass) icObjectFactory.GetSingletonInstance('icRepoBidder');
        List<Bidder__c> testResult = repository.getBidderDetailsforPDFAutomation(new List<Id> {icTestHelperUtility.getFakeId(Bidder__c.SObjectType)});
    }

    public static testMethod void test_updateBidderStatus(){
        icRepoBidder.IClass repository = (icRepoBidder.IClass) icObjectFactory.GetSingletonInstance('icRepoBidder');
        Account newAccountBL = icTestHelperDataCreator.generateAccountByRecordType('Building Location');
        Insert newAccountBL;
        Opportunity testOpportunity = icTestHelperDataCreator.generateOpportunityByRecordType('US Sales Bid', newAccountBL.Id);
        Insert testOpportunity; 
        
        Account newAccountUSContractor = icTestHelperDataCreator.generateAccountByRecordType('US Contractor');
        Insert newAccountUSContractor;
        Account newAccountUSDistributor = icTestHelperDataCreator.generateAccountByRecordType('US Distributor');
        Insert newAccountUSDistributor;

        Bidder__c newBidder =  icTestHelperDataCreator.generateBidder(testOpportunity,newAccountUSDistributor,newAccountUSContractor,'Open');
        Insert newBidder;
		List<Bidder__c> bidderList = new List<Bidder__c>();
        bidderList.add(newBidder);
        repository.updateBidderStatus(bidderList);
    }
}