@isTest
private class AccountServiceTest {

	@testSetup static void setupTestData() {

		List<User> toInsertUsers = new List<User>();
		toInsertUsers.add(TestFactory.createUser('UnitClaim','TestsClaim','claimsManagerUsr@iko.com','claimsManagerUsr@iko.com','Claims Manager',
				'Claims Manager','tclu','GMT','en_US','UTF-8','en_US','United States',null,false));
		toInsertUsers.add(TestFactory.createUser('Unit','Tests','testuser@iko.com','testuser@iko.com','Commercial Claims Rep',
				'Commercial Claims Rep','testuser','GMT','en_US','UTF-8','en_US','United States',null,false));
		toInsertUsers.add(TestFactory.createUser('Unit','Tests','rtestuser@iko.com','rtestuser@iko.com','Residential Claims Rep',
				'Residential Claims Rep','test2','GMT','en_US','UTF-8','en_US','United States',null,false));
		toInsertUsers.add(TestFactory.createUser('Unit','Tests','salesrsmmgr@iko.com','salesrsmmgr@iko.com','USRS Manager',
				'RSM West','salesmgr','GMT','en_US','UTF-8','en_US',null,null,false));
		toInsertUsers.add(TestFactory.createUser('UnitClaim','TestsClaim','claimsManagerMelissaTestUsr@iko.com','claimsManagerMelissaTestUsr@iko.com','Claims Manager',
				'Claims Manager','melUsr','GMT','en_US','UTF-8','en_US','United States',null,false));
		/*toInsertUsers.add(TestFactory.createUser('Unit','Tests','salesrep@iko.com','salesrep@iko.com',
				'USRS Sales Rep','TSR West','salesrep','GMT','en_US','UTF-8','en_US',null,null,false));*/

		insert toInsertUsers;

	}

	@isTest static void testThatSequenceNumberSetCorrectly() {
		/* initialize some Accounts and Sequence Numbers */
		Id conId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();

		Test.startTest();
		Account a1 = new Account(RecordTypeId = conId, Name = 'Test1', IAAP_Registered_Highlight__c = 'IAAP Registered',
				Registration__c = 'ON/2010', Registration_Sequence_Number__c = 2010, BillingStateCode = 'ON', BillingCountryCode = 'CA',
				IAP_Registered_Date__c = date.today(), IAP_Registration_Expiry_Date__c = date.today().addYears(3));
		insert a1;

		Account a2 = new Account(RecordTypeId = conId, Name = 'Test2', IAAP_Registered_Highlight__c = 'IAAP Registered', BillingStateCode = 'ON', BillingCountryCode = 'CA', IAP_Registered_Date__c = date.today(), IAP_Registration_Expiry_Date__c = date.today().addYears(3));
		Account a3 = new Account(RecordTypeId = conId, Name = 'Test3', IAAP_Registered_Highlight__c = 'IAAP Registered', BillingStateCode = 'AB', BillingCountryCode = 'CA', IAP_Registered_Date__c = date.today(), IAP_Registration_Expiry_Date__c = date.today().addYears(3));
		Account a4 = new Account(RecordTypeId = conId, Name = 'Test4', IAAP_Registered_Highlight__c = 'IAAP Registered', BillingCountryCode = 'CA', IAP_Registered_Date__c = date.today(), IAP_Registration_Expiry_Date__c = date.today().addYears(3));

		AccountService.generateRegistrationNumber(new List<Account>{
				a2, a3, a4
		}, new Map<Id, Account>());
		Test.stopTest();

		System.assertEquals(a2.Registration__c, 'ON/2011', 'Registration for Ontario should have been incremented by 1');
		System.assertEquals(a3.Registration__c, 'AB/' + AccountService.defaultRegistrationNumber, 'Registration for Alberta should start at the default starting number');
		System.assertEquals(a4.Registration__c, null, 'When no Billing State is set, no registration number is registered');
	}
	/*
	@isTest static void testThatUnverifiedBillingAddressPassedToApprovalProcess() {

		Test.startTest();

		Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();

		TestFactory.createAccounts(baRt,'CaseServiceTestWashingtonUnverified','91 King St E','Seattle','WA','US','12111',
				null,UserInfo.getUserId(),TRUE,TRUE,1,true);

		Account a = [SELECT Id FROM Account WHERE Name = 'CaseServiceTestWashingtonUnverified'];

		List<ProcessInstance> lstProcessInstance = [SELECT TargetObjectId, SubmittedById, ProcessDefinition.DeveloperName
													FROM ProcessInstance
													WHERE TargetObjectId = :a.Id
													AND ProcessDefinition.DeveloperName = 'Building_Address_Verification'];
		Test.stopTest();

		System.assertEquals(lstProcessInstance.size(), 1);
	}
	*/
	@isTest static void testThatVerifiedBillingAddressNotPassedToApprovalProcess() {

		Test.startTest();

		Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();

		TestFactory.createAccounts(baRt,'CaseServiceTestWashington','9 King St E','Seattle','WA','US','12111',
				'Verified',UserInfo.getUserId(),TRUE,TRUE,1,true);


		Account a = [SELECT Id FROM Account WHERE Name = 'CaseServiceTestWashington'];
		List<ProcessInstance> lstProcessInstance = [SELECT TargetObjectId, SubmittedById, ProcessDefinition.DeveloperName
													FROM ProcessInstance
													WHERE TargetObjectId = :a.Id
													AND ProcessDefinition.DeveloperName = 'Building_Address_Verification'];
		Test.stopTest();

		System.assertEquals(lstProcessInstance.size(), 0);
	}

