/**
 * Created by Anil Mannem (Incloud) on 03-Aug-2020
 */
public class  icUSSalesQuotePDFController {
    public Bidder__c bidder {get;set;}
    public List<OpportunityLineItem> opportunityLineItemList {get;set;}

    icLogicBidder.IClass logicBidder = (icLogicBidder.IClass) icObjectFactory.GetSingletonInstance('icLogicBidder');
    icLogicOpportunityLineItems.IClass logicOpportunityLineItems = (icLogicOpportunityLineItems.IClass) icObjectFactory.GetSingletonInstance('icLogicOpportunityLineItems');
    
    public icUSSalesQuotePDFController(ApexPages.StandardController controller){
        String bidderID = ApexPages.currentPage().getParameters().get('bidderID');
        List<Bidder__c> bidderList = logicBidder.getBidderDetailsforPDF(bidderID);
        if(!bidderList.isEmpty()) {
            bidder = bidderList[0];
            String fileTitle = '';
            if(bidder.Contractor_Account__r.Name == NULL) {
                fileTitle = bidder.Opportunity__r.Name+' - '+bidder.Distributor_Account__r.Name+' - Quote.pdf';
            } else {
                fileTitle = bidder.Opportunity__r.Name+' - '+bidder.Distributor_Account__r.Name+' - '+bidder.Contractor_Account__r.Name+' - Quote.pdf';
            }
            Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+fileTitle);
            opportunityLineItemList = logicOpportunityLineItems.getOpportunityLineItemForOpportunity(bidder.Opportunity__c);
        }
    }
}