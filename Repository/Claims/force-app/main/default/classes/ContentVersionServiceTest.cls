@isTest
private class ContentVersionServiceTest {

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

		//create Cases
		List<Case> toInsertCases = new List<Case>();

		toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTestClosed',null,'Commercial','Closed',1,false));
		toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTest',null,'Commercial','Draft',1,false));
		toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTest1',null,'Commercial','Draft',1,false));

		insert toInsertCases;
	}

	@isTest static void testThatContentNoteDoesNotInsert() {
		Case c = [SELECT Id FROM Case WHERE Subject = 'CaseServiceTestClosed'];

		Test.startTest();
		ContentNote cn = new ContentNote();
		cn.Title = 'test1';
		String body = 'Please work';
		cn.Content = Blob.valueOf(body.escapeHTML4());
		insert cn;

		ContentDocumentLink link2 = new ContentDocumentLink();
		link2.ContentDocumentId = cn.id;
		link2.LinkedEntityId = c.Id;
		link2.ShareType = 'I';
		link2.Visibility = 'AllUsers';

		Boolean errorCaught = false;
		try {
			insert link2;
		} catch (DmlException e) {
			errorCaught = true;
		}
		Test.stopTest();

		System.assertEquals(errorCaught, false);
	}


	@isTest static void testThatContentNoteDoesInsert() {
		Account a = [SELECT Id FROM Account WHERE Name = 'CaseServiceTest'];

		Test.startTest();
		ContentNote cn = new ContentNote();
		cn.Title = 'test1';
		String body = 'Please work';
		cn.Content = Blob.valueOf(body.escapeHTML4());
		insert cn;

		ContentDocumentLink link2 = new ContentDocumentLink();
		link2.ContentDocumentId = cn.id;
		link2.LinkedEntityId = a.Id;
		link2.ShareType = 'I';
		link2.Visibility = 'AllUsers';

		Boolean errorCaught = false;
		try {
			insert link2;
		} catch (DmlException e) {
			errorCaught = true;
		}
		Test.stopTest();

		System.assertEquals(errorCaught, false);
	}


	@isTest static void testThatContentNotesRetrieved() {
		Case c = [SELECT Id FROM Case WHERE Subject = 'CaseServiceTest1'];

		Test.startTest();
		ContentNote cn = new ContentNote();
		cn.Title = 'test1';
		String body = 'Please work';
		cn.Content = Blob.valueOf(body.escapeHTML4());
		insert cn;

		ContentDocumentLink link2 = new ContentDocumentLink();
		link2.ContentDocumentId = cn.id;
		link2.LinkedEntityId = c.Id;
		link2.ShareType = 'I';
		link2.Visibility = 'AllUsers';

		Boolean errorCaught = true;
		try {
			insert link2;
		} catch (DmlException e) {
			errorCaught = true;
		}
		Test.stopTest();
		System.assert(errorCaught);

		List<ContentVersionService.LightningNote> noteList = ContentVersionService.getContentNotes(c.Id);
		System.assertEquals(noteList.size(), 1);
	}


}