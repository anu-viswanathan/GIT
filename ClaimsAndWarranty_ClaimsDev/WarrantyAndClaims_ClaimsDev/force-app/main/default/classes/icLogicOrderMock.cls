@isTest
public with sharing class icLogicOrderMock implements icLogicOrder.IClass {

	public List<icDTOMapicsData> getOrderDTOFromMapicsPayload(String mapicsPayload) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getOrderDTOFromMapicsPayload');
		params.put('mapicsPayload', mapicsPayload);
		return (List<icDTOMapicsData>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getOrderDTOFromMapicsPayload');
	}

	public Set<String> getListExternalAccountIdsFromMapicsData(List<icDTOMapicsData> mapicsData) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getListExternalAccountIdsFromMapicsData');
		params.put('mapicsData', mapicsData);
		return (Set<String>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getListExternalAccountIdsFromMapicsData');
	}

	public List<Order> getOrdersFromListMapicsData(List<icDTOMapicsData> mapicsData, Map<String, Account> mapAccountsByMapicsExternalId) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getOrdersFromListMapicsData');
		params.put('mapicsData', mapicsData);
		params.put('mapAccountsByMapicsExternalId', mapAccountsByMapicsExternalId);
		return (List<Order>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getOrdersFromListMapicsData');
	}

	public List<Order> getOrdersByMapicIds(Set<String> accountMapicsIds) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getOrdersByMapicIds');
        params.put('accountMapicsIds', accountMapicsIds);
        return (List<Order>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getOrdersByMapicIds');
	}

	public Map<String, List<Order>> getOrdersByMapicIdsMap(List<Order> orders) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getOrdersByMapicIdsMap');
        params.put('orders', orders);
        return (Map<String, List<Order>>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getOrdersByMapicIdsMap');
	}

	public void saveOrders(List<Order> orders) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'saveOrders');
		params.put('orders', orders);
		//return (void) icTestMockUtilities.Tracer.GetReturnValue(this, 'saveOrders');
	}

	public void updateOrders(List<Order> orders) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'updateOrders');
		params.put('orders', orders);
		//return (void) icTestMockUtilities.Tracer.GetReturnValue(this, 'updateOrders');
	}
}