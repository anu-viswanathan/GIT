public class icLogicAttachment implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		ContentVersion getAttachementById(String attachmenId);
		List<ContentVersion> getAttachementsForRecord(String recordId);
		List<ContentDocumentLink> getContentDocumentByIds(List<String> recordIds);
		List<ContentDocumentLink> getContentDocumentByRelatedRecordIds(List<String> recordIds);
		List<icDTOSelectOption> getAttachementOptionsForRecord(String recordId);
		Map<String, List<ContentDocumentLink>> getMapListDocumentsByInvoiceId(List<ContentDocumentLink> relatedDocuments);
		void createDocumentInObject(String objectId, String title, String path, blob contentData);
		void deleteDocumentById(Id documentId);

		void deleteDocumentsByIds(List<Id> documentIds);
		void deleteDocumentByContracorInvoiceId(Id invoiceId);
		List<icDtoUploadedFile> getUploadedFilesByContracorInvoiceId(Id contractorInvoiceId);
	}

	public class Impl implements IClass {

		icRepoAttachment.IClass repository = (icRepoAttachment.IClass) icObjectFactory.GetSingletonInstance('icRepoAttachment');

		public ContentVersion getAttachementById(String attachmenId) {
			return repository.getAttachementById(attachmenId);
		}

		public List<ContentVersion> getAttachementsForRecord(String recordId) {
			List<ContentDocumentLink> thisRecordsAttachments = repository.getAttachementForRecord(recordId);
			system.debug('repository.getAttachementForRecord result : ' + thisRecordsAttachments);

			List<String> listContentDocIds = new List<String>();
			for(ContentDocumentLink thisAttachment : thisRecordsAttachments) {
				listContentDocIds.add(thisAttachment.ContentDocumentId);
			}

			return repository.getAttachementsByIds(listContentDocIds);
		}

		public List<ContentDocumentLink> getContentDocumentByIds(List<String> recordIds) {
			return repository.getContentDocumentByIds(recordIds);
		}

		public List<ContentDocumentLink> getContentDocumentByRelatedRecordIds(List<String> recordIds) {
			return repository.getContentDocumentByRelatedRecordIds(recordIds);
		}

		public List<icDTOSelectOption> getAttachementOptionsForRecord(String recordId) {
			List<icDTOSelectOption> returnAttachmentOptions = new List<icDTOSelectOption>();

			List<ContentDocumentLink> thisRecordsAttachments = repository.getAttachementForRecord(recordId);
			system.debug('repository.getAttachementForRecord result : ' + thisRecordsAttachments);

			for(ContentDocumentLink thisAttachment : thisRecordsAttachments) {
				icDTOSelectOption newOption = new icDTOSelectOption();
				newOption.value = thisAttachment.ContentDocumentId;
				newOption.label = thisAttachment.ContentDocument.Title;
				newOption.isDisabled = false;
				returnAttachmentOptions.add(newOption);
			}
			system.debug('getAttachementOptionsForRecord result : ' + returnAttachmentOptions);
			return returnAttachmentOptions;
		}

		public Map<String, List<ContentDocumentLink>> getMapListDocumentsByInvoiceId(List<ContentDocumentLink> relatedDocuments) {
			Map<String, List<ContentDocumentLink>> mapListDocumentsByInvoiceId = new Map<String, List<ContentDocumentLink>>();

			for(ContentDocumentLink relatedDoc : relatedDocuments) {
				List<ContentDocumentLink> listDocs = mapListDocumentsByInvoiceId.get(relatedDoc.LinkedEntityId);
				if(listDocs == null) {
					listDocs = new List<ContentDocumentLink>();
				}
				listDocs.add(relatedDoc);
				mapListDocumentsByInvoiceId.put(relatedDoc.LinkedEntityId, listDocs);
			}

			return mapListDocumentsByInvoiceId;
		}

		public void createDocumentInObject(String objectId, String title, String path, blob contentData) {
			ContentVersion contentDoc = new ContentVersion();
			contentDoc.FirstPublishLocationId = objectId;
			contentDoc.ContentLocation = 'S';
			contentDoc.Title = title;
			contentDoc.PathOnClient = path;
			contentDoc.VersionData = contentData;
			repository.createDocument(contentDoc);			
		}

		public void deleteDocumentById(Id documentId){

			repository.deleteContentDocumentById(documentId);

		}

		public void deleteDocumentsByIds(List<Id> documentIds){

			repository.deleteContentDocumentsByIds(documentIds);

		}

		public void deleteDocumentByContracorInvoiceId(Id invoiceId){

			repository.deleteContentDocumentByRelatedRecordId(invoiceId);

		}

		public List<icDtoUploadedFile> getUploadedFilesByContracorInvoiceId(Id contractorInvoiceId) {

			List<icDtoUploadedFile> uploadedFiles = new List<icDtoUploadedFile>();
			List<ContentDocumentLink> documentLinks = new List<ContentDocumentLink>();
			documentLinks = repository.getAttachementForRecord(contractorInvoiceId);
			for(ContentDocumentLink documentLink : documentLinks){

				icDtoUploadedFile uploadedFile = new icDtoUploadedFile();
				uploadedFile.name = documentLink.ContentDocument.Title;
				uploadedFile.documentId = documentLink.ContentDocumentId;
				uploadedFiles.add(uploadedFile);

			}

			return uploadedFiles;
		}
	}
}