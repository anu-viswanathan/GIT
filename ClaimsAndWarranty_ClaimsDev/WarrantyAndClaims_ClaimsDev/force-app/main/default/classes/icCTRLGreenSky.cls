/**
 * Created by Francois Poirier on 2018-07-16.
 */

global with sharing class icCTRLGreenSky {

    static icLogicGreenSky.IClass gsLogic = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');

    @AuraEnabled
    global static Boolean isCustomerSubscribed(){

        return gsLogic.isCustomerSubscribed();

    }

    @AuraEnabled
    global static Boolean createGreenSkySubscription(String gsSubscriptionString){

        system.debug('gsSubscriptionString in icCTRLGreenSky ===> ' + gsSubscriptionString);
        gsLogic.saveSubscription(gsSubscriptionString);

        return true;
    }


    @AuraEnabled
    global static icDTOGreenSkyMerchantValidation merchantValidation(){
        icDTOGreenSkyMerchantValidation response = new icDTOGreenSkyMerchantValidation();

        response = gsLogic.merchantValidation();

        return response;
    }

    @AuraEnabled
    global static icDTOGreenSkyApplication asyncSubmit(String merchantValidation, String payload){

        icDTOGreenSkyMerchantValidation mv = (icDTOGreenSkyMerchantValidation) JSON.deserialize(merchantValidation, icDTOGreenSkyMerchantValidation.class);
        icDTOGreenSkyApplication gsApp = new icDTOGreenSkyApplication();
        system.debug('mv ====> ' + merchantValidation);
        System.debug('payload ctrl ===> ' + payload);
        gsApp = gsLogic.asynchronousSubmit(mv.token, payload);

        return gsApp;

    }

    @AuraEnabled
    global static icDTOGreenSkyApplicationState state(String gsApplication){
        icDTOGreenSkyApplication gsApp = (icDTOGreenSkyApplication) JSON.deserialize(gsApplication, icDTOGreenSkyApplication.class);
        return gsLogic.state(gsApp);
    }

    @AuraEnabled
    global static icDTOGreenSkyDecision decision(String gsApplication){
        icDTOGreenSkyApplication gsApp = (icDTOGreenSkyApplication) JSON.deserialize(gsApplication, icDTOGreenSkyApplication.class);
        return gsLogic.decision(gsApp);
    }

    @AuraEnabled
    global static icDTOGreenSkyOffer offer(String gsApplication){
        icDTOGreenSkyApplication gsApp = (icDTOGreenSkyApplication) JSON.deserialize(gsApplication, icDTOGreenSkyApplication.class);
        return gsLogic.offer(gsApp);
    }

    @AuraEnabled
    global static icDTOGreenSkyCreate create(String gsOffer, String gsApplication){
        icDTOGreenSkyApplication gsApp = (icDTOGreenSkyApplication) JSON.deserialize(gsApplication, icDTOGreenSkyApplication.class);
        icDTOGreenSkyOffer gsOfferObj = (icDTOGreenSkyOffer) JSON.deserialize(gsOffer, icDTOGreenSkyOffer.class);
        return gsLogic.create(gsOfferObj, gsApp);
    }

    @AuraEnabled
    global static icDTOGreenSkyLoanAgreement loanAgreement(String gsApplication){
        icDTOGreenSkyApplication gsApp = (icDTOGreenSkyApplication) JSON.deserialize(gsApplication, icDTOGreenSkyApplication.class);
        return gsLogic.loanAgreement(gsApp);
    }

    @AuraEnabled
    global static icDTOGreenSkyEmail email(String loanAgreement, String gsApplication){
        icDTOGreenSkyApplication gsApp = (icDTOGreenSkyApplication) JSON.deserialize(gsApplication, icDTOGreenSkyApplication.class);
        icDTOGreenSkyLoanAgreement loanAgreementObj = (icDTOGreenSkyLoanAgreement) JSON.deserialize(loanAgreement, icDTOGreenSkyLoanAgreement.class);
        return gsLogic.email(loanAgreementObj, gsApp);
    }


}