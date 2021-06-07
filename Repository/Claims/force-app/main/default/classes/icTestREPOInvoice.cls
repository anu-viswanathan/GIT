/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icTestREPOInvoice {

    public static testMethod void test_getAllInvoicesByAccountIdAndDate(){

        icRepoInvoice.IClass repository = (icRepoInvoice.IClass) icObjectFactory.GetSingletonInstance('icRepoInvoice');

        Account contractor = icTestHelperUtility.generateContractorAccount();
        insert contractor;

        Invoice__c i = new Invoice__c();

        i.Contractor__c = contractor.Id;
        i.Invoice_Year__c = '2011';

        insert i;

        repository.getAllInvoicesByAccountIdAndDate(contractor.Id,'2011');

    }

    public static testMethod void test_getAllInvoicesByAccountIdsAndRebateYear() {
        icRepoInvoice.IClass repository = (icRepoInvoice.IClass) icObjectFactory.GetSingletonInstance('icRepoInvoice');

        List<Invoice__c> result = repository.getAllInvoicesByAccountIdsAndRebateYear(new List<String> {'test'}, '2019');
    }

    public static testMethod void test_getUploadedInvoiceById() {
        icRepoInvoice.IClass repository = (icRepoInvoice.IClass) icObjectFactory.GetSingletonInstance('icRepoInvoice');

        List<Contractor_Invoice__c> result = repository.getUploadedInvoiceById(new List<String> {'test'});
    }

    public static testMethod void test_updateInvoices() {
        icRepoInvoice.IClass repository = (icRepoInvoice.IClass) icObjectFactory.GetSingletonInstance('icRepoInvoice');

        Contractor_Invoice__c newUploadedInvoice = new Contractor_Invoice__c(Uploaded_Files_Long__c = 'test');
        insert newUploadedInvoice;

        newUploadedInvoice.Uploaded_Files_Long__c = 'test,test';
        repository.updateInvoices(new List<Contractor_Invoice__c> {newUploadedInvoice});
    }

}