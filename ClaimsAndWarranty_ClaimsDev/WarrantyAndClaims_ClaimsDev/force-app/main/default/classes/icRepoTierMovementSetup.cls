public class icRepoTierMovementSetup implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		Tier_Movement_Setup__c getTierMovementSetup();
	}

	public class Impl implements IClass {

		public Tier_Movement_Setup__c getTierMovementSetup() {
			Tier_Movement_Setup__c returnTierMovementSetup;
			List<Tier_Movement_Setup__c> listTierMovementSetup =
					[SELECT	Id
							,Name
							,Admin_Email__c
							,Simulation__c
							,Tier_Advancement_Start_Date__c
							,Tier_Advancement_End_Date__c
							,Tier_Advancement_Invoice_Year__c
							,Tier_Maintenance_Descend_Date__c
							,Tier_Maintenance_Descend_Invoice_Year__c
					FROM	Tier_Movement_Setup__c LIMIT 1];

			if(listTierMovementSetup.size() > 0) {
				returnTierMovementSetup = listTierMovementSetup[0];
			}
			return returnTierMovementSetup;
		}
	}
}