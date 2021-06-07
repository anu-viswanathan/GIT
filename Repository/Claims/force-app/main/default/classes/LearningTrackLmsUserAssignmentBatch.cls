public class LearningTrackLmsUserAssignmentBatch implements Database.Batchable<sObject> {

	public static final String CONTRACTOR_NAME = 'IKOPRO Contractor';

	private Set<String> permissionNames;

	public LearningTrackLmsUserAssignmentBatch() {
		permissionNames = new Set<String>{
			'LMS_External_User',
			'LMS_Player_User',
			'Player_User'
		};
	}

	public Database.QueryLocator start(Database.BatchableContext BC) {
		Set<String> tierNames = new Set<String>();
		Set<String> profileNames = new Set<String>();

		for (List<String> batchOrderConfigList : LearningTracAssignmentService.batchOrderConfig) {
			tierNames.add(batchOrderConfigList[0]);
			profileNames.add(batchOrderConfigList[1]);
		}
		
		Id contractorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(CONTRACTOR_NAME).getRecordTypeId();
		String query = 'SELECT Id FROM User ' +
			'WHERE Contact.Account.Present_Tier_Formula__c IN :tierNames ' +
			'AND Contact.Account.RecordType.Id = :contractorRecordTypeId ' +
			'AND Profile.Name IN :profileNames ';
		query += Test.isRunningTest() ? 'AND Username LIKE \'%' + LearningTracAssignmentTestDataFactory.UNIQ_MARK_FOR_SOQL + '%\'' : '';
		return Database.getQueryLocator(query);
	}

	public void execute(Database.BatchableContext BC, List<sObject> scope) {
		List<User> users = (List<User>) scope;
		Set<Id> userIds = new Map<Id, User>(users).keySet();
		assignLmsUserIfUnassigned(userIds);
	}

	public void finish(Database.BatchableContext BC) {
		Database.executeBatch(new LearningTracAssignmentBatch(), LearningTracAssignmentBatch.batchChunkSize);
	}

	private Set<Id> getLmsUserPermissionSet() {
		Set<Id> permIds = new Set<Id>();
		for (PermissionSet p : [SELECT Id FROM PermissionSet WHERE Name IN :permissionNames]) {
			permIds.add(p.Id);
		}
		return permIds;
	}

	private void assignLmsUserIfUnassigned(Set<Id> userIds) {
		Set<Id> permIds = getLmsUserPermissionSet();
		List<PermissionSetAssignment> assignments = [
			SELECT Id,
				AssigneeId,
				PermissionSetId
			FROM PermissionSetAssignment
			WHERE PermissionSetId IN :permIds
			AND AssigneeId IN :userIds
		];
		Map<Id, Set<Id>> assignedUserPermissionSets = new Map<Id, Set<Id>>();
		for (PermissionSetAssignment assignment : assignments) {
			if (!assignedUserPermissionSets.containsKey(assignment.AssigneeId)) {
				assignedUserPermissionSets.put(assignment.AssigneeId, new Set<Id>{
					assignment.PermissionSetId
				});
			} else {
				Set<Id> permissions = assignedUserPermissionSets.get(assignment.AssigneeId);
				permissions.add(assignment.PermissionSetId);
			}
		}

		List<PermissionSetAssignment> newAssignments = new List<PermissionSetAssignment>();
		for (Id userId : userIds) {
			Set<Id> assignedPermissions = assignedUserPermissionSets.get(userId);
			for (id permId : permIds) {
				if (assignedPermissions != null && assignedPermissions.contains(permId)) {
					continue;
				}
				newAssignments.add(new PermissionSetAssignment(
					PermissionSetId = permId,
					AssigneeId = userId
				));
			}
		}

		insert newAssignments;
	}

}