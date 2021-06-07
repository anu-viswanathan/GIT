public class icLogicOpportunity implements icIClass {

	public Object GetInstance(){
		return new Impl();
	}

	public Interface IClass {
		Integer getCurrentOpportunitiesCountByAccountId(String recordId);
		Opportunity getOpportunityDataForGreenSky(Id opportunityId);
		Map<Id,Opportunity>  getApprovedOpportunitiesByListId(Set<Id> opportunityIds,Id recordTypeId);
		List<Opportunity> getBidderForOpportunity(List<Id> opportunityIdList);
		Map<Id,List<Opportunity>> getOpportunityByAccountsIdsIsClosedAndRecordTypeId(Set<Id> accountIds,Boolean isClosed,Id recordTypeId);
		Map<Id,List<Opportunity>> createMapAccountIdToOpportunityList(List<Opportunity> opportunityResultList);
	}

	public class Impl implements IClass {

		icRepoOpportunity.IClass repoOpportunity = (icRepoOpportunity.IClass) icObjectFactory.GetSingletonInstance('icRepoOpportunity');
		
		public Integer getCurrentOpportunitiesCountByAccountId(String recordId){
			List<Opportunity> listOpportunities = repoOpportunity.getCurrentOpportunitiesByAccountId(recordId);
			return listOpportunities.size();
		}

		public Opportunity getOpportunityDataForGreenSky(Id opportunityId){

			return repoOpportunity.getOpportunityDataForGreenSky(opportunityId);
		}

		public Map<Id,Opportunity>  getApprovedOpportunitiesByListId(Set<Id> opportunityIds,Id recordTypeId){
			Map<Id,Opportunity> OpportunitiesMap = new Map<Id,Opportunity>();
			List<Opportunity> results = repoOpportunity.getApprovedOpportunitiesByListID(opportunityIds,recordTypeId);
			System.Debug ( 'result = ' + results.size());
			for (Opportunity result :results){
				OpportunitiesMap.put(result.Id, result);
			}
			 return OpportunitiesMap;
		}
        
        // Added by Anil Mannem
        public List<Opportunity> getBidderForOpportunity(List<Id> opportunityIdList){
            return repoOpportunity.getBidderForOpportunity(opportunityIdList);
		}
		
		public Map<Id,List<Opportunity>> getOpportunityByAccountsIdsIsClosedAndRecordTypeId(Set<Id> accountIds,Boolean isClosed,Id recordTypeId){
			List<Opportunity> opportunityResultList = repoOpportunity.getOpportunityByAccountsIdsIsClosedAndRecordTypeId(accountIds,isClosed,recordTypeId);
			return createMapAccountIdToOpportunityList(opportunityResultList); 
		}
		
		public Map<Id,List<Opportunity>> createMapAccountIdToOpportunityList(List<Opportunity> opportunityResultList){
			Map<Id,List<Opportunity>>  opportunityMap = new Map<Id,List<Opportunity>> ();
			for( Opportunity oppResult : opportunityResultList)
			{
			
				if (!opportunityMap.containsKey(oppResult.AccountId)){
					OpportunityMap.put(oppResult.AccountId, new List<Opportunity>());
				}
				OpportunityMap.get(oppResult.AccountId).add(oppResult);
			}
			return opportunityMap;
		}
	}
}