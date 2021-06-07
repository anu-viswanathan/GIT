/**
 * Created by Anil Mannem on 13-Oct-2020
 */
@isTest
public with sharing class icTestLogicBidder {
    public static testMethod void test_getBidderInfo(){
        icLogicBidder.IClass logicBidder = (icLogicBidder.IClass) icObjectFactory.GetSingletonInstance('icLogicBidder');
        List<Bidder__c> testResult = logicBidder.getBidderInfo();
    }

    public static testMethod void test_getBidderDetailsforPDF(){
        icLogicBidder.IClass logicBidder = (icLogicBidder.IClass) icObjectFactory.GetSingletonInstance('icLogicBidder');
        List<Bidder__c> testResult = logicBidder.getBidderDetailsforPDF(icTestHelperUtility.getFakeId(Bidder__c.SObjectType));
    }

    public static testMethod void test_getBidderDetailsforPDFAutomation(){
        icLogicBidder.IClass logicBidder = (icLogicBidder.IClass) icObjectFactory.GetSingletonInstance('icLogicBidder');
        List<Bidder__c> testResult = logicBidder.getBidderDetailsforPDFAutomation(new List<Id> {icTestHelperUtility.getFakeId(Bidder__c.SObjectType)});
    }

    public static testMethod void test_updateBidderStatus(){
        icLogicBidder.IClass logicBidder = (icLogicBidder.IClass) icObjectFactory.GetSingletonInstance('icLogicBidder');
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
        logicBidder.updateBidderStatus(bidderList);
    }
}