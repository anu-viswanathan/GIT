public with sharing class SettlementConditionService {

	/*
		Block all updates for Case when the Claim_Stage__c is Closed, *unless* it is being re-opened
	*/
	public static void blockCreatedUpdateDelete(List<Settlement_Condition__c> records) {
		User runningUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];

		Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
		List<Id> caseIds = new List<Id>();

		for (Settlement_Condition__c record : records)
			caseIds.add(record.Case__c);

		// SOQL query modified as part of US IWCN-723
		Map<Id, Case> caseMap = new Map<Id, Case>(
		[
				SELECT Id, RecordTypeId, Claim_Stage__c, ClaimApproved__c, Claim_Sub_Stage__c
				FROM Case
				WHERE Id IN :caseIds
				AND RecordTypeId IN :claimRecordTypes.keySet()
				AND
				(
						Claim_Stage__c = 'Closed' OR
						ClaimApproved__c = true OR
						(Claim_Stage__c = 'Assessment' AND Claim_Sub_Stage__c = 'In Approval')
				)
		]
		);

		if (caseMap.isEmpty()) {
			return;
		}

		for (Settlement_Condition__c record : records) {
			Case caseRecord = caseMap.get(record.Case__c);
			if (runningUser.Profile.Name != 'System Administrator') {
				if (caseRecord.Claim_Stage__c == 'Closed') {
					record.addError('Settlement Conditions cannot be modified for a closed case');
				} else {
					record.addERror('Case Settlement Condition cannot be modifed after submitting for approval');
				}
			}
		}
	}
}