global with sharing class icCTRLProzone {

	static icLogicUser.IClass logicUser = (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');
    static icLogicAccount.IClass logicAccount = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

	@AuraEnabled
	global static icDTOProzoneRemoteAuth getProzoneRemoteAuthDetails(String recordId) {
		icDTOProzoneRemoteAuth dtoRemoteAuth = new icDTOProzoneRemoteAuth();
		
		if(String.isBlank(recordId)) {
			recordId = logicUser.getAccountIdFromPartnerUser(UserInfo.getUserId());
		}
		Account customer = logicAccount.getAcountInfoById(recordId);
System.debug('--'+customer);
		dtoRemoteAuth.accountId = recordId;
		dtoRemoteAuth.sessionId = UserInfo.getSessionId();
		dtoRemoteAuth.tierLevel = customer.Present_Tier_Formula__c == null ? 0 : Integer.valueOf(customer.Present_Tier_Formula__c);
		return dtoRemoteAuth;
	}

	@AuraEnabled
	global static String getCurrentTheme() {
		return UserInfo.getUiThemeDisplayed();
	}
}