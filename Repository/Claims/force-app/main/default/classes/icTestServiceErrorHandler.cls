/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestServiceErrorHandler {

    public static void initTest() {
		icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicErrorLog', new icLogicErrorLogMock());		
	}

	static testMethod void test_StoreCommitError() {
		initTest();

		icServiceErrorHandler.StoreError('processName', 'className', 'methodName', 'stackTrace', 'errorMessage', 'jsonObject');	
		icServiceErrorHandler.CommitErrors('processName', true);
	}

	static testMethod void test_generateErrorLog() {
		initTest();

		icServiceErrorHandler.GenerateError('className', 'methodName', 'stackTrace', 'errorMessage', 'jsonObject');
	}

	static testMethod void test_generateErrorLog_withProjectName() {
		initTest();

		icServiceErrorHandler.GenerateError('projectName', 'className', 'methodName', 'stackTrace', 'errorMessage', 'jsonObject');
	}
	
	static testMethod void test_createErrorLog() {
		initTest();

		icServiceErrorHandler.LogError('className', 'methodName', 'stackTrace', 'errorMessage', 'jsonObject');
	}

	static testMethod void test_createErrorLog_withProjectName() {
		initTest();

		icServiceErrorHandler.LogError('projectName', 'className', 'methodName', 'stackTrace', 'errorMessage', 'jsonObject');
	}

	static testMethod void test_createErrorLogs() {
		initTest();

		icServiceErrorHandler.LogErrors(new List<IMT_Invoice_Log__c>());
	}

	static testMethod void test_sendErrorsByEmail() {
		initTest();

		icServiceErrorHandler.sendErrorsByEmail(new List<IMT_Invoice_Log__c>());
	}

	static testMethod void test_handleDatabaseSaveResult() {
		initTest();

		List<Database.SaveResult> mockSaveResults = new List<Database.SaveResult>();
        Database.SaveResult mockSaveResult = (Database.SaveResult)JSON.deserialize('{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', Database.SaveResult.class);
        mockSaveResults.add(mockSaveResult);
        
        icServiceErrorHandler.handleDatabaseSaveResult(new List<SObject> {new Account()}, mockSaveResults, 'className', 'methodName');
	}

	static testMethod void test_handleDatabaseSaveResult_withProjectName() {
		initTest();

		List<Database.SaveResult> mockSaveResults = new List<Database.SaveResult>();
        Database.SaveResult mockSaveResult = (Database.SaveResult)JSON.deserialize('{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', Database.SaveResult.class);
        mockSaveResults.add(mockSaveResult);
        
        icServiceErrorHandler.handleDatabaseSaveResult('projectName', new List<SObject> {new Account()}, mockSaveResults, 'className', 'methodName');
	}
}