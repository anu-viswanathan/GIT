/**
 * Created by Andrea Pissinis on 2018-08-13.
 */

global with sharing class icDTOLoanForm {

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