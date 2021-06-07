/**
 * Created by Anil Mannem (Incloud) on 22-May-2020
 */
@isTest
public with sharing class icTestLogicProduct {

    static void initTest() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoProduct', new icRepoProductMock());
        List<Product2> productList = new List<Product2>();
        Product2 newProduct = new Product2(Name='Test', ProductCode='12345678');
        productList.add(newProduct);
        icTestMockUtilities.Tracer.SetReturnValue('icRepoProductMock', 'getActiveProductsByProductCode', productList);
     }
    /**
     * Ticket ClaimsV2-118
     * By Anil Mannem (Incloud) on 22-May-2020
     */
    @isTest
    static void test_getActiveProductsByProductCode(){
        initTest();
        icLogicProduct.IClass logic = (icLogicProduct.IClass) icObjectFactory.GetSingletonInstance('icLogicProduct');
        List<Product2> productList = logic.getActiveProductsByProductCode(new Set<String> {'12345678'});
        system.assertNotEquals(null, productList, 'This should return a value');
        system.assertEquals(1, productList.size(), 'Expected ProductList returned');
    }

    @isTest
    static void test_getMapProductsByProductCode(){
        initTest();
        icLogicProduct.IClass logic = (icLogicProduct.IClass) icObjectFactory.GetSingletonInstance('icLogicProduct');
        List<Product2> productList = new List<Product2>();
        Product2 newProduct = new Product2();
        newProduct.Name = 'Test';
        newProduct.ProductCode = '1';
        productList.add(newProduct);
        Map<String, List<Product2>> productMap = logic.getMapProductsByProductCode(productList);
        system.assertNotEquals(null, productMap, 'This should return a value');
        system.assertEquals(true, productMap.containsKey('1'), 'Expected Map contained Key');
    }

    @isTest
    static void test_getMapProductsByProductCode_sameProductCode(){
        initTest();
        icLogicProduct.IClass logic = (icLogicProduct.IClass) icObjectFactory.GetSingletonInstance('icLogicProduct');
        List<Product2> productList = new List<Product2>();
        Product2 newProduct = new Product2();
        newProduct.Name = 'Test';
        newProduct.ProductCode = '1';
        productList.add(newProduct);
        productList.add(newProduct);
        Map<String, List<Product2>> productMap = logic.getMapProductsByProductCode(productList);
        system.assertNotEquals(null, productMap, 'This should return a value');
        system.assertEquals(true, productMap.containsKey('1'), 'Expected  Map contained Key');
    }

    @isTest
    static void test_getProductUnitOfMeasure(){
        icLogicProduct.IClass BL = (icLogicProduct.IClass) icObjectFactory.GetSingletonInstance('icLogicProduct');
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoProduct', new icRepoProductMock());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoProductMock', 'getProductUnitOfMeasure',  new List<Product2>{new Product2(Id=icTestHelperUtility.getFakeId(Product2.SObjectType))});
        BL.getProductUnitOfMeasure(new List<OpportunityLineItem>{new OpportunityLineItem()});
    }
}