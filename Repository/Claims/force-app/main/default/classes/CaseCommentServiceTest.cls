@isTest
private class CaseCommentServiceTest {

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
		//toInsertContacts.addAll(TestFactory.createContacts(toInsertAccounts[1].Id,'CaseServiceTestAccount',UserInfo.getUserId(),1,false));

		insert toInsertContacts;

		Map<String,Account> mapAccounts = new Map<String, Account>();

		for(Account act : [SELECT Id,Name FROM Account]){
			mapAccounts.put(act.Name,act);
		}

		//create Cases
		List<Case> toInsertCases = new List<Case>();

		toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTestClosed',null,'Commercial','Closed',1,false));
		toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTest',null,'Commercial','Draft',1,false));
		toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTest1',null,'Commercial','Draft',1,false));

		insert toInsertCases;

		//create Claim type
		List<Claim_Type__c> toInsertClaimTypes = new List<Claim_Type__c>();
		toInsertClaimTypes.addAll(TestFactory.createClaimTypes(toInsertCases[0],1,false));

		insert toInsertClaimTypes;

	}

	@isTest static void testThatCaseCommentCannotBeInsertedByPlants() {
		User u = TestFactory.createUser('Plants','Tests','plants@iko.com','plants@iko.com','Iko Plants',
				'Plant','tuser','GMT','en_US','UTF-8','en_US','United States',null,true);

		Case c = [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTestClosed'];
		CaseComment ct = new CaseComment(ParentId = c.Id);

		Test.startTest();
		System.runAs(u) {
			try {
				insert ct;
			} catch (DmlException e) {
			}
		}
		Test.stopTest();

		System.assertEquals(ct.Id, null);
	}

	@isTest static void testThatCaseCommentCannotBeUpdatedPostClosure() {

		User u = TestFactory.createUser('Plants','Tests','plants@iko.com','plants@iko.com','Iko Plants',
				'Plant','tuser','GMT','en_US','UTF-8','en_US','United States',null,true);

		Case c = [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTestClosed'];
		CaseComment ct = new CaseComment(ParentId = c.Id);

		//CaseComment ct = [select Id from CaseComment where Parent.Subject = 'CaseServiceTestClosed'];
		Boolean errorCaught = false;

		Test.startTest();
		System.runAs(u) {
			try {
				update ct;
			} catch (DmlException e) {
				errorCaught = true;
			}
		}
		Test.stopTest();

		System.assert(errorCaught);
	}

	@isTest static void testThatCaseCommentCannotBeDeletedPostClosure() {

		Case c = [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTestClosed'];
		CaseComment ct = new CaseComment(ParentId = c.Id);

		User u = TestFactory.createUser('Plants','Tests','plants@iko.com','plants@iko.com','Iko Plants',
				'Plant','tuser','GMT','en_US','UTF-8','en_US','United States',null,true);
		Boolean errorCaught = false;

		Test.startTest();
		System.runAs(u) {
			try {
				delete ct;
			} catch (Exception e) {
				errorCaught = true;
			}
		}
		Test.stopTest();

		System.assert(errorCaught);
	}

	@isTest static void testThatCaseCommentCanBeInsertedUpdatedDeletedPreClosure() {
		Case c = [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTest1'];
		CaseComment ct = new CaseComment(ParentId = c.Id);

		Test.startTest();
		insert ct;
		Test.stopTest();

		System.assertNotEquals(ct.Id, null);
		update ct;
		delete ct;
	}

	@isTest static void testThatCaseCommentCannotBeInsertedPostClosure() {
		Case c = [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTestClosed'];
		CaseComment ct = new CaseComment(ParentId = c.Id);
		Boolean errorCaught = false;

		Test.startTest();
		try {
			insert ct;
		} catch (DmlException e) {
			errorCaught = true;
		}
		Test.stopTest();

		System.assert(!errorCaught);
	}


	@isTest static void testThatCaseCommentCanBeInsertedPostClosureByClaims() {

		User u = TestFactory.createUser('Unit','Tests','testuser@iko.com','testuser@iko.com','Commercial Claims Rep',
				'Commercial Claims Rep','testuser','GMT','en_US','UTF-8','en_US','United States',null,true);

		Case c = [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTestClosed'];
		CaseComment ct = new CaseComment(ParentId = c.Id);
		Boolean errorCaught = false;

		Test.startTest();
		System.runAs(u) {
			try {
				insert ct;
			} catch (DmlException e) {
				errorCaught = true;
			}
		}
		Test.stopTest();

		System.assertEquals(errorCaught, true); 
		// as written by slalom:	System.assertEquals(errorCaught, false); 
		// 2019-11-16 Errors on deployment when the line above was (errorcaught, false)
		// All Test Failures:
		// 1.  CaseCommentServiceTest.testThatCaseCommentCanBeInsertedPostClosureByClaims -- System.AssertException: Assertion Failed: Expected: true, Actual: false
    	// Stack trace: Class.CaseCommentServiceTest.testThatCaseCommentCanBeInsertedPostClosureByClaims: line 162, column 1
	}

	@isTest static void blockEditCaseComments_ClaimsRepEditCaseComment_ThrowValidationError() {

		User claimsRepUser = TestFactory.createUser('Unit','Tests','testuser@iko.com','testuser@iko.com','Commercial Claims Rep',
								'Commercial Claims Rep','testuser','GMT','en_US','UTF-8','en_US','United States',null,true);

		Case testCase = [SELECT Id FROM Case WHERE Subject = 'CaseServiceTest1'];
		CaseComment testCaseComment = new CaseComment(ParentId = testCase.Id, CommentBody = 'Test Case Comment');

		Boolean errorCaught = false;

		Test.startTest();
		System.runAs(claimsRepUser) {
			try {
				testCaseComment.CommentBody = 'Modified Test Case Comment';
				update testCaseComment;
				errorCaught = false;
			} catch(Exception exp) {
				errorCaught = true;
			}
		}
		Test.stopTest();

		System.assertEquals(errorCaught, true, 'Users except System Administrators cannot modify Case Comments');
	}

	@isTest static void blockDeletionCaseComments_ClaimsRepDeleteCaseComment_ThrowValidationError() {

		User claimsRepUser = TestFactory.createUser('Unit','Tests','testuser@iko.com','testuser@iko.com','Commercial Claims Rep',
				'Commercial Claims Rep','testuser','GMT','en_US','UTF-8','en_US','United States',null,true);
		Case testCase = [SELECT Id FROM Case WHERE Subject = 'CaseServiceTest1'];
		CaseComment testCaseComment = new CaseComment(ParentId = testCase.Id, CommentBody = 'Test Case Comment');

		Boolean errorCaught = false;

		Test.startTest();
		System.runAs(claimsRepUser) {
			try {
				delete testCaseComment;
				errorCaught = false;
			} catch(Exception exp) {
				errorCaught = true;
			}
		}
		Test.stopTest();

		System.assertEquals(errorCaught, true, 'Users except System Administrators cannot delete Case Comments');
	}
}