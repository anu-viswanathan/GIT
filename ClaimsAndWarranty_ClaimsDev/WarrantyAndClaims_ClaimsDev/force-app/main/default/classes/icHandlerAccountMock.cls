@isTest
public with sharing class icHandlerAccountMock implements icHandlerAccount.IClass{

	public void onAfterUpdate(List<Account> oldAccounts, List<Account> newAccounts, Map<Id, Account> accountsMap) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onAfterUpdate');
		params.put('oldAccounts', oldAccounts);
		params.put('newAccounts', newAccounts);
		params.put('accountsMap', accountsMap);
		//return (void) icTestMockUtilities.Tracer.GetReturnValue(this, 'onAfterUpdate');
	}

	public void onAfterInsert(List<Account> newAccounts, Map<Id, Account> accountsMap) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onAfterInsert');
		params.put('newAccounts', newAccounts);
		params.put('accountsMap', accountsMap);
	}
	
	public void onBeforeUpdate(List<Account> oldAccounts, List<Account> newAccounts, Map<Id, Account> accountsMap) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onBeforeUpdate');
		params.put('oldAccounts', oldAccounts);
		params.put('newAccounts', newAccounts);
		params.put('accountsMap', accountsMap);
	}
}