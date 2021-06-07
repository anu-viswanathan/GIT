@isTest
public class LearningTracAssignmentServiceTest {

	@isTest
	private static void testGetCommunityId() {
		Id communityId = LearningTracAssignmentService.communityId;
		System.assert(communityId != null);
	}

	@isTest
	private static void testUpdateUserTrackAssignments() {

		initTestData();

		Id contractorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(LearningTracAssignmentService.CONTRACTOR_NAME).getRecordTypeId();
		Account testAccount = new Account(
			Name = 'test',
			Partner_Lead_Queue_Created__c = true,
			Present_Tier_Lookup__c = [SELECT Id FROM Tier__c WHERE Tier_Label__c = '1' LIMIT 1].Id,
			Prior_Tier__c = 'ROOFPRO Select',
			RecordTypeId = contractorRecordTypeId,
            BillingPostalCode = '22222'
		);
		insert testAccount;
        Contact applicantInfo = new Contact(
            AccountId = testAccount.Id,
			LastName = 'applicantInfo',
            Status_Match_Applicant__c = true,
            Membership_Start_Date_Applicant__c = Date.today().addDays(-1)            
		);
		insert applicantInfo;
        testAccount.Applicant_Information__c = applicantInfo.Id;
        update testAccount;
		Contact testContact = new Contact(
			AccountId = testAccount.Id,
			LastName = 'test'
		);
		insert testContact;
		User contractorAdmin = new User(
			ProfileId = LearningTracAssignmentTestDataFactory.contractorAdminProfileId,
			ContactId = testContact.Id,
			CREATE_QUEUE__c = true,
			Username = System.currentTimeMillis() + 'testassign@username.com',
			Alias = 'testAli',
			Email = System.currentTimeMillis() + '@testusemail.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'testName',
			LastName = 'testSurname',
			CommunityNickname = 'testNick',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			LanguageLocaleKey = 'en_US'
		);
		insert contractorAdmin;

		redwing.LMS_API.upsertTrackAssignments(new Set<Id>{contractorAdmin.Id}, [SELECT Id FROM redwing__Training_Track__c WHERE Name =: LearningTracAssignmentService.LEARNING_TRAC_NAMES[1]].Id, null);

		User userToProceed = [SELECT Id, Name, LanguageLocaleKey, Contact.Account.Present_Tier_Lookup__r.Tier_Label__c, Profile.Name FROM User WHERE LastName = 'testSurname'];

		Test.startTest();
		LearningTracAssignmentService.updateUserTrackAssignments(new List<User>{userToProceed});
		Test.stopTest();

		List<redwing__Training_Plan_Assignment__c> archivedUserPlanAssignments = [
			SELECT Id, redwing__Training_Plan__r.Name
			FROM redwing__Training_Plan_Assignment__c
			WHERE Archived_User__c =: userToProceed.Id
		];
		List<redwing__Training_Plan_Assignment__c> userPlanAssignments = [
			SELECT Id, redwing__Training_Plan__r.Name
			FROM redwing__Training_Plan_Assignment__c
			WHERE redwing__User__c =: userToProceed.Id
		];
		List<redwing__Training_Track_Assignment__c> archivedUserTracAssignments = [
			SELECT Id, redwing__Training_Track__r.Name
			FROM redwing__Training_Track_Assignment__c
			WHERE Archived_User__c =: userToProceed.Id
		];
		List<redwing__Training_Track_Assignment__c> userTracAssignments = [
			SELECT Id, redwing__Training_Track__r.Name
			FROM redwing__Training_Track_Assignment__c
			WHERE redwing__User__c =: userToProceed.Id
		];

		System.assertEquals(2, userPlanAssignments.size());
		System.assertEquals(0, archivedUserPlanAssignments.size());
		System.assertEquals(2, userTracAssignments.size());
		System.assertEquals(0, archivedUserTracAssignments.size());
		System.assertEquals('Learning Trac - Tier 2-CA', userTracAssignments[0].redwing__Training_Track__r.Name);
		//System.assertEquals(LearningTracAssignmentService.LEARNING_TRAC_NAMES[1], archivedUserTracAssignments[0].redwing__Training_Track__r.Name);
	}
	private static void initTestData() {
		Tier__c testTier2 = new Tier__c(
			Tier_Label__c = '2'
		);
		insert testTier2;
		Tier__c testTier1 = new Tier__c(
			Tier_Label__c = '1'
		);
		insert testTier1;

		redwing__Training_Track__c tierTrac = new redwing__Training_Track__c(
			Name = LearningTracAssignmentService.LEARNING_TRAC_NAMES[1],
			redwing__Status__c = 'Active'
		);
		insert tierTrac;
		redwing__Training_Track__c tierTracPrev = new redwing__Training_Track__c(
			Name = LearningTracAssignmentService.LEARNING_TRAC_NAMES[0],
			redwing__Status__c = 'Active'
		);
		insert tierTracPrev;

		redwing__Training_Plan__c tierTracsPlan = new redwing__Training_Plan__c(
			Name = 'Safety Fundamentals',
            redwing__Status__c = 'Active'
		);
		insert tierTracsPlan;
		redwing__Training_Plan__c tierTracsPlanPrev = new redwing__Training_Plan__c(
			Name = 'Business Fundamentals',
            redwing__Status__c = 'Active'
		);
		insert tierTracsPlanPrev;

		redwing__Learning__c testLearning  = new redwing__Learning__c(
			redwing__Published__c = true,
			Name = 'Test Learning',
			RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'RichText'].Id
		);
		insert testLearning;

