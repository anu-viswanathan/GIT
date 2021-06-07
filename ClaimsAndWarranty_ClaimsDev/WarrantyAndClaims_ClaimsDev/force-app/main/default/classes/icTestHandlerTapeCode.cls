/**
 * Created by Anil Mannem (Incloud) on 21-May-2020
 */
@isTest
public with sharing class icTestHandlerTapeCode {

    static void initTest() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicProduct', new icLogicProductMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicProductMock', 'getActiveProductsByProductCode', new List<Product2>());
    }

    /**
     * Ticket ClaimsV2-118
     * By Anil Mannem (Incloud) on 21-May-2020
    */
    @isTest
    static void test_onBeforeInsert_updateTapeCodeProduct_noName(){
        initTest();

        icHandlerTapeCode.IClass handler = (icHandlerTapeCode.IClass) icObjectFactory.GetSingletonInstance('icHandlerTapeCode');

        List<Tape_Code__c> tcList = new List<Tape_Code__c>();
        Tape_Code__c newTapeCode = new Tape_Code__c();
        newTapeCode.Product_Code_Value__c = '1';
        tcList.add(newTapeCode);
        try {
	        handler.onBeforeInsert(tcList);
        } catch (Exception e) {
            
        }

    } 

    @isTest
    static void test_onBeforeInsert_updateTapeCodeProduct_noProductCode(){
        initTest();

        icHandlerTapeCode.IClass handler = (icHandlerTapeCode.IClass) icObjectFactory.GetSingletonInstance('icHandlerTapeCode');

        List<Tape_Code__c> tcList = new List<Tape_Code__c>();
        Tape_Code__c newTapeCode = new Tape_Code__c();
        newTapeCode.Name = '1';
        tcList.add(newTapeCode);

        handler.onBeforeInsert(tcList);
    }

    @isTest
    static void test_onBeforeInsert_updateTapeCodeProduct_noMapValue(){
        initTest();

        icTestMockUtilities.Tracer.SetReturnValue('icLogicProductMock', 'getMapProductsByProductCode', new Map<String, List<Product2>>());
        icHandlerTapeCode.IClass handler = (icHandlerTapeCode.IClass) icObjectFactory.GetSingletonInstance('icHandlerTapeCode');

        List<Tape_Code__c> tcList = new List<Tape_Code__c>();
        Tape_Code__c newTapeCode = new Tape_Code__c();
        newTapeCode.Name = '1';
        newTapeCode.Product_Code_Value__c = '1';
        tcList.add(newTapeCode);

        handler.onBeforeInsert(tcList);
    }

    @isTest
    static void test_onBeforeInsert_updateTapeCodeProduct_listWithOneProduct(){
        initTest();

        Map<String, List<Product2>> mockMapListProduct = new Map<String, List<Product2>>();
        List<Product2> mockListProduct = new List<Product2>();
        mockListProduct.add(new Product2(Id = icTestHelperUtility.getFakeId(Product2.SObjectType)));
        mockMapListProduct.put('1',mockListProduct);
        
        icTestMockUtilities.Tracer.SetReturnValue('icLogicProductMock', 'getMapProductsByProductCode', mockMapListProduct);
        icHandlerTapeCode.IClass handler = (icHandlerTapeCode.IClass) icObjectFactory.GetSingletonInstance('icHandlerTapeCode');
          
        List<Tape_Code__c> tcList = new List<Tape_Code__c>();
        Tape_Code__c newTapeCode = new Tape_Code__c();
        newTapeCode.Name = '1';
        newTapeCode.Product_Code_Value__c = '1';
        tcList.add(newTapeCode);

        handler.onBeforeInsert(tcList);
    }

    @isTest
    static void test_onBeforeInsert_updateTapeCodeProduct_listWithMultipleProducts(){
        initTest();
        Map<String, List<Product2>> mockMapListProduct = new Map<String, List<Product2>>();
        List<Product2> mockListProduct = new List<Product2>();

        mockListProduct.add(new Product2(Id = icTestHelperUtility.getFakeId(Product2.SObjectType)));
        mockListProduct.add(new Product2(Id = icTestHelperUtility.getFakeId(Product2.SObjectType)));
        mockMapListProduct.put('1',mockListProduct);
        
        icTestMockUtilities.Tracer.SetReturnValue('icLogicProductMock', 'getMapProductsByProductCode', mockMapListProduct);
        icHandlerTapeCode.IClass handler = (icHandlerTapeCode.IClass) icObjectFactory.GetSingletonInstance('icHandlerTapeCode');
          
        List<Tape_Code__c> tcList = new List<Tape_Code__c>();
        Tape_Code__c newTapeCode = new Tape_Code__c();
        newTapeCode.Name = '1';
        newTapeCode.Product_Code_Value__c = '1';
        tcList.add(newTapeCode);

        handler.onBeforeInsert(tcList);
    }
}