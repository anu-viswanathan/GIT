public class icLogicTierMovementLog implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		Account_Tier_Movement__c createNewTierMovementLog(icDtoTierMovementConfig processConfig, Account contractor, Contact primaryContact, Integer calculatedMonth, Double calculatedSqares, Boolean isSignupYear, String tierMovement, Double tier1High, Double tier2Low, Double tier2High, Double tier3Low);
		void saveTierMovementLog(List<Account_Tier_Movement__c> tierMovementLogs);
	}

	public class Impl implements IClass {

		icRepoTierMovementLog.IClass repo = (icRepoTierMovementLog.IClass) icObjectFactory.GetSingletonInstance('icRepoTierMovementLog');

		Map<String, String> mapMovementDecision {
			get {
				if(mapMovementDecision == null) {
					mapMovementDecision = new Map<String, String>();
					mapMovementDecision.put('MAINTAIN', 'Maintained Sq. Purchase Volume');
					mapMovementDecision.put('ASCEND', 'Exceeded Sq. Purchase Volume');
					mapMovementDecision.put('DESCEND', 'Did Not Meet Minimum Sq. Purchase Volume');
				}
				return mapMovementDecision;
			}
			set;
		}

		public Account_Tier_Movement__c createNewTierMovementLog(icDtoTierMovementConfig processConfig, Account contractor, Contact primaryContact, Integer calculatedMonth, Double calculatedSqares, Boolean isSignupYear, String tierMovement, Double tier1High, Double tier2Low, Double tier2High, Double tier3Low) {

			System.debug('mapMovementDecision : ' + mapMovementDecision);
			System.debug('tierMovement : ' + tierMovement);

			Account_Tier_Movement__c newTierMovementLog = new Account_Tier_Movement__c();
			newTierMovementLog.ATM_Simulation__c = processConfig.isSimulation;
			newTierMovementLog.ATM_Contractor__c = contractor.Id;
			newTierMovementLog.ATM_Member_Since_Months__c = calculatedMonth;
			newTierMovementLog.ATM_Applicable_Invoice_Year__c = processConfig.rebateYear;
			newTierMovementLog.ATM_Purchase_Square_Volume__c = calculatedSqares;
			newTierMovementLog.ATM_Sign_Up_Year__c = isSignupYear;
			newTierMovementLog.ATM_Tier_Movement_Decision__c = mapMovementDecision.get(tierMovement);
			newTierMovementLog.ATM_Business_Fundamentals_Completed__c = contractor.Business_Fundamentals_Completed__c;
			newTierMovementLog.ATM_Installation_Fundamentals_Completed__c = contractor.IF_Course_Affirmation__c;
			newTierMovementLog.ATM_Performance_Fundamentals_Completed__c = contractor.Performance_Fundamentals_Completed__c;
			newTierMovementLog.ATM_Safety_Fundamentals_Completed__c = contractor.Safety_Fundamentals_Completed__c;
			newTierMovementLog.ATM_Applied_Benchmark_Value_Tier_1_High__c = tier1High;
			newTierMovementLog.ATM_Applied_Benchmark_Value_Tier_2_Low__c = tier2Low;
			newTierMovementLog.ATM_Applied_Benchmark_Value_Tier_2_High__c = tier2High;
			newTierMovementLog.ATM_Applied_Benchmark_Value_Tier_3_Low__c = tier3Low;
			newTierMovementLog.ATM_Date_Present_Tier__c = contractor.Date_Present_Tier__c;
			newTierMovementLog.ATM_Present_Tier__c = contractor.Present_Tier_Lookup__c;
			newTierMovementLog.ATM_Prior_Tier__c = contractor.Prior_Tier__c;
			newTierMovementLog.ATM_TSR_Email__c = contractor.Owner.Email;
			newTierMovementLog.ATM_Contractor_Email__c = contractor.Admin_Email_Address__c;
			if(primaryContact != null) {
				newTierMovementLog.ATM_Contact_Name__c = primaryContact.Id;
			}
			return newTierMovementLog;
		}

		public void saveTierMovementLog(List<Account_Tier_Movement__c> tierMovementLogs) {
            List<Database.SaveResult> saveResults = repo.saveTierMovementLog(tierMovementLogs);
            icServiceErrorHandler.handleDatabaseSaveResult(tierMovementLogs, saveResults, 'icLogicTierMovementLog', 'saveTierMovementLog');
        }
	}
}