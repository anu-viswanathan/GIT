/**
 * @description Unit Test for the Payment Request Line Item Service trigger handler
 * @author Sinan Bunni
 * @date 05/02/2019
 */
@isTest
private with sharing class PaymentRequestLineItemServiceTest {
	@testSetup static void setupTestData() {

		Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
		Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();

		//create Account
		List<Account> toInsertAccounts = new List<Account>();

		toInsertAccounts.addAll(TestFactory.createAccounts(baRt,'CaseServiceTest','9 King St E','Toronto','ON','CA','M4S 2H4',
				'Verified',UserInfo.getUserId(),TRUE,TRUE,1,false));

		insert toInsertAccounts;


		//create contact
		List<Contact> toInsertContacts = new List<Contact>();

		toInsertContacts.addAll(TestFactory.createContacts(toInsertAccounts[0].Id,'CaseServiceTest',UserInfo.getUserId(),1,false));


		insert toInsertContacts;

		Map<String,Account> mapAccounts = new Map<String, Account>();

		for(Account act : [SELECT Id,Name FROM Account]){
			mapAccounts.put(act.Name,act);
		}
		List<Case> toInsertCases = new List<Case>();
		toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTestClosed',null,'Commercial','Closed',1,false));

		insert toInsertCases;

		List<Payment_Request__c> toInsertPaymentRequests = new List<Payment_Request__c>();
		toInsertPaymentRequests.addAll(TestFactory.createPaymentRequests(toInsertCases[0],1,false));

		insert toInsertPaymentRequests;

		List<Payment_Request_Line_Item__c> toInsertPaymentRequestLineItems = new List<Payment_Request_Line_Item__c>();
		toInsertPaymentRequestLineItems.addAll(TestFactory.createPaymentRequestLineItems(toInsertPaymentRequests[0],1,false));

		insert toInsertPaymentRequestLineItems;

	}

	@isTest static void blockEditPaymentRequestLineItemOnClosedCases_LineItemAssociatedWithClosedCase_ThrowValidationError() {

		User claimsRepUser  = TestFactory.createUser('Unit','Tests','testuser@iko.com','testuser@iko.com','Commercial Claims Rep',
                    'Commercial Claims Rep','testuser','GMT','en_US','UTF-8','en_US','United States',null,false);

		Case closedCase = [SELECT Id
							FROM Case
							WHERE Subject = 'CaseServiceTestClosed'];
        
        	Payment_Request__c paymentRequest = [SELECT Id, Case_Closed__c
				FROM Payment_Request__c
				WHERE Case__c = :closedCase.Id];


				Payment_Request_Line_Item__c paymentRequestLineItem = [SELECT Id,Item_Description__c
				FROM Payment_Request_Line_Item__c
				WHERE Payment_Request__c = :paymentRequest.Id];

		System.runAs(claimsRepUser){
		//create payment request
			String errormesg= '';
			try{		
				 Test.startTest();
				paymentRequestLineItem.Item_Description__c = 'Test me';               
				update paymentRequestLineItem;
				Test.stopTest();

			}catch(Exception e){
				errormesg = e.getMessage();
				System.debug('@@@@@@@@'+errormesg);
			}
			System.assert(errormesg != NULL,'There is an error in creating the payment request');

        }



	}



	@isTest static void blockEditPaymentRequestLineItemOnClosedCases_LineItemAssociatedWithClosedCaseSysAdmin_NoThrowValidationError() {

		User sysAdmin  = TestFactory.createUser('UnitClaim1','TestsClaim','sysAdminUsr@iko.com','sysAdminUsr@iko.com','System Administrator',
				'CEO','tsAdmU','GMT','en_US','UTF-8','en_US','United States',null,false);

		Case closedCase = [SELECT Id
		FROM Case
		WHERE Subject = 'CaseServiceTestClosed'];

		Payment_Request__c paymentRequest = [SELECT Id, Case_Closed__c
		FROM Payment_Request__c
		WHERE Case__c = :closedCase.Id];


		Payment_Request_Line_Item__c paymentRequestLineItem = [SELECT Id,Item_Description__c
		FROM Payment_Request_Line_Item__c
		WHERE Payment_Request__c = :paymentRequest.Id];

		System.runAs(sysAdmin){
			//create payment request
			String errormesg= '';
			try{
				Test.startTest();
				paymentRequestLineItem.Item_Description__c = 'Test me';
				update paymentRequestLineItem;
				Test.stopTest();

			}catch(Exception e){
				errormesg = e.getMessage();
			}
			System.assert(errormesg.equals(''));

		}



	}

} // end PaymentRequestLineItemServiceTest class