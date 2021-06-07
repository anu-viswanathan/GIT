@isTest
public with sharing class icTestServiceCentralStation {

	public static testMethod void test_getShortUrlFromAccount() {
		Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());

		icServiceCentralStation.IClass csService = (icServiceCentralStation.IClass) icObjectFactory.GetSingletonInstance('icServiceCentralStation');

		String resultShortURL = csService.getShortUrl('contractorId', 'queueId');
	}

	public static testMethod void test_syncAccount() {
		Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());

		icServiceCentralStation.IClass csService = (icServiceCentralStation.IClass) icObjectFactory.GetSingletonInstance('icServiceCentralStation');

		Boolean resultShortURL = csService.syncAccount(icTestHelperUtility.getFakeId(Account.SObjectType), '');
	}
}