trigger LabTestResultTrigger on Lab_Test_Result__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	if(System.Trigger.isBefore){
		LabSampleTestResultService.blockCreatedUpdateDelete(System.Trigger.IsDelete ? System.Trigger.old : System.Trigger.new);

		if(System.Trigger.isUpdate || System.Trigger.isInsert){
			LabSampleTestResultService.updateOwnerIdAndStatusAccordingToTestResult(System.Trigger.new);
		}

	}

	if(System.Trigger.isAfter){
		if(System.Trigger.isInsert){
			LabSampleTestResultService.countCompletedAndNotRequiredTestResultsForLabSample(System.Trigger.new,NULL);
		}else if(System.Trigger.isUpdate){
			LabSampleTestResultService.countCompletedAndNotRequiredTestResultsForLabSample(System.Trigger.new,System.Trigger.oldMap);
		}else if(System.Trigger.isDelete){
			LabSampleTestResultService.countCompletedAndNotRequiredTestResultsForLabSample(NULL,System.Trigger.oldMap);
		}
	}

}