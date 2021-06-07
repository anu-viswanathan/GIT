/* Initially created to resolve IWCN-271
 * https://ikoussfsc.atlassian.net/browse/IWCN-271
 * 
 * Not that Documents are connnected to Cases through DocumentLink. 
 * If someone removes the document link, this will not prevent the document from being deleted.
 */
public class ContentDocument_TriggerHandler {

    private static Profile userProfile;
    public static Profile getUserProfile() {
        if (ContentDocument_TriggerHandler.userProfile == NULL) {
            ContentDocument_TriggerHandler.userProfile = [
                    SELECT Id, Name
                    FROM Profile
                    WHERE Id = :UserInfo.getProfileId()
            ];
        }

        return userProfile;
    }

    /*
        Run check against profile; if this is a Plant user, block the file upload
    */
    public static void allowUpload(List<ContentDocument> docList) {
        Profile p = ContentDocument_TriggerHandler.getUserProfile();
        for (ContentDocument doc : docList) {
            if (p.Name == 'Iko Plants') {
                doc.addError('You are not allowed to upload Files');
            }
        }

    }

    /*
        return list of Case Ids for a given ContentDocument
    */
    public static Set<Id> caseIds { get; set; }
    public static List<ContentDocumentLink> caseDocs { get; set; }
    public static void getCases(Id documentId) {
        String dlPrefix;
        List<ContentDocumentLink> allDocs = new List<ContentDocumentLink>([
                SELECT Id, LinkedEntityId, ContentDocumentId
                FROM ContentDocumentLink
                WHERE ContentDocumentId = :documentId
        ]);
        ContentDocument_TriggerHandler.caseDocs = new List<ContentDocumentLink>();
        ContentDocument_TriggerHandler.caseIds = new Set<Id>();

        For (ContentDocumentLink dl : allDocs) {
            // Convert the ID to a string so we can work with it more easily
            dlPrefix = String.valueOf(dl.LinkedEntityId).left(3);
            // 500 is the prefix for cases as defined here
            // https://help.salesforce.com/articleView?id=000005995&language=en_US&type=1
            if (dlPrefix == '500') {
                ContentDocument_TriggerHandler.caseDocs.add(dl);
                ContentDocument_TriggerHandler.caseIds.add(dl.LinkedEntityId);
            }
        }
    } 

    //The following code is being commented as we are using Chatter instead of SNOTEs
/*	*//*
		Run check to see if related to Closed Claims Case and is of type "SNOTE" (enhanced notes)
	*//*
	public static void allowAddNote(ContentDocument doc) {
		Profile p = ContentDocument_TriggerHandler.getUserProfile();
		System.debug('Profile--'+p.Name);
		if (p.Name == 'System Administrator')
			return;
		System.debug('Called 1--');
		if (doc.FileType <> 'SNOTE')
			return;

		System.debug('Called--');
		ContentDocument_TriggerHandler.getCases(doc.Id);
		System.debug('Called--');
		*//* if nothing is related to Cases, return *//*
		if (ContentDocument_TriggerHandler.caseDocs.isEmpty())
			return;

		Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id, RecordTypeId, RecordType.Name FROM Case WHERE Id IN :ContentDocument_TriggerHandler.caseIds AND RecordType.Name IN ('Commercial Claim', 'Residential Claim') AND Claim_Stage__c = 'Closed']);
		System.debug('caseMap--'+caseMap);
		if (caseMap.isEmpty())
			return;

		for (ContentDocumentLink cdl : ContentDocument_TriggerHandler.caseDocs) {
			if (caseMap.get(cdl.LinkedEntityId) <> null) {
				doc.addError('You cannot add a Note to a closed Residential or Commercial Claim Case');
			}
		}
	}*/

    /*
        Run check Parent record on deletion; if this is a Commercial or Residential Claim Case record, throw error
    */
    public static void cannotBeDeleted(ContentDocument doc) {
        ContentDocument_TriggerHandler.getCases(doc.Id);

        /* if nothing is related to Cases, return */
        if (ContentDocument_TriggerHandler.caseDocs.isEmpty())
            return;

        Map<Id, Case> casesById = new Map<Id, Case>();
        for (Case c : [
                SELECT Id, RecordTypeId, RecordType.Name, Legal__c
                FROM Case
                WHERE Id IN :ContentDocument_TriggerHandler.caseIds AND
                RecordType.Name IN ('Commercial Claim', 'Residential Claim')
        ]) {
            casesById.put(c.Id, c);
        }

        /* if these are non-claim Cases, return */
        if (casesById.isEmpty())
            return;

        for (ContentDocumentLink cdl : ContentDocument_TriggerHandler.caseDocs) {
            // Add a different error for Residential and Commercial, even though the error doesn't show
            // error is thrown on the ContentDocument (doc) as ContentDocumentLink does not support SObject Error
            if (casesById.get(cdl.LinkedEntityId).RecordType.Name == 'Residential Claim') {
                doc.addError('This file is part of a Residential Warranty Claim and cannot be deleted');
            } else if (casesById.get(cdl.LinkedEntityId).RecordType.Name == 'Commercial Claim') {
                doc.addError('This file is part of a Commercial Warranty Claim and cannot be deleted');
            }
        }
    }
}