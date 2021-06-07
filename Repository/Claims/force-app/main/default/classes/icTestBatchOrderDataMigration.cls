@isTest
public with sharing class icTestBatchOrderDataMigration {
    
    static testMethod void test_BatchOrderMigration() {

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicOrder', new icLogicOrderMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicAccount', new icLogicAccountMock());
		icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountMock', 'getMapAccountsByMapicsExternalId', new Map<String, Account>());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicOrderMock', 'getOrdersByMapicIds', new List<Order>());
        
        Map<String, List<Order>> mapOrdersByAccount = new Map<String, List<Order>>();
        
		Map<String, Schema.RecordTypeInfo> mapContractorRecordTypes = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
		Id distributorRecordTypeId = mapContractorRecordTypes.get('Distributor').getRecordTypeId();
        
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='Test Account', Mapics_ERP_Id__c='99999999', RecordTypeId = distributorRecordTypeId));
        accounts.add(new Account(Name='Test Account1', Mapics_ERP_Id__c='12345678', RecordTypeId = distributorRecordTypeId));
        insert accounts;
        
        List<Order> orders = new List<Order>();
        orders.add(new Order(Customer_Number_Mapics__c = '11234532', 
                             AccountId = accounts[0].Id, 
                             EffectiveDate = System.today(), Status = 'Draft'));
        insert orders;
        
        Map<String, List<Order>> ordersByMapicsMap = new Map<String, List<Order>>();
        ordersByMapicsMap.put('12345678', orders);
        
        icTestMockUtilities.Tracer.SetReturnValue('icLogicOrderMock', 'getOrdersByMapicIdsMap', ordersByMapicsMap);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountMock', 'getAccountsByMapicsExternalId', new List<Account> {accounts[1]});
        
		icBatchOrderDataMigration migrationBatch = new icBatchOrderDataMigration();   
        
        Database.executebatch( new icBatchOrderDataMigration(true, 'test@test.com'));
        
    }
}