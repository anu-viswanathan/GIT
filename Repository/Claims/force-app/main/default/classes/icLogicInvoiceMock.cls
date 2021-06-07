/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icLogicInvoiceMock implements icLogicInvoice.IClass{

    public List<Invoice__c> getAllYDTInvoicesByAccountId(String recordId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAllYDTInvoicesByAccountId');
        params.put('recordId', recordId);
        return (List<Invoice__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAllYDTInvoicesByAccountId');
    }

    public List<Invoice__c> getAllInvoicesByAccountIdsAndRebateYear(List<String> recordIds, String rebateYear) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAllInvoicesByAccountIdsAndRebateYear');
        params.put('recordIds', recordIds);
        params.put('rebateYear', rebateYear);
        return (List<Invoice__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAllInvoicesByAccountIdsAndRebateYear');
    }

    public Map<String, List<Invoice__c>> getMapInvoicesByAccount(List<Invoice__c> invoices) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getMapInvoicesByAccount');
        params.put('invoices', invoices);
        return (Map<String, List<Invoice__c>>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getMapInvoicesByAccount');
    }

    public List<Contractor_Invoice__c> getUploadedInvoiceById(List<String> recordIds){
        Map<String, Object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getUploadedInvoiceById');
        params.put('recordIds', recordIds);
        return (List<Contractor_Invoice__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getUploadedInvoiceById');
    }

    public Double getSquaresFromInvoices(List<Invoice__c> invoices, Boolean isProrated, Date startDate) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getSquaresFromInvoices');
        params.put('invoices', invoices);
        params.put('isProrated', isProrated);
        params.put('startDate', startDate);
        return (Double) icTestMockUtilities.Tracer.GetReturnValue(this, 'getSquaresFromInvoices');
    }

    public Double getPro4RewardsFromInvoices(List<Invoice__c> invoices) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getPro4RewardsFromInvoices');
        params.put('invoices', invoices);
        return (Double) icTestMockUtilities.Tracer.GetReturnValue(this, 'getPro4RewardsFromInvoices');
    }

    public Double getCoopRewardsFromInvoices(List<Invoice__c> invoices) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getCoopRewardsFromInvoices');
        params.put('invoices', invoices);
        return (Double) icTestMockUtilities.Tracer.GetReturnValue(this, 'getCoopRewardsFromInvoices');
    }

    public Double getUpcomingCoopRewardsFromInvoices(List<Invoice__c> invoices) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getUpcomingCoopRewardsFromInvoices');
        params.put('invoices', invoices);
        return (Double) icTestMockUtilities.Tracer.GetReturnValue(this, 'getUpcomingCoopRewardsFromInvoices');
    }

    public List<Invoice__c> getAllYTDInvoicesByAccountId(String recordId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAllYTDInvoicesByAccountId');
        params.put('recordId', recordId);
        return (List<Invoice__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAllYTDInvoicesByAccountId');
    }

    public void updateInvoices(List<Contractor_Invoice__c> invoices) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'updateInvoices');
        params.put('invoices', invoices);
    }
}