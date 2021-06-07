/**
 * Created by Andrea Pissinis on 2018-08-09.
 */

global with sharing class icCTRLCreditApplicationForm {

    static icLogicGreenSky.IClass gsLogic = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');


    @AuraEnabled
    global static icDTOGreenSkyLists getLists(){

        System.debug('the lists are ' + gsLogic.getListsFromGreenSkyAPI());

        return gsLogic.getListsFromGreenSkyAPI();
    }

    @AuraEnabled
    global static icDTOLoanForm initializeDTO(String merchantValidationString, String opportunityId){

        icDTOGreenSkyMerchantValidation merchantValidation = (icDTOGreenSkyMerchantValidation) JSON.deserialize(merchantValidationString, icDTOGreenSkyMerchantValidation.class);
        return gsLogic.getGreenSkyLoanForm(merchantValidation, opportunityId);

    }

}