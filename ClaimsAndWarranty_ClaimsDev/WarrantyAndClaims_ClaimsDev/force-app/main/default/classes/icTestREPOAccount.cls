/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icTestREPOAccount {

    public static testMethod void test_getPersonAcountInfoById(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerAccount', new icHandlerAccountMock());

        Account newAccount = icTestHelperUtility.generateAccount();
        insert newAccount;

        Account newAccount2 = icTestHelperUtility.generateAccount();
        insert newAccount2;

        Contact newContact = new Contact();
        newContact.FirstName = 'test';
        newContact.LastName = 'cccc';
        newContact.AccountId = newAccount.Id;
        insert newContact;

        icRepoAccount.IClass repository = (icRepoAccount.IClass) icObjectFactory.GetSingletonInstance('icRepoAccount');

        repository.getPersonAcountInfoById(newAccount.Id);
        repository.getPersonAcountInfoById(newAccount2.Id);

    }

    public static testMethod void test_getAcountInfoById(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerAccount', new icHandlerAccountMock());

        Account newAccount = icTestHelperUtility.generateAccount();
        insert newAccount;

        icRepoAccount.IClass repository = (icRepoAccount.IClass) icObjectFactory.GetSingletonInstance('icRepoAccount');
        repository.getAcountInfoById(newAccount.Id);
        repository.getAcountInfoById(icTestHelperUtility.getFakeId(Account.SObjectType));

    }

    public static testMethod void test_getAcountInfoByIds(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerAccount', new icHandlerAccountMock());

        Account newAccount = icTestHelperUtility.generateAccount();
        insert newAccount;

        icRepoAccount.IClass repository = (icRepoAccount.IClass) icObjectFactory.GetSingletonInstance('icRepoAccount');
        List<Id> accountIds = new List<Id>();
        accountIds.add(newAccount.Id);
        repository.getAcountsInfoByIds(accountIds);

    }

    public static testMethod void test_getAcountByHARefKey(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerAccount', new icHandlerAccountMock());

        Account newAccount = icTestHelperUtility.generateAccount();
        newAccount.IKOPRO_QueueID__c = 'test';
        insert newAccount;

        icRepoAccount.IClass repository = (icRepoAccount.IClass) icObjectFactory.GetSingletonInstance('icRepoAccount');
        repository.getAcountByHARefKey('test');
        repository.getAcountByHARefKey('notfoundtest');

    }

    public static testMethod void test_getContractorContactUsInfo(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerAccount', new icHandlerAccountMock());

        Account newAccount = icTestHelperUtility.generateAccount();
        insert newAccount;

        icRepoAccount.IClass repository = (icRepoAccount.IClass) icObjectFactory.GetSingletonInstance('icRepoAccount');
        repository.getContractorContactUsInfo(newAccount.Id);
        repository.getContractorContactUsInfo(icTestHelperUtility.getFakeId(Account.SObjectType));

    }

    public static testMethod void test_getContractorsWithExpiringFunds(){
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerAccount', new icHandlerAccountMock());

        icRepoAccount.IClass repository = (icRepoAccount.IClass) icObjectFactory.GetSingletonInstance('icRepoAccount');
        List<Account> resultAccounts = repository.getContractorsWithExpiringFunds();
    }

    public static testMethod void test_saveAccount(){
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerAccount', new icHandlerAccountMock());

        icRepoAccount.IClass repository = (icRepoAccount.IClass) icObjectFactory.GetSingletonInstance('icRepoAccount');

        Account newAccount = repository.saveAccount(icTestHelperUtility.generateAccount());
    }

    public static testMethod void test_saveAccounts(){
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerAccount', new icHandlerAccountMock());

        icRepoAccount.IClass repository = (icRepoAccount.IClass) icObjectFactory.GetSingletonInstance('icRepoAccount');

        List<Database.SaveResult> results = repository.saveAccounts(new List<Account> {icTestHelperUtility.generateAccount()});
    }

    public static testMethod void test_getAccountsByMapicsExternalId(){
        icRepoAccount.IClass repository = (icRepoAccount.IClass) icObjectFactory.GetSingletonInstance('icRepoAccount');

        List<Account> results = repository.getAccountsByMapicsExternalId(new Set<String> {'id2', 'id2'});
    }
}