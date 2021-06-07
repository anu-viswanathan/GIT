/**
 * Created by Francois Poirier on 2019-11-14.
 */

@isTest
public with sharing class icTestHandlerAccount {

    @isTest
    static void testAfterInsert(){

        test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicAccount', new icLogicAccountMock());
        icHandlerAccount.IClass handler = (icHandlerAccount.IClass) icObjectFactory.GetSingletonInstance('icHandlerAccount');


        List<Account> oldAccounts = new List<Account>();
        List<Account> newAccounts = new List<Account>();

        Account testAccount = new Account();
        testAccount.Admin_Email_Address__c = icTestHelperUtility.generateRandomString(10);
        testAccount.BillingStreet = icTestHelperUtility.generateRandomString(15);
        testAccount.DBA_Account__c = icTestHelperUtility.generateRandomString(10);
        testAccount.Website = icTestHelperUtility.generateRandomString(10);
        testAccount.Fax = icTestHelperUtility.generateRandomString(10);
        testAccount.Language_Preferences__c = icTestHelperUtility.generateRandomString(10);

        newAccounts.add(testAccount);

        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountMock', 'getAccountsForCSSync', newAccounts);

        handler.onAfterInsert(newAccounts, new Map<Id, Account>());


    }

    @isTest
    static void testAfterUpdate(){

        test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicAccount', new icLogicAccountMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoOrder', new icRepoOrderMock());
        icHandlerAccount.IClass handler = (icHandlerAccount.IClass) icObjectFactory.GetSingletonInstance('icHandlerAccount');

        List<Account> oldAccounts = new List<Account>();
        List<Account> newAccounts = new List<Account>();
        Map<Id, Account> oldAccountMap = new Map<Id, Account>();

        String mockAccountId = icTestHelperUtility.getFakeId(Account.SObjectType);

        Account newAccountMock = new Account();
        newAccountMock.Id = mockAccountId;
        newAccountMock.Admin_Email_Address__c = icTestHelperUtility.generateRandomString(10);
        newAccountMock.BillingStreet = icTestHelperUtility.generateRandomString(15);
        newAccountMock.DBA_Account__c = icTestHelperUtility.generateRandomString(10);
        newAccountMock.Website = icTestHelperUtility.generateRandomString(10);
        newAccountMock.Fax = icTestHelperUtility.generateRandomString(10);
        newAccountMock.Name = 'test';
        newAccountMock.Language_Preferences__c = icTestHelperUtility.generateRandomString(10);
        newAccountMock.MAPICS_ERP_ID__c = '12345678';
        newAccounts.add(newAccountMock);

        Account oldAccountMock = new Account();
        oldAccountMock.Id = mockAccountId;
        oldAccountMock.Admin_Email_Address__c = icTestHelperUtility.generateRandomString(10);
        oldAccountMock.BillingStreet = icTestHelperUtility.generateRandomString(15);
        oldAccountMock.DBA_Account__c = icTestHelperUtility.generateRandomString(10);
        oldAccountMock.Website = icTestHelperUtility.generateRandomString(10);
        oldAccountMock.Fax = icTestHelperUtility.generateRandomString(10);
        oldAccountMock.Name = 'test';
        oldAccountMock.Language_Preferences__c = icTestHelperUtility.generateRandomString(10);
        oldAccountMock.MAPICS_ERP_ID__c = null;
        oldAccounts.add(oldAccountMock);
        oldAccountMap.put(mockAccountId, oldAccountMock);

        Order orderObj = new Order ();
        orderObj.Customer_Number_Mapics__c = '12345678';
        orderObj.EffectiveDate = System.today();
        orderObj.Status = 'Draft';
        
        Map<String, Account> recordsMap = new Map<String, Account>();
        recordsMap.put('12345678', newAccountMock);
        
        icTestMockUtilities.Tracer.SetReturnValue('icRepoOrderMock', 'getOrdersByMapicIds', new List<Order>{orderObj});
        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountMock', 'getMapAccountsByMapicsExternalId', recordsMap);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountMock', 'getAccountsForCSSync', newAccounts);
        handler.onAfterUpdate(oldAccounts, newAccounts, oldAccountMap);
    }

    @isTest
    static void testBeforeUpdate(){

        test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicAccount', new icLogicAccountMock());

        icHandlerAccount.IClass handler = (icHandlerAccount.IClass) icObjectFactory.GetSingletonInstance('icHandlerAccount');

        List<Account> oldAccounts = new List<Account>();
        List<Account> newAccounts = new List<Account>();

        Account testAccount = new Account();
        testAccount.Admin_Email_Address__c = icTestHelperUtility.generateRandomString(10);
        testAccount.BillingStreet = icTestHelperUtility.generateRandomString(15);
        testAccount.DBA_Account__c = icTestHelperUtility.generateRandomString(10);
        testAccount.Website = icTestHelperUtility.generateRandomString(10);
        testAccount.Fax = icTestHelperUtility.generateRandomString(10);
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('IKOPRO_Contractor').getRecordTypeId();
        testAccount.Language_Preferences__c = icTestHelperUtility.generateRandomString(10);
        newAccounts.add(testAccount);

        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountMock', 'getAccountsForCSSync', newAccounts);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountMock', 'hasKeyFieldsChangedForCSSync', TRUE);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountMock', 'hasAllRequiredFieldsForCSSync', TRUE);

        handler.onBeforeUpdate(oldAccounts, newAccounts, new Map<Id, Account>());


    }
}