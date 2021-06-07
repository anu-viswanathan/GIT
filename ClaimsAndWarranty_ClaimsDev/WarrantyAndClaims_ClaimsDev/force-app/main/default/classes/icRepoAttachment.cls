public class icRepoAttachment implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		ContentVersion getAttachementById(String attachmenId);
		List<ContentVersion> getAttachementsByIds(List<String> attachmenIds);
		List<ContentDocumentLink> getContentDocumentByIds(List<String> recordIds);
		List<ContentDocumentLink> getContentDocumentByRelatedRecordIds(List<String> recordIds);
		List<ContentDocumentLink> getAttachementForRecord(String recordId);
		void createDocument(ContentVersion contentDoc);
		void deleteContentDocumentById(Id documentId);
		void deleteContentDocumentsByIds(List<Id> documentIds);
		void deleteContentDocumentByRelatedRecordId(Id recordId);
	}

	public class Impl implements IClass {

		public ContentVersion getAttachementById(String attachmenId) {
			return [SELECT Id, ContentDocumentId, ContentModifiedDate, Title, Description, ContentSize, FileExtension, FileType, IsLatest, VersionData FROM ContentVersion WHERE ContentDocumentId = :attachmenId];
		}

		public List<ContentVersion> getAttachementsByIds(List<String> attachmenIds) {
			return [SELECT Id, ContentDocumentId, ContentModifiedDate, Title, Description, ContentSize, FileExtension, FileType, IsLatest, VersionData FROM ContentVersion WHERE ContentDocumentId IN :attachmenIds];
		}

		public List<ContentDocumentLink> getContentDocumentByIds(List<String> recordIds) {
			return [SELECT ContentDocumentId, LinkedEntityId, ContentDocument.Title FROM ContentDocumentLink WHERE ContentDocumentId IN :recordIds];
		}

		public List<ContentDocumentLink> getContentDocumentByRelatedRecordIds(List<String> recordIds) {
			return [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN :recordIds];
		}

		public List<ContentDocumentLink> getAttachementForRecord(String recordId) {
			return [SELECT ContentDocumentId, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
		}		

		public void createDocument(ContentVersion contentDoc) {
			insert contentDoc;
		}

		public void deleteContentDocumentById(Id documentId){

			delete [SELECT Id FROM ContentDocument WHERE Id =: documentId];

		}

		public void deleteContentDocumentsByIds(List<Id> documentIds){
			delete [SELECT Id FROM ContentDocument WHERE Id IN: documentIds];
		}
		public void deleteContentDocumentByRelatedRecordId(Id recordId){
			List<ContentDocumentLink> contentDocumentsLinks = [SELECT ContentDocumentId
															   FROM ContentDocumentLink
															   WHERE LinkedEntityId = :recordId];
			List<ContentDocument> contentDocuments = new List<ContentDocument>();
			for(ContentDocumentLink documentLinkId : contentDocumentsLinks){
				contentDocuments.add(new ContentDocument(Id = documentLinkId.ContentDocumentId));
			}
			if(!contentDocuments.isEmpty()){
				delete contentDocuments;
			}

		}
	}
}