public class LearningTracAssignmentBatch implements Database.Batchable<sObject> {

	public static final Integer batchChunkSize = 15;
	private Integer batchOrdinalNumber;

	public LearningTracAssignmentBatch() {
		this(0);
	}

	public LearningTracAssignmentBatch(Integer batchOrdinalNumber) {
		this.batchOrdinalNumber = batchOrdinalNumber;
	}

	public Database.QueryLocator start(Database.BatchableContext batchableContext) {
		Id contractorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(LearningTracAssignmentService.CONTRACTOR_NAME).getRecordTypeId();
		String tierName = LearningTracAssignmentService.batchOrderConfig[batchOrdinalNumber][0];
		String profileName = LearningTracAssignmentService.batchOrderConfig[batchOrdinalNumber][1];
		String query = 'SELECT Id, Name, LanguageLocaleKey, Contact.Account.Present_Tier_Lookup__r.Tier_Label__c, Profile.Name ' +
			'FROM User ' +
			'WHERE Contact.Account.Present_Tier_Lookup__r.Tier_Label__c = :tierName ' +
			'AND Contact.Account.RecordType.Id = :contractorRecordTypeId ' +
			'AND Profile.Name = :profileName ';

		List<Tier__c> tier = [SELECT Id FROM Tier__c WHERE Tier_Label__c =:tierName];
		if (Test.isRunningTest()) {
			Id tid = tier.get(0).Id;
			query = 'SELECT Id, Name, LanguageLocaleKey, Contact.Account.Present_Tier_Lookup__r.Tier_Label__c, Profile.Name ' +
				'FROM User ' +
				'WHERE Contact.Account.Present_Tier_Lookup__c =:tid ' +
				'AND Contact.Account.RecordType.Id = :contractorRecordTypeId ' +
				'AND Profile.Name = :profileName ';
		}
		query += Test.isRunningTest() ? 'AND Username LIKE \'%' + LearningTracAssignmentTestDataFactory.UNIQ_MARK_FOR_SOQL + '%\'' : '';
		return Database.getQueryLocator(query);
	}

	// Chunk size for users is less 20, because of redwing.LMS_API.upsertTrackAssignments() limits
	public void execute(Database.BatchableContext batchableContext, List<User> users) {
		LearningTracAssignmentService.updateUserTrackAssignments(users);
	}

	public void finish(Database.BatchableContext batchableContext) {
		Integer nextBatchOrdinalNumber = ++batchOrdinalNumber;
		if(nextBatchOrdinalNumber < LearningTracAssignmentService.batchOrderConfig.size()) {
			Database.executeBatch(new LearningTracAssignmentBatch(nextBatchOrdinalNumber), batchChunkSize);
		}
	}
}