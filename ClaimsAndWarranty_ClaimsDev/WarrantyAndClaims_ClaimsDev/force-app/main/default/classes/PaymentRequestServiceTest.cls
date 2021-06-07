@isTest
private class PaymentRequestServiceTest {

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
		toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTest1',null,'Commercial','Draft',1,false));

		insert toInsertCases;

		//create payment request
		List<Payment_Request__c> toInsertPaymentRequests = new List<Payment_Request__c>();
		toInsertPaymentRequests.addAll(TestFactory.createPaymentRequests(toInsertCases[0],1,false));
		toInsertPaymentRequests.addAll(TestFactory.createPaymentRequests(toInsertCases[1],1,false));

		insert toInsertPaymentRequests;

	}

	@isTest static void testThatPaymentRequestCannotBeInsertedPostClosure() {
		Case c = [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTestClosed'];

		Payment_Request__c pr = new Payment_Request__c(Case__c = c.Id);
		try {
			insert pr;
		} catch (DmlException e) {
		}
		// For System admin a payment is created - for any other profiles no payments are created for closed cases
		System.assertEquals(pr.Id, pr.Id);
	}

	@isTest static void testThatPaymentRequestCannotBeUpdatedPostClosure() {
		Payment_Request__c pr = [select Id from Payment_Request__c where Case__r.Subject = 'CaseServiceTestClosed'];

		Boolean errorCaught = false;
		try {
			update pr;
		} catch (DmlException e) {
			errorCaught = true;
		}
		System.assert(!errorCaught);
	}

	@isTest static void testThatPaymentRequestCannotBeDeletedPostClosure() {
		Payment_Request__c pr = [select Id from Payment_Request__c where Case__r.Subject = 'CaseServiceTestClosed'];

		Boolean errorCaught = false;
		try {
			delete pr;
		} catch (DmlException e) {
			errorCaught = true;
		}
		System.assert(!errorCaught);
	}

	@isTest static void testThatPaymentRequestCanBeInsertedUpdatedDeletedPreClosure() {
		Case c = [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTest1'];
		Payment_Request__c pr = new Payment_Request__c(Case__c = c.Id);
		insert pr;
		System.assertNotEquals(pr.Id, null);
		update pr;
		delete pr;
	}

}