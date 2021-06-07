@isTest
public with sharing class icRepoOrderMock implements icRepoOrder.IClass {
	
	public List<Order> getOrdersByMapicIds(Set<String> accountMapicsIds) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getOrdersByMapicIds');
        params.put('accountMapicsIds', accountMapicsIds);
        return (List<Order>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getOrdersByMapicIds');
    }

	public List<Database.SaveResult> createOrders(List<Order> orders, Boolean allOrNone) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createOrders');
		params.put('orders', orders);
		params.put('allOrNone', allOrNone);
		return (List<Database.SaveResult>) icTestMockUtilities.Tracer.GetReturnValue(this, 'createOrders');
	}

	public List<Database.SaveResult> saveOrders(List<Order> orders, Boolean allOrNone) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'saveOrders');
        params.put('orders', orders);
        params.put('allOrNone', allOrNone);
        return (List<Database.SaveResult>) icTestMockUtilities.Tracer.GetReturnValue(this, 'saveOrders');
    }
}