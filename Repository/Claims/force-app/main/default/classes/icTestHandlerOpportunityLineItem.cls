/**
 * Created by Dominic Boivin on 2020-08-17.
 */
@isTest
public with sharing class icTestHandlerOpportunityLineItem {
    static List<OpportunityLineItem> deletedOpportunityLIList;
    static Map<Id,OpportunityLineItem> deletedOpportunityLIMap;
    static Opportunity testOpportunity;
    static Map<Id,Opportunity> opportunityMap;
    static Id finalDistributorId;
    static Id finalContractorId;
    
    public static void CreateTestData(){
        Id OwnerId = UserInfo.getUserId();
      
       
        
        Account newAccountBL = icTestHelperDataCreator.generateAccountByRecordType('Building Location');
        Insert newAccountBL;
        testOpportunity = icTestHelperDataCreator.generateOpportunityByRecordType('US Sales Bid', newAccountBL.Id);
        Insert testOpportunity; 
       
        OpportunityLineItem deletedOpportunityLI = icTestHelperDataCreator.createOpportunityLineItemWithoutPriceStructure(testOpportunity,true);
        deletedOpportunityLIList = new  List<OpportunityLineItem> ();
        deletedOpportunityLIList.add(deletedOpportunityLI);
        deletedOpportunityLIMap = new Map<Id,OpportunityLineItem>();
        deletedOpportunityLIMap.put(deletedOpportunityLI.Id,deletedOpportunityLI);

         icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicOpportunity', new icLogicOpportunityMock());
        opportunityMap = new Map<Id,Opportunity>(); 
    }
    
    @isTest
    public static void test_OnBeforeInsert(){
        CreateTestData();
        Map<Id, Product2> productMap = new Map<Id, Product2>();
        Product2 pro = new Product2(Name = 'Test', Unit_of_Measure__c = 'BD');
        insert pro;
        productMap.put(pro.Id, pro);
        
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicOpportunityLineItems', new icLogicOpportunityLineItemsMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicOpportunityLineItemsMock', 'getProductUnitOfMeasure', productMap);
        icHandlerOpportunityLineItem.IClass handler = (icHandlerOpportunityLineItem.IClass) icObjectFactory.GetSingletonInstance('icHandlerOpportunityLineItem');
        
        handler.onBeforeInsert(deletedOpportunityLIList);
    }
    
    @isTest
    public static void test_OnBeforeDeletePositive(){
        CreateTestData();
        Boolean expectedExceptionThrown = false;
          // opportunityMap is empty, we don't want any approved opportunity.
        icTestMockUtilities.Tracer.SetReturnValue('icLogicOpportunityMock', 'getApprovedOpportunitiesByListId', opportunityMap);
        icHandlerOpportunityLineItem.IClass handler = (icHandlerOpportunityLineItem.IClass) icObjectFactory.GetSingletonInstance('icHandlerOpportunityLineItem');
     
        handler.onBeforeDelete(deletedOpportunityLIList, deletedOpportunityLIMap);   
        if (ApexPages.GetMessages().size() > 0){
            expectedExceptionThrown = ApexPages.GetMessages()[0].getSummary().contains(System.Label.icOpportunityLineItemCannotDelete) ? true : false;
        } 
        System.AssertEquals(expectedExceptionThrown, false);
    }
    @isTest
    public static void test_OnBeforeDeleteNegative(){
        Boolean expectedExceptionThrown = false;
        
        //Create Mock Opportunity for getApprovedOpportunitiesByListId
        Opportunity opp = new Opportunity (Id=icTestHelperUtility.getFakeId(Opportunity.SObjectType));
        opp.Quote_Approved__c = True;
        opp.StageName = 'Quote Approved';
        Map<Id,Opportunity> mapOpp = new Map<Id,Opportunity>();
        mapOpp.put(opp.Id,opp);
        
        //Create Opportunity Line Itam Data
        OpportunityLineItem oppLi =  new OpportunityLineItem(Id=icTestHelperUtility.getFakeId(OpportunityLineItem.SObjectType),OpportunityId = opp.Id);
        Map<Id,OpportunityLineItem> mapOppLi = new Map<Id,OpportunityLineItem>();
        
        mapOppLi.put(oppLi.Id,oppLi);

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicOpportunity', new icLogicOpportunityMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicOpportunityMock', 'getApprovedOpportunitiesByListId', mapOpp);
        

        icHandlerOpportunityLineItem.IClass handler = (icHandlerOpportunityLineItem.IClass) icObjectFactory.GetSingletonInstance('icHandlerOpportunityLineItem');
        handler.onBeforeDelete(new List<OpportunityLineItem>{oppLi}, mapOppLi);   
        

        if (ApexPages.GetMessages().size() > 0){
            expectedExceptionThrown = ApexPages.GetMessages()[0].getSummary().contains(System.Label.icOpportunityLineItemCannotDelete) ? true : false;
            System.debug('Error is ' +  ApexPages.GetMessages()[0].getSummary()) ;
        } 
        
        System.AssertEquals(expectedExceptionThrown, true);
    }
}