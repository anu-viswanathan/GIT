@isTest
public with sharing class icTestRepoOrder {

	public static testMethod void test_createOrders(){
		icRepoOrder.IClass repository = (icRepoOrder.IClass) icObjectFactory.GetSingletonInstance('icRepoOrder');

		List<Database.SaveResult> testResult = repository.createOrders(new List<Order>(), false);
	}
	public static testMethod void test_saveOrders(){
        icRepoOrder.IClass repository = (icRepoOrder.IClass) icObjectFactory.GetSingletonInstance('icRepoOrder');
        List<Database.SaveResult> testResult = repository.saveOrders(new List<Order>(), false);
    }
    
    public static testMethod void test_getOrdersByMapicIds(){
        icRepoOrder.IClass repository = (icRepoOrder.IClass) icObjectFactory.GetSingletonInstance('icRepoOrder');
        List<Order> orders = repository.getOrdersByMapicIds(new Set<String> {'12345678'});
    }
}