/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icLogicErrorLogMock implements icLogicErrorLog.IClass{

    public IMT_Invoice_Log__c generateErrorLog(String className, String methodName, String stackTrace, String errorMessage, String jsonObject){
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'generateErrorLog');
		params.put('className', className);
		params.put('methodName', methodName);
		params.put('stackTrace', stackTrace);
		params.put('errorMessage', errorMessage);
		params.put('jsonObject', jsonObject);
		return (IMT_Invoice_Log__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'generateErrorLog');
	}

	public IMT_Invoice_Log__c generateErrorLog(String projectName, String className, String methodName, String stackTrace, String errorMessage, String jsonObject){
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'generateErrorLog');
		params.put('projectName', projectName);
		params.put('className', className);
		params.put('methodName', methodName);
		params.put('stackTrace', stackTrace);
		params.put('errorMessage', errorMessage);
		params.put('jsonObject', jsonObject);
		return (IMT_Invoice_Log__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'generateErrorLog');
	}

	public String createErrorLog(String className, String methodName, String stackTrace, String errorMessage, String jsonObject){
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createErrorLog');
		params.put('className', className);
		params.put('methodName', methodName);
		params.put('stackTrace', stackTrace);
		params.put('errorMessage', errorMessage);
		params.put('jsonObject', jsonObject);
		return (String) icTestMockUtilities.Tracer.GetReturnValue(this, 'createErrorLog');
	}

	public String createErrorLog(String projectName, String className, String methodName, String stackTrace, String errorMessage, String jsonObject){
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createErrorLog');
		params.put('projectName', projectName);
		params.put('className', className);
		params.put('methodName', methodName);
		params.put('stackTrace', stackTrace);
		params.put('errorMessage', errorMessage);
		params.put('jsonObject', jsonObject);
		return (String) icTestMockUtilities.Tracer.GetReturnValue(this, 'createErrorLog');
	}

	public void createErrorLogs(List<IMT_Invoice_Log__c> newErrorLogs){
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createErrorLogs');
		params.put('newErrorLogs', newErrorLogs);
		//return (returnType) icTestMockUtilities.Tracer.GetReturnValue(this, 'createErrorLogs');
	}

	public void sendErrorByEmail(List<IMT_Invoice_Log__c> errors) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'sendErrorByEmail');
		params.put('errors', errors);
	}
}