/**
 * Created by Francois Poirier on 2018-07-30.
 */

global with sharing class icDTOGreenSkyLoanOffer {

    @AuraEnabled global Decimal apr {get;set;}
    @AuraEnabled global String id {get;set;}
    @AuraEnabled global Decimal loanAmount {get;set;}
    @AuraEnabled global Decimal monthlyPayment {get;set;}
    @AuraEnabled global String promotionDetails {get;set;}
    @AuraEnabled global String term {get;set;}
    @AuraEnabled global String creditProduct {get;set;}
    @AuraEnabled global Integer secondLook {get;set;}
    @AuraEnabled global String planNumber {get;set;}
    @AuraEnabled global Integer promotionPeriod {get;set;}
    @AuraEnabled global Boolean isDeferred {get;set;}
    
}