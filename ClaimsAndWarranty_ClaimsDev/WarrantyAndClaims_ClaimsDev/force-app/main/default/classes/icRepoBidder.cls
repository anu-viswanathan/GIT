/**
 * Created by Anil Mannem on 03-Aug-2020
 */
public class icRepoBidder implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {
        List<Bidder__c> getBidderInfo();
        List<Bidder__c> getBidderDetailsforPDF(String recordId);
        List<Bidder__c> getBidderDetailsforPDFAutomation(List<Id> bidderIdList);
        void updateBidderStatus(List<Bidder__c> bidderList);
    }

    public class Impl implements IClass {
        public List<Bidder__c> getBidderInfo() {
            return [SELECT  Name,
                            Unique_ID__c,
                            Opportunity__c,
                            Opportunity__r.Quote_Approved__c
                    FROM Bidder__c];
        }

		public List<Bidder__c> getBidderDetailsforPDF(String recordId) {
			return [SELECT Id, 
                            Name,
                            Owner.Name,
                            Owner.Email,
                            Distributor_Account__r.Name,
                            Contractor_Account__r.Name,
                            Opportunity__r.Name,
                            Opportunity__r.Owner.Name,
                            Opportunity__r.Owner.Email,
                            Opportunity__c,
                            Opportunity__r.Account.Name,
                            Opportunity__r.Est_Project_Start_Date__c,
                            Opportunity__r.Est_Project_Completion__c,
                            Opportunity__r.Estimated_Project_Size__c,
                            Opportunity__r.Account.BillingStreet,
                            Opportunity__r.Account.BillingCity,
                            Opportunity__r.Account.BillingState,
                            Opportunity__r.Account.BillingPostalCode,
                            Opportunity__r.Account.BillingCountry,
                            Opportunity__r.US_Sales_Number_of_shingles_fewer__c,
                            Opportunity__r.US_Sales_IKO_Shingles__c,
                            Opportunity__r.US_Sales_Estimated_Material_Savings__c,
                            Opportunity__r.US_Sales_Estimated_Labor_Saving__c,
                            Opportunity__r.US_Sales_IKO_Shingle_count_for_project__c,
                            Opportunity__r.US_Sales_Competitor_shingle_count__c,
                            Opportunity__r.US_Sales_Estimated_nails_saved__c,
                            Opportunity__r.US_Sale_squares_saved__c,
                            Opportunity__r.Quote_Approved__c,
                            Opportunity__r.Amount,
                            Opportunity__r.Type,
                            Opportunity__r.Type_of_Project__c,
                            Opportunity__r.Unique_Reference_No__c
                        FROM Bidder__c
                        WHERE Id =: recordId];
        }
        
        public List<Bidder__c> getBidderDetailsforPDFAutomation(List<Id> bidderIdList){
            return [SELECT  Id,
                            Name,
                            Opportunity__r.Name,
                            Distributor_Account__r.Name,
                            Contractor_Account__r.Name,
                            Opportunity__r.Quote_Approved__c
                        FROM Bidder__c
                        WHERE Id IN: bidderIdList];
        }

        public void updateBidderStatus(List<Bidder__c> bidderList) {
			update bidderList;
		}

    }
}