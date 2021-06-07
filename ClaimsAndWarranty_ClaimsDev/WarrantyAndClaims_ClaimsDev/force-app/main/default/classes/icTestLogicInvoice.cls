/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestLogicInvoice {
    static void initTest() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoInvoice', new icRepoInvoiceMock());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoInvoiceMock', 'getAllInvoicesByAccountIdAndDate', new List<Invoice__c>());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoInvoiceMock', 'getAllInvoicesByAccountIdsAndRebateYear', new List<Invoice__c>());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoInvoiceMock', 'getAcountInfoById', new Account());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoInvoiceMock', 'getAcountByHARefKey', new Account());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoInvoiceMock', 'getUploadedInvoiceById', new List<Contractor_Invoice__c>());

        //icTestMockUtilities.Mocker.SetMockSingletonInstance('icMapAccount', new icMapAccountMock());
        //icTestMockUtilities.Tracer.SetReturnValue('icMapAccountMock', 'convertCustomerDTOToAccountWithRecordType', new Account());

    }

    public static testMethod void test_getAllYTDInvoicesByAccountId(){
        initTest();
        icLogicInvoice.IClass BL = (icLogicInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicInvoice');

        BL.getAllYTDInvoicesByAccountId('');
    }

    public static testMethod void test_getAllInvoicesByAccountIdsAndRebateYear(){
        initTest();
        icLogicInvoice.IClass BL = (icLogicInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicInvoice');

        List<Invoice__c> testResult = BL.getAllInvoicesByAccountIdsAndRebateYear(new List<String>(), '2019');
    }

    public static testMethod void test_getMapInvoicesByAccount(){
        initTest();
        icLogicInvoice.IClass BL = (icLogicInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicInvoice');

        List<Invoice__c> invoices = new List<Invoice__c>();
        Invoice__c newInvoice = new Invoice__c(Contractor__c = icTestHelperUtility.getFakeId(Account.SObjectType));
        invoices.add(newInvoice);

        Map<String, List<Invoice__c>> testResult = BL.getMapInvoicesByAccount(invoices);
    }

    public static testMethod void test_getSquaresFromInvoices(){
        initTest();
        icLogicInvoice.IClass BL = (icLogicInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicInvoice');

        BL.getSquaresFromInvoices(new List<Invoice__c>(), false, Date.today());
    }


    public static testMethod void test_getPro4RewardsFromInvoices(){
        initTest();
        icLogicInvoice.IClass BL = (icLogicInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicInvoice');

        BL.getPro4RewardsFromInvoices(new List<Invoice__c>());

    }
    
    public static testMethod void test_getUpcomingCoopRewardsFromInvoices(){
        initTest();
        icLogicInvoice.IClass BL = (icLogicInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicInvoice');

        BL.getUpcomingCoopRewardsFromInvoices(new List<Invoice__c>{new Invoice__c(Coop_Amount__c = 10)});

    }

    public static testMethod void test_getCoopRewardsFromInvoices(){
        initTest();
        icLogicInvoice.IClass BL = (icLogicInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicInvoice');

        BL.getCoopRewardsFromInvoices(new List<Invoice__c> {new Invoice__c()});

    }

    public static testMethod void test_getUploadedInvoiceById(){
        initTest();
        icLogicInvoice.IClass BL = (icLogicInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicInvoice');

        List<Contractor_Invoice__c> result = BL.getUploadedInvoiceById(new List<String> {'test'});

    }

     public static testMethod void test_updateInvoices(){
        initTest();
        icLogicInvoice.IClass BL = (icLogicInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicInvoice');

        BL.updateInvoices(new List<Contractor_Invoice__c>());

    }


}