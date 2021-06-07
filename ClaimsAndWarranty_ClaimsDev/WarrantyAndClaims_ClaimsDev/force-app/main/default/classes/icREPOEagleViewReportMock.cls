/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icREPOEagleViewReportMock implements icRepoEagleViewReport.IClass{

    public EagleView_Report__c getEagleViewReportById(String recordId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getEagleViewReportById');
        params.put('recordId', recordId);
        return (EagleView_Report__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'getEagleViewReportById');
    }

    public void createEagleViewReport(EagleView_Report__c newReport) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createEagleViewReport');
        params.put('newReport', newReport);
    }

    public void updateEagleViewReport(EagleView_Report__c updateReport) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'updateEagleViewReport');
        params.put('updateReport', updateReport);
    }

    public void deleteEagleViewReport(EagleView_Report__c deleteReport) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'deleteEagleViewReport');
        params.put('deleteReport', deleteReport);
    }
}