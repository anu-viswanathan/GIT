@RestResource(urlMapping='/evservice/FileDelivery')
global class icServiceEagleViewFileDelivery {

	static icLogicAttachment.IClass logicAttachment = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');

	@HttpPost
	global static String doPost() {
		System.debug('--------- icServiceEagleViewFileDelivery doPost ---------');
		
		String requestBody;
		try {
			requestBody = RestContext.request.requestBody.toString();
			System.debug('RestContext.request : ' + RestContext.request);
			System.debug('RestContext.request.requestBody : ' + RestContext.request.requestBody);
			
			//Blob requestDocument = Blob.valueOf(requestBody);
			Blob requestDocument = EncodingUtil.base64Decode(requestBody);

			Map<String, String> requestParams = RestContext.request.params;
			String sfRefId = requestParams.get('RefId');
			String evRefId = requestParams.get('ReportId');
			String fileFormatId = requestParams.get('FileFormatId');
			String fileTypeId = requestParams.get('FileTypeId');

			System.debug('sfRefId : ' + sfRefId);
			System.debug('evRefId : ' + evRefId);
			System.debug('fileFormatId : ' + fileFormatId);
			System.debug('fileTypeId : ' + fileTypeId);
			System.debug('requestDocument : ' + requestDocument);

			String strFilePath = evRefId + '.pdf';

			logicAttachment.createDocumentInObject(sfRefId, strFilePath, strFilePath, requestDocument);

			/*
			Attachment attach = new Attachment();
			attach.contentType = 'application/pdf';
			attach.name = evRefId + '.pdf';
			attach.parentId = sfRefId;
			attach.body = requestDocument;
			insert attach;
			*/

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
			icServiceErrorHandler.LogError('icServiceEagleViewFileDelivery', 'doPost', ex.getStackTraceString(), ex.getMessage(), requestBody);
		}
		
		return 'Ok';
	}
}