@RestResource(urlMapping='/haservice/*')
global class icServiceHomeAdvisor {

	static icLogicHomeAdvisor.IClass haLogic = (icLogicHomeAdvisor.IClass) icObjectFactory.GetSingletonInstance('icLogicHomeAdvisor');
	static icLogicAccount.IClass accountLogic = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

	@HttpPost
	global static String doPost() {
		System.debug('--------- icServiceHomeAdvisor doPost ---------');
		
		String requestBody;
		try {
			//Get request body (JSON)
			requestBody = RestContext.request.requestBody.toString();

			//get DTO lead from request body
			icDTOHALead haLead = haLogic.getHALeadFromJSON(requestBody);
			
			//if DTO is null; parsing error occured and logged already
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
		} catch (Exception ex) {
			icServiceErrorHandler.LogError('icServiceHomeAdvisor', 'doPost', ex.getStackTraceString(), ex.getMessage(), requestBody);
		}
		
		return 'Lead processed Successfully!';
	}
}