		redwing__Training_Track_Level__c tracLevel1 = new redwing__Training_Track_Level__c(
			Name = 'Test Level 1',
			redwing__Training_Track__c = tierTrac.Id
		);
		insert tracLevel1;
		redwing__Training_Track_Level__c tracLevel2 = new redwing__Training_Track_Level__c(
			Name = 'Test Level 2',
			redwing__Training_Track__c = tierTrac.Id
		);
		insert tracLevel2;
		redwing__Training_Track_Level__c tracLevelPrev = new redwing__Training_Track_Level__c(
			Name = 'Test Level 2',
			redwing__Training_Track__c = tierTracPrev.Id
		);
		insert tracLevelPrev;

		redwing__Training_Track_Level_Item__c tracLevelItem1 = new redwing__Training_Track_Level_Item__c(
			redwing__Training_Track_Level__c = tracLevel1.Id,
			redwing__Training_Plan__c = tierTracsPlan.Id
		);
		insert tracLevelItem1;
		redwing__Training_Track_Level_Item__c tracLevelItem2 = new redwing__Training_Track_Level_Item__c(
			redwing__Training_Track_Level__c = tracLevel2.Id,
			redwing__Training_Plan__c = tierTracsPlanPrev.Id
		);
		insert tracLevelItem2;
		redwing__Training_Track_Level_Item__c tracLevelItemPrev = new redwing__Training_Track_Level_Item__c(
			redwing__Training_Track_Level__c = tracLevelPrev.Id,
			redwing__Training_Plan__c = tierTracsPlanPrev.Id
		);
		insert tracLevelItemPrev;
		
		redwing__Training_Plan_Section__c planSection = new redwing__Training_Plan_Section__c(
			redwing__Training_Plan__c = tierTracsPlan.Id
		);
		insert planSection;
		redwing__Training_Plan_Section__c planSectionPrev = new redwing__Training_Plan_Section__c(
			redwing__Training_Plan__c = tierTracsPlanPrev.Id
		);
		insert planSectionPrev;
		
		redwing__Training_Plan_Section_Item__c planSectionItem = new redwing__Training_Plan_Section_Item__c(
			redwing__Training_Plan_Section__c = planSection.Id,
			redwing__Learning__c = testLearning.Id
		);
		insert planSectionItem;
		redwing__Training_Plan_Section_Item__c planSectionItemPrev = new redwing__Training_Plan_Section_Item__c(
			redwing__Training_Plan_Section__c = planSectionPrev.Id,
			redwing__Learning__c = testLearning.Id
		);
		insert planSectionItemPrev;

		redwing__RichText__c testRichText = new redwing__RichText__c(
			Name = 'Test Rich Text',
			redwing__Learning__c = testLearning.Id
		);
		insert testRichText;

		redwing__RichText_Content__c richContent = new redwing__RichText_Content__c(
			redwing__RichText__c = testRichText.Id,
			redwing__Content__c = 'Some test content'
		);
		insert richContent;
	}
}