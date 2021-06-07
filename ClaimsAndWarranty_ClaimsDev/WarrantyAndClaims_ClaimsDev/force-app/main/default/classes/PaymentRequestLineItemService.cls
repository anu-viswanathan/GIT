/**
 * @description Trigger Handler for the Payment Request Line Item object
 * @author Sinan Bunni
 * @date 02/05/2019
 */
public with sharing class PaymentRequestLineItemService {

	Private static User runningUser;
	public static User getRunningUser() {
		if (runningUser == NULL) {
			runningUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
		}
		return runningUser;
	}

	public static void blockEditPaymentRequestLineItemOnClosedCases(List<Payment_Request_Line_Item__c> paymentRequestLineItems) {

		User runningUser = getRunningUser();

		Set<Id> paymentRequestIds = new Set<Id>();
		for (Payment_Request_Line_Item__c paymentRequestLineItem : paymentRequestLineItems) {
			paymentRequestIds.add(paymentRequestLineItem.Payment_Request__c);
		}

		Map<Id, Payment_Request__c> paymentRequestMap = new Map<Id, Payment_Request__c>(
		[
				SELECT Id, Case_Closed__c
				FROM Payment_Request__c
				WHERE Id IN:paymentRequestIds AND
				Case_Closed__c = true
		]
		);

		for (Payment_Request_Line_Item__c paymentRequestLineItem : paymentRequestLineItems) {
			if (paymentRequestMap.containsKey(paymentRequestLineItem.Payment_Request__c) &&
					runningUser.Profile.Name != 'System Administrator') {
				paymentRequestLineItem.addError('Users cannot edit the payment request line item for closed cases.');
			}
		}
	} // end blockEditPaymentRequestLineItemOnClosedCases method

} // end PaymentRequestLineItemService class