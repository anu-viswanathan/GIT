public class icRepoOpportunity implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		List<Opportunity> getCurrentOpportunitiesByAccountId(String recordId);
		Opportunity getOpportunityDataForGreenSky(Id opportunityId);
		List<Opportunity> getApprovedOpportunitiesByListID(Set<Id> opportunityIds, Id recordTypeId);
		List<Opportunity> getBidderForOpportunity(List<Id> opportunityIdList);
		List<Opportunity> getOpportunityByAccountsIdsIsClosedAndRecordTypeId(Set<Id> accountIds,Boolean isClosed,Id recordTypeId);
	}

	public class Impl implements IClass {

		public List<Opportunity> getCurrentOpportunitiesByAccountId(String recordId) {
			List<Opportunity> listOpportunities = new List<Opportunity>();
			listOpportunities =
					[SELECT Id
							,Name
					FROM	Opportunity
					WHERE	Contractor__c = :recordId
					AND 	IsClosed = false];
			return listOpportunities;
		}

		public Opportunity getOpportunityDataForGreenSky(Id opportunityId){

			Opportunity myOpp = new Opportunity();

			List<Opportunity> myOpps = new List<Opportunity>();
			myOpps = [
					SELECT 	Id,
							AccountId,
							Amount
					FROM 	Opportunity
					WHERE  	Id = :opportunityId
					LIMIT   1
			];

			if(!myOpps.isEmpty()){
				myOpp = myOpps[0];
			}

			return myOpp;
		}
		public List<Opportunity> getApprovedOpportunitiesByListID(Set<Id> opportunityIds, Id recordTypeId){
			return [SELECT 	Id							
					FROM 	Opportunity
					WHERE  	Id in :opportunityIds
							AND Quote_Approved__c = true
							AND RecordTypeId = :recordTypeId];
		}
        
        // Added by Anil Mannem
        public List<Opportunity> getBidderForOpportunity(List<Id> opportunityIdList){
            return [SELECT Id,
                           Final_Distributor__c,
                           Final_Contractor__c,
                           StageName,
                           Quote_Approved__c,
                           (SELECT Id,
                                   Status__c,
                                   Opportunity__c,
                                   Opportunity__r.Name,
                                   Distributor_Account__r.Name,
                                   Contractor_Account__r.Name,
                                   Unique_ID__c
                            FROM Opportunity_Distributor_Contractor__r)
                    FROM Opportunity 
                    WHERE Id IN :opportunityIdList];
		}
		
		public List<Opportunity> getOpportunityByAccountsIdsIsClosedAndRecordTypeId(Set<Id> accountIds,Boolean isClosed,Id recordTypeId){
			
			return  [SELECT Id, 
			        	Name, 
			        	AccountId, 
						Account.BillingCity, 
						Account.Name 
	 		        	FROM Opportunity 
	 		        WHERE AccountId IN :accountIds and 
						isClosed = :isClosed and 
						recordTypeId = :recordtypeId];
		}
	}
}