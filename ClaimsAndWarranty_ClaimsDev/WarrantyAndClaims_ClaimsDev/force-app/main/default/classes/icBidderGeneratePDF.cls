public with sharing class icBidderGeneratePDF {
    static icLogicAttachment.IClass logicAttachment = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');
    static icLogicOpportunity.IClass logicOpportunity = (icLogicOpportunity.IClass) icObjectFactory.GetSingletonInstance('icLogicOpportunity');
    static icLogicBidder.IClass logicBidder = (icLogicBidder.IClass) icObjectFactory.GetSingletonInstance('icLogicBidder');
    static icLogicEmail.IClass logicEmail = (icLogicEmail.IClass) icObjectFactory.GetSingletonInstance('icLogicEmail');

    @future(callout = true)
    public static void bidderOpportunityGeneratePDF(List<Id> opportunityIdList){
        List<Opportunity> opportunityList = logicOpportunity.getBidderForOpportunity(opportunityIdList);
        Blob pdfContent; 
        for(Opportunity thisOpportunity : opportunityList){
            for(Bidder__c thisBidder : thisOpportunity.Opportunity_Distributor_Contractor__r){
                String recordId = thisBidder.Id;
                PageReference thisPageReference = Page.US_Sales_Quote_PDF;
                thisPageReference.getParameters().put('bidderID', recordId);
                String fileTitle = '';
                if(thisBidder.Contractor_Account__r.Name == NULL) {
                    fileTitle = thisBidder.Opportunity__r.Name+' - '+thisBidder.Distributor_Account__r.Name+' - Quote.pdf';
                } else {
                    fileTitle = thisBidder.Opportunity__r.Name+' - '+thisBidder.Distributor_Account__r.Name+' - '+thisBidder.Contractor_Account__r.Name+' - Quote.pdf';
                }
                
                if (Test.isRunningTest()) {
                    pdfContent= Blob.valueof('Quote PDF');
                }
                else {
                    pdfContent = thisPageReference.getContentAsPDF();
                }
                logicAttachment.createDocumentInObject(recordId, fileTitle, fileTitle, pdfContent);
                pdfContent = null;
            }
        }
    }

    @future(callout = true)
    public static void bidderGeneratePDF(List<Id> bidderIdList){
        List<Bidder__c> bidderList = logicBidder.getBidderDetailsforPDFAutomation(bidderIdList);
        for(Bidder__c thisBidder : bidderList) {
            if(thisBidder.Opportunity__r.Quote_Approved__c) {
                String recordId = thisBidder.Id;
                PageReference thisPageReference = Page.US_Sales_Quote_PDF;
                thisPageReference.getParameters().put('bidderID', recordId);
                String fileTitle = '';
                if(thisBidder.Contractor_Account__r.Name == NULL) {
                    fileTitle = thisBidder.Opportunity__r.Name+' - '+thisBidder.Distributor_Account__r.Name+' - Quote.pdf';
                } else {
                    fileTitle = thisBidder.Opportunity__r.Name+' - '+thisBidder.Distributor_Account__r.Name+' - '+thisBidder.Contractor_Account__r.Name+' - Quote.pdf';
                }
                logicAttachment.createDocumentInObject(recordId, fileTitle, fileTitle, (Test.isRunningTest() ? Blob.valueof('Quote PDF') : thisPageReference.getContentAsPDF()));    
            }
        }
    }
}