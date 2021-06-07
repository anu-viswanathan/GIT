@isTest
public class LearningTracAssignmentBatchCRCTest {

	@TestSetup
	private static void initData() {
		LearningTracAssignmentTestDataFactoryCRC.createLearningTracks();
		System.runAs(LearningTracAssignmentTestDataFactoryCRC.adminUser) {
			LearningTracAssignmentTestDataFactoryCRC.createCompanies();
		}
	}

	@isTest
	public static void testBatchExecution() {

		Map<String, Map<String, Id>> idByCompanyAndUserProfileNames = LearningTracAssignmentTestDataFactoryCRC.userIdByCompanyNameAndUserProfileName;
		Map<Id, List<List<String>>> actualTrackNamesAndStatuses = LearningTracAssignmentTestDataFactoryCRC.actualTrackNamesAndStatusesByUserId;
        
		ID c1ContractorId = idByCompanyAndUserProfileNames.get(LearningTracAssignmentTestDataFactoryCRC.COMPANY_1).get(LearningTracAssignmentServiceCRC.CONTRACTOR_NAME);
		ID c1ContractorAdminId = idByCompanyAndUserProfileNames.get(LearningTracAssignmentTestDataFactoryCRC.COMPANY_1).get(LearningTracAssignmentServiceCRC.CONTRACTOR_ADMIN_NAME);

		ID c6ContractorId = idByCompanyAndUserProfileNames.get(LearningTracAssignmentTestDataFactoryCRC.COMPANY_6).get(LearningTracAssignmentServiceCRC.CONTRACTOR_NAME);
		ID c6ContractorAdminId = idByCompanyAndUserProfileNames.get(LearningTracAssignmentTestDataFactoryCRC.COMPANY_6).get(LearningTracAssignmentServiceCRC.CONTRACTOR_ADMIN_NAME);

		//Company 1 with Tier 1 and its users without training track assignments
		System.assertEquals(null, actualTrackNamesAndStatuses.get(c1ContractorId));
		System.assertEquals(null, actualTrackNamesAndStatuses.get(c1ContractorAdminId));

		//Company 6 with record type that is not equal to 'IKOPRO Contractor' value
		System.assertEquals(null, actualTrackNamesAndStatuses.get(c6ContractorId));
		System.assertEquals(null, actualTrackNamesAndStatuses.get(c6ContractorAdminId));

		Test.startTest();
		Database.executeBatch(new LearningTracAssignmentBatchCRC());
		Test.stopTest();

		//In order to update values in Map
		LearningTracAssignmentTestDataFactoryCRC.actualTrackNamesAndStatusesByUserId = null;
		actualTrackNamesAndStatuses = LearningTracAssignmentTestDataFactoryCRC.actualTrackNamesAndStatusesByUserId;

		//Company 1 with Tier 1 and its users without training track assignments
		System.assertEquals(LearningTracAssignmentTestDataFactoryCRC.trackSet_Tier1NotStarted, actualTrackNamesAndStatuses.get(c1ContractorId));
		System.assertEquals(LearningTracAssignmentTestDataFactoryCRC.trackSet_Tier1NotStarted, actualTrackNamesAndStatuses.get(c1ContractorAdminId));

		//Company 6 with record type that is not equal to 'IKOPRO Contractor' value
		System.assertEquals(null, actualTrackNamesAndStatuses.get(c6ContractorId));
		System.assertEquals(null, actualTrackNamesAndStatuses.get(c6ContractorAdminId));
	}
}