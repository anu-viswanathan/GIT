public with sharing class icQueueableSaveResultHandler implements Queueable {

	public icLogicErrorLog.IClass errorLogic = (icLogicErrorLog.IClass) icObjectFactory.GetSingletonInstance('icLogicErrorLog');
	
	public List<Database.SaveResult> saveResults {get;set;}
	public List<Order> orders {get;set;}

	public icQueueableSaveResultHandler(List<Database.SaveResult> saveResults, List<Order> orders) {
		this.saveResults = saveResults;
		this.orders = orders;
	}

	public void execute(QueueableContext context) {
		try {
			Integer resultCounter = 0;
            List<IMT_Invoice_Log__c> errors = new List<IMT_Invoice_Log__c>();
            for(Database.SaveResult saveResult : saveResults) {
                if(!saveResult.isSuccess()) {
                    Order thisRecord = orders.get(resultCounter);

                    Database.Error[] saveErrors = saveResult.getErrors();
                    String stackTrace = 'Errors:';
                    for(Database.Error upsertError : saveErrors) {
                        stackTrace += '\r\n - ' + upsertError.getMessage();
                    }

                    errors.add(errorLogic.generateErrorLog('icQueueableSaveResultHandler', 'execute', stackTrace, saveResult.getErrors()[0].getMessage(), JSON.serialize(thisRecord)));
                }
                resultCounter++;
            }
            errorLogic.createErrorLogs(errors);
		} catch(Exception ex) {
			errorLogic.createErrorLog('icServiceGPSData', 'doPost', ex.getStackTraceString(), ex.getMessage(), '');
		}
	}
}