@isTest
public with sharing class icTestTriggerAccount {

    public static testMethod void test_getPersonAcountInfoById(){
    	icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerAccount', new icHandlerAccountMock());

        Account newAccount = icTestHelperUtility.generateAccount();
        insert newAccount;
        update newAccount;
    }
}