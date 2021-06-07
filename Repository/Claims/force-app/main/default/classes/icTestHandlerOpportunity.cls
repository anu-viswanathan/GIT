/**
 * Created by Dominic Boivin on 2020-08-11.
 */

@isTest
public with sharing class icTestHandlerOpportunity {

    static List<Opportunity> opportunityList;
    static Id finalDistributorId;
    static Id finalContractorId;
    static icHandlerOpportunity.IClass OppHandler;
    public static void CreateTestData(){
        opportunityList = new List<Opportunity>();
        Id OwnerId = UserInfo.getUserId();
      
        Account newAccountBL = icTestHelperDataCreator.generateAccountByRecordType('Building Location');
        Insert newAccountBL;
        Opportunity testOpportunity = icTestHelperDataCreator.generateOpportunityByRecordType('US Sales Bid', newAccountBL.Id);
        Insert testOpportunity; 
        
        Account newAccountUSContractor = icTestHelperDataCreator.generateAccountByRecordType('US Contractor');
        Insert newAccountUSContractor;
        Account newAccountUSDistributor = icTestHelperDataCreator.generateAccountByRecordType('US Distributor');
        Insert newAccountUSDistributor;
        finalContractorId= newAccountUSContractor.Id;
        finalDistributorId = newAccountUSDistributor.Id;

        Bidder__c newBidder =  icTestHelperDataCreator.generateBidder(testOpportunity,newAccountUSDistributor,newAccountUSContractor,'Open');
        Insert newBidder;

        opportunityList.add(testOpportunity);
        List<Opportunity> bidderByOpportunities = [SELECT Id, Final_Distributor__c, Final_Contractor__c, StageName, (SELECT Id, Status__c, Opportunity__c, Unique_ID__c FROM Opportunity_Distributor_Contractor__r) FROM Opportunity  WHERE Id in :opportunityList];
      
        Map<Id,Id> userManagerMap = new Map<Id,Id>();
        userManagerMap.put(OwnerId,OwnerId);
 
        Map<Id,List<Opportunity>> MapOpportunityByAccount = new Map<Id,List<Opportunity>>();
        MapOpportunityByAccount.put(testOpportunity.AccountId,opportunityList);
 

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicOpportunity', new icLogicOpportunityMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicBidder', new icLogicBidderMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicEmail', new icLogicEmailMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicUser', new icLogicUserMock());
        
        icTestMockUtilities.Tracer.SetReturnValue('icLogicOpportunityMock', 'getBidderForOpportunity', bidderByOpportunities);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicUserMock', 'getOwnerManagerIdByOwnerID', userManagerMap);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicOpportunityMock', 'getEmailTemplateByDevName', new EmailTemplate());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicOpportunityMock', 'RenderEmailTemplate', new Messaging.SingleEmailMessage());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicOpportunityMock', 'getOpportunityByAccountsIdsIsClosedAndRecordTypeId', MapOpportunityByAccount);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicBidderMock', 'getBidderDetailsforPDFAutomation', new List<Bidder__c>());
        
        OppHandler = (icHandlerOpportunity.IClass) icObjectFactory.GetSingletonInstance('icHandlerOpportunity');
        
    }
    static public Opportunity CreateTestOpportunity(Id id,String stageName) {
        
        Opportunity newopportunity = icTestHelperDataCreator.generateOpportunityByRecordType('US Sales Bid', icTestHelperUtility.getFakeId(Account.SObjectType));
        newopportunity.Id = id;
        newopportunity.Final_Distributor__c = finalDistributorId;
        newopportunity.Final_Contractor__c = finalContractorId;
        newopportunity.StageName = stageName;
        newopportunity.OwnerId = UserInfo.getUserId();
        return newopportunity;
    }

    @isTest
    public static void test_AfterUpdateInApproval(){
        CreateTestData();
        
        
        List<Opportunity> oldOpportunities = new List<Opportunity>();
        List<Opportunity> newOpportunities = new List<Opportunity>();
        Map<Id,Opportunity> mapOpportunities = new Map<Id,Opportunity>();
    
        Id CommonOpportuniyId = opportunityList[0].Id;
       
        Opportunity testOldOpportunity  = CreateTestOpportunity (CommonOpportuniyId, 'Preparing Quotes');
        Opportunity testNewOpportunity = CreateTestOpportunity(CommonOpportuniyId,'In Approval');
        
        newOpportunities.add(testNewOpportunity);
        oldOpportunities.add(testOldOpportunity);
        mapOpportunities.put(testNewOpportunity.Id,testOldOpportunity);


        OppHandler.onAfterUpdate(newOpportunities, oldOpportunities,  mapOpportunities);
    }
    @isTest
    public static void test_AfterUpdateCloseLost(){
        CreateTestData();
        List<Opportunity> oldOpportunities = new List<Opportunity>();
        List<Opportunity> newOpportunities = new List<Opportunity>();
        Map<Id,Opportunity> mapOpportunities = new Map<Id,Opportunity>();
    
        Id CommonOpportuniyId = opportunityList[0].Id;
       
        Opportunity testOldOpportunity  = CreateTestOpportunity (CommonOpportuniyId, 'Quote Approved');
        Opportunity testNewOpportunity = CreateTestOpportunity(CommonOpportuniyId,'Closed Lost');
        
        newOpportunities.add(testNewOpportunity);
        oldOpportunities.add(testOldOpportunity);
        mapOpportunities.put(testNewOpportunity.Id,testOldOpportunity);

        OppHandler.onAfterUpdate(newOpportunities, oldOpportunities,  mapOpportunities);
    }
    @isTest
    public static void test_AfterUpdateClosedExpired(){
        CreateTestData();
        List<Opportunity> oldOpportunities = new List<Opportunity>();
        List<Opportunity> newOpportunities = new List<Opportunity>();
        Map<Id,Opportunity> mapOpportunities = new Map<Id,Opportunity>();
    
        Id CommonOpportuniyId = opportunityList[0].Id;
       
        Opportunity testOldOpportunity  = CreateTestOpportunity (CommonOpportuniyId, 'Quote Approved');
        Opportunity testNewOpportunity = CreateTestOpportunity(CommonOpportuniyId,'Closed Expired');
        
        newOpportunities.add(testNewOpportunity);
        oldOpportunities.add(testOldOpportunity);
        mapOpportunities.put(testNewOpportunity.Id,testOldOpportunity);


        OppHandler.onAfterUpdate(newOpportunities, oldOpportunities,  mapOpportunities);
    }
    @isTest
    public static void test_AfterUpdateClosedWon(){
        CreateTestData();
        List<Opportunity> oldOpportunities = new List<Opportunity>();
        List<Opportunity> newOpportunities = new List<Opportunity>();
        Map<Id,Opportunity> mapOpportunities = new Map<Id,Opportunity>();
    
        Id CommonOpportuniyId = opportunityList[0].Id;
       
        Opportunity testOldOpportunity  = CreateTestOpportunity (CommonOpportuniyId, 'Quote Approved');
        Opportunity testNewOpportunity = CreateTestOpportunity(CommonOpportuniyId,'Closed Won');
        
        newOpportunities.add(testNewOpportunity);
        oldOpportunities.add(testOldOpportunity);
        mapOpportunities.put(testNewOpportunity.Id,testOldOpportunity);


        OppHandler.onAfterUpdate(newOpportunities, oldOpportunities,  mapOpportunities);
    }
    @isTest
    public static void test_AfterUpdatePreparingQuotesfromInApproval(){
        CreateTestData();
        List<Opportunity> oldOpportunities = new List<Opportunity>();
        List<Opportunity> newOpportunities = new List<Opportunity>();
        Map<Id,Opportunity> mapOpportunities = new Map<Id,Opportunity>();
    
        Id CommonOpportuniyId = opportunityList[0].Id;
       
        Opportunity testOldOpportunity  = CreateTestOpportunity (CommonOpportuniyId, 'In Approval');
        Opportunity testNewOpportunity = CreateTestOpportunity(CommonOpportuniyId,'Preparing Quotes');
        
        newOpportunities.add(testNewOpportunity);
        oldOpportunities.add(testOldOpportunity);
        mapOpportunities.put(testNewOpportunity.Id,testOldOpportunity);


        OppHandler.onAfterUpdate(newOpportunities, oldOpportunities,  mapOpportunities);
    }
    @isTest
    public static void test_beforeInsertOpportunityWithSameBuildingLocation(){
        CreateTestData();
        List<Opportunity> oldOpportunities = new List<Opportunity>();
        List<Opportunity> newOpportunities = new List<Opportunity>();
        Map<Id,Opportunity> mapOpportunities = new Map<Id,Opportunity>();
    
        Id CommonOpportuniyId = opportunityList[0].Id;
        Opportunity testOldOpportunity = new Opportunity();
        Opportunity testNewOpportunity  = CreateTestOpportunity (null, 'Preparing Quotes');
        testNewOpportunity.AccountId =  opportunityList[0].AccountID;
        
        newOpportunities.add(testNewOpportunity);
        oldOpportunities.add(testOldOpportunity);
        
        OppHandler.onBeforeInsert(newOpportunities, oldOpportunities,  mapOpportunities);
        
    }
}