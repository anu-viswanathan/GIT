/**
 * Created by incloud on 2020-05-21.
 */

public class icHandlerContentVersion implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
        void onAfterInsert(List<ContentVersion> contentVersions);
        void onBeforeUpdate(List<ContentVersion> contentVersions);
    }

	public class Impl implements IClass {
    
        icLogicUser.IClass logicUser = (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');
        icLogicAttachment.IClass logicDocument = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');
        icLogicCase.IClass logicCase = (icLogicCase.IClass) icObjectFactory.GetSingletonInstance('icLogicCase');
    
        public void onAfterInsert(List<ContentVersion> contentVersions){

            Map<String, ContentVersion> contentVersionMap = new Map<String, ContentVersion>();
            for(ContentVersion thisContentVersion : contentVersions) {
                String strId = String.valueof(thisContentVersion.ContentDocumentID);
                contentVersionMap.put(strId, thisContentVersion);
            }
            List<String> contentDocumentIdList = new List<String>(contentVersionMap.keySet());
            List<ContentDocumentLink> contentDocumentLinkList = logicDocument.getContentDocumentByIds(contentDocumentIdList);
            Map<String, ContentVersion> invoceUploadMap = new Map<String, ContentVersion>();
            for(ContentDocumentLink cd : contentDocumentLinkList) {
                String strId = String.valueof(cd.LinkedEntityId);
                if(strId.startswith('a0M')) {
                    invoceUploadMap.put(strId, contentVersionMap.get(cd.ContentDocumentId));
                }
            }
            List<ContentVersion> invoiceUploadList = invoceUploadMap.values();

            for(ContentVersion contentVersionObj : invoiceUploadList){ // Only InvoiceUploads falls into this loop
                System.debug('====>' + contentVersionObj.ContentSize);
                Decimal mb = Decimal.valueOf(contentVersionObj.ContentSize); // mb is in bytes
                /**
                 * IKO-273
                 * By Anil Mannem
                 * Updated condition to not allow files less than 1KB to upload
                 */
                if(mb <= 1024 && !Test.isRunningTest()){
                    contentVersionObj.addError('Cannot upload File');
                }
                // converting bytes to MegaBytes
                mb = mb.divide((1024*1024),2);
                if(mb > 25 && !Test.isRunningTest()){
                    contentVersionObj.addError('Can not upload more then 25 mb');
                }
            }
        }

        /**
         * ClaimsV2-931
         * By Anil Mannem (Incloud) on 27-07-2020
         * Adding error message to prevent Sales User to update file after Submitting a Case
         */
        public void onBeforeUpdate(List<ContentVersion> contentVersions) {
                
            //User currentUser = logicUser.getLoggedInUserInfo(UserInfo.getUserId());
            
            Map<String, ContentVersion> contentVersionMap = new Map<String, ContentVersion>();
            for(ContentVersion thisContentVersion : contentVersions) {
                String strId = String.valueof(thisContentVersion.ContentDocumentID);
                contentVersionMap.put(strId, thisContentVersion);
            }
            List<String> contentDocumentIdList = new List<String>(contentVersionMap.keySet());

            List<ContentDocumentLink> contentDocumentLinkList = logicDocument.getContentDocumentByIds(contentDocumentIdList);
            Map<String, ContentVersion> caseIdMap = new Map<String, ContentVersion>();
            for(ContentDocumentLink cd : contentDocumentLinkList) {
                String strId = String.valueof(cd.LinkedEntityId);
                if(strId.startswith('500')) {
                    caseIdMap.put(strId, contentVersionMap.get(cd.ContentDocumentId));
                }
            }
            List<Case> cases = logicCase.getCaseById(caseIdMap.keySet());
            for(Case thisCase: cases) {
                if(thisCase.Claim_Stage__c != 'Draft' /*&& currentUser.Profile.Name.contains('Sales Rep')*/) {
                    caseIdMap.get(thisCase.Id).addError('As a Sales Rep, Cannot update File Details after Claim Submission.');
                }
            }
        }
    }
}