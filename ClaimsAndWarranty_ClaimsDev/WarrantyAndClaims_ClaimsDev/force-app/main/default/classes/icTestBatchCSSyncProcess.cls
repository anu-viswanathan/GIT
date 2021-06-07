@isTest
public with sharing class icTestBatchCSSyncProcess {

	static testMethod void test_BatchCSSyncProcess() {
		icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerAccount', new icHandlerAccountMock());
		icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicAccount', new icLogicAccountMock());
		icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountMock', 'serializeAccount', '');

		Account csSync = new Account(Name = 'CS_Sync'
			,BillingPostalCode = 'h0h 0h0'
			,CS_Sync_Required__c = true);
		insert csSync;

		icBatchCSSyncProcess batchClass = new icBatchCSSyncProcess();
		Database.executebatch(batchClass, 1);
	}
}