	/**
	@isTest static void testThatChangedBillingAddressPassedToApprovalProcess() {

		Account a = [select Id, BillingStreet, Address_Verification_Status__c from Account where Name = 'CaseServiceTestWashington'];
		System.assertEquals(a.Address_Verification_Status__c, 'Verified');

		Test.startTest();
		a.BillingStreet = a.BillingStreet + ' XYZ';
		update a;

		Account aCheck = [select Id, Address_Verification_Status__c from Account where Id = :a.Id];
		System.assertEquals(aCheck.Address_Verification_Status__c, 'In Verification');

		List<ProcessInstance> lstProcessInstance = [SELECT TargetObjectId, SubmittedById, ProcessDefinition.DeveloperName FROM ProcessInstance WHERE TargetObjectId = :a.Id AND ProcessDefinition.DeveloperName = 'Building_Address_Verification'];
		Test.stopTest();

		System.assertEquals(lstProcessInstance.size(), 1);
	}
	

	@isTest static void testThatPendingRemovedAddressPassedToApprovalProcess() {
		Test.startTest();
		Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();

		TestFactory.createAccounts(baRt,'CaseServiceTestWashington','9 King St E','Seattle','WA','US','12111',
				'Verified',UserInfo.getUserId(),TRUE,TRUE,1,true);

		Account a = [select Id, BillingStreet, Address_Verification_Status__c from Account where Name = 'CaseServiceTestWashington'];
		System.assertEquals(a.Address_Verification_Status__c, 'Verified');
		a.Address_Verification_Status__c = 'Pending';
		update a;

		List<ProcessInstance> lstProcessInstance = [SELECT TargetObjectId, SubmittedById, ProcessDefinition.DeveloperName FROM ProcessInstance
													WHERE TargetObjectId = :a.Id AND ProcessDefinition.DeveloperName = 'Building_Address_Verification'];
		System.assertEquals(lstProcessInstance.size(), 0);

		a.Address_Verification_Status__c = null;
		update a;
		Test.stopTest();

		List<ProcessInstance> lstProcessInstance2 = [SELECT TargetObjectId, SubmittedById, ProcessDefinition.DeveloperName FROM ProcessInstance
														WHERE TargetObjectId = :a.Id AND ProcessDefinition.DeveloperName = 'Building_Address_Verification'];
		System.assertEquals(lstProcessInstance2.size(), 1);
	}
**/
	@isTest static void validateBuildingLocationAccountsWithNotInDraftCaseStatus_SystemAdminUserWithLinkedToClaimIsTrue_NoValidationThrown() {

		Test.startTest();
		Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();

		TestFactory.createAccounts(baRt,'CaseServiceTestWashington','9 King St E','Seattle','WA','US','12111',
				'Verified',UserInfo.getUserId(),TRUE,TRUE,1,true);

		Account testAccount = [SELECT Id FROM Account WHERE name = 'CaseServiceTestWashington' LIMIT 1];
		testAccount.Linked_to_Claim__c = true;
		update testAccount;

		Boolean isValidationThrown = false;


		try {
			AccountService.validateBuildingLocationAccountsWithNotInDraftCaseStatus(new List<Account> { testAccount });
		} catch (System.Exception e) {
			isValidationThrown = true;
		}
		Test.stopTest();

		System.assertEquals(isValidationThrown, false, 'System Admin users are allowed to edit account records.');
	}

