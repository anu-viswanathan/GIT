public with sharing class ContentVersionService {



    /*
		Get list of ContentNote records for a given record, to show read-only view of Notes on record page
    */
    @AuraEnabled
    public static List<LightningNote> getContentNotes(Id recordId) {
    	List<Id> docIds 						= new List<Id>();
    	List<lightningNote> cvList 			= new List<lightningNote>();

    	for(ContentDocumentLink cdl : [select Id, ContentDocumentId from ContentDocumentLink where LinkedEntityId = :recordId])
    		docIds.add(cdl.ContentDocumentId);

    	if(docIds.isEmpty())
    		return cvList;

    	List<Id> contentVersionIds 				= new List<Id>();
    	for(ContentNote cn : [SELECT Id, Content, FileExtension, FileType, IsReadOnly, TextPreview, Title, LatestPublishedVersionId FROM ContentNote where Id IN :docIds AND FileType = 'SNOTE']) 
    		contentVersionIds.add(cn.LatestPublishedVersionId);

    	if(contentVersionIds.isEmpty())
    		return cvList;

    	for(ContentVersion cv : [select Id, Title, VersionData, CreatedBy.Name, CreatedDate, LastModifiedDate from ContentVersion where Id IN : contentVersionIds]) 
    		cvList.add(new lightningNote(cv));
    	return cvList;
	}    	

		public class LightningNote { 
			@AuraEnabled
			public String title {get; set; }
			@AuraEnabled
			public String createdBy { get; set; }
			@AuraEnabled
			public String createdById { get; set; }
			@AuraEnabled
			public Datetime timestamp { get; set; }
			@AuraEnabled
			public String noteText { get; set; }

			public LightningNote(ContentVersion cv) {
				this.title 			= cv.Title;
				this.createdBy 		= cv.CreatedBy.Name;
				this.createdById 	= cv.CreatedById;
				this.timestamp 		= cv.CreatedDate;
				this.noteText 		= cv.VersionData.toString();
			}
		}
}