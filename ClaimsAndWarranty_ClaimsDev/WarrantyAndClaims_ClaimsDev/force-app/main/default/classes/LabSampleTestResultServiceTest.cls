@isTest
private class LabSampleTestResultServiceTest {
	
	@testSetup static void setupTestData() {
		initTestData();
        insertLabTestResults();
	}


    private static void initTestData(){
        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();
        List<Account> toInsertAccounts = new List<Account>();

        toInsertAccounts.addAll(TestFactory.createAccounts(baRt,'CaseServiceTest','9 King St E','Toronto','ON','CA','M4S 2H4',
                'Verified',UserInfo.getUserId(),TRUE,TRUE,1,false));
        insert toInsertAccounts;
        
        //create contact
        List<Contact> con = TestFactory.createContacts(toInsertAccounts[0].Id,'LabSampleTapeCodeServiceTest',UserInfo.getUserId(),1,false);
        insert con;
        
        //create Cases
        List<Case> toInsertCases = new List<Case>();

        toInsertCases.addAll(TestFactory.createCases(ccRt,toInsertAccounts[0].Id,con[0].Id,'Owner','LabSampleTapeCodeServiceTest',null,'Commercial',null,1,false));
        toInsertCases.addAll(TestFactory.createCases(ccRt,toInsertAccounts[0].Id,con[0].Id,'Distributor',null,null,'Commercial',null,5,false));
        toInsertCases[1].Subject='CaseServiceTestClosed';
        toInsertCases[1].Claim_Stage__c='Closed';
        
        toInsertCases[2].Subject='CaseServiceTest1';
        
        toInsertCases[3].Subject='CaseServiceTest2';
        
        toInsertCases[4].Subject='CaseServiceTest3';
        
        toInsertCases[5].Subject='CaseServiceTest4';
        Insert toInsertCases;
        System.debug('toInsertCases: '+ toInsertCases);
        
        List<Lab_Sample__c> toInsertLabSamples = new List<Lab_Sample__c>();
        toInsertLabSamples.addAll(TestFactory.createLabSamples(toInsertCases[1], 5, false));
        toInsertLabSamples[1].Case__c=toInsertCases[2].Id;
        toInsertLabSamples[2].Case__c=toInsertCases[3].Id;
        toInsertLabSamples[3].Case__c=toInsertCases[4].Id;
        toInsertLabSamples[4].Case__c=toInsertCases[5].Id;
        Insert toInsertLabSamples;
        List<Lab_Sample__c> verifyLabSamples = [Select Case__r.Subject from Lab_Sample__c ];
        System.debug('verifyLabSamples[0]: '+verifyLabSamples[0].Case__r.Subject);
        
        List<Lab_Test__c> toInsertLabTests = new List<Lab_Test__c>();
        toInsertLabTests.addAll(TestFactory.createLabTests('Blistering', 'alpha', 1, false));   
        toInsertLabTests.addAll(TestFactory.createLabTests('Blistering', 'beta', 1, false)); 
        Insert toInsertLabTests;
    }
    
	@future
    static void insertLabTestResults(){
        List<Lab_Sample__c> labSamples = [select Id, Case__r.Subject from Lab_Sample__c ];
        System.debug('labSamples: '+labSamples.size());
        List<Lab_Test__c> labTests = [Select Id, Test_Reason__c, Test_Description__c from Lab_Test__c];
        List<Lab_Test_Result__c> toInsertLabTestResults = new List<Lab_Test_Result__c>();
        toInsertLabTestResults.addAll(TestFactory.createlabTestResults(labSamples[1], labTests[0], 1, false));
        toInsertLabTestResults.addAll(TestFactory.createlabTestResults(labSamples[2], labTests[1], 1, false));
        toInsertLabTestResults.addAll(TestFactory.createlabTestResults(labSamples[3], labTests[1], 1, false));
        toInsertLabTestResults.addAll(TestFactory.createlabTestResults(labSamples[4], labTests[0], 1, false));
        Insert toInsertLabTestResults;
    }    
	@isTest static void testThatLabTestResultCannotBeInsertedPostClosure() {
        System.debug('All sample results: '+[Select Count(Id) from Lab_Sample__c]);
		Lab_Sample__c ls 			= [select Id, Case__c from Lab_Sample__c where Case__r.Subject = 'CaseServiceTestClosed'];
		Case c = [Select Id, Claim_Stage__c from Case where Id = :ls.Case__c LIMIT 1];
        c.Claim_Stage__c='Closed';
        Update c;
        
		Lab_Test_Result__c lstc 	= new Lab_Test_Result__c(Lab_Sample__c = ls.Id);
		try {
			insert lstc;
		} catch(DmlException e) { }
		System.assertEquals(lstc.Id, null);
	}