	@isTest static void validateBuildingLocationAccountsWithNotInDraftCaseStatus_ClaimsManagerUserWithLinkedToClaimIsTrue_NoValidationThrown() {
		User u =[SELECT Id FROM User WHERE Username = 'claimsManagerUsr@iko.com'];
		Test.startTest();
		Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();

		System.runAs(u){
			TestFactory.createAccounts(baRt,'CaseServiceTestWashington','9 King St E','Seattle','WA','US','12111',
					'Verified',UserInfo.getUserId(),TRUE,TRUE,1,true);
			Account testAccount = [SELECT Id FROM Account WHERE name = 'CaseServiceTestWashington' LIMIT 1];
			testAccount.Linked_to_Claim__c = true;
			update testAccount;


			Boolean isValidationThrown = false;


			try {
				AccountService.validateBuildingLocationAccountsWithNotInDraftCaseStatus(new List<Account> { testAccount });
			} catch (System.Exception e) {
				isValidationThrown = true;
			}
			Test.stopTest();

			System.assertEquals(isValidationThrown, false, 'System Admin users are allowed to edit account records.');
		}

	}

	@isTest static void validateBuildingLocationAccountsWithNotInDraftCaseStatus_CommercialUserWithLinkedToClaimIsTrue_NoValidationThrown() {
		User u =[SELECT Id FROM User WHERE Username = 'testuser@iko.com'];
		Test.startTest();
		Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();

		System.runAs(u){
			TestFactory.createAccounts(baRt,'CaseServiceTestWashington','9 King St E','Seattle','WA','US','12111',
					'Verified',UserInfo.getUserId(),TRUE,TRUE,1,true);
			Account testAccount = [SELECT Id, Name FROM Account WHERE name = 'CaseServiceTestWashington' LIMIT 1];
			testAccount.Name += 'edited';
			update testAccount;


			Boolean isValidationThrown = false;
            

			try {
				AccountService.validateBuildingLocationAccountsWithNotInDraftCaseStatus(new List<Account> { testAccount });
			} catch (System.Exception e) {
				isValidationThrown = true;
                
			}
			Test.stopTest();

			System.assertEquals(false, isValidationThrown, 'System Admin users are allowed to edit account records.');
            
		}

	}
	
