/**
 * Created by Francois Poirier on 2018-07-16.
 */

global with sharing class icDTOGreenSkyMerchantValidation {

    @AuraEnabled global Boolean isValid {get;set;}
    @AuraEnabled global String token {get;set;}
    @AuraEnabled global String merchantName {get;set;}
    @AuraEnabled global String creditProduct {get;set;}
    @AuraEnabled global String applicationFlow {get;set;}
    @AuraEnabled global String program {get;set;}
    @AuraEnabled global Boolean affected {get;set;}
    @AuraEnabled global icDTOGreenSkyError error {get;set;}
}