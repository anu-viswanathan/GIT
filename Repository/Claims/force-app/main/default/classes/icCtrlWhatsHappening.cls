global with sharing class icCtrlWhatsHappening {

	static icLogicWhatsHappening.IClass logicWhatsHappening = (icLogicWhatsHappening.IClass) icObjectFactory.GetSingletonInstance('icLogicWhatsHappening');
	static icLogicUser.IClass logicUser = (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');
    static icLogicConfig.IClass logicConfig = (icLogicConfig.IClass) icObjectFactory.GetSingletonInstance('icLogicConfig');

	@AuraEnabled
	global static icDTOWhatsHappeningResult getWhatsHappening() {
		icDTOWhatsHappeningResult returnResult = new icDTOWhatsHappeningResult();

		User thisUSerInfo = logicUser.getUserAndAccountFromPartnerUser(UserInfo.getUserId());
		
		//IKO-240 Get the community Name to filter the What's happening object.
		String communityName = Site.getName();
		CommunitySiteNameConfiguration__mdt communityConfig = logicConfig.getCommunitySiteNameConfigByName(communityName);
		system.debug('Community Name ===> ' + communityName);
		List<What_s_Happening__c> listWhatsHappening = logicWhatsHappening.getActiveWhatHappeningByLanguageAndCommunityName(thisUSerInfo.ROOFPRO_Portal_Language__c, communityConfig.CommunityNameGlobalSetValue__c);
        returnResult.content = logicWhatsHappening.getListDTOFromWhatHappening(listWhatsHappening);
		returnResult.theme = UserInfo.getUiThemeDisplayed();

		return returnResult;
	}
}