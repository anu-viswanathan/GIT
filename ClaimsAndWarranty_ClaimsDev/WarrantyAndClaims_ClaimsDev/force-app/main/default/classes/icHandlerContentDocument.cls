public class icHandlerContentDocument implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		void onAfterInsert(List<ContentDocumentLink> oldContentDocumentLink, List<ContentDocumentLink> newContentDocumentLink, Map<Id, ContentDocumentLink> contentDocumentLinkMap);
		void onBeforeDelete(List<ContentDocument> oldContentDocument, Map<Id, ContentDocument> contentDocumentMap);
		void onBeforeInsert(List<ContentDocument> contentDocuments);
		
	}

	public class Impl implements IClass {
		
		icLogicAttachment.IClass documentLogic = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');
		icLogicInvoice.IClass invoiceLogic = (icLogicInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicInvoice');

		public void onBeforeInsert(List<ContentDocument> contentDocuments){
			System.debug('this is calling before insert');
			for(ContentDocument contentDocumentObj : contentDocuments){
				System.debug('fileSize' + contentDocumentObj.ContentSize);
				if(contentDocumentObj.ContentSize > 250000){
					contentDocumentObj.addError('You can not upload file more then 25 mb');
				}
			}

		}
		public void onAfterInsert(List<ContentDocumentLink> oldContentDocumentLink, List<ContentDocumentLink> newContentDocumentLink, Map<Id, ContentDocumentLink> contentDocumentLinkMap) {
			//get list of trigger record id; fetch related object from content document link
			
			/*
			List<String> listContentDocIds = new List<String>();
			for(ContentDocument thisContentDoc : newContentDocument) {
				listContentDocIds.add(thisContentDoc.Id);
			}
			List<ContentDocumentLink> listContentDocLinks = documentLogic.getContentDocumentByIds(listContentDocIds);
			*/

			//get list of related object id; map trigger record id to related object id; fetch all related object (uploaded invoice)
			List<String> listRelatedObjectIds = new List<String>();
			Map<String, String> mapContentDocIdToRelatedObjectId = new Map<String, String>();
			for(ContentDocumentLink thisContentDocLink : newContentDocumentLink) {
				String stringLinkedEntity = thisContentDocLink.LinkedEntityId;
                System.debug('stringLinkedEntity===' + stringLinkedEntity);
				if(stringLinkedEntity.startsWith('a0M')) {
					listRelatedObjectIds.add(thisContentDocLink.LinkedEntityId);
					mapContentDocIdToRelatedObjectId.put(thisContentDocLink.ContentDocumentId, thisContentDocLink.LinkedEntityId);
				}
			}

			List<Contractor_Invoice__c> listUploadedInvoice =  invoiceLogic.getUploadedInvoiceById(listRelatedObjectIds);

			//map uploaded invoice
			Map<String, Contractor_Invoice__c> mapUploadedInvoice = new Map<String, Contractor_Invoice__c>();
			for(Contractor_Invoice__c thisUploadedInvoice : listUploadedInvoice) {
				mapUploadedInvoice.put(thisUploadedInvoice.Id, thisUploadedInvoice);
			}

			Set<Contractor_Invoice__c> updateInvoices = new Set<Contractor_Invoice__c>();
			for(ContentDocumentLink thisContentDocLink : newContentDocumentLink) { //for(ContentDocument thisContentDoc : newContentDocument) {
				Id thisInvoiceId = mapContentDocIdToRelatedObjectId.get(thisContentDocLink.ContentDocumentId);
				Contractor_Invoice__c thisRelatedInvoice = mapUploadedInvoice.get(thisInvoiceId);
				
				if(thisRelatedInvoice != null) {
					thisRelatedInvoice.File_s_Attached__c = true;
					if(String.isBlank(thisRelatedInvoice.Uploaded_Files_Long__c)) {
                        thisRelatedInvoice.Uploaded_Files_Long__c = thisContentDocLink.ContentDocumentId  + ',';
						updateInvoices.add(thisRelatedInvoice);
					} else {					
						if(!thisRelatedInvoice.Uploaded_Files_Long__c.contains(thisContentDocLink.ContentDocumentId)) {
                            thisRelatedInvoice.Uploaded_Files_Long__c += thisContentDocLink.ContentDocumentId + ',';
							updateInvoices.add(thisRelatedInvoice);
						}
					}
				}
			}

			if(updateInvoices.size() > 0) {
				invoiceLogic.updateInvoices(new List<Contractor_Invoice__c>(updateInvoices));
			}
		}

		public void onBeforeDelete(List<ContentDocument> oldContentDocument, Map<Id, ContentDocument> contentDocumentMap) {
			Map<String, String> mapContentDocIdToRelatedObjectId = new Map<String, String>();

			//get list of trigger record id; fetch related object from content document link
			List<String> listContentDocIds = new List<String>();
			for(ContentDocument thisContentDoc : oldContentDocument) {
				listContentDocIds.add(thisContentDoc.Id);
			}
			System.debug('listContentDocIds : ' + listContentDocIds);
			List<ContentDocumentLink> listContentDocLinks = documentLogic.getContentDocumentByIds(listContentDocIds);
			System.debug('listContentDocLinks : ' + listContentDocLinks);

			//get list of related object id; map trigger record id to related object id; fetch all related object (uploaded invoice)
			List<String> listRelatedObjectIds = new List<String>();
			for(ContentDocumentLink thisContentDocLink : listContentDocLinks) {
				String stringLinkedEntity = thisContentDocLink.LinkedEntityId;
				if(stringLinkedEntity.startsWith('a0M')) {
					listRelatedObjectIds.add(thisContentDocLink.LinkedEntityId);
					mapContentDocIdToRelatedObjectId.put(thisContentDocLink.ContentDocumentId, thisContentDocLink.LinkedEntityId);
				}
			}
			List<Contractor_Invoice__c> listUploadedInvoice =  invoiceLogic.getUploadedInvoiceById(listRelatedObjectIds);

			//map uploaded invoice
			Map<String, Contractor_Invoice__c> mapUploadedInvoice = new Map<String, Contractor_Invoice__c>();
			for(Contractor_Invoice__c thisUploadedInvoice : listUploadedInvoice) {
				mapUploadedInvoice.put(thisUploadedInvoice.Id, thisUploadedInvoice);
			}

			for(ContentDocument thisContentDoc : oldContentDocument) {
				Id thisInvoiceId = mapContentDocIdToRelatedObjectId.get(thisContentDoc.Id);
				Contractor_Invoice__c thisRelatedInvoice = mapUploadedInvoice.get(thisInvoiceId);

				System.debug('thisInvoiceId : ' + thisInvoiceId);
				System.debug('thisRelatedInvoice : ' + thisRelatedInvoice);

				if(thisRelatedInvoice != null) {
					System.debug('thisRelatedInvoice Status__c : ' + thisRelatedInvoice.Status__c);
					if(thisRelatedInvoice.Status__c != 'Draft') {
						thisContentDoc.addError(Label.icSorry_you_cannot_delete_this_file);
					}
				}
			}
		}
	}
}