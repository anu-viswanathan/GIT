public with sharing class LabSampleService {


    // Used to generate a sequence number for the Sequence Number value;
    // uses the prefix of the Case’s Claim Number (e.g. USRES, CACOM)
    // Runs only as a Before Insert which means if the cases sector changes, this will not
    public static void setSequencePrefix(List<Lab_Sample__c> records) {
        Set<Id> caseIds = new Set<Id>();

        for (Lab_Sample__c labSample : records) {
            caseIds.add(labSample.Case__c);
        }

        Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id, Claim_Number__c FROM Case WHERE Id IN :caseIds]);
        for (Lab_Sample__c labSample : records) {
            Case c = caseMap.get(labSample.Case__c);
            if (c.Claim_Number__c != NULL) {
                List<String> claimNumberSegments = c.Claim_Number__c.split('-');
                labSample.Sequence_Prefix__c = claimNumberSegments[0];
            } else {
                return;
            }
        }
    }

    //  Used to generate a Sample Number value, by determining a sequence number
    //  (based on the highest existing sequence for the prefix set above) and
    //  generates a value in the format
    //  {CountryCode}{SectorCode}-{Sequence Number}-{YY}, e.g.
    //  •	CARES-1005-19
    //  •	USRES-1004-19
    //  •	CACOM-1002-19
    //    The sequence numbers reset annually to 0001
    //  Runs as Before Insert and Before Update trigger
    public static void setSampleNumber(List<Lab_Sample__c> records, Map<Id, Lab_Sample__c> oldRecords) {
		System.Debug('Records: ' + records);
        System.debug('Old Records: ' + oldRecords);
        List<Lab_Sample__c> labSamplesToUpdate = new List<Lab_Sample__c>();

    	// Runs when: Sample Number is Emmty, Generate Sample Number is checked and Claim State is in Lab
    	// And the Lab Sample is not in the list of old Lab Samples
    	// or the record IS but the generate lab sample if false
        for (Lab_Sample__c labSample : records) {
            if (labSample.Sample_Number__c == NULL &&
                    labSample.Generate_Sample_Number__c == true && labSample.Claim_Stage__c == 'In Lab' &&
                    (oldRecords.get(labSample.Id) == NULL || oldRecords.get(labSample.Id).Generate_Sample_Number__c == false)) {
                labSamplesToUpdate.add(labSample);
            }
        }

        // if nothing fits our criteria, stop
        if (labSamplesToUpdate.isEmpty()) {
            return;
        }

        // Get the current year and turn it into two digits
        Integer year = Integer.valueOf(String.valueOf(Date.today().year()).right(2));

		// Returns a list of the highest number for a give prefix
		// Interestingly this doesn't seem to exist for any year prior to 2017
		// e.g. 
		// AURES    1 
		// CARES    60
		// USRES    141
        AggregateResult[] groupedResults = [
                SELECT Sequence_Prefix__c, MAX(Sequence_Number__c)
                FROM Lab_Sample__c
                WHERE Year__c = :year AND Sequence_Prefix__c != NULL AND Sequence_Number__c != NULL
                AND (Legacy_Id__c = NULL OR CreatedDate = TODAY)
                GROUP BY Sequence_Prefix__c
        ];

        // Turn the sequences into a map with the highest number as the value
        Map<String, Integer> sequenceMap = new Map<String, Integer>();

        for (AggregateResult ar : groupedResults) {
            sequenceMap.put(String.valueOf(ar.get('Sequence_Prefix__c')), Integer.valueOf(ar.get('expr0')));
        }

        for (Lab_Sample__c labSample : labSamplesToUpdate) {
            labSample.Year__c = year;
            Integer currentSequence = (sequenceMap.get(labSample.Sequence_Prefix__c) <> null) ?
                    sequenceMap.get(labSample.Sequence_Prefix__c) :
                    0;
            currentSequence++;

            labSample.Sequence_Number__c = currentSequence;
            labSample.Sample_Number__c = LabSampleService.generateSampleNumber(labSample);
            sequenceMap.put(labSample.Sequence_Prefix__c, currentSequence);
        }
    }

    public static String generateSampleNumber(Lab_Sample__c labSample) {
        String sequenceNumber = String.valueOf(labSample.Sequence_Number__c);
        while (sequenceNumber.length() < 5)
            sequenceNumber = '0' + sequenceNumber;
        String year = String.valueOf(labSample.Year__c).split('\\.')[0];
        return labSample.Sequence_Prefix__c + '-' + sequenceNumber + '-' + year;
    }

    public static void generateLabTestResults(List<Lab_Sample__c> records, Map<Id, Lab_Sample__c> oldRecords) {
        User runningUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
        //CLAIMS - 359
        //CLAIMSV2-730 no longer assigning queue id to owner id. 
        //List<QueueSobject> queueIds = [SELECT QueueId, Queue.Name, SobjectType FROM QueueSobject WHERE Queue.Name = 'Lab Test Queue'];

        List<Lab_Sample__c> labSamplesToUpdate = new List<Lab_Sample__c>();
        Set<Id> caseIds = new Set<Id>();

        // Determine the Lab Samples that require test generation, long with the related Case Ids
        for (Lab_Sample__c labSample : records) {
            if (labSample.Generate_Tests__c &&
                    (oldRecords.get(labSample.Id) == null || oldRecords.get(labSample.Id).Generate_Tests__c == false)) {
                if (runningUser.Profile.Name.contains('Claims')) {
                    labSample.addError('You are not allowed to generate tests');
                } else {
                    labSamplesToUpdate.add(labSample);
                    caseIds.add(labSample.Case__c);
                }
            }
        }
        if (labSamplesToUpdate.isEmpty()) {
            return;
        }

        /*
            Build map of Cases to their Primary Claim Type, along with a list of Secondary Types to query on
        */
        Map<Id, Claim_Type__c> claimTypeMap = new Map<Id, Claim_Type__c>();
        Set<String> claimTypeReasons = new Set<String>();
        for (Claim_Type__c claimType : [
                SELECT Id, Case__c, Concern__c
                FROM Claim_Type__c
                WHERE Case__c IN :caseIds
                AND Is_Primary__c = TRUE
        ]) {
            claimTypeMap.put(claimType.Case__c, claimType);
            if (!claimTypeReasons.contains(claimType.Concern__c)) {
                claimTypeReasons.add(claimType.Concern__c);
            }
        }

        if (claimTypeReasons.isEmpty()) {
            return;
        }

        /*
            Build a map of Secondary Types (the reason for the Claim) and the list of required Lab Test records
        */
        Map<String, List<Lab_Test__c>> labTestMap = new Map<String, List<Lab_Test__c>>();

        String claimTypeReasonStr = String.join(new List<String>(claimTypeReasons), '\',\'');
        String query = 'SELECT Id, Test_Description__c, Test_Reason__c FROM Lab_Test__c WHERE Test_Reason__c INCLUDES  (\'' + claimTypeReasonStr + '\')';

        for (Lab_Test__c labTest : Database.query(query)) {
            if (labTest.Test_Reason__c <> null) {
                for (String reason : labTest.Test_Reason__c.split(';')) {
                    List<Lab_Test__c> labTests = labTestMap.get(reason) <> null ? labTestMap.get(reason) : new List<Lab_Test__c>();
                    labTests.add(labTest);
                    labTestMap.put(reason, labTests);
                }
            }
        }

        if (labTestMap.isEmpty()) {
            return;
        }

        /*
            Now generate the Lab Test Result records
        */
        List<Lab_Test_Result__c> labTestResults = new List<Lab_Test_Result__c>();
        for (Lab_Sample__c labSample : labSamplesToUpdate) {
            if (claimTypeMap.get(labSample.Case__c) <> null) {
                Claim_Type__c claimType = claimTypeMap.get(labSample.Case__c);

                if (labTestMap.get(claimType.Concern__c) <> null) {
                    for (Lab_Test__c labTest : labTestMap.get(claimType.Concern__c)) {
                        //Queue assignment & TestStatus added as a part of CLAIMS -359
                        labTestResults.add(
                               // new Lab_Test_Result__c(Lab_Sample__c = labSample.Id, Lab_Test__c = labTest.Id,
                                 //       OwnerId = queueIds.get(0).QueueId, Test_Status__c = 'New')
                                 //   Jira ticket ClaimsV2-730 ownerID is no longer needed because lab sample master-detail relationship with lab Sample test result.Last modified by is used instead.
                                 new Lab_Test_Result__c(Lab_Sample__c = labSample.Id, Lab_Test__c = labTest.Id,
                                                        Test_Status__c = 'New')
                        );
                    }
                }
            }
        }
        Database.insert(labTestResults, false);
    }

    /*
        Block all updates for Case when the Claim_Stage__c is Closed, *unless* it is being re-opened
    */
    public static void blockCreatedUpdateDelete(List<Lab_Sample__c> records) {
        User runningUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];

        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        List<Id> caseIds = new List<Id>();

        for (Lab_Sample__c rp : records) {
            caseIds.add(rp.Case__c);
        }

        // SOQL query modified as part of US IWCN-723
        Map<Id, Case> caseMap = new Map<Id, Case>(
        [
                select Id, RecordTypeId, Claim_Stage__c, Claim_Sub_Stage__c, ClaimApproved__c
                from Case
                where Id IN :caseIds
                AND RecordTypeId IN :claimRecordTypes.keySet()
                AND
                (Claim_Stage__c = 'Closed' OR
                ClaimApproved__c = TRUE OR
                (Claim_Stage__c = 'Assessment' AND Claim_Sub_Stage__c = 'In Approval')
                )
        ]
        );

        if (caseMap.isEmpty()) {
            return;
        }

        for (Lab_Sample__c rp : records) {
            Case caseRecord = caseMap.get(rp.Case__c);
            if (runningUser.Profile.Name != 'System Administrator'
                && runningUser.Profile.Name != 'IKO Power User') {
                if (caseRecord.Claim_Stage__c == 'Closed') {
                    rp.addError('Lab Samples cannot be modified for a closed case');
                } else {
                    rp.addError('Case Lab Samples cannot be modifed after submitting for approval');
                }
            }
        }
    }

    /**
     * @description Populate the PRM field which indicate if the Lab Sample needs to be sent to the Plant based on the criteria
     * If the Case Created Date is within one year of the Case Installation Date
     * OR
     * If any Tape Code that meets this criteria - Case Created Date - Manufactured Date less than 365 days
     *
     * @param newLabSamples List data structure of newly created or updated Lab Sample records
     */
    public static void populateLabSamplePRMField(List<Lab_Sample__c> newLabSamples, final String objectName) {

        Map<Id, Lab_Sample__c> toUpdate = new Map<Id, Lab_Sample__c>();

        // Map of Lab Samples to collect the records that matches the PRM conditions (as described in method definition)
        // Map for Case Create Date is within a year from Case Installation Date
        Map<Id, Lab_Sample__c> labSamplesByIdsCaseMap = new Map<Id, Lab_Sample__c>();
        if (objectName == 'Case' || objectName == 'Lab_Sample') {
            labSamplesByIdsCaseMap = labSamplesWhenCaseCreateDateSubtractedByInstallationDateIsLess365(newLabSamples);
            toUpdate = updatePRMFieldWhenObjectNameIsCaseOrSampleDescription(labSamplesByIdsCaseMap, newLabSamples);
        }

        // Map for Case Created Date - Tape Code Manufacture Date is less than 365 days
        Map<Id, Lab_Sample__c> labSamplesByIdsTapeCodeMap = new Map<Id, Lab_Sample__c>();
        if (objectName == 'Sample_Description' || objectName == 'Lab_Sample') {
            labSamplesByIdsTapeCodeMap = labSamplesWhenCaseCreatedDateSubtractedByTapeCodeManufactureDateIsLess365(newLabSamples);
            toUpdate = updatePRMFieldWhenObjectNameIsCaseOrSampleDescription(labSamplesByIdsTapeCodeMap, newLabSamples);
        }

        if (objectName == 'Lab_Sample') {
            // copy all the mappings from labSamplesByIdsCaseMap to labSamplesByIdsTapeCodeMap
            labSamplesByIdsTapeCodeMap.putAll(labSamplesByIdsCaseMap);

            // update the Lab Sample PRM field to true
            for (Lab_Sample__c labSample : newLabSamples) {
                if (labSamplesByIdsTapeCodeMap.containsKey(labSample.Id)) {
                    labSample.PRM__c = true;
                }
            }
        } else {
            Database.update(toUpdate.values(), false);
        }

    } // end populateLabSamplePRMField method

    /**
     *
     *
     * @param newLabSamples
     *
     * @return
     */
    private static Map<Id, Lab_Sample__c> labSamplesWhenCaseCreateDateSubtractedByInstallationDateIsLess365(final List<Lab_Sample__c> newLabSamples) {

        // Map of Lab Samples to collect the records that matches the PRM conditions (as described in method definition)
        Map<Id, Lab_Sample__c> labSamplesByIds = new Map<Id, Lab_Sample__c>();

        // find out if Case Created Date is within one year of the Case Installation Date
        for (Lab_Sample__c labSample : newLabSamples) {
            Date caseInstallationDate = labSample.Case_Installation_Date__c;
            Datetime caseOpenDateTime = labSample.Case_Open_Date__c;

            if (caseInstallationDate != NULL && caseOpenDateTime != NULL) {
                Date caseOpenDate = Date.newInstance(caseOpenDateTime.year(), caseOpenDateTime.month(), caseOpenDateTime.day());
                Integer daysBetweenCaseOpenAndInstallationDates = caseInstallationDate.daysBetween(caseOpenDate);

                Integer numberOfDaysInYear = getNumberOfDaysInYear(caseOpenDate.year(), caseInstallationDate.year());
                if (daysBetweenCaseOpenAndInstallationDates <= numberOfDaysInYear && caseInstallationDate <= caseOpenDate) {
                    if (!labSamplesByIds.containsKey(labSample.Id)) {
                        labSamplesByIds.put(labSample.Id, labSample);
                    }
                }
            }
        }

        if (labSamplesByIds.isEmpty()) {
            return new Map<Id, Lab_Sample__c>();
        }

        return labSamplesByIds;
    } // end labSamplesWhenCaseCreateDateSubtractedByInstallationDateIsLess365 method

    /**
     *
     *
     * @param newLabSamples
     *
     * @return
     */
    private static Map<Id, Lab_Sample__c> labSamplesWhenCaseCreatedDateSubtractedByTapeCodeManufactureDateIsLess365(final List<Lab_Sample__c> newLabSamples) {

        // Map of Lab Samples to collect the records that matches the PRM conditions (as described in method definition)
        Map<Id, Lab_Sample__c> labSamplesByIds = new Map<Id, Lab_Sample__c>();

        // find out if Case Created Date - Sample Description Manufactured Date is less than 365 days
        for (Lab_Sample__c labSample : [
                SELECT Id, Case_Open_Date__c, (
                        SELECT Id, Tape_Code__r.Manufacture_Date__c, Tape_Code__c
                        FROM Lab_Sample_Tape_Codes__r
                        WHERE Tape_Code__r.Manufacture_Date__c != NULL AND
                        Tape_Code__c != NULL
                )
                FROM Lab_Sample__c
                WHERE Id IN :newLabSamples AND
                Case_Open_Date__c != NULL
        ]) {
            if (!labSample.Lab_Sample_Tape_Codes__r.isEmpty()) {

                Datetime caseOpenDateTime = labSample.Case_Open_Date__c;
                Date caseOpenDate = Date.newInstance(caseOpenDateTime.year(), caseOpenDateTime.month(), caseOpenDateTime.day());

                for (Lab_Sample_Tape_Code__c labSampleTapeCode : labSample.Lab_Sample_Tape_Codes__r) {
                    if (labSampleTapeCode.Tape_Code__r.Manufacture_Date__c != NULL) {
                        Datetime tapeCodeManufactureDateTime = labSampleTapeCode.Tape_Code__r.Manufacture_Date__c;
                        Date tapeCodeManufactureDate = Date.newInstance(tapeCodeManufactureDateTime.year(), tapeCodeManufactureDateTime.month(), tapeCodeManufactureDateTime.day());

                        Integer daysBetweenCodeManufactureAndCaseOpenDates = tapeCodeManufactureDate.daysBetween(caseOpenDate);
                        Integer numberOfDaysInYear = getNumberOfDaysInYear(caseOpenDate.year(), tapeCodeManufactureDate.year());

                        if (daysBetweenCodeManufactureAndCaseOpenDates <= numberOfDaysInYear && tapeCodeManufactureDate <= caseOpenDate) {
                            if (!labSamplesByIds.containsKey(labSample.Id)) {
                                labSamplesByIds.put(labSample.Id, labSample);
                            }
                        }
                    }
                }
            }
        }

        if (labSamplesByIds.isEmpty()) {
            return new Map<Id, Lab_Sample__c>();
        }

        return labSamplesByIds;

    } // end labSamplesWhenCaseCreatedDateSubtractedByTapeCodeManufactureDateIsLess365 method

    /**
     *
     *
     * @param labSamplesByIds
     * @param newLabSamples
     *
     * @return
     */
    private static Map<Id, Lab_Sample__c> updatePRMFieldWhenObjectNameIsCaseOrSampleDescription(Map<Id, Lab_Sample__c> labSamplesByIds, List<Lab_Sample__c> newLabSamples) {

        Map<Id, Lab_Sample__c> toUpdate = new Map<Id, Lab_Sample__c>();

        if (labSamplesByIds.isEmpty()) {
            for (Lab_Sample__c labSample : newLabSamples) {
                if (!toUpdate.containsKey(labSample.Id)) {
                    labSample.PRM__c = false;
                    toUpdate.put(labSample.Id, labSample);
                }
            }
        } else {
            for (Lab_Sample__c labSample : newLabSamples) {
                if (!toUpdate.containsKey(labSample.Id)) {
                    labSample.PRM__c = true;
                    toUpdate.put(labSample.Id, labSample);
                }
            }
        }

        if (toUpdate.isEmpty()) {
            return new Map<Id, Lab_Sample__c>();
        }

        return toUpdate;

    } // end updatePRMFieldWhenObjectNameIsCaseOrSampleDescription method

    /**
     *
     *
     * @param year
     *
     * @return
     */
    private static Integer getNumberOfDaysInYear(final Integer year1, final Integer year2) {
        if (Date.isLeapYear(year1) || Date.isLeapYear(year2)) {
            return 366;
        } else {
            return 365;
        }
    } // end getNumberOfDaysInYear method

    /**
     * CLAIMS -77
     * @description method to copy the parent Case Description on the Lab Sample
     * @param labSamplesByIds
     *
     * @return
     */
    public static void populateCaseDescriptionOnLabSample(final List<Lab_Sample__c> labSamplesByIds) {

        Set<Id> relatedCases = new Set<Id>();
        for (Lab_Sample__c labSample : labSamplesByIds) {
            relatedCases.add(labSample.Case__c);
        }

        if (relatedCases.isEmpty()) {
            return;
        }

        Map<Id, Case> cases = new Map<Id, Case>([SELECT Id, Description FROM Case WHERE Id IN :relatedCases]);

        for (Lab_Sample__c labSample : labSamplesByIds) {
            Case c = cases.get(labSample.Case__c);
            if (c.Description != NULL && c.Description != '') {
                labSample.Case_Description__c = c.Description;
            }

        }
        // CaseService.populateCaseDescriptionOnLabSample(cases, null);

    }

    /**
     * @description populate the Sample Received Date to Today's date when then the In Brampton is checked
     *      and the Sample Received Date is not populated
     *      Used in Before Insert and Before Update
     *
     * @param newLabSamples list of the new versions of the Lab Sample records.
     */
    public static void populateLabSampleReceivedDateToTodaysDate(List<Lab_Sample__c> newLabSamples) {

        for (Lab_Sample__c labSample : newLabSamples) {
            if (labSample.Received_Date_Brampton__c == NULL && labSample.In_Brampton__c) {
                labSample.Received_Date_Brampton__c = Date.today();
            }
        }
    }  // end populateLabSampleReceivedDateToTodaysDate method

    /**
     * CLAIMS - 83
     * @description method to initiate actions when InBrampton is set to True
     * @param newLabSamples
     * @param oldLabSamples
     * @return
     */
    public static void populateLabSampleOwnerWhenInBramptonIsChecked(List<Lab_Sample__c> newLabSamples) {

        Set<Id> caseIds = new Set<Id>();

        for (Lab_Sample__c labSample : newLabSamples) {
            if (labSample.Case__c != NULL && labSample.Generate_Sample_Number__c == false) {
                caseIds.add(labSample.Case__c);
            }
        }

        if (caseIds.isEmpty()) {
            return;
        }

        // Retrieve related cases
        Map<Id, Case> relatedCasesByIds = new Map<Id, Case>([
                SELECT Id, RecordType.Name, Sector__c,Claim_Stage__c, Claim_Sub_Stage__c, Account.BillingCountry, Account.BillingCountryCode
                FROM Case
                WHERE Id IN :caseIds
        ]);

        if (relatedCasesByIds.isEmpty()) {
            return;
        }

        List<QueueSobject> queuesList = [
                SELECT QueueId,Queue.Name,SobjectType
                FROM QueueSobject
                WHERE Queue.Name = 'Canadian Queue'
                OR Queue.Name = 'US Queue' OR Queue.Name = 'Blair/Hyload Queue'
                ORDER BY Queue.Name ASC
        ];

        if (queuesList.isEmpty()) {
            return;
        }

        for (Lab_Sample__c labSample : newLabSamples) {

            Case thisCase = relatedCasesByIds.get(labSample.Case__c);

            //re-assign Claim to Queue
            //claimsv2-730 this is no longer needed due to master detail relationship.
            /*
            if (thisCase.RecordType.Name == 'Residential Claim' && thisCase.Sector__c == 'CA') {
                //Assign to Canadian Queue
                labSample.OwnerId = queuesList.get(1).QueueId;

            } else if (thisCase.RecordType.Name == 'Commercial Claim' &&
                    (thisCase.Account.BillingCountry == 'Canada' || thisCase.Account.BillingCountryCode == 'CA') &&
                    thisCase.Sector__c == 'Commercial') {

                //Assign to Canadian Queue
                labSample.OwnerId = queuesList.get(1).QueueId;

            } else if (thisCase.RecordType.Name == 'Residential Claim' && thisCase.Sector__c == 'US') {

                //Assign to US Queue
                labSample.OwnerId = queuesList.get(2).QueueId;
            } else if (thisCase.RecordType.Name == 'Commercial Claim' &&
                    (thisCase.Account.BillingCountry == 'United States' || thisCase.Account.BillingCountryCode == 'US') &&
                    thisCase.Sector__c == 'Commercial') {
                //Assign to US Queue
                labSample.OwnerId = queuesList.get(2).QueueId;
            } else if (thisCase.RecordType.Name == 'Commercial Claim' &&
                    (thisCase.Sector__c == 'Blair' || thisCase.Sector__c == 'Hyload')) {
                //Assign to Blair/Hyload queue
                labSample.OwnerId = queuesList.get(0).QueueId;
            }
				
			*/ 
            

        }
    } // end populateLabSampleOwnerWhenInBramptonIsChecked method

    /**
    * CLAIMS - 83
    * @description method to initiate actions on related Case when InBrampton is set to True
    * @param newLabSamples
    * @param oldLabSamples
    * @return
    */
    public static void initiateActionsOnCaseWhenInBramptonSetTrue(final List<Lab_Sample__c> newLabSamples, final Map<Id, Lab_Sample__c> oldLabSamples) {

        Set<Id> caseIds = new Set<Id>();
        List<Case> casesToUpdate = new List<Case>();

        // related cases' Ids
        if (oldLabSamples != NULL) {
            for (Lab_Sample__c labSample : newLabSamples) {
                if ((labSample.In_Brampton__c != oldLabSamples.get(labSample.Id).In_Brampton__c && labSample.In_Brampton__c) &&
                        (labSample.Claim_Stage__c == 'Awaiting Docs' || labSample.Claim_Stage__c == 'In Kankakee')) {
                    caseIds.add(labSample.Case__c);
                }
            }
        } else {
            for (Lab_Sample__c labSample : newLabSamples) {
                if (labSample.In_Brampton__c && (labSample.Claim_Stage__c == 'Awaiting Docs' || labSample.Claim_Stage__c == 'In Kankakee')) {
                    caseIds.add(labSample.Case__c);
                }
            }
        }

        if (caseIds.isEmpty()) {
            return;
        }

        for (Case thisCase : [
                SELECT Id,RecordType.Name,Sector__c,Claim_Stage__c,Claim_Sub_Stage__c
                FROM Case
                WHERE Id IN :caseIds
        ]) {
            thisCase.Claim_Stage__c = 'In Lab';
            thisCase.Claim_Sub_Stage__c = 'Samples Received';

            casesToUpdate.add(thisCase);
        }

        if (!casesToUpdate.isEmpty()) {
            Database.update(casesToUpdate, true);
        }
    }

    public static void changeCaseSubStageWhenStatusChanged(final List<Lab_Sample__c> newLabSamples, final Map<Id, Lab_Sample__c> oldMLabSamplesByIds) {

        Set<Id> inApprovalCaseIds = new Set<Id>();
        Set<Id> approvedCaseIds = new Set<Id>();
        Set<Id> declinedAndRecalledCaseIds = new Set<Id>();

        Map<Id, Case> toUpdate = new Map<Id, Case>();

        for (Lab_Sample__c labSample : newLabSamples) {
            String oldStatus = oldMLabSamplesByIds.get(labSample.Id).Status__c;

            if (oldStatus != 'In Approval' && labSample.Status__c == 'In Approval') {
                inApprovalCaseIds.add(labSample.Case__c);
            } else if (oldStatus != 'Approved' && labSample.Status__c == 'Approved') {
                approvedCaseIds.add(labSample.Case__c);
            } else if ((oldStatus != 'Declined' && labSample.Status__c == 'Declined') ||
                    (oldStatus != 'Analysis' && labSample.Status__c == 'Analysis')) {
                declinedAndRecalledCaseIds.add(labSample.Case__c);
            }
        }

        if (!inApprovalCaseIds.isEmpty()) {
            for (Case caseRecord : [SELECT Id, Claim_Sub_Stage__c FROM Case WHERE Id IN :inApprovalCaseIds]) {
                caseRecord.Claim_Sub_Stage__c = 'In Approval';
                toUpdate.put(caseRecord.Id, caseRecord);
            }
        }

        if (!approvedCaseIds.isEmpty()) {
            for (Case caseRecord : [SELECT Id, Claim_Stage__c, Claim_Sub_Stage__c FROM Case WHERE Id IN :approvedCaseIds]) {
                caseRecord.Claim_Stage__c = 'File Preparation';
                caseRecord.Claim_Sub_Stage__c = 'Data Entry';
                toUpdate.put(caseRecord.Id, caseRecord);
            }
        }

        if (!declinedAndRecalledCaseIds.isEmpty()) {
            for (Case caseRecord : [SELECT Id, Claim_Sub_Stage__c FROM Case WHERE Id IN :declinedAndRecalledCaseIds]) {
                caseRecord.Claim_Sub_Stage__c = 'Analysis';
                toUpdate.put(caseRecord.Id, caseRecord);
            }
        }

        if (!toUpdate.isEmpty()) {
            Database.update(toUpdate.values(), true);
        }

    } // end changeCaseSubStageWhenStatusChanged method

    /**
     * @description Prevent Lab Sample record from being saved when In Brampton is checked
     *      and the Claim Stage is  neither Awaiting Docs or In Kankakee
     *
     * @param newLabSamples list of the new versions of the Lab Sample records.
     */
    public static void inBramptonCannotBeCheckedInSomeClaimStages(final List<Lab_Sample__c> newLabSamples, final Map<Id, Lab_Sample__c> oldLabSamplesByIds) {

        Set<Id> caseIds = new Set<Id>();
        for (Lab_Sample__c labSample : newLabSamples) {
            if (labSample.In_Brampton__c && labSample.Status__c != 'Approved') {
                caseIds.add(labSample.Case__c);
            }
        }

        if (caseIds.isEmpty()) {
            return;
        }

        Map<Id, Case> casesByIds = new Map<Id, Case>();
        for (Case caseRecord : [SELECT Id, Claim_Stage__c FROM Case WHERE Id IN :caseIds]) {
            if (caseRecord.Claim_Stage__c != 'Awaiting Docs' &&
                    caseRecord.Claim_Stage__c != 'In Kankakee' &&
                    caseRecord.Claim_Stage__c != 'In Lab') {
                casesByIds.put(caseRecord.Id, caseRecord);
            }
        }

        if (casesByIds.isEmpty()) {
            return;
        }

        for (Lab_Sample__c labSample : newLabSamples) {
            if (casesByIds.containsKey(labSample.Case__c)) {
                labSample.addError('The Claims Stage is incorrect, please contact the Claims Department.');
            }
        }
    } //  end inBramptonCannotBeCheckedInSomeClaimStages method

    /**
     * @description Prevent Lab Sample record from being saved when Generate Sample Number is checked
     *  and the Claim Stage is not In Lab.
     *
     * @param newLabSamples list of the new versions of the Lab Sample records.
     */
    public static void generateSampleNumberCannotBeCheckedInSomeClaimStages(final List<Lab_Sample__c> newLabSamples, final Map<Id, Lab_Sample__c> oldMapLabSamples) {

        Set<Id> caseIds = new Set<Id>();
        for (Lab_Sample__c labSample : newLabSamples) {
            if (oldMapLabSamples != NULL) {
                if (labSample.Generate_Sample_Number__c && !oldMapLabSamples.get(labSample.Id).Generate_Sample_Number__c) {
                    caseIds.add(labSample.Case__c);
                }
            } else {
                if (labSample.Generate_Sample_Number__c) {
                    caseIds.add(labSample.Case__c);
                }
            }
        }

        if (caseIds.isEmpty()) {
            return;
        }

        Map<Id, Case> casesByIds = new Map<Id, Case>();
        for (Case caseRecord : [SELECT Id, Claim_Stage__c FROM Case WHERE Id IN :caseIds]) {
            if (caseRecord.Claim_Stage__c != 'In Lab') {
                casesByIds.put(caseRecord.Id, caseRecord);
            }
        }

        if (casesByIds.isEmpty()) {
            return;
        }

        for (Lab_Sample__c labSample : newLabSamples) {
            if (casesByIds.containsKey(labSample.Case__c)) {
                labSample.addError('The Claims Stage is incorrect, please contact the Claims Department.');
            }
        }

    } // end generateSampleNumberCannotBeCheckedInSomeClaimStages method

    /**
     * @description Update value of Case PRM based on the value of Lab Sample PRM
     *
     * @param newLabSamples list of the new versions of the Lab Sample records.
     *        oldLabSamples map of the old versions of the Lab Sample records.
     */
    public static void updateCasePRMBasedOnLabSamplePRM(List<Lab_Sample__c> newLabSamples, Map<Id, Lab_Sample__c> oldLabSamples) {

        List<Case> casesToUpdate = new List<Case>();
        Set<Id> caseIds = new Set<Id>();

        //get related Case Ids
        for (Lab_Sample__c labSample : newLabSamples) {

            if (oldLabSamples.get(labSample.Id) != NULL && oldLabSamples.get(labSample.Id).PRM__c != labSample.PRM__c) {
                caseIds.add(labSample.Case__c);
            } else if (oldLabSamples.isEmpty())  //Will be applicable on insert
            {
                caseIds.add(labSample.Case__c);
            }
        }

        if (caseIds.isEmpty()) {
            return;
        }

        for (Case c : [
                SELECT Id,Lab_Sample_PRM__c, (SELECT Id,PRM__c FROM Lab_Samples__r)
                FROM Case
                WHERE Id IN :caseIds
        ]) {
            // loop over all children Lab Sample of the Case
            for (Lab_Sample__c ls : c.Lab_Samples__r) {
                if (!ls.PRM__c) {
                    c.Lab_Sample_PRM__c = FALSE;
                } else {
                    c.Lab_Sample_PRM__c = TRUE;
                    break;
                }
            }

            casesToUpdate.add(c);
        }
        if (!casesToUpdate.isEmpty()) {
            update casesToUpdate;
        }
    }
    
    /* Ticket CLAIMSV2-968
     * Added conditions to display error Message when submitting record for Approval,
     * By: Vicki Tran June 16, 2020
     */
    public static void validateLabApprovalSubmission(List<Lab_Sample__c> labSampleList, Map<Id, Lab_Sample__c> labSampleOldMap) {
        String errMsg = '';
        
        Set<Id> caseIds = new Set<Id>();
        
        for(Lab_Sample__c l : labSampleList) { 
            caseIds.add(l.Case__c);
            
        }
       
        List<Case> allCases = new List<Case>([SELECT Id, Claim_Stage__c FROM Case WHERE Id IN :caseIds]);
        
        Map<Id, Case> caseByCaseId = new Map<Id, Case>();
        for(Case c : allCases) {
            caseByCaseId.put(c.Id, c);
        }
        
        
        for(Lab_Sample__c thisLabSample : labSampleList) {
            Lab_Sample__c oldLabSample = labSampleOldMap.get(thisLabSample.id);
            System.debug('Old lab sample status: ' + oldLabSample.Status__c);
            if(caseByCaseId.containsKey(thisLabSample.Case__c) == true && caseByCaseId.get(thisLabSample.Case__c).Claim_Stage__c == 'In Lab') 
            {
                
                if (thisLabSample.Status__c == 'In Approval')
                {
                    if (thisLabSample.Total_Lab_Test_Result_Completed__c != thisLabSample.Total_Number_of_Lab_Test_Result__c)
                    {
                        errMsg += 'Cannot submit for approval. Total Lab Test Result Completed does not equal to Total Number of Lab Test Result.';
                        System.debug('Total_Lab_Test_Result_Completed = ' + thisLabSample.Total_Lab_Test_Result_Completed__c + ' lab: ' + thisLabSample.Name);
                        System.debug('Total_Number_of_Lab_Test_Result__c = ' + thisLabSample.Total_Number_of_Lab_Test_Result__c + ' lab: ' + thisLabSample.Name);
                    }
                    if (thisLabSample.PRM__c == true && thisLabSample.Disposition_Plant__c == null)
                    {
                        errMsg += 'Cannot submit for approval. PRM field is checked but no value selected for Plant Disposition.';
                        System.debug('PRM__c = ' + thisLabSample.PRM__c + ' lab: ' + thisLabSample.Name);
                        System.debug('Disposition_Plant__c = ' + thisLabSample.Disposition_Plant__c + ' lab: ' + thisLabSample.Name);
                        
                    }
                }
                
                
            }
            
            
            if(String.isNotBlank(errMsg)) {
                thisLabSample.addError(errMsg);
            }
		
        }

    }
}