	@isTest static void testThatLabTestResultCannotBeUpdatedPostClosure() {
        
        Lab_Test_Result__c lstc = [Select Id,Lab_Sample__c from Lab_Test_Result__c where Lab_Sample__r.Case__r.Subject = 'CaseServiceTest3' LIMIT 1];
		//Lab_Sample__c ls 			= [select Id, Case__c from Lab_Sample__c where Case__r.Subject = 'CaseServiceTestClosed'];
		Case c = [Select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTest3' LIMIT 1];
        c.Claim_Stage__c='Closed';
        Update c;
        Test.startTest();
		Boolean errorCaught = false;
		try {
			update lstc;
		} catch(DmlException e) { 
			errorCaught = true;
		}
		System.assert(errorCaught);
        Test.stopTest();
	}

	@isTest static void testThatLabTestResultCannotBeDeletedPostClosure() {
		Lab_Test_Result__c lstc = [select Id from Lab_Test_Result__c where Lab_Sample__r.Case__r.Subject = 'CaseServiceTest2'];
		Case c = [Select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTest2' LIMIT 1];
        c.Claim_Stage__c='Closed';
        Update c;
        
		Boolean errorCaught 		= false;
		try {
			delete lstc;
		} catch(DmlException e) { 
			errorCaught 			= true;
		}
		System.assert(errorCaught);
	}

	@isTest static void testThatLabTestResultCanBeInsertedUpdatedDeletedPreClosure() {
		Case c 			= [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTest1'];

		Lab_Test__c lt1 	= [select Id from Lab_Test__c where Test_Reason__c = 'Blistering' limit 1];

		Test.startTest();
		Lab_Sample__c ls	= new Lab_Sample__c(Case__c = c.Id);
		insert ls;

		Lab_Test_Result__c lstc 	= new Lab_Test_Result__c(Lab_Sample__c = ls.Id, Lab_Test__c = lt1.Id);
		insert lstc;

		System.assertNotEquals(lstc.Id, null);

		update lstc;
		delete lstc;
		Test.stopTest();
	}

	@isTest static void testUpdateStatusAccordingToTestResult_UpdateTestStatusWhenTestResultIsBlank_TestStatusUpdatedToNew(){

		Case c 	= [SELECT Id, Claim_Stage__c FROM Case WHERE Subject = 'CaseServiceTest1'];

		Lab_Test__c lt1 = [SELECT Id FROM Lab_Test__c WHERE Test_Reason__c = 'Blistering' LIMIT 1];


		Test.startTest();
		Lab_Sample__c ls = new Lab_Sample__c(Case__c = c.Id);
		insert ls;

		Lab_Test_Result__c lstc = new Lab_Test_Result__c(Lab_Sample__c = ls.Id, Lab_Test__c = lt1.Id,Test_Result__c = '');
		insert lstc;
		Test.stopTest();


		Lab_Test_Result__c expectedTestResult = [SELECT Test_Status__c FROM Lab_Test_Result__c WHERE Id = :lstc.Id];

		//assert
		System.assertEquals(expectedTestResult.Test_Status__c,'New');
	}

	@isTest static void testUpdateStatusAccordingToTestResult_UpdateTestStatusWhenTestResultIsNotBlank_TestStatusUpdatedToCompleted(){

		Case c 	= [SELECT Id, Claim_Stage__c FROM Case WHERE Subject = 'CaseServiceTest1'];

		Lab_Test__c lt1 = [SELECT Id FROM Lab_Test__c WHERE Test_Reason__c = 'Blistering' LIMIT 1];

		Test.startTest();
		Lab_Sample__c ls = new Lab_Sample__c(Case__c = c.Id);
		insert ls;

		Lab_Test_Result__c lstc = new Lab_Test_Result__c(Lab_Sample__c = ls.Id, Lab_Test__c = lt1.Id,Test_Status__c = 'New');
		insert lstc;

		lstc.Test_Result__c = 'Test Result';
		update lstc;
		Test.stopTest();


		Lab_Test_Result__c expectedTestResult = [SELECT Test_Status__c FROM Lab_Test_Result__c WHERE Id = :lstc.Id];

		//assert
		System.assertEquals(expectedTestResult.Test_Status__c,'Completed');
	}

	@isTest
	public static void testCountCompletedAndNotRequiredTestResultsForLabSample_checkEligibleForApprovalOnLabSample_OnInsertNotCompleted(){
		Case c 	= [SELECT Id, Claim_Stage__c FROM Case WHERE Subject = 'CaseServiceTest1'];

		Lab_Test__c lt1 = [SELECT Id FROM Lab_Test__c WHERE Test_Reason__c = 'Blistering' LIMIT 1];

		Test.startTest();
		Lab_Sample__c ls = new Lab_Sample__c(Sequence_Number__c = 1111111,Case__c = c.Id);
		insert ls;

		Lab_Test_Result__c lstc = new Lab_Test_Result__c(Lab_Sample__c = ls.Id, Lab_Test__c = lt1.Id,Test_Status__c = 'New');
		insert lstc;
		Test.stopTest();

		ls = [SELECT Eligible_for_Approval_submission__c FROM Lab_Sample__c WHERE Sequence_Number__c = 1111111];

		System.assert(!ls.Eligible_for_Approval_submission__c);
	}

	@isTest
	public static void testCountCompletedAndNotRequiredTestResultsForLabSample_checkEligibleForApprovalOnLabSample_OnInsertCompleted(){
		Case c 	= [SELECT Id, Claim_Stage__c FROM Case WHERE Subject = 'CaseServiceTest1'];

		Lab_Test__c lt1 = [SELECT Id FROM Lab_Test__c WHERE Test_Reason__c = 'Blistering' LIMIT 1];

		Test.startTest();
		Lab_Sample__c ls = new Lab_Sample__c(Sequence_Number__c = 1111111,Case__c = c.Id);
		insert ls;

		Lab_Test_Result__c lstc = new Lab_Test_Result__c(Lab_Sample__c = ls.Id, Lab_Test__c = lt1.Id,Test_Status__c = 'Completed');
		insert lstc;
		Test.stopTest();

		ls = [SELECT Eligible_for_Approval_submission__c FROM Lab_Sample__c WHERE Sequence_Number__c = 1111111];

		System.assert(ls.Eligible_for_Approval_submission__c);
	}

	@isTest
	public static void testCountCompletedAndNotRequiredTestResultsForLabSample_checkEligibleForApprovalOnLabSample_OnUpdateNotRequired(){
		Case c 	= [SELECT Id, Claim_Stage__c FROM Case WHERE Subject = 'CaseServiceTest1'];

		Lab_Test__c lt1 = [SELECT Id FROM Lab_Test__c WHERE Test_Reason__c = 'Blistering' LIMIT 1];

		Test.startTest();
		Lab_Sample__c ls = new Lab_Sample__c(Sequence_Number__c = 1111111,Case__c = c.Id);
		insert ls;

		Lab_Test_Result__c lstc = new Lab_Test_Result__c(Lab_Sample__c = ls.Id, Lab_Test__c = lt1.Id,Test_Status__c = 'Completed');
		insert lstc;

		lstc.Test_Status__c = 'Not Required';
		update lstc;
		Test.stopTest();

		ls = [SELECT Eligible_for_Approval_submission__c FROM Lab_Sample__c WHERE Sequence_Number__c = 1111111];

		System.assert(ls.Eligible_for_Approval_submission__c);
	}

	@isTest
	public static void testCountCompletedAndNotRequiredTestResultsForLabSample_checkEligibleForApprovalOnLabSample_OnUpdateNotCompleted(){
		Case c 	= [SELECT Id, Claim_Stage__c FROM Case WHERE Subject = 'CaseServiceTest1'];

		Lab_Test__c lt1 = [SELECT Id FROM Lab_Test__c WHERE Test_Reason__c = 'Blistering' LIMIT 1];

		Test.startTest();
		Lab_Sample__c ls = new Lab_Sample__c(Sequence_Number__c = 1111111,Case__c = c.Id);
		insert ls;

		Lab_Test_Result__c lstc = new Lab_Test_Result__c(Lab_Sample__c = ls.Id, Lab_Test__c = lt1.Id,Test_Status__c = 'New');
		insert lstc;

		lstc.Test_Status__c = 'In Progress';
		update lstc;
		Test.stopTest();

		ls = [SELECT Eligible_for_Approval_submission__c FROM Lab_Sample__c WHERE Sequence_Number__c = 1111111];

		System.assert(!ls.Eligible_for_Approval_submission__c);
	}

	@isTest
	public static void testCountCompletedAndNotRequiredTestResultsForLabSample_checkEligibleForApprovalOnLabSample_OnDeleteNotCompleted(){
		Case c 	= [SELECT Id, Claim_Stage__c FROM Case WHERE Subject = 'CaseServiceTest1'];

		Lab_Test__c lt1 = [SELECT Id FROM Lab_Test__c WHERE Test_Reason__c = 'Blistering' LIMIT 1];

		Test.startTest();
		Lab_Sample__c ls = new Lab_Sample__c(Sequence_Number__c = 1111111,Case__c = c.Id);
		insert ls;

		Lab_Test_Result__c lstc = new Lab_Test_Result__c(Lab_Sample__c = ls.Id, Lab_Test__c = lt1.Id,Test_Status__c = 'New');
		insert lstc;

		Lab_Test_Result__c lstc1 = new Lab_Test_Result__c(Lab_Sample__c = ls.Id, Lab_Test__c = lt1.Id,Test_Status__c = 'Completed');
		insert lstc1;

		delete lstc1;
		Test.stopTest();

		ls = [SELECT Eligible_for_Approval_submission__c FROM Lab_Sample__c WHERE Sequence_Number__c = 1111111];

		System.assert(!ls.Eligible_for_Approval_submission__c);
	}

	@isTest
	public static void testCountCompletedAndNotRequiredTestResultsForLabSample_checkEligibleForApprovalOnLabSample_OnDeleteCompleted(){
		Case c 	= [SELECT Id, Claim_Stage__c FROM Case WHERE Subject = 'CaseServiceTest1'];

		Lab_Test__c lt1 = [SELECT Id FROM Lab_Test__c WHERE Test_Reason__c = 'Blistering' LIMIT 1];

		Test.startTest();
		Lab_Sample__c ls = new Lab_Sample__c(Sequence_Number__c = 1111111,Case__c = c.Id);
		insert ls;

		Lab_Test_Result__c lstc = new Lab_Test_Result__c(Lab_Sample__c = ls.Id, Lab_Test__c = lt1.Id,Test_Status__c = 'New');
		insert lstc;

		Lab_Test_Result__c lstc1 = new Lab_Test_Result__c(Lab_Sample__c = ls.Id, Lab_Test__c = lt1.Id,Test_Status__c = 'Completed');
		insert lstc1;

		delete lstc;
		Test.stopTest();

		ls = [SELECT Eligible_for_Approval_submission__c FROM Lab_Sample__c WHERE Sequence_Number__c = 1111111];

		System.assert(ls.Eligible_for_Approval_submission__c);
	}
}