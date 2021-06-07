@RestResource(urlMapping='/evservice/FileDeliveryConfirmation')
global class icServiceEagleViewFileDeliveryConf {

	//static icLogicHomeAdvisor.IClass haLogic = (icLogicHomeAdvisor.IClass) icObjectFactory.GetSingletonInstance('icLogicHomeAdvisor');	

	@HttpGet
	global static String doGet() {
		System.debug('--------- icServiceEagleViewFileDeliveryConf doGet ---------');
		try {
			Map<String, String> requestParams = RestContext.request.params;
			String sfRefId = requestParams.get('RefId');
			String evRefId = requestParams.get('ReportId');

			System.debug('sfRefId : ' + sfRefId);
			System.debug('evRefId : ' + evRefId);

			//get DTO lead from request body
			//icDTOHALead haLead = haLogic.getHALeadFromJSON(requestBody);
			
			//if DTO is null; parsing error occured and logged already
			/*
			if(haLead != null) {
				Lead newLead = haLogic.getSFLeadFromHALead(haLead);
				
				//if Lead is null; mapping error occured and logged already
				if(newLead != null) {
					Account refCustomer = accountLogic.getAcountByHARefKey(haLead.crmKey);
					if(refCustomer != null) {
						newLead.Referred_Customer__c = refCustomer.Id;
					}
					
					haLogic.processHALead(newLead);				
				}			
			}
			*/
		} catch (Exception ex) {
			icServiceErrorHandler.LogError('icServiceEagleViewFileDeliveryConf', 'doGet', ex.getStackTraceString(), ex.getMessage(), '');
		}
		
		return 'Ok';
	}
}