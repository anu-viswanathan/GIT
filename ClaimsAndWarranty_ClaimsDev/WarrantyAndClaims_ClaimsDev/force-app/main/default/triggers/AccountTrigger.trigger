trigger AccountTrigger on Account (before insert, before update, before delete,
        after insert, after update, after delete, after undelete) {

    if (System.Trigger.IsBefore && System.Trigger.IsInsert) {
        AccountService.populateIkoDivisionType(System.Trigger.new);
        AccountService.generateRegistrationNumber(System.Trigger.new, new Map<Id, Account>());
        AccountService.validateBuildingLocationAccountsWithNotInDraftCaseStatus(System.Trigger.new);
        AccountService.populateRecordTypeFamilyForRoofProAccount(System.Trigger.New, new Map<Id, Account>());
    }

    // ClaimsV2-1015, by Anil Mannem (Incloud), doesn`t need to send records to approval automatically
    // if (System.Trigger.isAfter && System.Trigger.IsInsert) {
    //     AccountService.sendUnverifiedBuildingLocationToApproval(System.Trigger.new);
    // }

    if (System.Trigger.IsBefore && System.Trigger.IsUpdate) {
        AccountService.populateIkoDivisionType(System.Trigger.new);
        AccountService.sendUnverifiedBuildingLocationToApproval(System.Trigger.new, System.Trigger.oldMap);
        AccountService.generateRegistrationNumber(System.Trigger.new, System.Trigger.oldMap);
        AccountService.validateBuildingLocationAccountsWithNotInDraftCaseStatus(System.Trigger.new);
        AccountService.populateRecordTypeFamilyForRoofProAccount(System.Trigger.New, System.Trigger.oldMap);
        /* ClaimsV2-828 - Update the address verfication status if the billing address is saved by Melissa Data Service */
        AccountService.UpdateAddressVerificationStatus(System.Trigger.new, System.Trigger.oldMap);
    }

    if (System.Trigger.isAfter && System.Trigger.IsUpdate) {
        CaseSharingRulesUtility.afterUpdateAccounts(System.Trigger.new, System.Trigger.oldMap);
        // AccountService.sendUnverifiedBuildingLocationToApproval(System.Trigger.new);
        AccountService.populateParentBuildingAccountFieldOnCase(System.Trigger.new, System.Trigger.oldMap);
        // ClaimsV2-1010, by Anil Mannem (Incloud), needs to update Claim TaxRates when BillingState changed
        CaseService.updateTaxRateOnBillingStateChange(System.Trigger.new, System.Trigger.oldMap);
    }
}