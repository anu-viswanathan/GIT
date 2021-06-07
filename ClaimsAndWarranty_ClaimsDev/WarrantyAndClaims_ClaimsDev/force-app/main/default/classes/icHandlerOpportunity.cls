public class icHandlerOpportunity implements icIClass {

	public Object GetInstance(){
		return new Impl();
	}

	public Interface IClass {
        void onAfterUpdate(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id, Opportunity> opportunitiesMap);
        void onBeforeUpdate(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id, Opportunity> opportunitiesMap);
        void onBeforeInsert(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id, Opportunity> opportunitiesMap);
    }

	public class Impl implements IClass {
		icLogicOpportunity.IClass logicOpportunity = (icLogicOpportunity.IClass) icObjectFactory.GetSingletonInstance('icLogicOpportunity');
        icLogicAttachment.IClass logicAttachment = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');
        icLogicBidder.IClass logicBidder = (icLogicBidder.IClass) icObjectFactory.GetSingletonInstance('icLogicBidder');
        icLogicEmail.IClass logicEmail = (icLogicEmail.IClass) icObjectFactory.GetSingletonInstance('icLogicEmail');
        icLogicUser.IClass logicUser = (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');
        icLogicOpportunityLineItems.IClass logicOpportunityLineItem = (icLogicOpportunityLineItems.IClass) icObjectFactory.GetSingletonInstance('icLogicOpportunityLineItems');
        icLogicAccount.IClass logicAccount = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

        public void onAfterUpdate(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id, Opportunity> opportunitiesOldMap){
            Id USSalesBidRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('US_Sales_Bid').getRecordTypeId();
            
            handlePDFGenerationForAllBidder(oldOpportunities, newOpportunities, opportunitiesOldMap,USSalesBidRecordTypeId);
            handleBidderStatusByOpportunityStage(oldOpportunities, newOpportunities, opportunitiesOldMap,USSalesBidRecordTypeId);
            handleSendingEmailOnOpportunityStage(oldOpportunities, newOpportunities, opportunitiesOldMap,USSalesBidRecordTypeId);
        }
        
        public void onBeforeUpdate(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id, Opportunity> opportunitiesOldMap){
            Id USSalesBidRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('US_Sales_Bid').getRecordTypeId();
            handleProductCompetitorPriceOnClosedLost(oldOpportunities, newOpportunities, opportunitiesOldMap,USSalesBidRecordTypeId);
            handleDuplicateOpportunitywithSameAccountNameAddress(oldOpportunities, newOpportunities, opportunitiesOldMap,USSalesBidRecordTypeId);

        }
        public void onBeforeInsert(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id, Opportunity> opportunitiesOldMap){
            Id USSalesBidRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('US_Sales_Bid').getRecordTypeId();
            handleDuplicateOpportunitywithSameAccountNameAddress(oldOpportunities, newOpportunities, opportunitiesOldMap,USSalesBidRecordTypeId);

        }

        /**
        * By Anil Mannem (Incloud) to Generate PDF to all bidders, on Opportunity Quote Approval
        */ 
        private void handlePDFGenerationForAllBidder(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id, Opportunity> opportunitiesOldMap, Id recordTypeId) {
                
            List<Id> opportunityIdGenerateBidderPDF = new List<Id>();
            for(Opportunity newOpportunity : newOpportunities){
                if(newOpportunity.RecordTypeId == recordTypeId){
                    Opportunity oldOpportunity = opportunitiesOldMap.get(newOpportunity.Id);
                    if(oldOpportunity.Quote_Approved__c != true && newOpportunity.Quote_Approved__c == true){
                        opportunityIdGenerateBidderPDF.add(newOpportunity.Id);
                    }
                }
            }
            if(!opportunityIdGenerateBidderPDF.isEmpty()){
                icBidderGeneratePDF.bidderOpportunityGeneratePDF(opportunityIdGenerateBidderPDF);
            }
        }
        /**
         * By Anil Mannem (Incloud) to update all bidders status, based on Opportunity Stage value
         */ 
        private void handleBidderStatusByOpportunityStage(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id, Opportunity> opportunitiesOldMap, Id recordTypeId) {
            List<Bidder__c> newbidderList = new List<Bidder__c>();
            List<Id> opportunityIdList = new List<Id>();
            for(Opportunity opp : newOpportunities){
                opportunityIdList.add(opp.Id);
            }
            List<Opportunity> opportunityList = logicOpportunity.getBidderForOpportunity(opportunityIdList);
            for(Opportunity thisOpportunity : opportunityList){
                String uniqueIdValue = thisOpportunity.Id+''+thisOpportunity.Final_Distributor__c+''+thisOpportunity.Final_Contractor__c;
                for(Bidder__c thisBidder : thisOpportunity.Opportunity_Distributor_Contractor__r){
                    if(thisOpportunity.StageName == 'Closed Won'){
                        if(thisBidder.Unique_ID__c == uniqueIdValue){
                            thisBidder.Status__c = 'Won';
                        } else {
                            thisBidder.Status__c = 'Lost';
                        }
                    } else if(thisOpportunity.StageName == 'Closed Lost'){
                        thisBidder.Status__c = 'Lost';
                    } else if(thisOpportunity.StageName == 'Closed Expired'){
                        thisBidder.Status__c = 'Expired';
                    } else if(thisOpportunity.StageName == 'Closed Rejected'){
                        thisBidder.Status__c = 'Rejected';
                    }
                    newbidderList.add(thisBidder);
                }
            }
            if (!newbidderList.isEmpty()){
                logicBidder.updateBidderStatus(newBidderList);
            }
        }
        private void handleSendingEmailOnOpportunityStage(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id, Opportunity> opportunitiesOldMap, Id recordTypeId) {
            List <Opportunity> opporutnitiesToEmail = new List<Opportunity>();
            for (Opportunity newOpportunity : newOpportunities){
                if(newOpportunity.RecordTypeId == recordTypeId){
                    if (newOpportunity.StageName != opportunitiesOldMap.get(newOpportunity.Id).StageName){
                        if(newOpportunity.StageName == 'In Approval'  || newOpportunity.StageName == 'Closed Won' ||
                           newOpportunity.StageName == 'Closed Lost' || newOpportunity.StageName == 'Closed Expired' ||
                           (newOpportunity.StageName == 'Preparing Quotes' && opportunitiesOldMap.get(newOpportunity.ID).StageName == 'In Approval' ) ){
                            opporutnitiesToEmail.add(newOpportunity);
                        }
                    }
                }
            }
            if ( ! opporutnitiesToEmail.isEmpty()){
                Set<Id> Owners = new Set<Id>();
                // Get the List of All OpportunitiesOwner
                for (Opportunity sendEmailOpportunity : opporutnitiesToEmail){
                    Owners.add(sendEmailOpportunity.OwnerId);
                }

                Map<Id,Id>  relatedManagerID = logicUser.getOwnerManagerIdByOwnerID(Owners);
                            
                EmailTemplate templateInApproval = null;
                EmailTemplate templateClosed = null;
                EmailTemplate templateExpired = null;
                EmailTemplate templateRecall = null;
                EmailTemplate currentEmailTemplate = null;

                Messaging.SingleEmailMessage emailToSend = null;
                List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
                Id  managerId = null ; 
                for (Opportunity sendEmailOpportunity : opporutnitiesToEmail){
                    // Create the good Email template object only once in function of the stage of the opportunity
                    if ( sendEmailOpportunity.StageName == 'In Approval' ){
                        if (templateInApproval == null){
                            templateInApproval = logicEmail.getEmailTemplateByDevName('US_Sales_Request_Approval');
                        }
                        currentEmailTemplate = templateInApproval;
                    }
                    else if (sendEmailOpportunity.StageName == 'Closed Won' ||  sendEmailOpportunity.StageName == 'Closed Lost')  {
                        if ( templateClosed  == null){
                            templateClosed = logicEmail.getEmailTemplateByDevName('US_Sales_Opportunity_Close_Won_Lost');
                        }
                        currentEmailTemplate = templateClosed;
                    }
                    else if (sendEmailOpportunity.StageName == 'Closed Expired'){
                        if (templateExpired  == null){
                            templateExpired = logicEmail.getEmailTemplateByDevName('US_Sales_Opportunity_Expired');
                        }
                    }
                    else if (sendEmailOpportunity.StageName == 'Preparing Quotes' && opportunitiesOldMap.get(sendEmailOpportunity.ID).StageName == 'In Approval'){
                        if (templateRecall  == null){
                            templateRecall = logicEmail.getEmailTemplateByDevName('US_Sales_Recall_Approval');
                        }
                        currentEmailTemplate = templateRecall;
                    }
                    managerId = relatedManagerID.get(sendEmailOpportunity.OwnerId);
                    if (currentEmailTemplate  != null && managerId != null ){ 
                        if(!Test.isRunningTest()){
                            emailToSend = logicEmail.RenderEmailTemplate(currentEmailTemplate, managerId, sendEmailOpportunity.ID, new List<String>(),new List<Messaging.EmailFileAttachment>());
                        } else {
                            emailToSend = new Messaging.SingleEmailMessage();
                        }
                        emailsToSend.add(emailToSend);
                        currentEmailTemplate = null;
                        managerId = null;
                    }
                }
                if(!Test.isRunningTest()){
                    Messaging.sendEmail(emailsToSend);
                } 
            }
        }
        private void handleProductCompetitorPriceOnClosedLost(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id, Opportunity> opportunitiesOldMap, Id recordTypeId) {
            List <Opportunity> opporutnitiesToHandle = new List<Opportunity>();
            for (Opportunity newOpportunity : newOpportunities) {
                if(newOpportunity.RecordTypeId == recordTypeId) {
                    if (newOpportunity.StageName != opportunitiesOldMap.get(newOpportunity.Id).StageName) {
                        if( newOpportunity.StageName == 'Closed Lost'){
                            opporutnitiesToHandle.add(newOpportunity);
                        }
                    }
                }
            }
            if (!opporutnitiesToHandle.isEmpty()){
                Map<Id,List<OpportunityLineItem>> OpportunityMapOppLI = logicOpportunityLineItem.getMapForOpportunityLineItemByOpportunities(opporutnitiesToHandle);
                List<OpportunityLineItem> OppotunityLineItems; 
                for (Opportunity closedLostOpportunity : opporutnitiesToHandle) {
                    if (OpportunityMapOppLI.containsKey(closedLostOpportunity.Id)) {
                        OppotunityLineItems = OpportunityMapOppLI.get(closedLostOpportunity.Id);
                        for ( OpportunityLineItem  relatedOpportunityLineItem : OppotunityLineItems) {
                            if (relatedOpportunityLineItem.Competitor_Price__c == null || relatedOpportunityLineItem.Competitor_Price__c == 0){
                                //'Please make sure that all Competitor Prices have been entered for all products before setting the opportunity Stage to Closed Lost';
                                closedLostOpportunity.addError(System.Label.icOpportunityClosedLost);
                                break;
                            }
                        }
                    }
                }
            }
        }    
        private void handleDuplicateOpportunitywithSameAccountNameAddress(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities, Map<Id, Opportunity> opportunitiesOldMap, Id recordTypeId) {
            List <Opportunity> opportunitiesToHandle = new List<Opportunity>();
            Set <Id> accountIds = new Set<Id>();
            //Get all AccountId where  AccountID has changed or is Created.
            for (Opportunity newOpportunity : newOpportunities) {
                if(newOpportunity.RecordTypeId == recordTypeId) {
                    accountIds.add(newOpportunity.AccountId);
                }
            }
            
            Map<Id,List<Opportunity>> mapOpportunitiesById = logicOpportunity.getOpportunityByAccountsIdsIsClosedAndRecordTypeId(accountIds, false, recordTypeId);
            List<Opportunity> duplicateOpportunities; 
            
            for(Opportunity newOpportunity : newOpportunities) {
                if(newOpportunity.RecordTypeId == recordTypeId && !newOpportunity.isClosed)  {
                   
                    duplicateOpportunities = mapOpportunitiesById.get(newOpportunity.AccountID);
                    // if (more than one Opportunity is found) or
                    // if (is onUpdate,  the size = 1 and is not the same opportunities of the current one.) or 
                    // if (is onInsert && size >=1) Throw and error
                    if (duplicateOpportunities != null) {
                        if ((duplicateOpportunities.size()> 1) ||
                            (newOpportunity.Id != null &&  duplicateOpportunities.size() == 1 && duplicateOpportunities[0].Id != newOpportunity.Id) ||
                            (newOpportunity.Id == null &&  duplicateOpportunities.size() >= 1)) {
                                newOpportunity.addError('An open Opportunity with the Name: "' + duplicateOpportunities[0].Name + '" already exist with the same Account Id: "'+ newOpportunity.AccountID + '".');
                        }
                    }
                }
            }
        }            
    }
}