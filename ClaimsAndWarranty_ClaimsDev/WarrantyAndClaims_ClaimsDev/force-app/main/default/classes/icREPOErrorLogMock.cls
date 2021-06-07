/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icREPOErrorLogMock implements icRepoErrorLog.IClass{

    public void createErrorLog(IMT_Invoice_Log__c newErrorLog) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createErrorLog');
        params.put('newErrorLog', newErrorLog);
    }

    public void createErrorLogs(List<IMT_Invoice_Log__c> newErrorLogs) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createErrorLogs');
        params.put('newErrorLogs', newErrorLogs);
    }
}