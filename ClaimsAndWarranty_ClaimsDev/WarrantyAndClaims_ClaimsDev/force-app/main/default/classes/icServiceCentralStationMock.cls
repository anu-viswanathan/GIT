@isTest
public with sharing class icServiceCentralStationMock implements icServiceCentralStation.IClass {

	public String getShortUrl(String contractorId, String queueId) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getShortUrl');
		params.put('contractorId', contractorId);
		params.put('queueId', queueId);
		return (String) icTestMockUtilities.Tracer.GetReturnValue(this, 'getShortUrl');
	}

	public Boolean syncAccount(String accountId, String payload) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'syncAccount');
		params.put('accountId', accountId);
		params.put('payload', payload);
		return (Boolean) icTestMockUtilities.Tracer.GetReturnValue(this, 'syncAccount');
	}
}