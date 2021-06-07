trigger CaseTrigger on Case (before insert, before update, before delete,
        after insert, after update, after delete, after undelete) {

    if (System.Trigger.IsBefore && System.Trigger.IsInsert) {
        CaseSharingRulesUtility.beforeInsertCases(System.Trigger.new);
        CaseService.populateCaseCreatedByUserRoleField(System.Trigger.new);
        CaseService.calculateCasePriorityScore(System.Trigger.new);
        CaseService.catchDuplicate(System.Trigger.new);
        CaseService.setGoodwillHierarchy(System.Trigger.new);
        CaseService.setTaxRate(System.Trigger.new, null);

        CaseService.checkValidationForDecra(System.Trigger.new, null, true);
        //CLAIMS - 667 
        CaseService.populateParentBuildingAccountFieldOnCase(System.Trigger.new);
    }

    if (System.Trigger.IsBefore && System.Trigger.IsUpdate) {
        CaseSharingRulesUtility.beforeUpdateCases(System.Trigger.new, System.Trigger.oldMap);
        CaseService.allowOnlyClaimsManagerToUpdateClaimsStage(System.Trigger.new, System.Trigger.oldMap);
        CaseService.changeCaseOwnerWhenClaimInLitigation(System.Trigger.new, System.Trigger.oldMap);
        CaseService.calculateCasePriorityScore(System.Trigger.new);
        CaseService.setGoodwillHierarchy(System.Trigger.new);
        CaseService.closeClaimCase(System.Trigger.new, System.Trigger.oldMap);
        CaseService.blockCaseUpdate(System.Trigger.new, System.Trigger.oldMap);
        CaseService.sendCaseToQueueOnSubmission(System.Trigger.new, System.Trigger.oldMap);
        CaseService.blockSelfApprovalOfClaim(System.Trigger.new, System.Trigger.oldMap, System.Trigger.newMap);
        CaseService.catchDuplicate(System.Trigger.new);
        CaseService.setLabourRate(System.Trigger.new);
        CaseService.setTaxRate(System.Trigger.new, System.Trigger.oldMap);
        CaseService.updateClaimApprover(System.Trigger.new, System.Trigger.oldMap);
        CaseService.resetSettlementTypeToDefault(System.Trigger.new, System.Trigger.oldMap);
        CaseService.calculateSettlementPayment(System.Trigger.new);
        CaseService.postChatterForClaimApprovalProcesses(System.Trigger.newMap, System.Trigger.oldMap);
		
        CaseService.checkValidationForDecra(System.Trigger.new, System.Trigger.oldMap, false);
        //CLAIMS - 667
        CaseService.populateParentBuildingAccountFieldOnCase(System.Trigger.new);

        // CLAIMSVS-780
        // Process builder Settlement Goodwill Offer Text is firing and causing problems. Replace it with a before insert trigger
        // (Process builder's fire AFTER)
        List<Case> settlementGoodwill = new List<Case>();
            For(Case c : Trigger.new) {
                if(c.Claim_Stage__c != 'Draft' && c.Claim_Stage__c != 'Submitted' && c.Claim_Stage__c != 'Closed') { settlementGoodwill.add(c); }
            }
	        Case_TriggerHandler.settlementGoodwillOfferText(settlementGoodwill);
            System.debug('SOQL Limits :'+Limits.getQueries()+' - '+Limits.getLimitQueries() );
        system.debug('******Leaving CaseTrigger - BeforeUpdate');
    }

    if (System.Trigger.IsBefore && System.Trigger.IsDelete) {
        CaseService.blockClaimCaseDeletion(System.Trigger.old);
    }

    if (System.Trigger.IsAfter && System.Trigger.IsUpdate) {
        CaseService.resetClaimCaseOwnerToQueue(System.Trigger.new, System.Trigger.oldMap);
        CaseService.populateLabSamplePRMField(System.Trigger.newMap, System.Trigger.oldMap);
        CaseService.populateCaseDescriptionOnLabSample(System.Trigger.newMap, System.Trigger.oldMap);
        CaseService.claimSubmissionEmailNotification(System.Trigger.new, System.Trigger.oldMap);
    }

}