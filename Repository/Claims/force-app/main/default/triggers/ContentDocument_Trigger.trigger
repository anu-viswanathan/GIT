trigger ContentDocument_Trigger on ContentDocument (before insert, before delete, after insert, after delete) {

    /*if(System.Trigger.isAfter) {
        if(Trigger.isInsert) {
            for(ContentDocument doc : Trigger.new)
                ContentDocument_TriggerHandler.allowAddNote(doc);
        }
        
    }*/

    if(Trigger.isBefore == true) {
        if(Trigger.isInsert) {
            ContentDocument_TriggerHandler.allowUpload(System.Trigger.new);

           /* for(ContentDocument doc : Trigger.new) {
                ContentDocument_TriggerHandler.allowAddNote(doc);
            }*/
        }

            //System.debug('ContentDocument_Trigger: isDelete = ' + System.Trigger.isDelete);
        if(Trigger.isDelete == true) {
            System.debug('ContentDocument_Trigger: isDelete = ' + System.Trigger.isDelete);
			/*  IWCN-271 https://ikoussfsc.atlassian.net/browse/IWCN-271
			   	Files that are attached to Claims cannot be deleted except by someone with the Modify All Data permission
				e.g. a System Administrator
				Solid example! https://developer.salesforce.com/forums/?id=9060G0000005Y9rQAE 
				Our example is a bit more challenging because we need to prevent for specific
				Record Types and that can't be queried from ContentDocumentLink */
            
            // Get the record types for a Residential Claims Case
            // We're going to put them in a map with an index of Developer_Name - SObjectType
            // To get the ID you pull rTypesbyNameObject.get('Residental_Claim - Case').Id

            /* defer querying of record types to ContentDocument_TriggerHandler.cannotBeDeleted */
            /*
            List<RecordType> rTypes = new List<RecordType>([SELECT Id, Name, DeveloperName, SObjectType FROM RecordType ]);
            Map<String, RecordType> rTypesbyNameObject = new Map<String, RecordType>();
            For(RecordType r : rTypes) {
                rTypesbyNameObject.put(r.Name + ' - ' + r.SObjectType, r);
            	}
            */

            // Make a list of all the documents so we can pass it off
            /*List<ContentDocument> deletedDocs = new List<ContentDocument>();
            for(ContentDocument c : Trigger.Old) {
				deletedDocs.add(c);                
            }*/

            /* ContentDocumentLink can only be queried with a *single* ContentDocumentId 
			   which means it may be impossible to bulkify this properly. The query below 
			   doesn't work, and the only option appears to be to loop through the thing
			   which is going to blow our query limits */
            // Build a list of all the document links
            /* List<ContentDocumentLink> docLinks = New List<ContentDocumentLink>(
                [SELECT Id, 
                 	LinkedEntityId, 
                 	ContentDocumentId 
                 	FROM ContentDocumentLink 
                 	WHERE ContentDocumentId IN :deletedDocs]); */

            // send our list off to be deleted
                System.Debug(Trigger.Old);
            For(ContentDocument doc : Trigger.Old) {
                ContentDocument_TriggerHandler.cannotBeDeleted(doc);
            }

        }
    }
}