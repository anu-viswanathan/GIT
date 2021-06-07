/**
 * @description Aura Controller for all operations related the Files Data Table Lightning Components
 * @author Sinan Bunni
 * @date 2019-07-23
 */
public without sharing class FileDataTableAuraController {

    private static final String COLONWITHSPACES = ' : ';
    private static final String COLON = ':';
    private static final String EMPTY = '';
    private static final String CASEOBJECT = 'Case';
    private static final String WARRANTYOBJECT = 'Warranty__c';
    private static final String LABSAMPLEOBJECT = 'Lab_Sample__c';


    /**
     * @description Get all the settings associated filedownload
     */
    @AuraEnabled 
    public static ClaimsFD__c getHierarchySettings()
    {
        return ClaimsFD__c.getInstance();
    }
    /**
     * @description Get all the files associated with the Object
     * @param recordId object Id passed in by the @see FileDataTableParentModal lightning component
     * @param objectName object name passed in by the @see FileDataTableParentModal lightning component
     * @return List of ContentVersion files associated with the passed in object and objectId
     */
    @AuraEnabled
    public static List<ContentVersion> getFiles(String recordId, String objectName) {
        String objectRecordId = EMPTY;

        if (objectName == CASEOBJECT) {
            objectRecordId = recordId;
        } else if (objectName == LABSAMPLEOBJECT) {
            objectRecordId = getCaseIdByLabSampleId(recordId);
        } else if (objectName == WARRANTYOBJECT) {
            objectRecordId = recordId;
        }

        Set<Id> documentIds = new Set<Id>();  //store file ids
        List<ContentDocumentLink> contentDocumentLinkList = [
                SELECT Id, LinkedEntityId, ContentDocumentId
                FROM ContentDocumentLink
                WHERE LinkedEntityId = :objectRecordId
        ];
        for (ContentDocumentLink contentDocumentLink : contentDocumentLinkList) {
            documentIds.add(contentDocumentLink.ContentDocumentId);  // Document ids
        }
        
        List<ContentVersion> contentVersionRecords = new List<ContentVersion>([
                SELECT Id, ContentDocumentId, Title, VersionNumber, CreatedBy.Alias, Owner.Name, ContentModifiedDate
                FROM ContentVersion
                WHERE ContentDocumentId IN :documentIds
        ]);
        
        return contentVersionRecords;
        
        

    } // end getFiles method

    /**
     * @description update the File Title with IKO Abbreviate File Type and Object Unique identifier and Original File Title
     * @param documentId ContentDocumentId passed in by the @see FileDataTableChildModal lightning component
     * @param recordId object Id passed in by the @see FileDataTableChildModal lightning component
     * @param ikoFileType IKO File Type passed in by the @see FileDataTableChildModal lightning component
     * @param objectName object name passed in by the @see FileDataTableChildModal lightning component
     */
    @AuraEnabled
    public static void updateFilesBulkified(String fileMetaList, String objectName, String recordId) {
		
        List<FileProperty> fileProperties = (List<FileProperty>) System.JSON.deserializeStrict(fileMetaList, List<FileProperty>.Class);
        
        Set<String> documentIds = new Set<String>();
        
        Map<String, FileProperty> fpDocumentIdToFileType = new Map<String, FileProperty>();
        
        for (FileProperty fp : fileProperties){
            documentIds.add(fp.documentId);
            fpDocumentIdToFileType.put(fp.documentId, fp);
        }
        
        List<ContentVersion> contentDocumentRecords = [
                SELECT Id, Title, ContentDocumentId
                FROM ContentVersion
                WHERE ContentDocumentId in :documentIds
        ]; // Getting files from Parent record

        if (objectName == CASEOBJECT) {
            // retrieve the Case record
            	Case caseRecord = [SELECT Id, CaseNumber FROM Case WHERE Id = :recordId LIMIT 1];
            for(ContentVersion contentDocumentRecord : contentDocumentRecords){
                // update the ContentVersion File with the IKOFileType
                contentDocumentRecord = updateContentDocumentTitle(contentDocumentRecord, fpDocumentIdToFileType.get(contentDocumentRecord.ContentDocumentId).ikoFileType, caseRecord.CaseNumber);
            }
            

        } else if (objectName == LABSAMPLEOBJECT) {
            // Files that are imporeted to the Lab Sample should be linked to the parent Case record

            // List to insert new ContentDocumentLink records and associate the file to the Case record
            List<ContentDocumentLink> toInsert = new List<ContentDocumentLink>();
            // List to delete the existing ContentDocumentLink records
            List<ContentDocumentLink> toDelete = new List<ContentDocumentLink>();

            // retrieve the Sample record and associated Case fields
            Lab_Sample__c labSampleRecord = [
                    SELECT Id, Case__c, Case__r.CaseNumber
                    FROM Lab_Sample__c
                    WHERE Id = :recordId LIMIT 1
            ];

            for(ContentVersion contentDocumentRecord : contentDocumentRecords){
                // update the ContentVersion File with the IKOFileType
                contentDocumentRecord = updateContentDocumentTitle(contentDocumentRecord, fpDocumentIdToFileType.get(contentDocumentRecord.ContentDocumentId).ikoFileType, labSampleRecord.Case__r.CaseNumber);
            }

            // Retrieve the existing ContentDocumentLink associated with the Lab Sample records
            List<ContentDocumentLink> contentDocumentLinkList = [
                    SELECT Id, LinkedEntityId, ContentDocumentId
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :recordId
            ];
            for (ContentDocumentLink contentDocumentLink : contentDocumentLinkList) {
                ContentDocumentLink newContentDocumentLink = contentDocumentLink.clone(); // deep clone the existing ContentDocumentLink associated with the Lab Sample
                newContentDocumentLink.LinkedEntityId = labSampleRecord.Case__c; // Link the Sample Lab CaseId to the cloned ContentDcoumentLink record
                newContentDocumentLink.ShareType = 'I';
                newContentDocumentLink.Visibility = 'AllUsers';
                
                toInsert.add(newContentDocumentLink);
                toDelete.add(contentDocumentLink);
            }

            Database.insert(toInsert, true);
            Database.delete(toDelete, true);
            
            

        } else if (objectName == WARRANTYOBJECT) {
            // retrieve the Warranty record
            Warranty__c warrantyRecord = [SELECT Id, Warranty_Registration_Id__c FROM Warranty__c WHERE Id = :recordId LIMIT 1];
			
            for(ContentVersion contentDocumentRecord : contentDocumentRecords){
                // update the ContentVersion File with the IKOFileType
                contentDocumentRecord = updateContentDocumentTitle(contentDocumentRecord, fpDocumentIdToFileType.get(contentDocumentRecord.ContentDocumentId).ikoFileType, warrantyRecord.Warranty_Registration_Id__c);
            }
            
        }

        try {
            update contentDocumentRecords;  // Update ContentVersion (File)
        } catch (DmlException e) {
            System.debug('Exception has occurred! ' + e.getMessage());
        }

    } // end UpdateFiles method

    /**
     * @description update the File Title with IKO Abbreviate File Type and Object Unique identifier and Original File Title
     * @param contentDocumentRecord uploaded Document (File) to the Files in Salesforce
     * @param ikoFileType File IKO Type
     * @param objectUniqueIdnentifier for Case is Case Number, for Warranty is Warranty Id
     * @return updated version of the ContentVersion with modified title
     */
    private static ContentVersion updateContentDocumentTitle(final ContentVersion contentDocumentRecord, final String ikoFileType, final String objectUniqueIdnentifier) {

        ContentVersion copyContentDocumentRecord = contentDocumentRecord;
        String fileTitle = contentDocumentRecord.Title;

        if (fileTitle.containsIgnoreCase(ikoFileType) || fileTitle.containsIgnoreCase(objectUniqueIdnentifier)) {
            String originalFileTitle = fileTitle.substringAfterLast(COLON);
            copyContentDocumentRecord.Title = ikoFileType + COLONWITHSPACES + objectUniqueIdnentifier + COLONWITHSPACES + fileTitle; // Changing file Title with user entered IKO Data Type
        } else {
            copyContentDocumentRecord.Title = ikoFileType + COLONWITHSPACES + objectUniqueIdnentifier + COLONWITHSPACES + copyContentDocumentRecord.Title;
        }

        return copyContentDocumentRecord;

    }// end updateContentDocumentTitle method

    /**
     * @description Get a Map of Master IKO File Type and associated Abbreviate IKO File Type
     * @return Map of Master IKO File Type and Abbreviate IKO File Type
     */
    @AuraEnabled
    public static Map<String, String> getListOfFileTypes() {
        Map<String, String> fileTypeLabeMap = new Map<String, String>();
        for (IKOFileType__mdt fileType : [SELECT MasterLabel, Abbreviate__c FROM IKOFileType__mdt ORDER BY MasterLabel ASC]) {
            fileTypeLabeMap.put(fileType.MasterLabel, fileType.Abbreviate__c);
        }

        return fileTypeLabeMap;
    } // end getListOfFileTypes method

    /**
     * @description Get the CaseId associatd with the Lab Sample
     * @param labSampleId Lab Sample Id
     * @return parent CaseId to the Lab Sample record
     */
    @AuraEnabled
    public static String getCaseIdByLabSampleId(String labSampleId) {
        return [SELECT Case__c FROM Lab_Sample__c WHERE Id = :labSampleId LIMIT 1].Case__c;
    } // end getCaseIdByLabSampleId method
	
    Class FileProperty {
        private String name;
        private String documentId;
        private String ikoFileType;
        
        public FileProperty(String documentId, String name, String ikoFileType){
            this.documentId = documentId;
            this.name = name;
            this.ikoFileType = ikoFileType;
        } 
        
    }
} // end class AuraDataTableController class