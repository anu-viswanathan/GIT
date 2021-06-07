/**
 * Created by sinan.bunni on 2019-07-23.
 */

public with sharing class AuraDataTableController {

    private static final String COLONWITHSPACES = ' : ';
    private static final String COLON = ':';
    private static final String EMPTY = '';
    private static final String CASEOBJECT = 'Case';
    private static final String WARRANTYOBJECT = 'Warranty__c';
    private static final String LABSAMPLEOBJECT = 'Lab_Sample__c';

    /**
     * @description
     *
     * @param recordId
     * @param objectName
     *
     * @return
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

        return new List<ContentVersion>([
                SELECT Id, ContentDocumentId, Title, VersionNumber, CreatedBy.Name, Owner.Name, ContentModifiedDate
                FROM ContentVersion
                WHERE ContentDocumentId IN:documentIds
        ]);

    } // end getFiles method

    /**
     * @description
     *
     * @param documentId
     * @param recordId
     * @param ikoFileType
     * @param objectName
     */
    @AuraEnabled
    public static void updateFiles(String documentId, String recordId, String ikoFileType, String objectName) {

        ContentVersion contentDocumentRecord = [
                SELECT Id, Title
                FROM ContentVersion
                WHERE ContentDocumentId = :documentId
        ]; // Getting files from Parent record

        if (objectName == CASEOBJECT) {
            // retrieve the Case record
            Case caseRecord = [SELECT Id, CaseNumber FROM Case WHERE Id = :recordId LIMIT 1];
            
            // update the ContentVersion File with the IKOFileType
            contentDocumentRecord = updateContentDocumentTitle(contentDocumentRecord, ikoFileType, caseRecord.CaseNumber);

        } else if (objectName == LABSAMPLEOBJECT) {
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

            // Update the ContentVersion file Title
            contentDocumentRecord = updateContentDocumentTitle(contentDocumentRecord, ikoFileType, labSampleRecord.Case__r.CaseNumber);

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

            // update the ContentVersion File with the IKOFileType
            contentDocumentRecord = updateContentDocumentTitle(contentDocumentRecord, ikoFileType, warrantyRecord.Warranty_Registration_Id__c);
        }

        try {
            update contentDocumentRecord;  // Update ContentVersion (File)
        } catch (DmlException e) {
            System.debug('Exception has occurred! ' + e.getMessage());
        }

    } // end UpdateFiles method

    /**
     * @description
     *
     * @param contentDocumentRecord
     * @param ikoFileType
     * @param objectUniqueIdnentifier
     *
     * @return
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
     * @description
     *
     * @return
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
     * @description
     *
     * @param labSampleId
     *
     * @return
     */
    @AuraEnabled
    public static String getCaseIdByLabSampleId(String labSampleId) {
        return [SELECT Case__c FROM Lab_Sample__c WHERE Id = :labSampleId LIMIT 1].Case__c;
    } // end getCaseIdByLabSampleId method

} // end class AuraDataTableController class