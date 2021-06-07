public with sharing class ContentDocumentLinkService {

    public static Set<Id> caseIds { get; set; }
    public static List<ContentDocumentLink> caseDocs { get; set; }

    public static Set<Id> labSampleIds { get; set; }
    public static List<ContentDocumentLink> labSampleDocs { get; set; }

    public static Set<Id> warrantyIds { get; set; }
    public static List<ContentDocumentLink> warrantyDocs { get; set; }

    /*
        Run check Parent record on creation; if this is a Lab Sample/ Case/ Test Result or
        Lab Sample Tape Coe for a Closed Case, throw error
    */
    public static void cannotBeUploaded(final ContentDocumentLink docLink) {

        Profile p = ContentDocument_TriggerHandler.getUserProfile();

        if (docLink.LinkedEntityId.getSObjectType().getDescribe().getName() == 'Warranty__c') {
            blockUploadDocumentOnWarrantyProfileBased(docLink, p);
        }

        if (p.Name == 'System Administrator') {
            return;
        }

        if (docLink.LinkedEntityId.getSObjectType().getDescribe().getName() == 'Case') {
            blockUploadDocumentsOnCases(docLink);
        }

        if (docLink.LinkedEntityId.getSObjectType().getDescribe().getName() == 'Lab_Sample__c') {
            blockUploadDocumentsOnLabSamples(docLink);
        }

    } // end cannotBeUploaded method

    /* Blocks uploads on cases when certain conditions are met. 
     * 
     * CLAIMSV2-227 Now blocks uploads from the various Sales profiles when a case is not draft
     * 
     * Formerly this was _ONLY WHEN CASE IT CLOSED_ because that parameter
     * is hard defined the the bottom. This is a poor name for this method, but oh
     * well */
    private static void blockUploadDocumentsOnCases(final ContentDocumentLink docLink) {

        /* We need profiles because some restrictions apply only to some profile at some times */
        Profile p = ContentDocument_TriggerHandler.getUserProfile();

        caseIds = new Set<Id>();
        caseDocs = new List<ContentDocumentLink>();

        caseIds.add(docLink.LinkedEntityId);
        caseDocs.add(docLink);

        /* if nothing is related to Lab Samples, return */
        if (ContentDocumentLinkService.caseDocs.isEmpty()) {
            return;
        }

        /* Get all the cases involved here */
        List<Case> allCases = new List<Case>([
                SELECT Id, Claim_Stage__c
                FROM Case
                WHERE Id IN :caseIds
        ]);

        /* We need two lookups (Maps)--for ALL users, if the case is closed NO UPLOAD FOR YOU
         * CLAIMSV2-227 For sales users, if the case is NOT draft NO UPLOAD FOR YOU. */

        Map<Id, Case> closedCasesById = new Map<Id, Case>();
        Map<Id, Case> notDraftCasesById = new Map<Id, Case>();

        for (Case c : allCases) {
            if (c.Claim_Stage__c == 'Closed') {
                closedCasesById.put(c.Id, c);
            }

            if (c.Claim_Stage__c != 'Draft' && ((p.Name.left(4) == 'CACS' || P.Name.left(4) == 'CARS' || p.Name.left(4) == 'USRS'))) {
                notDraftCasesById.put(c.Id, c);
            }
        }

        // If there are no Closed cases and no non-Draft cases let's bump out of here
        if (closedCasesById.isEmpty() && notDraftCasesById.isEmpty()) {
            return;
        }

        // Add an error if the Case_Closed__c field is true
        // But the specific error depends on the stage
        // So we're going to slap our maps together into one so
        // we can use LinkedEntityId to get the value from a single place
        // and they're small so this won't take much CPU
        Map<Id, Case> allCasesById = new Map<Id, Case>();
        allCasesById.putAll(closedCasesById);
        allCasesById.putAll(notDraftCasesById);

        for (ContentDocumentLink cdl : caseDocs) {
            if (allCasesById.get(cdl.LinkedEntityId).Claim_Stage__c == 'Closed') {
                if (!p.Name.contains('Claims')) {
                    cdl.addError('Files cannot be uploaded for Closed Cases');
                }
            } else {
                cdl.addError('You cannot attach files to cases that aren\'t in Draft');
            }
        }

        // Add an error if the case is 
    } // end blockUploadDocumentsOnCases method

    private static void blockUploadDocumentOnWarrantyProfileBased(final ContentDocumentLink docLink,
            final Profile userProfile) {

        warrantyIds = new Set<Id>();
        warrantyDocs = new List<ContentDocumentLink>();

        warrantyIds.add(docLink.LinkedEntityId);
        warrantyDocs.add(docLink);

        for (ContentDocumentLink cdl : warrantyDocs) {
            if (userProfile.Name == 'Claims Manager' ||
                    userProfile.Name == 'Residential Claims Rep' ||
                    userProfile.Name == 'Commercial Claims Rep' ||
                    userProfile.Name == 'System Administrator') {
                return;
            } else {
                cdl.addError('Files cannot be uploaded');
            }
        }
    } // end blockUploadDocumentOnWarrantyProfileBased method

    private static void blockUploadDocumentsOnLabSamples(final ContentDocumentLink docLink) {

        labSampleIds = new Set<Id>();
        labSampleDocs = new List<ContentDocumentLink>();

        labSampleIds.add(docLink.LinkedEntityId);
        labSampleDocs.add(docLink);

        /* if nothing is related to Lab Samples, return */
        if (labSampleDocs.isEmpty()) {
            return;
        }

        Map<Id, Lab_Sample__c> labSamplesMap = new Map<Id, Lab_Sample__c>([
                SELECT Id, Case_Closed__c
                FROM Lab_Sample__c
                WHERE Id IN :labSampleIds AND
                Case_Closed__c = true
        ]);

        //if these are non-claim Cases, return
        if (labSamplesMap.isEmpty()) {
            return;
        }

        // Add an error if the Case_Closed__c field is true
        for (ContentDocumentLink cdl : labSampleDocs) {
            cdl.addError('Files cannot be uploaded for Lab Samples for Closed Cases');
        }
    } // end blockUploadDocumentsOnLabSamples method

}