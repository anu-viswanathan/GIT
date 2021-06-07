@isTest
public class icRepoAccountMock implements icRepoAccount.IClass{

    public Account getAcountByHARefKey(String haRefKey) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAcountByHARefKey');
        params.put('haRefKey', haRefKey);
        return (Account) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAcountByHARefKey');
    }

    public List<Database.UpsertResult> upsertAccountsByExternalId(List<Account> sfAccounts, Schema.SObjectField externalId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'upsertAccountsByExternalId');
        params.put('sfAccounts', sfAccounts);
        params.put('externalId', externalId);
        return (List<Database.UpsertResult>) icTestMockUtilities.Tracer.GetReturnValue(this, 'upsertAccountsByExternalId');
    }

    public List<Database.SaveResult> insertAccounts(List<Account> sfAccounts) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'insertAccounts');
        params.put('sfAccounts', sfAccounts);
        return (List<Database.SaveResult>) icTestMockUtilities.Tracer.GetReturnValue(this, 'insertAccounts');
    }

    public Contact getPersonAcountInfoById(String recordId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getPersonAcountInfoById');
        params.put('recordId', recordId);
        return (Contact) icTestMockUtilities.Tracer.GetReturnValue(this, 'getPersonAcountInfoById');
    }

    public Account getAcountInfoById(String recordId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAcountInfoById');
        params.put('recordId', recordId);
        return (Account) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAcountInfoById');
    }

    public List<Account> getAcountsInfoByIds(List<Id> accountIds) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAcountsInfoByIds');
        params.put('accountIds', accountIds);
        return (List<Account>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAcountsInfoByIds');
    }

    public Account getContractorContactUsInfo(String customerId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getContractorContactUsInfo');
        params.put('customerId', customerId);
        return (Account) icTestMockUtilities.Tracer.GetReturnValue(this, 'getContractorContactUsInfo');
    }

    public List<Account> getContractorsWithExpiringFunds() {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getContractorsWithExpiringFunds');
        return (List<Account>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getContractorsWithExpiringFunds');
    }

    public Account saveAccount(Account record){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'saveAccount');
        params.put('record', record);
        return (Account) icTestMockUtilities.Tracer.GetReturnValue(this, 'saveAccount');
    }

    public List<Database.SaveResult> saveAccounts(List<Account> accounts) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'saveAccounts');
        params.put('accounts', accounts);
        return (List<Database.SaveResult>) icTestMockUtilities.Tracer.GetReturnValue(this, 'saveAccounts');
    }

    public List<Account> getAccountsByMapicsExternalId(Set<String> externalId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAccountsByMapicsExternalId');
        params.put('externalId', externalId);
        return (List<Account>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAccountsByMapicsExternalId');
    }
}