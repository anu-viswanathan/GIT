/**
 * Created by Anil Mannem (Incloud) on 21-May-2020
 */
@isTest
public with sharing class icTestRepoProduct {
	/**
	 * Ticket ClaimsV2-118
	 * By Anil Mannem (Incloud) on 21-May-2020
	 */
    @isTest
    static void testGetActiveProductsByProductCode () {
        icRepoProduct.IClass repository = (icRepoProduct.IClass) icObjectFactory.GetSingletonInstance('icRepoProduct');
        Product2 newProduct = new Product2(Name='Test', ProductCode='1', IsActive=true);
        insert newProduct;
        List<Product2> productList = repository.getActiveProductsByProductCode(new Set<String>{'1'});
        system.assertNotEquals(null, productList, 'This should return a value');
        system.assertEquals(1, productList.size(),'Expected Products were returned');        
    }

    /**
     * IKO-359
     * By Anil Mannem (Incloud) on 30-Sep-2020
     */
    @isTest
    static void test_getProductUnitOfMeasure() {
        icRepoProduct.IClass repository = (icRepoProduct.IClass) icObjectFactory.GetSingletonInstance('icRepoProduct');
        Product2 newProduct = new Product2(Name='Test', ProductCode='1', Unit_of_Measure__c='BD', IsActive=true);
        insert newProduct;
        List<Product2> productList = repository.getProductUnitOfMeasure(new List<Id>{newProduct.Id});
        system.assertNotEquals(null, productList, 'This should return a value');
    }

}