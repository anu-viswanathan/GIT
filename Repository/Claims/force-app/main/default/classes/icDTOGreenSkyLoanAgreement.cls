/**
 * Created by Francois Poirier on 2018-07-31.
 */

global with sharing class icDTOGreenSkyLoanAgreement {

    @AuraEnabled global String applicantFullName {get;set;}
    @AuraEnabled global String applicantEmail {get;set;}
    @AuraEnabled global String lender {get;set;}
    @AuraEnabled global Decimal amountFinanced {get;set;}
    @AuraEnabled global Decimal apr {get;set;}
    @AuraEnabled global String term {get;set;}
    @AuraEnabled global Decimal monthlyPayment {get;set;}
    @AuraEnabled global String promotionDetails {get;set;}
    @AuraEnabled global String creditProduct {get;set;}
    @AuraEnabled global icDTOGreenSkyError error {get;set;}

}