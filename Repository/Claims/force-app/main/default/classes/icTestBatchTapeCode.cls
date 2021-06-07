/**
 * Created by Anil Mannem (Incloud) on 08-June-2020
 * Ticket ClaimsV2-118
 */

@isTest
public with sharing class icTestBatchTapeCode {
    
    static void initTest() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicProduct', new icLogicProductMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicProductMock', 'getActiveProductsByProductCode', new List<Product2>());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerTapeCode', new icHandlerTapeCodeMock());
    }

    @isTest
    static void testBatchTapeCode_WithDate() {
        Tape_Code__c tc = new Tape_Code__c(Name='1', Product_Code_Value__c='1');
        insert tc;
        Date d = Date.Today();
        icBatchTapeCode batchClass = new icBatchTapeCode(d);
        Database.executebatch(batchClass);
    }

    @isTest
    static void test_BatchTapeCode_noProductCode(){
        initTest();

        List<Tape_Code__c> tcList = new List<Tape_Code__c>();
        Tape_Code__c newTapeCode = new Tape_Code__c();
        newTapeCode.Name = '1';
        tcList.add(newTapeCode);
        insert tcList;

        icBatchTapeCode batchClass = new icBatchTapeCode();
        Database.executebatch(batchClass);
    }

    @isTest
    static void test_BatchTapeCode_noMapValue(){
        initTest();

        icTestMockUtilities.Tracer.SetReturnValue('icLogicProductMock', 'getMapProductsByProductCode', new Map<String, List<Product2>>());

        List<Tape_Code__c> tcList = new List<Tape_Code__c>();
        Tape_Code__c newTapeCode = new Tape_Code__c();
        newTapeCode.Name = '1';
        newTapeCode.Product_Code_Value__c = '1';
        tcList.add(newTapeCode);
        insert tcList;

        icBatchTapeCode batchClass = new icBatchTapeCode();
        Database.executebatch(batchClass);
    }

    @isTest
    static void test_BatchTapeCode_listWithOneProduct(){
        initTest();
        Map<String, List<Product2>> mockMapListProduct = new Map<String, List<Product2>>();
        List<Product2> mockListProduct = new List<Product2>();
        Product2 newProduct = new Product2(Name='Test', ProductCode='1', IsActive=true);
        insert newProduct;
        mockListProduct.add(newProduct);
        mockMapListProduct.put('1',mockListProduct);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicProductMock', 'getMapProductsByProductCode', mockMapListProduct);

        List<Tape_Code__c> tcList = new List<Tape_Code__c>();
        Tape_Code__c newTapeCode = new Tape_Code__c(Name = '1', Product_Code_Value__c = '1');
        tcList.add(newTapeCode);
        Tape_Code__c newTapeCode1 = new Tape_Code__c(Name = '1', Product_Code_Value__c = '1', Product_Description__c = 'No Products / No Active Products found with given Product Code');
        tcList.add(newTapeCode1);    
        Tape_Code__c newTapeCode2 = new Tape_Code__c(Name = '1', Product_Code_Value__c = '1', Product_Description__c = 'Multiple Active Products found with same Product Code');
        tcList.add(newTapeCode2);
        insert tcList;

        icBatchTapeCode batchClass = new icBatchTapeCode();
        Database.executebatch(batchClass);
    }

    @isTest
    static void test_BatchTapeCode_listWithMultipleProducts(){
        initTest();
        Map<String, List<Product2>> mockMapListProduct = new Map<String, List<Product2>>();
        List<Product2> mockListProduct = new List<Product2>();

        mockListProduct.add(new Product2(Id = icTestHelperUtility.getFakeId(Product2.SObjectType)));
        mockListProduct.add(new Product2(Id = icTestHelperUtility.getFakeId(Product2.SObjectType)));
        mockMapListProduct.put('1',mockListProduct);
        
        icTestMockUtilities.Tracer.SetReturnValue('icLogicProductMock', 'getMapProductsByProductCode', mockMapListProduct);
          
        List<Tape_Code__c> tcList = new List<Tape_Code__c>();
        Tape_Code__c newTapeCode = new Tape_Code__c();
        newTapeCode.Name = '1';
        newTapeCode.Product_Code_Value__c = '1';
        tcList.add(newTapeCode);
        insert tcList;
        
        icBatchTapeCode batchClass = new icBatchTapeCode();
        Database.executebatch(batchClass);
    }
}