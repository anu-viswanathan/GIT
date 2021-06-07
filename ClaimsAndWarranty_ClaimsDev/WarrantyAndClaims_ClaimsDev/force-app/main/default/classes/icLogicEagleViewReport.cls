public class icLogicEagleViewReport implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		EagleView_Report__c generateEagleViewReportFromOrderForm(icDTOEagleViewOrderForm orderForm);
		EagleView_Report__c getEagleViewReportById(String recordId);
		void getEagleViewDownloadReportLink(EagleView_Report__c evReport);
		void createEagleViewReport(EagleView_Report__c newReport);
		void updateEagleViewReport(EagleView_Report__c updateReport);
		void deleteEagleViewReport(EagleView_Report__c deleteReport);
	}

	public class Impl implements IClass {

		icRepoEagleViewReport.IClass repo = (icRepoEagleViewReport.IClass) icObjectFactory.GetSingletonInstance('icRepoEagleViewReport');		

		public EagleView_Report__c generateEagleViewReportFromOrderForm(icDTOEagleViewOrderForm orderForm) {
			EagleView_Report__c returnEVReport = new EagleView_Report__c(Status__c = '1'
				,SubStatus__c = '1'
				,Street_Address__c = orderForm.streetAddress
				,City__c = orderForm.city
				,State_Province__c = orderForm.state
				,Zip_Postal_Code__c = orderForm.postalCode
				,Country__c = orderForm.country
				,Property_Type__c = String.valueOf(orderForm.propertyType)
				,Product__c = orderForm.product.name
				,Delivery__c = orderForm.delivery.name
				,Measurement_Type__c = String.valueOf(orderForm.measurementType)
				,Special_Instructions__c = orderForm.specialInstructions
				,Changes_in_the_last_4_years__c = orderForm.changesInLast4Years);
			return returnEVReport;
		}

		public EagleView_Report__c getEagleViewReportById(String recordId) {
			return repo.getEagleViewReportById(recordId);
		}

		public void getEagleViewDownloadReportLink(EagleView_Report__c evReport) {
			getDownloadLink(evReport.Id, evReport.Account__c, evReport.Report_Id__c);
		}

		public void createEagleViewReport(EagleView_Report__c newReport) {
			repo.createEagleViewReport(newReport);
		}

		public void updateEagleViewReport(EagleView_Report__c updateReport) {
			repo.updateEagleViewReport(updateReport);
		}

		public void deleteEagleViewReport(EagleView_Report__c deleteReport) {
			repo.deleteEagleViewReport(deleteReport);
		}
	}

	@future(callout=true)
	private static void getDownloadLink(String sfReportId, String accountId, String evReportId) {
		icBLeagleView.IClass evService = (icBLeagleView.IClass) icObjectFactory.GetSingletonInstance('icBLeagleView');
		icLogicSubscription.IClass logicSubscription = (icLogicSubscription.IClass) icObjectFactory.GetSingletonInstance('icLogicSubscription');
		icRepoEagleViewReport.IClass repo = (icRepoEagleViewReport.IClass) icObjectFactory.GetSingletonInstance('icRepoEagleViewReport');		

		List<IKOPRO_Contractor_Subscription__c> customerSubscriptions = logicSubscription.getEagleViewSubscriptionForCustomer(accountId);

		if(customerSubscriptions.size() == 1) {
			IKOPRO_Contractor_Subscription__c eagleViewSubsciption = customerSubscriptions[0];
			String reportDownalodLink = evService.getDownloadLink(evReportId);

			EagleView_Report__c updateReport = new EagleView_Report__c(Id = sfReportId, Download_Link__c = reportDownalodLink);
			repo.updateEagleViewReport(updateReport);
        }
    }
}