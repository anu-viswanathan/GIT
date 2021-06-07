public class icLogicTier implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		List<Tier__c> getAllTiers();
		Map<String, Tier__c> getMapTiersByName(List<Tier__c> tiers);
	}

	public class Impl implements IClass {

		icRepoTier.IClass repository = (icRepoTier.IClass) icObjectFactory.GetSingletonInstance('icRepoTier');

		public List<Tier__c> getAllTiers() {
			return repository.getAllTiers();
		}

		public Map<String, Tier__c> getMapTiersByName(List<Tier__c> tiers) {
			Map<String, Tier__c> returnMap = new Map<String, Tier__c>();
			for(Tier__c thisTier : tiers) {
				returnMap.put(thisTier.Id, thisTier);
			}
			return returnMap;
		}
	}
}