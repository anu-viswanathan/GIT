/**
 * Created by Andrea Pissinis on 2018-08-13.
 */

global with sharing class icDTOcoApplicantDetails {
    @AuraEnabled global String coApplicantFirstName {get;set;}
    @AuraEnabled global String coApplicantMiddleIntial {get;set;}
    @AuraEnabled global String coApplicantLastName {get;set;}
    @AuraEnabled global String coApplicantStreetAddress {get;set;}
    @AuraEnabled global String coApplicantStreetNumber {get;set;}
    @AuraEnabled global String coApplicantOtherAddress {get;set;}
    @AuraEnabled global String coApplicantCity {get;set;}
    @AuraEnabled global String coApplicantState {get;set;}
    @AuraEnabled global String coApplicantZipCode {get;set;}
    @AuraEnabled global String coApplicantZipCode4 {get;set;}
    @AuraEnabled global String coApplicantPhoneNumber {get;set;}
    @AuraEnabled global String coApplicantCellPhoneNumber {get;set;}
    @AuraEnabled global Boolean coApplicantMobileOptIn {get;set;}
    @AuraEnabled global String coApplicantEmailAddress {get;set;}
    @AuraEnabled global String coApplicantSSN {get;set;}
    @AuraEnabled global String coApplicantDateOfBirth {get;set;}
    @AuraEnabled global Double coApplicantGrossIncome {get;set;}
    @AuraEnabled global String coApplicantNameOnId {get;set;}
    @AuraEnabled global String coApplicantIDNumber {get;set;}
    @AuraEnabled global String coApplicantTypeOfID {get;set;}
    @AuraEnabled global String coApplicantStateOnID {get;set;}
    @AuraEnabled global String coApplicantIDExpiryDate {get;set;}
    @AuraEnabled global Boolean coApplicantMarried {get;set;}
}