@RestResource(urlMapping='/mapics/*')
global class icServiceGPSData {

	static icLogicOrder.IClass orderLogic = (icLogicOrder.IClass) icObjectFactory.GetSingletonInstance('icLogicOrder');
	static icLogicAccount.IClass accountLogic = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

	@HttpPost
	global static String doPost() {
		//System.debug('--------- icServiceGPSData doPost ---------');
		
		String requestBody;
		try {
			//Get request body (JSON)
			//System.debug('CPU Limit : ' + Limits.getLimitCpuTime());

			requestBody = RestContext.request.requestBody.toString();
			//System.debug('get request : ' + Limits.getCpuTime());

			List<icDTOMapicsData> mapicsData = orderLogic.getOrderDTOFromMapicsPayload(requestBody);
			//System.debug('parse to DTOs : ' + Limits.getCpuTime());

			Set<String> mapicsExternalAccountIds = orderLogic.getListExternalAccountIdsFromMapicsData(mapicsData);
			//System.debug('get unique id : ' + Limits.getCpuTime());

			List<Account> accounts = accountLogic.getAccountsByMapicsExternalId(mapicsExternalAccountIds);
			//System.debug('get accounts : ' + Limits.getCpuTime());

			Map<String, Account> mapAccountsByMapicsExternalId = accountLogic.getMapAccountsByMapicsExternalId(accounts);
			//System.debug('get map : ' + Limits.getCpuTime());

			List<Order>  newOrders = orderLogic.getOrdersFromListMapicsData(mapicsData, mapAccountsByMapicsExternalId);
			//System.debug('get orders : ' + Limits.getCpuTime());

			orderLogic.saveOrders(newOrders);
			//System.debug('save : ' + Limits.getCpuTime());
		} catch (Exception ex) {
			icServiceErrorHandler.LogError('icServiceGPSData', 'doPost', ex.getStackTraceString(), ex.getMessage(), '');
		}
		
		return 'Success';
	}
}