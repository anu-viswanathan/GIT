public class icRepoEagleViewReport implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		EagleView_Report__c getEagleViewReportById(String recordId);
		void createEagleViewReport(EagleView_Report__c newReport);
		void updateEagleViewReport(EagleView_Report__c updateReport);
		void deleteEagleViewReport(EagleView_Report__c deleteReport);
	}

	public class Impl implements IClass {

		public EagleView_Report__c getEagleViewReportById(String recordId) {
			return [SELECT Id, Order_Id__c, Report_Id__c, Status__c, SubStatus__c FROM EagleView_Report__c WHERE Id = :recordId];
		}

		public void createEagleViewReport(EagleView_Report__c newReport) {
			insert newReport;
		}

		public void updateEagleViewReport(EagleView_Report__c updateReport) {
			update updateReport;
		}

		public void deleteEagleViewReport(EagleView_Report__c deleteReport) {
			delete deleteReport;
		}
	}
}