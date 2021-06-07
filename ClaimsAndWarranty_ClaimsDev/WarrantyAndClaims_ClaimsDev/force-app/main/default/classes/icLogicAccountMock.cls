/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icLogicAccountMock implements icLogicAccount.IClass{

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

    public Account getAcountByHARefKey(String haRefKey) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAcountByHARefKey');
        params.put('haRefKey', haRefKey);
        return (Account) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAcountByHARefKey');
    }

    public icDTOContactUs getContractorContactUsInfo(String customerId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getContractorContactUsInfo');
        params.put('customerId', customerId);
        return (icDTOContactUs) icTestMockUtilities.Tracer.GetReturnValue(this, 'getContractorContactUsInfo');
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

    public void saveAccounts(List<Account> accounts) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'saveAccounts');
        params.put('accounts', accounts);
        //return (castType) icTestMockUtilities.Tracer.GetReturnValue(this, 'saveAccounts');
    }

    public void updatePartnerAccountsByContactsIds(Set<Id> contactIds) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'updatePartnerAccountsByContactsIds');
        params.put('contactIds', contactIds);
        //return (castType) icTestMockUtilities.Tracer.GetReturnValue(this, 'updatePartnerAccountsByContactsIds');
    }

    public List<Account> getAccountsByMapicsExternalId(Set<String> externalId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAccountsByMapicsExternalId');
        params.put('externalId', externalId);
        return (List<Account>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAccountsByMapicsExternalId');
    }
     
    public Map<String, Account> getMapAccountsByMapicsExternalId(List<Account> accounts) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getMapAccountsByMapicsExternalId');
        params.put('accounts', accounts);
        return (Map<String, Account>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getMapAccountsByMapicsExternalId');
    }

    public Boolean hasAllRequiredFieldsForCSSync(Account thisAccount) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'hasAllRequiredFieldsForCSSync');
        params.put('thisAccount', thisAccount);
        return (Boolean) icTestMockUtilities.Tracer.GetReturnValue(this, 'hasAllRequiredFieldsForCSSync');
    }

    public Boolean hasKeyFieldsChangedForCSSync(Account newAccount, Account oldAccount) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'hasKeyFieldsChangedForCSSync');
        params.put('newAccount', newAccount);
        params.put('oldAccount', oldAccount);
        return (Boolean) icTestMockUtilities.Tracer.GetReturnValue(this, 'hasKeyFieldsChangedForCSSync');
    }

    public List<Account> getAccountsForCSSync(List<Account> newAccounts, List<Account> oldAccounts) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAccountsForCSSync');
        params.put('newAccounts', newAccounts);
        params.put('oldAccounts', oldAccounts);
        return (List<Account>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAccountsForCSSync');
    }

    public Boolean evaluateIsProratedYear(Account objAccount, Integer intYear) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'evaluateIsProratedYear');
        params.put('objAccount', objAccount);
        params.put('intYear', intYear);
        return (Boolean) icTestMockUtilities.Tracer.GetReturnValue(this, 'evaluateIsProratedYear');
    }

    public void sendEmailRequiredFieldsAlert(Account objAccount) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'sendEmailRequiredFieldsAlert');
        params.put('objAccount', objAccount);
    }

    public String serializeAccount(Account accountToSync) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'serializeAccount');
        params.put('accountToSync', accountToSync);
        return (String) icTestMockUtilities.Tracer.GetReturnValue(this, 'serializeAccount');
    }
}