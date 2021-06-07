/**
* Created by Francois Poirier on 2018-06-20.
*/
global with sharing class icCTRLEagleview {

    static icBLeagleView.IClass evBL = (icBLeagleView.IClass) icObjectFactory.GetSingletonInstance('icBLeagleView');
    static icLogicUser.IClass logicUser = (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');
    static icLogicSubscription.IClass logicSubscription = (icLogicSubscription.IClass) icObjectFactory.GetSingletonInstance('icLogicSubscription');
    static icLogicEagleViewReport.IClass evReportLogic = (icLogicEagleViewReport.IClass) icObjectFactory.GetSingletonInstance('icLogicEagleViewReport');

    @AuraEnabled
    global static Boolean isCustomerSubscribed(){
        Boolean isCustomerSubscribed = false;

        String customerId = logicUser.getAccountIdFromPartnerUser(UserInfo.getUserId());
        List<IKOPRO_Contractor_Subscription__c> customerSubscriptions = logicSubscription.getEagleViewSubscriptionForCustomer(customerId);

        if(customerSubscriptions.size() == 1) {
            isCustomerSubscribed = true;
        }

        return isCustomerSubscribed;
    }

    @AuraEnabled
    global static Boolean isCommunity(String sPageURL){

       if (sPageURL.contains('lightning')){
           return false;
       }else return true;
    }

    @AuraEnabled
    global static List<icDTOEagleViewProduct> getAvailableProducts(){
        List<icDTOEagleViewProduct> returnAvailableProducts;
        
        String customerId = logicUser.getAccountIdFromPartnerUser(UserInfo.getUserId());
        List<IKOPRO_Contractor_Subscription__c> customerSubscriptions = logicSubscription.getEagleViewSubscriptionForCustomer(customerId);
        
        if(customerSubscriptions.size() == 1) {
            IKOPRO_Contractor_Subscription__c eagleViewSubsciption = customerSubscriptions[0];            
            returnAvailableProducts = evBL.getAvailableProducts();
        }

        return returnAvailableProducts;
    }

    @AuraEnabled
    global static icDTOEagleViewPlaceOrderResponse placeOrder(String strOrder){ 
        icDTOEagleViewPlaceOrderResponse placeOrderResponse = new icDTOEagleViewPlaceOrderResponse();

        try {
            String customerId = logicUser.getAccountIdFromPartnerUser(UserInfo.getUserId());
            List<IKOPRO_Contractor_Subscription__c> customerSubscriptions = logicSubscription.getEagleViewSubscriptionForCustomer(customerId);

            if(customerSubscriptions.size() == 1) {
                IKOPRO_Contractor_Subscription__c eagleViewSubsciption = customerSubscriptions[0];
                placeOrderResponse = evBL.placeOrder(strOrder, eagleViewSubsciption.Username__c);
            }            
        } catch (Exception ex ) {
            System.debug(ex.getMessage());
            String errorRef = icServiceErrorHandler.LogError('icCTRLEagleview', 'placeOrder', ex.getStackTraceString(), ex.getMessage(), strOrder);
            placeOrderResponse.message = Label.icAn_Exception_Occured_please_contact_IKO_for_assistance_with_this_reference_Id + errorRef;
        }

        return placeOrderResponse;
    }

    @AuraEnabled
    global static String createOrder(String orderDetailsJSON, String opportunityId){
        try {
            icDTOEagleViewOrderForm orderForm = (icDTOEagleViewOrderForm)JSON.deserialize(orderDetailsJSON, icDTOEagleViewOrderForm.Class);

            String customerId = logicUser.getAccountIdFromPartnerUser(UserInfo.getUserId());

            EagleView_Report__c newReport = evReportLogic.generateEagleViewReportFromOrderForm(orderForm);
            newReport.Account__c = customerId;
            newReport.Opportunity__c = opportunityId;

            evReportLogic.createEagleViewReport(newReport);
            return newReport.Id;
        } catch (Exception ex ) {
            System.debug(ex.getMessage());
            String errorRef = icServiceErrorHandler.LogError('icCTRLEagleview', 'createOrder', ex.getStackTraceString(), ex.getMessage(), orderDetailsJSON);
            return Label.icAn_Exception_Occured_please_contact_IKO_for_assistance_with_this_reference_Id + errorRef;
        }
    }

    @AuraEnabled
    global static String setOrderIds(String sfOrderId, String jsonOrderInfo){
        try {
            icDTOEagleViewPlaceOrderResponse orderInfo = (icDTOEagleViewPlaceOrderResponse)JSON.deserialize(jsonOrderInfo, icDTOEagleViewPlaceOrderResponse.Class);
            
            EagleView_Report__c updateReport = new EagleView_Report__c(Id = sfOrderId);
            if(orderInfo.OrderId == null) {
                evReportLogic.deleteEagleViewReport(updateReport);
            } else {
                updateReport.Order_Id__c = String.valueOf(orderInfo.OrderId);
                updateReport.Report_Id__c = String.valueOf(orderInfo.ReportIds[0]);
                evReportLogic.updateEagleViewReport(updateReport);
            }
            return Label.icSuccess;
        } catch (Exception ex ) {
            System.debug(ex.getMessage());
            String errorRef = icServiceErrorHandler.LogError('icCTRLEagleview', 'setOrderIds', ex.getStackTraceString(), ex.getMessage(), jsonOrderInfo);
            return Label.icAn_Exception_Occured_please_contact_IKO_for_assistance_with_this_reference_Id + errorRef;
        }
    }

    @AuraEnabled
    global static String cancelOrder(String recordId) {
        try {
            String returnResult = Label.icInternal_Error_Could_not_cancel_Order;
            EagleView_Report__c thisReport = evReportLogic.getEagleViewReportById(recordId);

            String customerId = logicUser.getAccountIdFromPartnerUser(UserInfo.getUserId());
            List<IKOPRO_Contractor_Subscription__c> customerSubscriptions = logicSubscription.getEagleViewSubscriptionForCustomer(customerId);

            if(customerSubscriptions.size() == 1) {
                IKOPRO_Contractor_Subscription__c eagleViewSubsciption = customerSubscriptions[0];            
                returnResult = evBL.cancelOrder(thisReport.Report_Id__c);
            }
            
            return returnResult;
        } catch (Exception ex ) {
            System.debug(ex.getMessage());
            String errorRef = icServiceErrorHandler.LogError('icCTRLEagleview', 'cancelOrder', ex.getStackTraceString(), ex.getMessage(), recordId);
            return Label.icAn_Exception_Occured_please_contact_IKO_for_assistance_with_this_reference_Id + errorRef;
        }
    }

    @AuraEnabled
    global static icDTOGenericResult subscribe(String eagleviewUsername, String eagleviewPassword) {
        icDTOGenericResult returnResult = new icDTOGenericResult();

        try {
            returnResult = evBL.grantUserOrderDelegation(eagleviewUsername, eagleviewPassword);

            System.debug('delegate result : ' + returnResult);

            if(returnResult.isSuccess) {
                String customerId = logicUser.getAccountIdFromPartnerUser(UserInfo.getUserId());
                List<IKOPRO_Contractor_Subscription__c> customerSubscriptions = logicSubscription.getEagleViewSubscriptionForCustomer(customerId);

                if(customerSubscriptions.size() == 1) {
                    IKOPRO_Contractor_Subscription__c eagleViewSubsciption = customerSubscriptions[0];
                    eagleViewSubsciption.Username__c = eagleviewUsername;
                    logicSubscription.updateEagleViewSubscription(eagleViewSubsciption);
                } else {
                    logicSubscription.createEagleViewSubscription(customerId, eagleviewUsername);
                }

                returnResult.message = Label.icYou_are_successfully_subscribed_to_EagleView;
            }
        } catch (Exception ex) {
            System.debug(ex.getMessage());
            String errorRef;
            errorRef = icServiceErrorHandler.LogError('icCTRLEagleview', 'subscribe', ex.getStackTraceString(), ex.getMessage(), eagleviewUsername);
            system.debug('errorRef ===> ' + errorRef);
            system.debug('returnResult ===> ' + returnResult);
            if(returnResult == null){
                returnResult = new icDTOGenericResult();
            }
            returnResult.message = Label.icAn_Exception_Occured_please_contact_IKO_for_assistance_with_this_reference_Id + errorRef;
            returnResult.isSuccess = false;            
        }

        System.debug('final result : ' + returnResult);
        
        return returnResult;
    }
}