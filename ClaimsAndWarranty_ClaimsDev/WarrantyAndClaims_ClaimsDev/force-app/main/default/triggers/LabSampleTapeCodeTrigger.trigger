trigger LabSampleTapeCodeTrigger on Lab_Sample_Tape_Code__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if (System.Trigger.isBefore && System.Trigger.isInsert) {
		LabSampleTapeCodeService.blockCreatedUpdateDelete(System.Trigger.new);
	}

	if (System.Trigger.isBefore && System.Trigger.isUpdate) {
		LabSampleTapeCodeService.blockCreatedUpdateDelete(System.Trigger.new);
	}

	if (System.Trigger.isBefore && System.Trigger.isDelete) {
		LabSampleTapeCodeService.blockCreatedUpdateDelete(System.Trigger.old);
	}

	if (System.Trigger.isAfter && System.Trigger.isInsert) {
		LabSampleTapeCodeService.populateLabSamplePRMField(System.Trigger.newMap);
		LabSampleTapeCodeService.populateLabSampleRecentManufactureDate(System.Trigger.new);
	}

	if (System.Trigger.isAfter && System.Trigger.isUpdate) {
		LabSampleTapeCodeService.populateLabSamplePRMField(System.Trigger.newMap);
		LabSampleTapeCodeService.populateLabSampleRecentManufactureDate(System.Trigger.new);
	}

	if (System.Trigger.isAfter && System.Trigger.isDelete) {
		LabSampleTapeCodeService.populateLabSamplePRMField(System.Trigger.oldMap);
		LabSampleTapeCodeService.populateLabSampleRecentManufactureDate(System.Trigger.old);
	}

}