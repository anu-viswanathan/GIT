/**
 * Created by Anil Mannem on 03-Aug-2020
 */
public class icRepoOpportunityLineItems implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {
        List<OpportunityLineItem> getOpportunityLineItemForOpportunity(String recordId);
        List<OpportunityLineItem> getOpportunityLineItemsByOpportunities(List<Opportunity> opportunities);
    }

    public class Impl implements IClass {
        public List<OpportunityLineItem> getOpportunityLineItemForOpportunity(String recordId) {
            return [SELECT  Product2.Name,
                            Quantity,
                            Product2.Colour__c,
                            Unit_of_Measure__c,
                            UnitPrice,
                            Subtotal,
                            ListPrice,
                            TotalPrice
                    FROM OpportunityLineItem
                    WHERE Opportunity.Id =: recordId];
        }

        public List<OpportunityLineItem> getOpportunityLineItemsByOpportunities(List<Opportunity> opportunities) {
            return [SELECT  Product2.Name,
                            Quantity,
                            Product2.Colour__c,
                            Unit_of_Measure__c,
                            UnitPrice,
                            Subtotal,
                            ListPrice,
                            TotalPrice,
                            Competitor_Price__c,
                            Opportunity.Id
                    FROM OpportunityLineItem
                    WHERE Opportunity.Id =: opportunities];
        }
    }
}