public with sharing class LabSampleTapeCodeService {

    /*
        Block all updates for Case when the Claim_Stage__c is Closed, *unless* it is being re-opened
    */
    public static void blockCreatedUpdateDelete(List<Lab_Sample_Tape_Code__c> records) {
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        List<Id> caseIds = new List<Id>();

        List<Id> labSampleIds = new List<Id>();

        for (Lab_Sample_Tape_Code__c record : records)
            labSampleIds.add(record.Lab_Sample__c);

        // SOQL query modified as part of US IWCN-723
        Map<Id, Lab_Sample__c> labSamplesMap = new Map<Id, Lab_Sample__c>(
        [
                SELECT Id, Case__r.RecordTypeId, Case__r.Claim_Stage__c, Case__r.Claim_Sub_Stage__c, Case__r.ClaimApproved__c
                FROM Lab_Sample__c
                WHERE Id IN :labSampleIds
                AND Case__r.RecordTypeId IN :claimRecordTypes.keySet()
                AND (
                        Case__r.Claim_Stage__c = 'Closed' OR
                        Case__r.ClaimApproved__c = true OR
                        (Case__r.Claim_Stage__c = 'Assessment' AND Case__r.Claim_Sub_Stage__c = 'In Approval')
                )
        ]
        );

        if (labSamplesMap.isEmpty()) {
            return;
        }

        for (Lab_Sample_Tape_Code__c record : records) {
            Lab_Sample__c labSampleRecord = labSamplesMap.get(record.Lab_Sample__c);
            if (labSampleRecord.Case__r.Claim_Stage__c == 'Closed') {
                record.addError('Lab Sample Tape Codes cannot be modified for a closed case');
            } else {
                record.addERror('Case Lab Samples cannot be modifed after submitting for approval');
            }
        }
    }

    /**
     * @description Populate the PRM field on the Lab Sample
     *
     * @param labSampleTapeCodeMap new Map of triggered Lab Sample Tape Code
     */
    public static void populateLabSamplePRMField(final Map<Id, Lab_Sample_Tape_Code__c> labSampleTapeCodeMap) {

        Set<Id> labSampleIds = new Set<Id>();
        for (Lab_Sample_Tape_Code__c labSampleTapeCode : labSampleTapeCodeMap.values()) {
            if (labSampleTapeCode.Lab_Sample__c != NULL && labSampleTapeCode.Tape_Code__c != NULL && labSampleTapeCode.Manufacture_Date__c != NULL) {
                labSampleIds.add(labSampleTapeCode.Lab_Sample__c);
            }
        }

        if (labSampleIds.isEmpty()) {
            return;
        }

        List<Lab_Sample__c> labSamples = [
                SELECT Id, Case_Open_Date__c, PRM__c
                FROM Lab_Sample__c
                WHERE Id IN :labSampleIds
        ];

        if (labSamples.isEmpty()) {
            return;
        }

        LabSampleService.populateLabSamplePRMField(labSamples, 'Sample_Description');

    } // end populateLabSamplePRMField method

    /**
     * @description populates the Sample Recent Manufacture Date on Lab Sample with the recent manufacture date
     *      of Lab Sample Tape Code
     *
     * @param labSampleTapeCodes new list of Sample Taple Code records
     */
    public static void populateLabSampleRecentManufactureDate(final List<Lab_Sample_Tape_Code__c> labSampleTapeCodes) {

        Set<Id> labSamplesIds = new Set<Id>();
        for (Lab_Sample_Tape_Code__c labSampleTapeCode : labSampleTapeCodes) {
            //&& labSampleTapeCode.Manufacture_Date__c != NULL
            if (labSampleTapeCode.Lab_Sample__c != NULL && labSampleTapeCode.Tape_Code__c != NULL) {
                labSamplesIds.add(labSampleTapeCode.Lab_Sample__c);
            }
        }

        if (labSamplesIds.isEmpty()) {
            return;
        }

        // this map contains all Lab Sample Ids with the most recent date of the Lab Sample Tape Code
        Map<Id, String> manufactureDateByLabSampleIds = new Map<Id, String>();
        List<Lab_Sample_Tape_Code__c> allLabSampleTapeCodes = [
                SELECT Id, Manufacture_Date__c, Lab_Sample__c
                FROM Lab_Sample_Tape_Code__c
                WHERE Lab_Sample__c IN :labSamplesIds AND
                (Manufacture_Date__c != 'Z' OR Manufacture_Date__c != NULL)
                ORDER BY Manufacture_Date__c DESC // Get the recent Manufacture Date
        ];

        if (allLabSampleTapeCodes.isEmpty()) {
            for (Id labSampleId : labSamplesIds) {
                manufactureDateByLabSampleIds.put(labSampleId, NULL);
            }
        } else {
            for (Lab_Sample_Tape_Code__c labSampleTapeCode : allLabSampleTapeCodes) {
                if (!manufactureDateByLabSampleIds.containsKey(labSampleTapeCode.Lab_Sample__c)) {
                    manufactureDateByLabSampleIds.put(labSampleTapeCode.Lab_Sample__c, labSampleTapeCode.Manufacture_Date__c);
                }
            }
        }

        if (manufactureDateByLabSampleIds.isEmpty()) {
            return;
        }

        Map<Id, Lab_Sample__c> toUpdate = new Map<Id, Lab_Sample__c>();
        for (Lab_Sample__c labSample : [SELECT Id, Recent_Manufacture_Date__c FROM Lab_Sample__c WHERE Id IN :manufactureDateByLabSampleIds.keySet()]) {
            String manufactureDate = manufactureDateByLabSampleIds.get(labSample.Id);
            if (manufactureDate != 'Z') {
                labSample.Recent_Manufacture_Date__c = manufactureDate == NULL ? NULL : Date.valueOf(manufactureDate);
                toUpdate.put(labSample.Id, labSample);
            }
        }

        if (toUpdate.isEmpty()) {
            return;
        }

        Database.update(toUpdate.values(), false);


    } // end populateLabSampleRecentManufactureDate method
}