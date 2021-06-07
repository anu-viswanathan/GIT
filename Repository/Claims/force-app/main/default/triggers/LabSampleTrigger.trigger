trigger LabSampleTrigger on Lab_Sample__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	/* Ticket CLAIMSV2-969
                * Remove this trigger because users want to be able to edit non-disposition fields even if the case is closed.
                * By: Vicki Tran on 26-June-2020
                */
    /*
    if (System.Trigger.isBefore) {
        LabSampleService.blockCreatedUpdateDelete(System.Trigger.IsDelete ? System.Trigger.old : System.Trigger.new);
    }
   */


    if (System.Trigger.IsBefore && System.Trigger.IsInsert) {
        LabSampleService.inBramptonCannotBeCheckedInSomeClaimStages(System.Trigger.new, NULL);
        LabSampleService.generateSampleNumberCannotBeCheckedInSomeClaimStages(System.Trigger.new,NULL);
        LabSampleService.populateLabSampleReceivedDateToTodaysDate(System.Trigger.new);
        LabSampleService.populateLabSampleOwnerWhenInBramptonIsChecked(System.Trigger.new);
        LabSampleService.initiateActionsOnCaseWhenInBramptonSetTrue(System.Trigger.new, NULL);
        LabSampleService.setSequencePrefix(System.Trigger.new);
        LabSampleService.setSampleNumber(System.Trigger.new, new Map<Id, Lab_Sample__c>());
        LabSampleService.populateCaseDescriptionOnLabSample(System.Trigger.new);
        LabSampleService.populateLabSamplePRMField(System.Trigger.new, 'Lab_Sample');
    }

    if (System.Trigger.isAfter && System.Trigger.IsInsert) {
        LabSampleService.generateLabTestResults(System.Trigger.new, new Map<Id, Lab_Sample__c>());
        //CLAIMS -77

        //FeedItemService.bringDownCaseChatterFeedToLabSample(System.Trigger.new);
        LabSampleService.updateCasePRMBasedOnLabSamplePRM(System.Trigger.new , new Map<Id, Lab_Sample__c>());
    }

    if (System.Trigger.IsBefore && System.Trigger.IsUpdate) {
        LabSampleService.inBramptonCannotBeCheckedInSomeClaimStages(System.Trigger.new, System.Trigger.oldMap);
        LabSampleService.generateSampleNumberCannotBeCheckedInSomeClaimStages(System.Trigger.new,System.Trigger.oldMap);
        LabSampleService.setSampleNumber(System.Trigger.new, System.Trigger.oldMap);
        LabSampleService.populateLabSamplePRMField(System.Trigger.new, 'Lab_Sample');
        LabSampleService.populateLabSampleReceivedDateToTodaysDate(System.Trigger.new);
        LabSampleService.populateLabSampleOwnerWhenInBramptonIsChecked(System.Trigger.new);
        LabSampleService.changeCaseSubStageWhenStatusChanged(System.Trigger.new, System.Trigger.oldMap);

    }

    if (System.Trigger.isAfter && System.Trigger.IsUpdate) {
        LabSampleService.generateLabTestResults(System.Trigger.new, System.Trigger.oldMap);
        LabSampleService.initiateActionsOnCaseWhenInBramptonSetTrue(System.Trigger.new,System.Trigger.oldMap);
        LabSampleService.updateCasePRMBasedOnLabSamplePRM(System.Trigger.new, System.Trigger.oldMap);
		/* Ticket CLAIMSV2-968
     	* Added conditions to display error Message when submitting record for Approval,
     	* By: Vicki Tran on 16-June-2020
     	*/
		LabSampleService.validateLabApprovalSubmission(System.Trigger.new, System.Trigger.oldMap);
    }
    
    
    

}