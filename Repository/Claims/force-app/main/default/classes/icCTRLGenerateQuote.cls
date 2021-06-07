global with sharing class icCTRLGenerateQuote {

	static icLogicQuote.IClass logicQuote = (icLogicQuote.IClass) icObjectFactory.GetSingletonInstance('icLogicQuote');
	static icLogicAccount.IClass logicAccount = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');	
	static icLogicAttachment.IClass logicAttachment = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');
	static icLogicEmail.IClass logicEmail = (icLogicEmail.IClass) icObjectFactory.GetSingletonInstance('icLogicEmail');

	@AuraEnabled
	global static String generateQuote(String recordId) {
		String returnResult = 'Quote Created';

		System.debug('icCTRLGenerateQuote.generateQuote : ' + recordId);

		try {
			Quote thisQuote = logicQuote.getQuoteInfoById(recordId);

			String strFilePath = thisQuote.Opportunity.Name + '-' + 
				Datetime.now() + ' ' + 
				thisQuote.BillingStreet + '-' +
				thisQuote.BillingCity + '-' +
				thisQuote.BillingState + '-' +
				thisQuote.BillingCountry + '-' +
				thisQuote.BillingPostalCode + '.pdf';

			PageReference pageRef = Page.icQuotePDF;
			pageRef.getParameters().put('id', recordId);
			Blob quotePDF;
			if(!Test.isRunningTest()) {
				quotePDF = pageRef.getContent();
				System.debug('quotePDF : ' + quotePDF);
			} else {
				quotePDF = Blob.valueOf('quotePDF');
			}

			logicAttachment.createDocumentInObject(recordId, strFilePath, strFilePath, quotePDF);			
		} catch (Exception ex) {
			returnResult = ex.getMessage();
			System.debug('Exception : ' + ex.getMessage());
		}

		return returnResult;
	}

	@AuraEnabled
	global static List<icDTOSelectOption> getQuoteFiles(String recordId) {
		List<icDTOSelectOption> fileOptions = new List<icDTOSelectOption>();
		try {
			fileOptions = logicAttachment.getAttachementOptionsForRecord(recordId);
		} catch(Exception ex) {
			System.debug('getQuoteFiles : ' + ex.getMessage());
		}
		return fileOptions;
	}

	@AuraEnabled
	global static String sendQuote(String recordId, String quoteId) {
		String returnResult = 'Quote Sent to ';

		try {
			Quote thisQuote = logicQuote.getQuoteInfoById(recordId);
			ContentVersion thisQuotePDF = logicAttachment.getAttachementById(quoteId);
			Contact thisRecipient = logicAccount.getPersonAcountInfoById(thisQuote.Opportunity.AccountId);		
			if(thisRecipient != null) {
				returnResult += ': ' + thisRecipient.FirstName + ' ' + thisRecipient.LastName + '(' + thisRecipient.Email + ')';
				EmailTemplate template = logicEmail.getEmailTemplateByDevName('IKOPRO_Quote_Ready');
				logicEmail.sendTemplateEmail(template, thisRecipient.Id, recordId, new String[] {thisQuotePDF.Id}, new List<Messaging.EmailFileAttachment>());
			} else {
				returnResult = 'Quote not sent. Could not find recipient.';
			}
		} catch (Exception ex) {
			returnResult = ex.getMessage();
			System.debug('Exception : ' + ex.getMessage());
		}

		return returnResult;
	}
}