public with sharing class icCTRLQuotePDF {

	icLogicUser.IClass logicUser = (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');
	icLogicAccount.IClass logicAccount = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

	public Quote thisQuote {get; set;}
	public Account userAccount {get; set;}

	/*public String imageName {get;set;}
	public String fileId  {get; set;}
	public String fileType  {get; set;}
	public String fileData  {get; set;}
	public BLob fileVersionData  {get; set;}*/

	public icCTRLQuotePDF(ApexPages.StandardController stdController) {
		
		/*List<String> addFields = new List<String> {'Quote_Logo__c'};
		if(!test.isRunningTest()) stdController.addFields(addFields);*/

		thisQuote = (Quote)stdController.getRecord();

		String customerId = logicUser.getAccountIdFromPartnerUser(UserInfo.getUserId());
		//customerId = '001m000000jjg5KAAQ';
		userAccount = logicAccount.getAcountInfoById(customerId);

		/*List<ContentDocumentLink> thisAccountDocs = [SELECT ContentDocumentId, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId = :thisQuote.AccountId];
		fileId = thisAccountDocs[0].ContentDocumentId;		

		ContentVersion thisFile = [SELECT Id, Title, Description, ContentSize, FileExtension, FileType, IsLatest, VersionData FROM ContentVersion WHERE ContentDocumentId = :fileId];
		fileData = EncodingUtil.Base64Encode(thisFile.VersionData);
		fileVersionData = thisFile.VersionData;
		fileType = thisFile.FileExtension;*/
	}

	public Account getUserAccount (){
		return userAccount;
	}

	public String getImageHTMLMarkup() {
		String returnHTMLMarkup = '&nbsp;';
		if(String.isNotEmpty(userAccount.Quote_Logo__c)) {
			returnHTMLMarkup = '<div style="height:100px;">' + userAccount.Quote_Logo__c.replace('<img src=', '<img height="100px" src=') + '</div>';
		} else {
			returnHTMLMarkup = '<div style="height:100px;">&nbsp;</div>';
		}

		return returnHTMLMarkup;
	}
}