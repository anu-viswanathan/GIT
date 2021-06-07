/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icTestREPOErrorLog {

    public static testMethod void test_createErrorLog(){
    	IMT_Invoice_Log__c newErrorLog = new IMT_Invoice_Log__c(
		Class_Name__c = 'className'
		,Method_Name__c = 'methodName'
		,Stack_Trace__c = 'stackTrace'
		,Error_Message__c = 'errorMessage'
		,JSON_Object__c = 'jsonObject');

		IMT_Invoice_Log__c newErrorLogForList = new IMT_Invoice_Log__c(
		Class_Name__c = 'className'
		,Method_Name__c = 'methodName'
		,Stack_Trace__c = 'stackTrace'
		,Error_Message__c = 'errorMessage'
		,JSON_Object__c = 'jsonObject');
		
		icRepoErrorLog.IClass repository = (icRepoErrorLog.IClass) icObjectFactory.GetSingletonInstance('icRepoErrorLog');
		repository.createErrorLog(newErrorLog);
		repository.createErrorLogs(new List<IMT_Invoice_Log__c>{newErrorLogForList});
    }

}