/**
 * Created by Anil Mannem on 03-Aug-2020
 */
public with sharing class icLogicOpportunityLineItems implements icIClass {

	public Object GetInstance(){
		return new Impl();
	}

	public interface IClass {
		List<OpportunityLineItem> getOpportunityLineItemForOpportunity(String recordId);
		List<OpportunityLineItem> getOpportunityLineItemsByOpportunities(List<Opportunity> opportunities);
		Map<Id,List<OpportunityLineItem>> getMapForOpportunityLineItemByOpportunities(List<Opportunity> opportunities);
	}

	public class Impl implements IClass {

		icRepoOpportunityLineItems.IClass repository = (icRepoOpportunityLineItems.IClass) icObjectFactory.GetSingletonInstance('icRepoOpportunityLineItems');
		icRepoProduct.IClass repoProduct = (icRepoProduct.IClass) icObjectFactory.GetSingletonInstance('icRepoProduct');

		public List<OpportunityLineItem> getOpportunityLineItemForOpportunity(String recordId) {
			return repository.getOpportunityLineItemForOpportunity(recordId);
		}
		public List<OpportunityLineItem> getOpportunityLineItemsByOpportunities(List<Opportunity> opportunities) {
			return repository.getOpportunityLineItemsByOpportunities(opportunities);
		}

		/*****
		 * Return a Map of OpportunityID corresponding to a List of OpportunityLineItem
		 * 
		 * 
		 *****/
		public Map<Id,List<OpportunityLineItem>> getMapForOpportunityLineItemByOpportunities(List<Opportunity> opportunities){
			
			Map<Id,List<OpportunityLineItem>> opportunityLineItemMap = new Map<Id,List<OpportunityLineItem>>();
			List<OpportunityLineItem> opportunityLineItems = getOpportunityLineItemsByOpportunities(opportunities);

			for( OpportunityLineItem oppLI : opportunityLineItems ) {
				if (!opportunityLineItemMap.containsKey(oppLI.Opportunity.Id)){
					opportunityLineItemMap.put(oppLI.Opportunity.Id,new List<OpportunityLineItem>());
				}
				opportunityLineItemMap.get(oppLI.Opportunity.Id).add(oppLI);
			}
			return opportunityLineItemMap;

		}
	}
}