    @isTest static void validateBuildingLocationAccountsWithNotInDraftCaseStatus_AccountLinkedToClaimCannotModify_ValidationThrown() {
		User u =[SELECT Id FROM User WHERE Username = 'salesrsmmgr@iko.com'];
        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId();
		
		Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();

		System.runAs(u){
			TestFactory.createAccounts(baRt,'CaseServiceTestWashington','9 King St E','Seattle','WA','US','12111',
					'Verified',UserInfo.getUserId(),TRUE,TRUE,1,true);
			Account testAccount = [SELECT Id, Name FROM Account WHERE name = 'CaseServiceTestWashington' LIMIT 1];
            List<Contact> toInsertContacts = TestFactory.createContacts(testAccount.Id, 'CaseServiceTest', UserInfo.getUserId(), 1, false);
			toInsertContacts[0].FirstName = 'Test';
			//toInsertContacts.addAll(con);
			insert toInsertContacts;
            
            List<Product2> newProduct = TestFactory.createProducts('TestProd', true, '1111', 'US', '12345', 1, true);
            
			Boolean isValidationThrown = false;
            String validationMsg = '';
            
            //Claim_Type__c claimType = new Claim_Type__c(n)
            List<Case> toInsertCases = TestFactory.createCases(ccRt, testAccount.Id, toInsertContacts[0].Id, 'Owner', 'CaseServiceTest', null, 'US', 'Draft', 1, false);
            toInsertCases[0].Samples_Collected__c='Yes';
            toInsertCases[0].All_Claim_Photos_Attached__c=true;
            toInsertCases[0].Product__c=newProduct[0].Id;
            toInsertCases[0].Type_of_Structure__c='Garage';
            
            Insert toInsertCases;
            
            List<Claim_Type__c> newClaimType = TestFactory.createClaimTypes(toInsertCases[0], 1, false);
            newClaimType[0].Is_Primary__c = true;
            Insert newClaimType;
            
        }
            
            Test.startTest();
            	Case caseRecordTest = [SELECT Id, Claim_Stage__c, AccountId, ContactId from Case where Subject='CaseServiceTest' LIMIT 1];
            	caseRecordTest.Claim_Stage__c='Submitted';

                CaseService.assignmentRulesRun= true;
                Account testAccount = [SELECT Id, Name FROM Account WHERE Id = :caseRecordTest.AccountId LIMIT 1];
                    try{
                        update caseRecordTest;
                        System.debug('Updating...');
                    }
                    catch(System.Exception ex){
                        System.debug('Exception Printed: '+ex.getMessage());
                    }
        
        			Case caseRecordQuery = [SELECT Id, Subject, Claim_Stage__c, Account.Name from Case where Id = :caseRecordTest.Id LIMIT 1];
        			System.debug('caseRecordQuery: '+caseRecordQuery);
                	
                    try{
                        testAccount.Name+='edited';
                        update testAccount;
                    }
                    Catch(System.Exception ex){
                        System.debug('Exception Caught: '+ex.getMessage());
                    }

                
                System.runAs(u){
                    Account testAccountUs = [SELECT Id, Name FROM Account WHERE Id = :caseRecordTest.AccountId LIMIT 1];

                    try{
                        testAccountUs.Name+='edited';
                        update testAccountUs;
                    }
                    Catch(System.Exception ex){
                        System.debug('Exception Caught: '+ex.getMessage());
                    }
                }
            Test.stopTest();

			//System.assertEquals(true, isValidationThrown, 'System Admin users are allowed to edit account records.');
            //System.assertEquals('System Admin users are allowed to edit account records.',validationMsg );
            
		

	}

	@isTest static void validateBuildingLocationAccountsWithNotInDraftCaseStatus_ResidentialUserWithLinkedToClaimIsTrue_NoValidationThrown() {
		User u =[SELECT Id FROM User WHERE Username = 'rtestuser@iko.com'];
		Test.startTest();
		Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();

		System.runAs(u){
			TestFactory.createAccounts(baRt,'CaseServiceTestWashington','9 King St E','Seattle','WA','US','12111',
					'Verified',UserInfo.getUserId(),TRUE,TRUE,1,true);
			Account testAccount = [SELECT Id FROM Account WHERE name = 'CaseServiceTestWashington' LIMIT 1];
			testAccount.Linked_to_Claim__c = true;
			update testAccount;


			Boolean isValidationThrown = false;


			try {
				AccountService.validateBuildingLocationAccountsWithNotInDraftCaseStatus(new List<Account> { testAccount });
			} catch (System.Exception e) {
				isValidationThrown = true;
			}
			Test.stopTest();

			System.assertEquals(isValidationThrown, false, 'System Admin users are allowed to edit account records.');
		}
	}

