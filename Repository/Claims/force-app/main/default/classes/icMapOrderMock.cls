@isTest
public with sharing class icMapOrderMock implements icMapOrder.IClass{

	public Order getSFOrderFromDTOMapicsData(icDTOMapicsData mapicsData, Account account, String orderRecordType) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getSFOrderFromDTOMapicsData');
		params.put('mapicsData', mapicsData);
		params.put('account', account);
		params.put('orderRecordType', orderRecordType);
		return (Order) icTestMockUtilities.Tracer.GetReturnValue(this, 'getSFOrderFromDTOMapicsData');
	}
}