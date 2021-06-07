public class icRepoTierMovementLog implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		List<Database.SaveResult> saveTierMovementLog(List<Account_Tier_Movement__c> tierMovementLog);
	}

	public class Impl implements IClass {

		public List<Database.SaveResult> saveTierMovementLog(List<Account_Tier_Movement__c> tierMovementLog) {
            return Database.insert(tierMovementLog, false);
        }
	}
}