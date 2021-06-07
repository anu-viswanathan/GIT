public class icHandlerEagleViewReport implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		void onAfterUpdate(List<EagleView_Report__c> oldEVReport, List<EagleView_Report__c> newEVReport, Map<Id, EagleView_Report__c> evReportMap);
		
	}

	public class Impl implements IClass {
		
		icLogicEagleViewReport.IClass evLogic = (icLogicEagleViewReport.IClass) icObjectFactory.GetSingletonInstance('icLogicEagleViewReport');



		public void onAfterUpdate(List<EagleView_Report__c> oldEVReport, List<EagleView_Report__c> newEVReport, Map<Id, EagleView_Report__c> evReportMap) {
			for(EagleView_Report__c thisOldEVReport : oldEVReport) {
				EagleView_Report__c thisNewEVReport = evReportMap.get(thisOldEVReport.Id);
				if(thisOldEVReport.SubStatus__c != '19' && thisNewEVReport.SubStatus__c == '19') {
					evLogic.getEagleViewDownloadReportLink(thisNewEVReport);
				}
			}
		}
	}
}