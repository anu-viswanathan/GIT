@RestResource(urlMapping='/evservice/OrderStatusUpdate')
global class icServiceEagleViewOrderStatusUpdate {

	//static icLogicHomeAdvisor.IClass haLogic = (icLogicHomeAdvisor.IClass) icObjectFactory.GetSingletonInstance('icLogicHomeAdvisor');	

	@HttpGet
	global static String doGet() {
		System.debug('--------- icServiceEagleViewOrderStatusUpdate doGet ---------');

		icLogicEagleViewReport.IClass evReportLogic = (icLogicEagleViewReport.IClass) icObjectFactory.GetSingletonInstance('icLogicEagleViewReport');

		try {
			Map<String, String> requestParams = RestContext.request.params;
			String statusId = requestParams.get('StatusId');
			String subStatusId = requestParams.get('SubStatusId');
			String sfRefId = requestParams.get('RefId');
			String evRefId = requestParams.get('ReportId');

			System.debug('statusId : ' + statusId);
			System.debug('subStatusId : ' + subStatusId);
			System.debug('sfRefId : ' + sfRefId);
			System.debug('evRefId : ' + evRefId);

			EagleView_Report__c updateReport = new EagleView_Report__c(Id = sfRefId
                ,Status__c = statusId
                ,SubStatus__c = subStatusId);
        	evReportLogic.updateEagleViewReport(updateReport);
		} catch (Exception ex) {
			icServiceErrorHandler.LogError('icServiceEagleViewOrderStatusUpdate', 'doGet', ex.getStackTraceString(), ex.getMessage(), '');
		}
		
		return 'Ok';
	}
}