trigger ClaimTypeTrigger on Claim_Type__c (before insert, before update, before delete, after insert,
        after update, after delete, after undelete) {

    if (System.Trigger.isBefore && System.Trigger.isInsert) {
        ClaimTypeService.setPrimary(System.Trigger.new);
        ClaimTypeService.blockCreatedUpdateDelete(System.Trigger.new);
    }

    if (System.Trigger.isBefore && System.Trigger.isUpdate) {
        ClaimTypeService.setPrimary(System.Trigger.new);
        ClaimTypeService.blockCreatedUpdateDelete(System.Trigger.new);
    }

    if (System.Trigger.isBefore && System.Trigger.isDelete) {
        ClaimTypeService.blockCreatedUpdateDelete(System.Trigger.old);
    }

    if (System.Trigger.isAfter && System.Trigger.isInsert) {
        // ClaimTypeService.setPrimaryTypeOnCaseRecords(Trigger.New);
        ClaimType_TriggerHandler.setPrimaryAndSecondary(Trigger.new, NULL);
    }

    if (System.Trigger.isAfter && System.Trigger.isUpdate) {
        // ClaimTypeService.setPrimaryTypeOnCaseRecords(Trigger.New);
        ClaimType_TriggerHandler.setPrimaryAndSecondary(Trigger.new, Trigger.oldMap);
    }

    if (System.Trigger.isAfter && System.Trigger.isDelete) {
        ClaimType_TriggerHandler.setPrimaryAndSecondary(Trigger.old, NULL);
    }

}