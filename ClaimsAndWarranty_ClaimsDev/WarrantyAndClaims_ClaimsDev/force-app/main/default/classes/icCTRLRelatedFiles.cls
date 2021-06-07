global with sharing class icCTRLRelatedFiles {
	static icLogicAttachment.IClass logicAttachement = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');

	@AuraEnabled
    global static List<ContentVersion> getAttachedFiles(String recordId){
    	System.debug('getAttachedFiles for : ' + recordId);
    	return logicAttachement.getAttachementsForRecord(recordId);
    }
}