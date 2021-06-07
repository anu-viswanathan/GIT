/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icREPOInvoiceMock implements icRepoInvoice.IClass{

    public List<Invoice__c> getAllInvoicesByAccountIdAndDate(String recordId, String strYear) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAllInvoicesByAccountIdAndDate');
        params.put('recordId', recordId);
        params.put('strYear', strYear);
        return (List<Invoice__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAllInvoicesByAccountIdAndDate');
    }

    public List<Invoice__c> getAllInvoicesByAccountIdsAndRebateYear(List<String> recordIds, String rebateYear) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAllInvoicesByAccountIdsAndRebateYear');
        params.put('recordIds', recordIds);
        params.put('rebateYear', rebateYear);
        return (List<Invoice__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAllInvoicesByAccountIdsAndRebateYear');
    }

    public List<Contractor_Invoice__c> getUploadedInvoiceById(List<String> recordIds) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getUploadedInvoiceById');
        params.put('recordIds', recordIds);
        return (List<Contractor_Invoice__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getUploadedInvoiceById');
    }

    public void updateInvoices(List<Contractor_Invoice__c> invoices) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'updateInvoices');
        params.put('invoices', invoices);
        //return (void) icTestMockUtilities.Tracer.GetReturnValue(this, 'updateInvoices');
    }

}