	@isTest static void populateCaseAccountsSharedWithFieldsUponUpdate_ForBuildingLocationAccountRecordtype_NoValidationThrown() {


		Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
		Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();


		List<Account> testAccount = TestFactory.createAccounts(baRt,'CaseServiceTestWashington','9 King St E','Seattle','WA','US','12111',
				'Verified',UserInfo.getUserId(),TRUE,TRUE,1,true);

		List<Contact> toInsertContacts = new List<Contact>();
		toInsertContacts.addAll(TestFactory.createContacts(testAccount[0].Id,'CaseServiceTest',UserInfo.getUserId(),1,false));
		insert toInsertContacts;

		List<Case> casesWithAccount = TestFactory.createCases(ccRt,testAccount[0].Id,toInsertContacts[0].Id,'Distributor',
										'CaseServiceTest',null,'Commercial','Draft',1,false);
		String result = 'Chicago TSRs,USRS Mid West,VP_Commercial_Division,Claims_Manager,Director_National_Accounts,RAM_MidWest,US_HR';
		casesWithAccount[0].Account_Shared_With__c = result;

		insert casesWithAccount;

		User u =[SELECT Id FROM User WHERE Username = 'rtestuser@iko.com'];
		Test.startTest();
		testAccount[0].OwnerId = u.Id;
		update testAccount;
		Test.stopTest(); 

		Case c = [SELECT Id,Account_Shared_With__c FROM Case WHERE AccountId = :testAccount[0].Id];
		//System.assertEquals(c.Account_Shared_With__c,'');
	}

	@isTest static void populateCaseAccountsSharedWithFieldsUponUpdate_ForContractorAccountRecordtype_NoValidationThrown() {


		Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
		Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();


		List<Account> testAccount = TestFactory.createAccounts(baRt,'CaseServiceTestWashington','9 King St E','Seattle','WA','US','12111',
				'Verified',UserInfo.getUserId(),TRUE,TRUE,1,true);

		List<Contact> toInsertContacts = new List<Contact>();
		toInsertContacts.addAll(TestFactory.createContacts(testAccount[0].Id,'CaseServiceTest',UserInfo.getUserId(),1,false));
		insert toInsertContacts;

		List<Case> casesWithAccount = TestFactory.createCases(ccRt,testAccount[0].Id,toInsertContacts[0].Id,'Distributor',
				'CaseServiceTest',null,'Commercial','Draft',1,false);
		String result = 'Chicago TSRs,USRS Mid West,VP_Commercial_Division,Claims_Manager,Director_National_Accounts,RAM_MidWest,US_HR';
		casesWithAccount[0].Contractor_Shared_With__c = result;

		insert casesWithAccount;

		User u =[SELECT Id FROM User WHERE Username = 'rtestuser@iko.com'];
		Test.startTest();
		testAccount[0].OwnerId = u.Id;
		update testAccount;
		Test.stopTest();

		Case c = [SELECT Id,Contractor_Shared_With__c FROM Case WHERE AccountId = :testAccount[0].Id];
		System.assertEquals(c.Contractor_Shared_With__c,result);
	}

	@isTest static void populateCaseAccountsSharedWithFieldsUponUpdate_ForDistributorAccountRecordtype_NoValidationThrown() {


		Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
		Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();


		List<Account> testAccount = TestFactory.createAccounts(baRt,'CaseServiceTestWashington','9 King St E','Seattle','WA','US','12111',
				'Verified',UserInfo.getUserId(),TRUE,TRUE,1,true);

		List<Contact> toInsertContacts = new List<Contact>();
		toInsertContacts.addAll(TestFactory.createContacts(testAccount[0].Id,'CaseServiceTest',UserInfo.getUserId(),1,false));
		insert toInsertContacts;

		List<Case> casesWithAccount = TestFactory.createCases(ccRt,testAccount[0].Id,toInsertContacts[0].Id,'Distributor',
				'CaseServiceTest',null,'Commercial','Draft',1,false);
		String result = 'Chicago TSRs,USRS Mid West,VP_Commercial_Division,Claims_Manager,Director_National_Accounts,RAM_MidWest,US_HR';
		casesWithAccount[0].Distributor_Shared_With__c = result;

		insert casesWithAccount;
		User u =[SELECT Id FROM User WHERE Username = 'rtestuser@iko.com'];
		Test.startTest();
		testAccount[0].OwnerId = u.Id;
		update testAccount;
		Test.stopTest();

		Case c = [SELECT Id,Distributor_Shared_With__c FROM Case WHERE AccountId = :testAccount[0].Id];
		System.assertEquals(c.Distributor_Shared_With__c,result);
	}
    
