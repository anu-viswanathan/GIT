public class icRepoTier implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		List<Tier__c> getAllTiers();
	}

	public class Impl implements IClass {

		public List<Tier__c> getAllTiers() {
			return [SELECT	Id
							,Name
							,Tier_Label__c
							,Minimum_Squares__c
							,Maximum_Squares__c
					FROM	Tier__c];
		}
	}
}