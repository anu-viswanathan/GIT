public class icHandlerOpportunityLineItem implements icIClass {

	public Object GetInstance(){
		return new Impl();
	}

	public Interface IClass {
        void onBeforeInsert(List<OpportunityLineItem> newOpportunityLineItems);
        void onBeforeDelete(List<OpportunityLineItem> oldOpportunityLineItems, Map<Id, OpportunityLineItem> OpportunityLineItemsOldMap);
    }

	public class Impl implements IClass {

        icLogicOpportunity.IClass logicOpportunity = (icLogicOpportunity.IClass) icObjectFactory.GetSingletonInstance('icLogicOpportunity');
        icLogicProduct.IClass logicProduct = (icLogicProduct.IClass) icObjectFactory.GetSingletonInstance('icLogicProduct');
        
        public void onBeforeInsert(List<OpportunityLineItem> newOpportunityLineItems){
            List<OpportunityLineItem> opportunityLineItemList = new List<OpportunityLineItem>();
            for(OpportunityLineItem thisOpportunityLineItem : newOpportunityLineItems){
                if(thisOpportunityLineItem.Unit_of_Measure__c == null){
                    opportunityLineItemList.add(thisOpportunityLineItem);
                }
            }
            if(!opportunityLineItemList.isEmpty()){
                Map<Id, Product2> productMap = logicProduct.getProductUnitOfMeasure(opportunityLineItemList);
                for(OpportunityLineItem thisOpportunityLineItem : opportunityLineItemList){
                    thisOpportunityLineItem.Unit_of_Measure__c = productMap.get(thisOpportunityLineItem.Product2Id).Unit_of_Measure__c;
                }
            }
        }
        
        public void onBeforeDelete(List<OpportunityLineItem> oldOpportunityLineItems, Map<Id, OpportunityLineItem> OpportunityLineItemsOldMap){
            Id USSalesBidRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('US_Sales_Bid').getRecordTypeId();
            Set<Id> parentApprovedOpportunitiesId = new Set<Id>();
            // Get the List of All OpportunitiesOwner
            for (OpportunityLineItem oldOpportunityLineItem : oldOpportunityLineItems){ 
                parentApprovedOpportunitiesId.add(oldOpportunityLineItem.OpportunityId);
            }
            Map<Id,Opportunity> approvedOpportunities = logicOpportunity.getApprovedOpportunitiesByListId(parentApprovedOpportunitiesId,USSalesBidRecordTypeId);
            if (!approvedOpportunities.isEmpty()){
                for (OpportunityLineItem oldOpportunityLineItem : oldOpportunityLineItems){
                    if(approvedOpportunities.containsKey(oldOpportunityLineItem.OpportunityId)){
                        //You cannot delete a product from an opportunity when this opportunity is approved by the manager.
                        oldOpportunityLineItem.addError(System.Label.icOpportunityLineItemCannotDelete);
                    }
                }
            }
        }
    }
}