    @isTest static void populateRecordTypeFamilyForRoofProAccount() {
        
		Test.startTest();
		Id rpAcc1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IKO ROOFPRO APPLICANTS').getRecordTypeId();
        Id rpAcc2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IKOPRO Contractor').getRecordTypeId();
        Id rpAcc3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IKOPRO Contractor HA OK').getRecordTypeId();
         
		TestFactory.createAccounts(rpAcc1,'RecordTypeFamilyTest1','91 King St E','Seattle','WA','US','12111',
				null,UserInfo.getUserId(),TRUE,TRUE,1,true);

		Account a1 = [SELECT Id, Record_Type_Family__c FROM Account WHERE Name = 'RecordTypeFamilyTest1'];
		//System.assertEquals(a1.Record_Type_Family__c, 'RoofPro');	
        
        TestFactory.createAccounts(rpAcc1,'RecordTypeFamilyTest2','92 King St E','Seattle','WA','US','12111',
				null,UserInfo.getUserId(),TRUE,TRUE,1,true);

		Account a2 = [SELECT Id, Record_Type_Family__c FROM Account WHERE Name = 'RecordTypeFamilyTest2'];
		//System.assertEquals(a2.Record_Type_Family__c, 'RoofPro');	
        
        TestFactory.createAccounts(rpAcc1,'RecordTypeFamilyTest3','93 King St E','Seattle','WA','US','12111',
				null,UserInfo.getUserId(),TRUE,TRUE,1,true);

		Account a3 = [SELECT Id, Record_Type_Family__c FROM Account WHERE Name = 'RecordTypeFamilyTest2'];
		//System.assertEquals(a3.Record_Type_Family__c, 'RoofPro');
        
        Test.stopTest();
        
	}
	
	/* ClaimsV2-828 - Update the address verfication status if the billing address is saved by Melissa Data Service */
	/* Test case to verify if address verification status is updated to 'In Verification' when Billing Address is not saved by Melissa */
	@isTest static void UpdateAddressVerificationStatus_WithoutMelissa_ForBuildingAccounts()
	{
		User u =[SELECT Id FROM User WHERE Username = 'testuser@iko.com'];
		Test.startTest();
		System.runAs(u){
			Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();

			TestFactory.createAccounts(baRt,'AccountServiceTestForAddressUpdate','9 King St E','Seattle','WA','US','12111',
					'Pending',UserInfo.getUserId(),TRUE,TRUE,1,true);
			Account a1 = [SELECT Id, BillingCity FROM Account WHERE Name = 'AccountServiceTestForAddressUpdate' LIMIT 1];
			a1.BillingCity = 'Montreal';

			update a1;

			a1 = [SELECT Id, Address_Verification_Status__c FROM Account WHERE Name = 'AccountServiceTestForAddressUpdate' LIMIT 1];

			System.assertEquals('In Verification', a1.Address_Verification_Status__c,'Success');
		}
		Test.stopTest();
	}

	/* ClaimsV2-828 - Update the address verfication status if the billing address is saved by Melissa Data Service */
	/* Test case to verify if the data fed to Melissa is updated properly to the Account's Billing Address */
	@isTest static void UpdateAddressVerificationStatus_WithMelissa_ForBuildingAccounts()
	{
		User u =[SELECT Id FROM User WHERE Username = 'claimsManagerMelissaTestUsr@iko.com'];
		Test.startTest();
		System.runAs(u){
			Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();

			TestFactory.createAccounts(baRt,'AccountServiceTestForAddressUpdate','9 King St E','Seattle','WA','US','12111',
					'In Verification',UserInfo.getUserId(),TRUE,TRUE,1,true);

			Account a1 = [SELECT Id FROM Account WHERE Name = 'AccountServiceTestForAddressUpdate' LIMIT 1];

			MDPERSONATOR.MD_ExpressEntry.updateRecord(a1.Id, '{"BillingStreet":"55 Fielding Dr Se","BillingCity":"Calgary","BillingStateCode":"AB","BillingPostalCode":"T2H 1H3","BillingCountryCode":"CA"}');

			a1 = [SELECT Id, Address_Verification_Status__c,BillingCity FROM Account WHERE Name = 'AccountServiceTestForAddressUpdate' LIMIT 1];

			System.assertEquals('Verified', a1.Address_Verification_Status__c, 'Success');
		}

		Test.stopTest();
	}
}