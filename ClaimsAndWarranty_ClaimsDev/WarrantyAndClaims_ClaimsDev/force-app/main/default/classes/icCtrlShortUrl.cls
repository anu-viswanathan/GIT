global with sharing class icCtrlShortUrl {

	static icLogicAccount.IClass logicAccount = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');
	static icLogicUser.IClass logicUser = (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');
	static icServiceCentralStation.IClass csService = (icServiceCentralStation.IClass) icObjectFactory.GetSingletonInstance('icServiceCentralStation');

	@AuraEnabled
	global static String getShortUrlFromAccount() {

		String contractorId = logicUser.getAccountIdFromPartnerUser(UserInfo.getUserId());
		Account contractorAccount = logicAccount.getAcountInfoById(contractorId);

		String shortURL;
		if(String.isNotBlank(contractorAccount.Central_Station_Short_URL__c)) {
			shortURL = contractorAccount.Central_Station_Short_URL__c;
		}

		return shortURL;
	}

	@AuraEnabled
	global static String getShortUrl() {

		String contractorId = logicUser.getAccountIdFromPartnerUser(UserInfo.getUserId());
		Account contractorAccount = logicAccount.getAcountInfoById(contractorId);

		String shortURL = csService.getShortUrl(contractorId, contractorAccount.IKOPRO_QueueID__c);

		if(shortURL.startsWith('https://')) {
			contractorAccount.Central_Station_Short_URL__c = shortURL;
			logicAccount.saveAccount(contractorAccount);
		}

		return shortURL;
	}
}