trigger PaymentRequestLineItemTrigger on Payment_Request_Line_Item__c (before insert, before update, before delete,
		after insert, after update, after delete, after undelete) {

	if (System.Trigger.IsBefore && System.Trigger.IsUpdate) {
		PaymentRequestLineItemService.blockEditPaymentRequestLineItemOnClosedCases(Trigger.new);
	}

} // end PaymentRequestLineItemTrigger trigger