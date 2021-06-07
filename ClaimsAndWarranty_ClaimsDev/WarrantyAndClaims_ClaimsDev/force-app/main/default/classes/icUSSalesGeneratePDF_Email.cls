/**
 * Created by Anil Mannem on 03-Aug-2020
 */
public class icUSSalesGeneratePDF_Email {
    
    static icLogicBidder.IClass logicBidder = (icLogicBidder.IClass) icObjectFactory.GetSingletonInstance('icLogicBidder');
    static icLogicAttachment.IClass logicAttachment = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');
    static icLogicEmail.IClass logicEmail = (icLogicEmail.IClass) icObjectFactory.GetSingletonInstance('icLogicEmail');

    @AuraEnabled
    public static String generatePDFandEmail(String recordId) {
        String errorMessage = '';
        List<Bidder__c> bidderList = logicBidder.getBidderDetailsforPDF(recordId);
        Bidder__c bidder;
        if(!bidderList.isEmpty()) {
            bidder = bidderList[0];
        }
        if (bidder.Opportunity__r.Quote_Approved__c) {
            PageReference thisPageReference = Page.US_Sales_Quote_PDF;
            thisPageReference.getParameters().put('bidderID', recordId);
            
            String fileTitle = '';
            if(bidder.Contractor_Account__r.Name == NULL) {
                fileTitle = bidder.Opportunity__r.Name+' - '+bidder.Distributor_Account__r.Name+' - Quote.pdf';
            } else {
                fileTitle = bidder.Opportunity__r.Name+' - '+bidder.Distributor_Account__r.Name+' - '+bidder.Contractor_Account__r.Name+' - Quote.pdf';
            }
            
            Messaging.EmailFileAttachment emailAttach = new Messaging.EmailFileAttachment();
            emailAttach.setContentType('application/pdf');
            emailAttach.setFileName(fileTitle);
            emailAttach.setInline(false);
            emailAttach.Body = (Test.isRunningTest() ? Blob.valueof('Quote PDF') : thisPageReference.getContentAsPDF());

            String subject = '';
            if(bidder.Contractor_Account__r.Name == NULL){
                subject = 'US Sales Quote of '+bidder.Opportunity__r.Name+' - '+bidder.Distributor_Account__r.Name+' pair';
            } else {
                subject = 'US Sales Quote of '+bidder.Opportunity__r.Name+' - '+bidder.Distributor_Account__r.Name+' - '+bidder.Contractor_Account__r.Name+' pair';
            }
                
            EmailTemplate template = logicEmail.getEmailTemplateByDevName('US_Sales_Quote_Follow_Up');
                        
            String emailBody = template.HtmlValue;
            Boolean projectSizeIsNull = true;     
            
            if(bidder.Opportunity__r.Estimated_Project_Size__c != NULL){
                projectSizeIsNull = false;
            }

            emailBody = emailBody.replace('{!Bidder__c.Owner}', bidder.Owner.Name);
            emailBody = emailBody.replace('{!Bidder__c.Opportunity__r.Name}', bidder.Opportunity__r.Name);
            
            //If Estimated Project size is Null we replace the returned value by N/A 
            emailBody = emailBody.replace('{!Bidder__c.Distributor_Account__r.Name}', bidder.Distributor_Account__r.Name);
            emailBody = emailBody.replace('{!Opportunity.US_Sales_Number_of_shingles_fewer__c}', projectSizeIsNull ? 'N/A' : String.valueOf(bidder.Opportunity__r.US_Sales_Number_of_shingles_fewer__c.format()));
            emailBody = emailBody.replace('{!Opportunity.Estimated_Project_Size__c}', projectSizeIsNull ? 'N/A' : String.valueOf(bidder.Opportunity__r.Estimated_Project_Size__c.format()));
            emailBody = emailBody.replace('{!Opportunity.US_Sales_IKO_Shingles__c}', projectSizeIsNull ? 'N/A' : bidder.Opportunity__r.US_Sales_IKO_Shingles__c);
            emailBody = emailBody.replace('{!Opportunity.US_Sales_Estimated_Material_Savings__c}', projectSizeIsNull ? 'N/A' : String.valueOf(bidder.Opportunity__r.US_Sales_Estimated_Material_Savings__c.setScale(2)).leftPad(2, '0'));
            emailBody = emailBody.replace('{!Opportunity.US_Sales_Estimated_Labor_Saving__c}', projectSizeIsNull ? 'N/A' : String.valueOf(bidder.Opportunity__r.US_Sales_Estimated_Labor_Saving__c.setScale(2)).leftPad(2, '0'));
            emailBody = emailBody.replace('{!Opportunity.US_Sales_IKO_Shingle_count_for_project__c}', projectSizeIsNull ? 'N/A' : String.valueOf(bidder.Opportunity__r.US_Sales_IKO_Shingle_count_for_project__c.format()));
            emailBody = emailBody.replace('{!Opportunity.US_Sales_Competitor_shingle_count__c}', projectSizeIsNull ? 'N/A' : String.valueOf(bidder.Opportunity__r.US_Sales_Competitor_shingle_count__c.format()));
            emailBody = emailBody.replace('{!Opportunity.US_Sales_Estimated_nails_saved__c}', projectSizeIsNull ? 'N/A' : String.valueOf(bidder.Opportunity__r.US_Sales_Estimated_nails_saved__c.format()));
            emailBody = emailBody.replace('{!Opportunity.US_Sale_squares_saved__c}', projectSizeIsNull ? 'N/A' : String.valueOf(bidder.Opportunity__r.US_Sale_squares_saved__c.format()));
            
            
            List<String> recipients = new List<String>{bidder.Owner.Email}; //Email of Sales Rep who creates the bidder record.
            List<String> ccRecipients = new List<String>();
            if (bidder.Owner.Email != bidder.Opportunity__r.Owner.Email) {
                ccRecipients.add(bidder.Opportunity__r.Owner.Email);
            }
            List<String> bccRecipients = new List<String>();
            List<String> entities = new List<String>();
            List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
            attachments.add(emailAttach);
            
            Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage();
            List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

            emailOut.setToAddresses(recipients);
            emailOut.setCcAddresses(ccRecipients);
			emailOut.setSubject(subject);
			emailOut.setHTMLBody(emailBody);
            emailOut.setSaveAsActivity(false);
            emailOut.setEntityAttachments(entities);
            emailOut.setFileAttachments(attachments);

            emailsToSend.add(emailOut);
            Messaging.sendEmail(emailsToSend);

            // logicEmail.sendPlainTextEmail(subject, emailBody, recipients, ccRecipients, bccRecipients, entities, attachments);
        } else {
            errorMessage = System.Label.icQuoteNotApproved;
        }
        return errorMessage;
    }
}