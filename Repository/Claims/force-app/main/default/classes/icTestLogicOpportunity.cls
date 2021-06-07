/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestLogicOpportunity {

    public static testMethod void test_getCurrentOpportunitiesCountByAccountId(){

       
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoOpportunity', new icREPOOpportunityMock());
        icTestMockUtilities.Tracer.SetReturnValue('icREPOOpportunityMock', 'getCurrentOpportunitiesByAccountId', new List<Opportunity>{new Opportunity()});
        icLogicOpportunity.IClass BL = (icLogicOpportunity.IClass) icObjectFactory.GetSingletonInstance('icLogicOpportunity');
        BL.getCurrentOpportunitiesCountByAccountId('');

    }
    public static testMethod void test_getOpportunityDataForGreenSky(){

        
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoOpportunity', new icREPOOpportunityMock());
        icTestMockUtilities.Tracer.SetReturnValue('icREPOOpportunityMock', 'getOpportunityDataForGreenSky', new Opportunity());
        icLogicOpportunity.IClass BL = (icLogicOpportunity.IClass) icObjectFactory.GetSingletonInstance('icLogicOpportunity');
        BL.getOpportunityDataForGreenSky(icTestHelperUtility.getFakeId(Opportunity.SObjectType));

    }
    
    public static testMethod void test_getApprovedOpportunitiesByListId(){

        
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoOpportunity', new icREPOOpportunityMock());
        Opportunity opp = new Opportunity (Id=icTestHelperUtility.getFakeId(Opportunity.SObjectType));
        List<Opportunity> oppList  = new List<Opportunity>{opp};
        icTestMockUtilities.Tracer.SetReturnValue('icREPOOpportunityMock', 'getApprovedOpportunitiesByListID',oppList);
        icLogicOpportunity.IClass BL = (icLogicOpportunity.IClass) icObjectFactory.GetSingletonInstance('icLogicOpportunity');
        Id OpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('US_Sales_Bid').getRecordTypeId();
        BL.getApprovedOpportunitiesByListID(new Set<Id> { icTestHelperUtility.getFakeId(Opportunity.SObjectType)},OpportunityRecordTypeId);
    }
    public static testMethod void test_getBidderForOpportunity(){
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoOpportunity', new icREPOOpportunityMock());
        icTestMockUtilities.Tracer.SetReturnValue('icREPOOpportunityMock', 'getBidderForOpportunity', new List<Opportunity>{new Opportunity()});
        icLogicOpportunity.IClass BL = (icLogicOpportunity.IClass) icObjectFactory.GetSingletonInstance('icLogicOpportunity');
        BL.getBidderForOpportunity(new List<Id> { icTestHelperUtility.getFakeId(Opportunity.SObjectType)});
    }
    public static testMethod void test_getOpportunityByAccountsIdsIsClosedAndRecordTypeId(){

        icLogicOpportunity.IClass BL = (icLogicOpportunity.IClass) icObjectFactory.GetSingletonInstance('icLogicOpportunity');
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoOpportunity', new icRepoOpportunityMock());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoOpportunityMock', 'getOpportunityByAccountsIdsIsClosedAndRecordTypeId', new List<Opportunity>{new Opportunity()});
        Id OpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('US_Sales_Bid').getRecordTypeId();
        BL.getOpportunityByAccountsIdsIsClosedAndRecordTypeId(new Set<Id> { icTestHelperUtility.getFakeId(Account.SObjectType)},false,OpportunityRecordTypeId);
    }
    public static testMethod void test_createMapAccountIdToOpportunityList(){
        icLogicOpportunity.IClass BL = (icLogicOpportunity.IClass) icObjectFactory.GetSingletonInstance('icLogicOpportunity');
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.AccountID = icTestHelperUtility.getFakeId(Account.SObjectType);
        BL.createMapAccountIdToOpportunityList(new List<Opportunity> { newOpportunity});
    }
}