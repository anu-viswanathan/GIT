/**
 * Created by Andrea Pissinis on 2018-08-10.
 */

global with sharing class icDTOLoanDetails {

    @AuraEnabled global Boolean coApplicantIndicator {get;set;}
    @AuraEnabled global String contractLanguage {get;set;}
    @AuraEnabled global Double requestedLoanAmount {get;set;}
    @AuraEnabled global String referenceNumber {get;set;}
    @AuraEnabled global String program {get;set;}
    @AuraEnabled global String product {get;set;}
    @AuraEnabled global String role {get;set;}
    @AuraEnabled global String channel {get;set;}
    @AuraEnabled global String promotionCode {get;set;}
    @AuraEnabled global String referral {get;set;}
    @AuraEnabled global String youAre {get;set;}

}