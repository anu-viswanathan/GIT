public class icLogicErrorLog implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		IMT_Invoice_Log__c generateErrorLog(String className, String methodName, String stackTrace, String errorMessage, String jsonObject);
        IMT_Invoice_Log__c generateErrorLog(String projectName, String className, String methodName, String stackTrace, String errorMessage, String jsonObject);
		String createErrorLog(String className, String methodName, String stackTrace, String errorMessage, String jsonObject);
        String createErrorLog(String projectName, String className, String methodName, String stackTrace, String errorMessage, String jsonObject);
		void createErrorLogs(List<IMT_Invoice_Log__c> newErrorLogs);
		void sendErrorByEmail(List<IMT_Invoice_Log__c> errors);
	}

	public class Impl implements IClass {

		icRepoErrorLog.IClass repo = (icRepoErrorLog.IClass) icObjectFactory.GetSingletonInstance('icRepoErrorLog');

		public IMT_Invoice_Log__c generateErrorLog(String className, String methodName, String stackTrace, String errorMessage, String jsonObject) {
			if(errorMessage.length() > 254) {
				errorMessage = errorMessage.left(254);
			}

			IMT_Invoice_Log__c newErrorLog = new IMT_Invoice_Log__c(
				Class_Name__c = className
				,Method_Name__c = methodName
				,Stack_Trace__c = stackTrace
				,Error_Message__c = errorMessage
				,JSON_Object__c = jsonObject);

			return newErrorLog;
		}
        
        public IMT_Invoice_Log__c generateErrorLog(String projectName,String className, String methodName, String stackTrace, String errorMessage, String jsonObject) {
			if(errorMessage.length() > 254) {
				errorMessage = errorMessage.left(254);
			}

			IMT_Invoice_Log__c newErrorLog = new IMT_Invoice_Log__c(
                Project_Name__c	= projectName
				,Class_Name__c = className
				,Method_Name__c = methodName
				,Stack_Trace__c = stackTrace
				,Error_Message__c = errorMessage
				,JSON_Object__c = jsonObject);

			return newErrorLog;
		}

		public String createErrorLog(String className, String methodName, String stackTrace, String errorMessage, String jsonObject) {
			IMT_Invoice_Log__c newErrorLog = generateErrorLog(className, methodName, stackTrace, errorMessage, jsonObject);			
			repo.createErrorLog(newErrorLog);
			return newErrorLog.Id;
		}
        public String createErrorLog(String projectName,String className, String methodName, String stackTrace, String errorMessage, String jsonObject) {
			IMT_Invoice_Log__c newErrorLog = generateErrorLog(projectName, className, methodName, stackTrace, errorMessage, jsonObject);			
			repo.createErrorLog(newErrorLog);
			return newErrorLog.Id;
		}

		public void createErrorLogs(List<IMT_Invoice_Log__c> newErrorLogs) {
			repo.createErrorLogs(newErrorLogs);
		}

		public void sendErrorByEmail(List<IMT_Invoice_Log__c> errors) {

			String messageBody;
			Messaging.SingleEmailMessage errorEmail = new Messaging.SingleEmailMessage();
			List<String> toAddresses = new List<String>();
			toAddresses.add(Label.Error_Email_Address);

			errorEmail.setToAddresses(toAddresses);
			errorEmail.setSubject('Salesforce Error');

			messageBody = 'The following error(s) occurred: \n\n';

			for(IMT_Invoice_Log__c currentError : errors){

				messageBody += 'Class Name: ' + currentError.Class_Name__c + '\n';
				messageBody += 'Method Name: ' + currentError.Method_Name__c + '\n';
				messageBody += 'Stack Trace: ' + currentError.Stack_Trace__c + '\n';
				messageBody += 'Error Message: ' + currentError.Error_Message__c + '\n';
				messageBody += 'JSON: ' + currentError.JSON_Object__c + '\n\n';

			}

			errorEmail.setPlainTextBody(messageBody);
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] {errorEmail});
		}
	}
}