trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert, before delete, after insert, after delete) {
    if(System.Trigger.isAfter) {
        if(Trigger.isInsert) {
            for(ContentDocumentLink doc : Trigger.new) {
                ContentDocumentLinkService.cannotBeUploaded(doc); // for files
            }
        }
    }
    
    /* When a note is inserted we're going to set it's permissions to view only
     * CLAIMSV2-177 */
    if(System.Trigger.isBefore && System.Trigger.isInsert) {
        
        List<ContentDocumentLink> relatedToCase = new List<ContentDocumentLink>();
        for(ContentDocumentLink c : Trigger.new) {
            if(String.valueOf(c.LinkedEntityId).left(3) == '500') {
                /**
                 * ClaimsV2-931/684
                 * By Anil Mannem (Incloud)
                 * Changed ShareType value from 'V' to 'I' to allow users to edit file name based on record access
                 */
                c.ShareType = 'I';
            	}
        	}
        
    	}
}