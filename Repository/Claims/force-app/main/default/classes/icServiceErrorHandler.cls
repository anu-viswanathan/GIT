public class icServiceErrorHandler {
	private static icLogicErrorLog.IClass logic = (icLogicErrorLog.IClass) icObjectFactory.GetSingletonInstance('icLogicErrorLog');

	private static Map<String, List<IMT_Invoice_Log__c>> errorLogsByProcess {
		get{
			if(errorLogsByProcess == null) {
				errorLogsByProcess = new Map<String, List<IMT_Invoice_Log__c>>();
			}
			return errorLogsByProcess;
		}
		set;
	}

	private static Integer globalCount {
		get {
			if(globalCount == null) {
				globalCount = 1;
			} else {
				globalCount = globalCount + 1;
			}
			return globalCount;
		}
		set;
	}

	public static void StoreError(String processName, String className, String methodName, String stackTrace, String errorMessage, String jsonObject) {
		if(!errorLogsByProcess.containsKey(processName)){
			errorLogsByProcess.put(processName, new List<IMT_Invoice_Log__c>());
		}
		//logs.add(logic.generateErrorLog('',className, methodName + ' - ' + globalCount, stackTrace, errorMessage, jsonObject));
		errorLogsByProcess.get(processName).add(logic.generateErrorLog(className, methodName + ' - ' + globalCount, stackTrace, errorMessage, jsonObject));
	}

	public static void CommitErrors(String processName, Boolean sendByEmail) {

		if(errorLogsByProcess.containsKey(processName)){
			List<IMT_Invoice_Log__c> allLogs = errorLogsByProcess.get(processName);
		
			if(allLogs.size() > 0) {
				logic.createErrorLogs(allLogs);

				if(sendByEmail) {
					logic.sendErrorByEmail(allLogs);
				}

				//clear logs after commit
				errorLogsByProcess.put(processName, null);
			}
		}
	}

	public static IMT_Invoice_Log__c GenerateError(String className, String methodName, String stackTrace, String errorMessage, String jsonObject) {
		return GenerateError('', className, methodName, stackTrace, errorMessage, jsonObject);
	}
    public static IMT_Invoice_Log__c GenerateError(String projectName, String className, String methodName, String stackTrace, String errorMessage, String jsonObject) {
		return logic.generateErrorLog(projectName, className, methodName, stackTrace, errorMessage, jsonObject);
	}

	public static String LogError(String className, String methodName, String stackTrace, String errorMessage, String jsonObject) {
		return LogError('', className, methodName, stackTrace, errorMessage, jsonObject);
	}
    public static String LogError(String projectName, String className, String methodName, String stackTrace, String errorMessage, String jsonObject) {
		return logic.createErrorLog(projectName,className, methodName, stackTrace, errorMessage, jsonObject);
	}

	public static void LogErrors(List<IMT_Invoice_Log__c> errors) {
		logic.createErrorLogs(errors);
	}

	public static void sendErrorsByEmail(List<IMT_Invoice_Log__c> errors){
		logic.sendErrorByEmail(errors);
	}

	public static void handleDatabaseSaveResult(List<SObject> saveRecords, List<Database.SaveResult> saveResults, String className, String methodName) {
		Integer resultCounter = 0;
        List<IMT_Invoice_Log__c> errors = new List<IMT_Invoice_Log__c>();
        for(Database.SaveResult saveResult : saveResults) {
            if(!saveResult.isSuccess()) {
                SObject thisRecord = saveRecords.get(resultCounter);

                Database.Error[] saveErrors = saveResult.getErrors();
                String stackTrace = 'Errors:';
                for(Database.Error upsertError : saveErrors) {
                    stackTrace += '\r\n - ' + upsertError.getMessage();
                }

                errors.add(GenerateError(className, methodName, stackTrace, saveResult.getErrors()[0].getMessage(), JSON.serialize(thisRecord)));
            }
            resultCounter++;
        }
        LogErrors(errors);
	}

	public static void handleDatabaseSaveResult(String projectName, List<SObject> saveRecords, List<Database.SaveResult> saveResults, String className, String methodName) {
		Integer resultCounter = 0;
        List<IMT_Invoice_Log__c> errors = new List<IMT_Invoice_Log__c>();
        for(Database.SaveResult saveResult : saveResults) {
            if(!saveResult.isSuccess()) {
                SObject thisRecord = saveRecords.get(resultCounter);

                Database.Error[] saveErrors = saveResult.getErrors();
                String stackTrace = 'Errors:';
                for(Database.Error upsertError : saveErrors) {
                    stackTrace += '\r\n - ' + upsertError.getMessage();
                }

                errors.add(GenerateError(projectName, className, methodName, stackTrace, saveResult.getErrors()[0].getMessage(), JSON.serialize(thisRecord)));
            }
            resultCounter++;
        }
        LogErrors(errors);
	}
}