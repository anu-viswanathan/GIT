/**
* Created by Dominic Boivin on 2020-08-26.
*/
@isTest
public with sharing class icTestLogicOpportunityLineItems {
    public static testMethod void test_getOpportunityLineItemForOpportunity(){
        icLogicOpportunityLineItems.IClass BL = (icLogicOpportunityLineItems.IClass) icObjectFactory.GetSingletonInstance('icLogicOpportunityLineItems');
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoOpportunityLineItems', new icRepoOpportunityLineItemsMock());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoOpportunityLineItemsMock', 'getOpportunityLineItemForOpportunity', new List<OpportunityLineItem>{new OpportunityLineItem()});
        BL.getOpportunityLineItemForOpportunity(icTestHelperUtility.getFakeId(Opportunity.SObjectType));
    }
    public static testMethod void test_getOpportunityLineItemsByOpportunities(){
        icLogicOpportunityLineItems.IClass BL = (icLogicOpportunityLineItems.IClass) icObjectFactory.GetSingletonInstance('icLogicOpportunityLineItems');
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoOpportunityLineItems', new icRepoOpportunityLineItemsMock());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoOpportunityLineItemsMock', 'getOpportunityLineItemsByOpportunities', new List<OpportunityLineItem>{new OpportunityLineItem()});
        BL.getOpportunityLineItemsByOpportunities(new List<Opportunity> { new Opportunity() });
    }
    public static testMethod void test_getMapForOpportunityLineItemByOpportunities(){
        icLogicOpportunityLineItems.IClass BL = (icLogicOpportunityLineItems.IClass) icObjectFactory.GetSingletonInstance('icLogicOpportunityLineItems');
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoOpportunityLineItems', new icRepoOpportunityLineItemsMock());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoOpportunityLineItemsMock', 'getOpportunityLineItemsByOpportunities',  new List<OpportunityLineItem>{new OpportunityLineItem(Id=icTestHelperUtility.getFakeId(OpportunityLineItem.SObjectType),OpportunityId=icTestHelperUtility.getFakeId(Opportunity.SObjectType))});
        BL.getMapForOpportunityLineItemByOpportunities(new List<Opportunity>{new Opportunity()});
    }
}