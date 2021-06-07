trigger PaymentRequestTrigger on Payment_Request__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	if(System.Trigger.isBefore) 
		PaymentRequestService.blockCreatedUpdateDelete(System.Trigger.IsDelete ? System.Trigger.old : System.Trigger.new);

	if(System.Trigger.isBefore && System.Trigger.isUpdate){
		System.debug('before calling method');
		PaymentRequestService.checkValidationForDecra(System.Trigger.new, System.Trigger.oldMap);
	}

	if(System.Trigger.isBefore && System.Trigger.isBefore){
		System.debug('before calling method');
		//PaymentRequestService.checkValidationForDecra(System.Trigger.new, null);
	}
}