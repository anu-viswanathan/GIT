global with sharing class icCTRLContactUs {

	static icLogicUser.IClass logicUser = (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');
	static icLogicAccount.IClass logicAccount = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');
	
	@AuraEnabled
	global static icDTOContactUs getContactUsInfo(){
		icDTOContactUs info = new icDTOContactUs();

		String customerId = logicUser.getAccountIdFromPartnerUser(UserInfo.getUserId());

		if(String.isNotBlank(customerId)) {
			info = logicAccount.getContractorContactUsInfo(customerId);
		}
		
		return info;
	}
}