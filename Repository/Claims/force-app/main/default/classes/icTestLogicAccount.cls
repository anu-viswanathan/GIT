/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icTestLogicAccount {

    static void initTest() {

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerAccount', new icHandlerAccountMock());

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoAccount', new icRepoAccountMock());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoAccountMock', 'getPersonAcountInfoById', new Contact());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoAccountMock', 'getAcountInfoById', new Account());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoAccountMock', 'getAcountsInfoByIds', new List<Account>());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoAccountMock', 'getAcountByHARefKey', new Account());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoAccountMock', 'saveAccount', new Account());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoAccountMock', 'getContractorsWithExpiringFunds', new List<Account>());

        Account a = new Account();
        a.Owner = new User();
        a.OwnerId = icTestHelperUtility.getFakeId(User.SObjectType);
        icTestMockUtilities.Tracer.SetReturnValue('icRepoAccountMock', 'getContractorContactUsInfo', a);


        //icTestMockUtilities.Mocker.SetMockSingletonInstance('icMapAccount', new icMapAccountMock());
        //icTestMockUtilities.Tracer.SetReturnValue('icMapAccountMock', 'convertCustomerDTOToAccountWithRecordType', new Account());

    }

    public static testMethod void test_getPersonAcountInfoById(){

        initTest();

        icLogicAccount.IClass BL = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

        BL.getPersonAcountInfoById('');

    }

    public static testMethod void test_getAcountInfoById(){

        initTest();
        icLogicAccount.IClass BL = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

        BL.getAcountInfoById('');

    }


    public static testMethod void test_getAcountByHARefKey(){

        initTest();
        icLogicAccount.IClass BL = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

        BL.getAcountByHARefKey('');

    }

    public static testMethod void test_getContractorContactUsInfo(){

        initTest();
        icLogicAccount.IClass BL = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

        BL.getContractorContactUsInfo('');

    }

    public static testMethod void test_saveAccount(){

        initTest();
        icLogicAccount.IClass BL = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

        Account accountResult = BL.saveAccount(new Account());

    }

    public static testMethod void test_saveAccounts(){

        initTest();
        icLogicAccount.IClass BL = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

        List<Database.SaveResult> mockSaveResults = new List<Database.SaveResult>();
        Database.SaveResult mockSaveResult = (Database.SaveResult)JSON.deserialize('{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', Database.SaveResult.class);
        mockSaveResults.add(mockSaveResult);
        icTestMockUtilities.Tracer.SetReturnValue('icRepoAccountMock', 'saveAccounts', mockSaveResults);

        BL.saveAccounts(new List<Account> {new Account()});

    }

    public static testMethod void test_getContractorsWithExpiringFunds(){

        initTest();
        icLogicAccount.IClass BL = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

        BL.getContractorsWithExpiringFunds();

    }

     public static testMethod void test_updatePartnerAccountsByContactsIds(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerAccount', new icHandlerAccountMock());
        Account newAccount = icTestHelperUtility.generateAccount();
        insert newAccount;

        Contact newContact = new Contact();
        newContact.FirstName = 'test';
        newContact.LastName = 'cccc';
        newContact.AccountId = newAccount.Id;
        insert newContact;

        newAccount.Applicant_Information__c = newContact.Id;
        update newAccount;

        icLogicAccount.IClass BL = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

        BL.updatePartnerAccountsByContactsIds(new Set<Id> {newContact.Id});

    }

    public static testMethod void test_getAccountsByMapicsExternalId(){

        initTest();
        icLogicAccount.IClass BL = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

        List<Account> resultAccounts = BL.getAccountsByMapicsExternalId(new Set<String>{'id1', 'id2'});

    }

    public static testMethod void test_getMapAccountsByMapicsExternalId(){

        icLogicAccount.IClass BL = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

        List<Account> mockAccounts = new List<Account>();
        mockAccounts.add(new Account(Name='mockAccount', Mapics_ERP_ID__c='id1'));

        Map<String, Account> resultAccounts = BL.getMapAccountsByMapicsExternalId(mockAccounts);

    }

    @isTest
    static void testGetAccountsForCSSync(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerAccount', new icHandlerAccountMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoAccount', new icRepoAccountMock());

        icLogicAccount.IClass BL = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

        Account oldAccount = new Account();
        Account testAccount = new Account();
        testAccount.Id = icTestHelperUtility.getFakeId(Account.SObjectType);
        testAccount.Name = icTestHelperUtility.generateRandomString(10);
        testAccount.DBA_Account__c = icTestHelperUtility.generateRandomString(10);
        testAccount.Website = icTestHelperUtility.generateRandomString(10);
        //testAccount.Contractor_ID__c = icTestHelperUtility.getFakeId(Account.SObjectType);
        testAccount.IKOPRO_QueueID__c = icTestHelperUtility.getFakeId(Account.SObjectType);
        testAccount.Phone = icTestHelperUtility.generateRandomString(10);
        testAccount.Fax  = icTestHelperUtility.generateRandomString(10);
        testAccount.BillingStreet = icTestHelperUtility.generateRandomString(10);
        testAccount.BillingCity = icTestHelperUtility.generateRandomString(10);
        testAccount.BillingState = icTestHelperUtility.generateRandomString(10);
        testAccount.BillingPostalCode = icTestHelperUtility.generateRandomString(9);
        testAccount.BillingCountry = icTestHelperUtility.generateRandomString(10);
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('IKOPRO_Contractor').getRecordTypeId();
        //testAccount.Applicant_Information__r.Wants_To_Be_Listed_On_IKO_com__c = true;
        //testAccount.Tier_Prozone__c = icTestHelperUtility.generateRandomString(10);
        testAccount.Language_Preferences__c = icTestHelperUtility.generateRandomString(10);
        String jsonAccount = JSON.serialize(testAccount);
        jsonAccount = jsonAccount.substring(0, jsonAccount.length()-1);
        jsonAccount += ',"Tier_Prozone__c":"aTest"}';
        system.debug('jsonAccount ===> ' + jsonAccount);
        testAccount = (Account) JSON.deserialize(jsonAccount, Account.class);
        oldAccount = (Account) JSON.deserialize(jsonAccount, Account.class);

        oldAccount.Language_Preferences__c = 'TEST';

        List<Account> newAccounts = new List<Account>();
        List<Account> oldAccounts = new List<Account>();
        List<Account> accountsToSync = new List<Account>();

        newAccounts.add(testAccount);
        oldAccounts.add(oldAccount);

        icTestMockUtilities.Tracer.SetReturnValue('icRepoAccountMock', 'getAcountsInfoByIds', newAccounts);

        accountsToSync = BL.getAccountsForCSSync(newAccounts, oldAccounts);

    }

    public static testMethod void test_evaluateIsProratedYear() {
        icLogicAccount.IClass BL = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

        Date mockDate = Date.newInstance(2020, 03, 03);

        Account mockAccount = new Account(Name='mockAccount', IKOPRO_Approved_On__c = mockDate);

        Boolean bolResult = BL.evaluateIsProratedYear(mockAccount, mockDate.year());
    }

    @isTest
    static void test_serializeAccount(){

        icLogicAccount.IClass BL = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

        Account testAccount = new Account(Id = icTestHelperUtility.getFakeId(Account.SObjectType)
            ,Name = icTestHelperUtility.generateRandomString(10)
            ,DBA_Account__c = icTestHelperUtility.generateRandomString(10)
            ,Website = icTestHelperUtility.generateRandomString(10)
            ,IKOPRO_QueueID__c = icTestHelperUtility.getFakeId(Account.SObjectType)
            ,Phone = icTestHelperUtility.generateRandomString(10)
            ,Fax  = icTestHelperUtility.generateRandomString(10)
            ,BillingStreet = icTestHelperUtility.generateRandomString(10)
            ,BillingCity = icTestHelperUtility.generateRandomString(10)
            ,BillingState = icTestHelperUtility.generateRandomString(10)
            ,BillingPostalCode = icTestHelperUtility.generateRandomString(9)
            ,BillingCountry = icTestHelperUtility.generateRandomString(10)
            ,RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('IKOPRO_Contractor').getRecordTypeId()
            ,Language_Preferences__c = icTestHelperUtility.generateRandomString(10));

        String jsonAccount = BL.serializeAccount(testAccount);

    }
}