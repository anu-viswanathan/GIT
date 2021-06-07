/**
 * Created by Andrea Pissinis on 2018-08-10.
 */

global with sharing class icDTOApplicantDetails {

    @AuraEnabled global String applicantFirstName {get;set;}
    @AuraEnabled global String applicantMiddleInitial {get;set;}
    @AuraEnabled global String applicantLastName {get;set;}
    @AuraEnabled global String applicantStreetAddress {get;set;}
    @AuraEnabled global String applicantStreetNumber {get;set;}
    @AuraEnabled global String applicantOtherAddress {get;set;}
    @AuraEnabled global String applicantCity {get;set;}
    @AuraEnabled global String applicantState {get;set;}
    @AuraEnabled global String applicantZipCode {get;set;}
    @AuraEnabled global String applicantZipCode4 {get;set;}
    @AuraEnabled global String applicantPhoneNumber {get;set;}
    @AuraEnabled global String applicantCellPhoneNumber {get;set;}
    @AuraEnabled global Boolean applicantMobileOptIn {get;set;}
    @AuraEnabled global String applicantEmailAddress {get;set;}
    @AuraEnabled global String applicantSSN {get;set;}
    @AuraEnabled global String applicantDateOfBirth {get;set;}
    @AuraEnabled global Double applicantGrossIncome {get;set;}
    @AuraEnabled global String applicantNameOnId {get;set;}
    @AuraEnabled global String applicantIDNumber {get;set;}
    @AuraEnabled global String applicantTypeOfID {get;set;}
    @AuraEnabled global String applicantStateOnID {get;set;}
    @AuraEnabled global String applicantIDExpiryDate {get;set;}
    @AuraEnabled global Boolean applicantMarried {get;set;}

}