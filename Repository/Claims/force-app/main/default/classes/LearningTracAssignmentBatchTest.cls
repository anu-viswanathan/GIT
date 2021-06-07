@isTest
public class LearningTracAssignmentBatchTest {

	@TestSetup
	private static void initData() {
		LearningTracAssignmentTestDataFactory.createLearningTracks();
		System.runAs(LearningTracAssignmentTestDataFactory.adminUser) {
			LearningTracAssignmentTestDataFactory.createCompanies();
		}
	}

	@isTest
	public static void testBatchExecution() {

		Map<String, Map<String, Id>> idByCompanyAndUserProfileNames = LearningTracAssignmentTestDataFactory.userIdByCompanyNameAndUserProfileName;
		Map<Id, List<List<String>>> actualTrackNamesAndStatuses = LearningTracAssignmentTestDataFactory.actualTrackNamesAndStatusesByUserId;
        
		ID c1ContractorId = idByCompanyAndUserProfileNames.get(LearningTracAssignmentTestDataFactory.COMPANY_1).get(LearningTracAssignmentService.CONTRACTOR_NAME);
		ID c1ContractorAdminId = idByCompanyAndUserProfileNames.get(LearningTracAssignmentTestDataFactory.COMPANY_1).get(LearningTracAssignmentService.CONTRACTOR_ADMIN_NAME);

		ID c2ContractorId = idByCompanyAndUserProfileNames.get(LearningTracAssignmentTestDataFactory.COMPANY_2).get(LearningTracAssignmentService.CONTRACTOR_NAME);
		ID c2ContractorAdminId = idByCompanyAndUserProfileNames.get(LearningTracAssignmentTestDataFactory.COMPANY_2).get(LearningTracAssignmentService.CONTRACTOR_ADMIN_NAME);

		ID c3ContractorId = idByCompanyAndUserProfileNames.get(LearningTracAssignmentTestDataFactory.COMPANY_3).get(LearningTracAssignmentService.CONTRACTOR_NAME);
		ID c3ContractorAdminId = idByCompanyAndUserProfileNames.get(LearningTracAssignmentTestDataFactory.COMPANY_3).get(LearningTracAssignmentService.CONTRACTOR_ADMIN_NAME);

		ID c4ContractorId = idByCompanyAndUserProfileNames.get(LearningTracAssignmentTestDataFactory.COMPANY_4).get(LearningTracAssignmentService.CONTRACTOR_NAME);
		ID c4ContractorAdminId = idByCompanyAndUserProfileNames.get(LearningTracAssignmentTestDataFactory.COMPANY_4).get(LearningTracAssignmentService.CONTRACTOR_ADMIN_NAME);

		ID c5ContractorId = idByCompanyAndUserProfileNames.get(LearningTracAssignmentTestDataFactory.COMPANY_5).get(LearningTracAssignmentService.CONTRACTOR_NAME);
		ID c5ContractorAdminId = idByCompanyAndUserProfileNames.get(LearningTracAssignmentTestDataFactory.COMPANY_5).get(LearningTracAssignmentService.CONTRACTOR_ADMIN_NAME);

		ID c6ContractorId = idByCompanyAndUserProfileNames.get(LearningTracAssignmentTestDataFactory.COMPANY_6).get(LearningTracAssignmentService.CONTRACTOR_NAME);
		ID c6ContractorAdminId = idByCompanyAndUserProfileNames.get(LearningTracAssignmentTestDataFactory.COMPANY_6).get(LearningTracAssignmentService.CONTRACTOR_ADMIN_NAME);

		//Company 1 with Tier 1 and its users without training track assignments
		System.assertEquals(null, actualTrackNamesAndStatuses.get(c1ContractorId));
		System.assertEquals(null, actualTrackNamesAndStatuses.get(c1ContractorAdminId));

		//Company 2 with Tier 2 and its users without training track assignments
		System.assertEquals(null, actualTrackNamesAndStatuses.get(c2ContractorId));
		System.assertEquals(null, actualTrackNamesAndStatuses.get(c2ContractorAdminId));

		//Company 3 with Tier 3 and its users without training track assignments
		System.assertEquals(null, actualTrackNamesAndStatuses.get(c3ContractorId));
		System.assertEquals(null, actualTrackNamesAndStatuses.get(c3ContractorAdminId));

		//Company 4 with Tier 3 and its users with training track assignments (tier 3)
		System.assertEquals(LearningTracAssignmentTestDataFactory.trackSet_Tier3StAndInProgress, actualTrackNamesAndStatuses.get(c4ContractorId));
		System.assertEquals(LearningTracAssignmentTestDataFactory.trackSet_Tier3CaAndInProgress, actualTrackNamesAndStatuses.get(c4ContractorAdminId));

		//Company 5 with Tier 1 and its users with training track assignments (tier 3) before batch execution
		System.assertEquals(LearningTracAssignmentTestDataFactory.trackSet_Tier3StAndInProgress, actualTrackNamesAndStatuses.get(c5ContractorId));
		System.assertEquals(LearningTracAssignmentTestDataFactory.trackSet_Tier3CaAndInProgress, actualTrackNamesAndStatuses.get(c5ContractorAdminId));

		//Company 6 with record type that is not equal to 'IKOPRO Contractor' value
		System.assertEquals(null, actualTrackNamesAndStatuses.get(c6ContractorId));
		System.assertEquals(null, actualTrackNamesAndStatuses.get(c6ContractorAdminId));

		Test.startTest();
		Database.executeBatch(new LearningTracAssignmentBatch());
		Test.stopTest();

		//In order to update values in Map
		LearningTracAssignmentTestDataFactory.actualTrackNamesAndStatusesByUserId = null;
		actualTrackNamesAndStatuses = LearningTracAssignmentTestDataFactory.actualTrackNamesAndStatusesByUserId;

		//Company 1 with Tier 1 and its users without training track assignments
		System.assertEquals(LearningTracAssignmentTestDataFactory.trackSet_Tier1NotStarted, actualTrackNamesAndStatuses.get(c1ContractorId));
		System.assertEquals(LearningTracAssignmentTestDataFactory.trackSet_Tier1NotStarted, actualTrackNamesAndStatuses.get(c1ContractorAdminId));

		//Company 2 with Tier 2 and its users without training track assignments
		System.assertEquals(LearningTracAssignmentTestDataFactory.trackSet_Tier2StAndNotStarted, actualTrackNamesAndStatuses.get(c2ContractorId));
		System.assertEquals(LearningTracAssignmentTestDataFactory.trackSet_Tier2CaAndNotStarted, actualTrackNamesAndStatuses.get(c2ContractorAdminId));

		//Company 3 with Tier 3 and its users without training track assignments
		System.assertEquals(LearningTracAssignmentTestDataFactory.trackSet_Tier3StAndNotStarted, actualTrackNamesAndStatuses.get(c3ContractorId));
		System.assertEquals(LearningTracAssignmentTestDataFactory.trackSet_Tier3CaAndNotStarted, actualTrackNamesAndStatuses.get(c3ContractorAdminId));

		//Company 4 with Tier 3 and its users with training track assignments (tier 3)
		System.assertEquals(LearningTracAssignmentTestDataFactory.trackSet_Tier3StAndInProgress, actualTrackNamesAndStatuses.get(c4ContractorId));
		System.assertEquals(LearningTracAssignmentTestDataFactory.trackSet_Tier3CaAndInProgress, actualTrackNamesAndStatuses.get(c4ContractorAdminId));

		//Company 5 with Tier 1 and its users with training track assignments (tier 3) before batch execution
		//System.assertEquals(LearningTracAssignmentTestDataFactory.trackSet_Tier1NotStarted, actualTrackNamesAndStatuses.get(c5ContractorId));
		//System.assertEquals(LearningTracAssignmentTestDataFactory.trackSet_Tier1NotStarted, actualTrackNamesAndStatuses.get(c5ContractorAdminId));

		//Company 6 with record type that is not equal to 'IKOPRO Contractor' value
		System.assertEquals(null, actualTrackNamesAndStatuses.get(c6ContractorId));
		System.assertEquals(null, actualTrackNamesAndStatuses.get(c6ContractorAdminId));
	}
}