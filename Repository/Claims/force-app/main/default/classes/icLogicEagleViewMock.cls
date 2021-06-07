/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icLogicEagleViewMock implements icLogicEagleViewReport.IClass{

    public EagleView_Report__c generateEagleViewReportFromOrderForm(icDTOEagleViewOrderForm orderForm) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'generateEagleViewReportFromOrderForm');
        params.put('orderForm', orderForm);
        return (EagleView_Report__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'generateEagleViewReportFromOrderForm');    }

    public EagleView_Report__c getEagleViewReportById(String recordId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getEagleViewReportById');
        params.put('recordId', recordId);
        return (EagleView_Report__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'getEagleViewReportById');    }

    public void getEagleViewDownloadReportLink(EagleView_Report__c evReport) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getEagleViewDownloadReportLink');
        params.put('evReport', evReport);
    }

    public void createEagleViewReport(EagleView_Report__c newReport) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createEagleViewReport');
        params.put('newReport', newReport);
    }

    public void updateEagleViewReport(EagleView_Report__c updateReport) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAPIConfigByName');
        params.put('updateReport', updateReport);
    }

    public void deleteEagleViewReport(EagleView_Report__c deleteReport) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'deleteEagleViewReport');
        params.put('deleteReport', deleteReport);
    }
}