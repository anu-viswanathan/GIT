global with sharing class icCTRLCommunityNavigation {

    static icLogicUser.IClass logicUser = (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');
    static icLogicAccount.IClass logicAccount = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

    /**
     * Created by Anil Mannem (Incloud) on 14-Aug-2020
     */
	@AuraEnabled
	global static icDTOProzoneRemoteAuth getSummitBlogAuthDetails(String recordId) {
		icDTOProzoneRemoteAuth summitBlogAuth = new icDTOProzoneRemoteAuth();

		if(String.isBlank(recordId)) {
			recordId = logicUser.getAccountIdFromPartnerUser(UserInfo.getUserId());
        }
        summitBlogAuth.accountId = recordId;
        summitBlogAuth.sessionId = UserInfo.getSessionId();
   	    summitBlogAuth.theme = UserInfo.getUiThemeDisplayed();
 		return summitBlogAuth;
	}

    @AuraEnabled
    global static List<String> getCurrentTheme() {
        String customerId = logicUser.getAccountIdFromPartnerUser(UserInfo.getUserId());
        Account customer = logicAccount.getAcountInfoById(customerId);
        return new List<String>{UserInfo.getUiThemeDisplayed(), customer.Present_Tier_Formula__c};
    }
}