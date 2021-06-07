@isTest
private class LearningTrackLmsUserAssignmentBatchTest {

	@TestSetup
	private static void initData() {
		LearningTracAssignmentTestDataFactory.createLearningTracks();
		System.runAs(LearningTracAssignmentTestDataFactory.adminUser) {
			LearningTracAssignmentTestDataFactory.createCompanies();
		}
	}

	@isTest
	private static void testExecute() {
		Id contractorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(LearningTrackLmsUserAssignmentBatch.CONTRACTOR_NAME).getRecordTypeId();
		List<User> users = [
			SELECT Id
			FROM User
			WHERE Username LIKE :'%' + LearningTracAssignmentTestDataFactory.UNIQ_MARK_FOR_SOQL + '%'
			AND Contact.Account.Present_Tier_Formula__c != null
			AND Contact.Account.RecordTypeId =: contractorRecordTypeId
		];
		List<PermissionSet> permissionSets = [
			SELECT Id
			FROM PermissionSet
			WHERE Name IN :new Set<String>{
				'LMS_External_User'
			}
		];

		System.assert(getPermissionSetAssigmentNumber(permissionSets, users) == 0);

		Test.startTest();
		Database.executeBatch(new LearningTrackLmsUserAssignmentBatch());
		Test.stopTest();

		System.assert(getPermissionSetAssigmentNumber(permissionSets, users) == users.size());
	}

	private static Integer getPermissionSetAssigmentNumber(List<PermissionSet> permissionSets, List<User> users) {
		List<PermissionSetAssignment> assignments = [
			SELECT Id,
				AssigneeId,
				PermissionSetId
			FROM PermissionSetAssignment
			WHERE PermissionSetId IN :permissionSets
			AND AssigneeId IN :users
		];
		return assignments.size();
	}
}