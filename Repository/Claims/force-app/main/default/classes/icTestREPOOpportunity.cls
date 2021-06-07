/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icTestREPOOpportunity {

    public static testMethod void test_getCurrentOpportunitiesByAccountId(){
        icRepoOpportunity.IClass repository = (icRepoOpportunity.IClass) icObjectFactory.GetSingletonInstance('icRepoOpportunity');

        repository.getCurrentOpportunitiesByAccountId(icTestHelperUtility.getFakeId(Account.SObjectType));
    }
    public static testMethod void test_getOpportunityDataForGreenSky(){
        icRepoOpportunity.IClass repository = (icRepoOpportunity.IClass) icObjectFactory.GetSingletonInstance('icRepoOpportunity');

        repository.getOpportunityDataForGreenSky(icTestHelperUtility.getFakeId(Opportunity.SObjectType));
    }
    public static testMethod void test_getApprovedOpportunitiesByListID(){
        icRepoOpportunity.IClass repository = (icRepoOpportunity.IClass) icObjectFactory.GetSingletonInstance('icRepoOpportunity');
        Id USSalesBidRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('US_Sales_Bid').getRecordTypeId();
        repository.getApprovedOpportunitiesByListID(new Set<Id> { icTestHelperUtility.getFakeId(Opportunity.SObjectType)},USSalesBidRecordTypeId);
    }
    public static testMethod void test_getBidderForOpportunity(){
        
        icRepoOpportunity.IClass repository = (icRepoOpportunity.IClass) icObjectFactory.GetSingletonInstance('icRepoOpportunity');
        Id USSalesBidRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('US_Sales_Bid').getRecordTypeId();
        Id BuildingLocationIdRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Building_Location').getRecordTypeId();
        Account a = new Account();
        a.RecordTypeId = BuildingLocationIdRecordTypeId;
        a.Name = 'testing';
        a.BillingPostalCode='91605';
        insert a;

        Opportunity o = new Opportunity();
        o.Name = 'tsing';
        o.RecordTypeId = USSalesBidRecordTypeId;
        o.AccountId = a.Id;
        o.CloseDate = Date.today().addDays(+10);
        o.StageName = 'Preparing Quotes';
        insert o;
        repository.getBidderForOpportunity(new List<Id> { o.Id });
    }
    public static testMethod void test_getOpportunityByAccountsIdsIsClosedAndRecordTypeId(){
        
        icRepoOpportunity.IClass repository = (icRepoOpportunity.IClass) icObjectFactory.GetSingletonInstance('icRepoOpportunity');
        Id USSalesBidRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('US_Sales_Bid').getRecordTypeId();
        Id BuildingLocationIdRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Building_Location').getRecordTypeId();
        Account a = new Account();
        a.RecordTypeId = BuildingLocationIdRecordTypeId;
        a.Name = 'testing';
        a.BillingPostalCode='91605';
        insert a;

        Opportunity o = new Opportunity();
        o.Name = 'tsing';
        o.RecordTypeId = USSalesBidRecordTypeId;
        o.AccountId = a.Id;
        o.CloseDate = Date.today().addDays(+10);
        o.StageName = 'Preparing Quotes';
        insert o;
        repository.getOpportunityByAccountsIdsIsClosedAndRecordTypeId(new Set<Id> { a.Id }, false, USSalesBidRecordTypeId);
    }
}