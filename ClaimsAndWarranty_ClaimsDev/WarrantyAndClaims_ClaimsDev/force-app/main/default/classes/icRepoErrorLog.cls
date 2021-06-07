public class icRepoErrorLog implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		void createErrorLog(IMT_Invoice_Log__c newErrorLog);
		void createErrorLogs(List<IMT_Invoice_Log__c> newErrorLogs);
	}

	public class Impl implements IClass {

		public void createErrorLog(IMT_Invoice_Log__c newErrorLog) {
			insert newErrorLog;
		}

		public void createErrorLogs(List<IMT_Invoice_Log__c> newErrorLogs) {
			insert newErrorLogs;
			newErrorLogs = new List<IMT_Invoice_Log__c>();
		}
	}
}