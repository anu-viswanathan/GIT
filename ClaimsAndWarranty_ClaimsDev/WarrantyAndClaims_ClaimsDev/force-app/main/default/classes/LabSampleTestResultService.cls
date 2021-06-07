public with sharing class LabSampleTestResultService {
    /*
        Block all updates for Case when the Claim_Stage__c is Closed, *unless* it is being re-opened
    */
    public static void blockCreatedUpdateDelete(List<Lab_Test_Result__c> records) {
        User runningUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
//
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        List<Id> caseIds = new List<Id>();

        List<Id> labSampleIds = new List<Id>();

        for (Lab_Test_Result__c record : records) {
            labSampleIds.add(record.Lab_Sample__c);
        }

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

        for (Lab_Test_Result__c record : records) {
            Lab_Sample__c labSampleRecord = labSamplesMap.get(record.Lab_Sample__c);
            System.debug('what is in labSampleRecord?'+labSampleRecord);
            if (labSampleRecord.Case__r.Claim_Stage__c == 'Closed' && runningUser.Profile.Name != 'System Administrator') {
                record.addError('Lab Sample Tape Codes cannot be modified for a closed case');
            } else {
                record.addError('Case Lab Samples cannot be modifed after submitting for approval');
            }
        }

    }

    /*
        CLAIMS -359
        Update Status field according to value in Test Result field
    */
    public static void updateOwnerIdAndStatusAccordingToTestResult(List<Lab_Test_Result__c> newLabTestResults) {

		//CLAIMS - 359
		if (newLabTestResults.isEmpty()) {
			return;
		}

        /* claimsV2-730 queue id is no longer assigned to owner Id due to the master detail relationship.
        List<QueueSobject> queueIds = [SELECT QueueId, Queue.Name, SobjectType FROM QueueSobject WHERE Queue.Name = 'Lab Test Queue'];
        if (queueIds.isEmpty()) {
            return;
        }
		*/
        for (Lab_Test_Result__c labTestResult : newLabTestResults) {
            //ClaimsV2-730 owner Id is not used anymore, master detail relationship.
          //  labTestResult.OwnerId = queueIds.get(0).QueueId;
            if (labTestResult.Test_Result__c != NULL &&
                    labTestResult.Test_Result__c != '' && labTestResult.Test_Status__c == 'New' //&&
                    //Condition for N/A added for CLAIMS - 514
                   /* !labTestResult.N_A__c*/) {
                labTestResult.Test_Status__c = 'Completed';
            } //else if - added for CLAIMS - 514
           /* else if(labTestResult.N_A__c){
                labTestResult.Test_Status__c = 'Not Required';
            }*/
        }
    }

    public static void countCompletedAndNotRequiredTestResultsForLabSample(List<Lab_Test_Result__c> newLabTestResults,
                                                                            Map<Id,Lab_Test_Result__c> oldLabTestResultMapByIds){

        Set<Id> labSampleIds = new Set<Id>();

        // For insert
        if(newLabTestResults!= NULL && oldLabTestResultMapByIds == NULL){
            for(Lab_Test_Result__c eachTestResult : newLabTestResults){
                labSampleIds.add(eachTestResult.Lab_Sample__c);
             }
        }
        //for delete
        else if(newLabTestResults == NULL && oldLabTestResultMapByIds != NULL){
            for(Lab_Test_Result__c eachTestResult : oldLabTestResultMapByIds.values()){
                labSampleIds.add(eachTestResult.Lab_Sample__c);
            }
        }
        //for update
        else{
            for(Lab_Test_Result__c eachTestResult : newLabTestResults){
                if(eachTestResult.Test_Status__c != oldLabTestResultMapByIds.get(eachTestResult.Id).Test_Status__c){
                    labSampleIds.add(eachTestResult.Lab_Sample__c);
                }
            }
        }

       if(labSampleIds.isEmpty()){
            return;
        }

        // retrieve LabSamples along with all related test results
        List<Lab_Sample__c> allSamplesWithRelatedResults = [SELECT Id,Eligible_for_Approval_submission__c,
                                                            (Select Id,Test_Status__c FROM Lab_Test_Results__r)
                                                            FROM Lab_Sample__c WHERE Id IN :labSampleIds];

        System.debug('@@@allSamplesWithRelatedResults--'+allSamplesWithRelatedResults);

        // retrieve test results which are 'Completed' or 'Not Required'
        AggregateResult[] groupedResult = [SELECT Lab_Sample__c,COUNT(Test_Status__c) FROM Lab_Test_Result__c
                                            WHERE (Lab_Sample__c IN :labSampleIds OR CreatedDate = TODAY) AND
                                            (Test_Status__c = 'Completed' OR Test_Status__c = 'Not Required') GROUP BY Lab_Sample__c];

        Map<Id,Integer> sequenceMap = new Map<Id, Integer>();
        for(AggregateResult agr : groupedResult){
            sequenceMap.put(String.valueOf(agr.get('Lab_Sample__c')),Integer.valueOf(agr.get('expr0')));
        }

        List<Lab_Sample__c> toUpdateLabSamples = new List<Lab_Sample__c>();

        for(Lab_Sample__c eachLabSample : allSamplesWithRelatedResults){

            Integer countOfEligibleTestResults = sequenceMap.get(eachLabSample.Id);

            System.debug('@@@countOfEligibleTestResults--'+countOfEligibleTestResults);
            System.debug('@@@eachLabSample.Lab_Test_Results__r.size()--'+eachLabSample.Lab_Test_Results__r.size());

            if(countOfEligibleTestResults == eachLabSample.Lab_Test_Results__r.size()){
                eachLabSample.Eligible_for_Approval_submission__c = TRUE;
                toUpdateLabSamples.add(eachLabSample);
            }else{
                eachLabSample.Eligible_for_Approval_submission__c = FALSE;
                toUpdateLabSamples.add(eachLabSample);
            }
        }

        if(!toUpdateLabSamples.isEmpty()){
            update toUpdateLabSamples;
        }

    }//countCompletedAndNotRequiredTestResultsForLabSample() end

}