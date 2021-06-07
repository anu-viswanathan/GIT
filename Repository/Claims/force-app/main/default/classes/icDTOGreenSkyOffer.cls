/**
 * Created by Francois Poirier on 2018-07-30.
 */

global with sharing class icDTOGreenSkyOffer {

    @AuraEnabled global String applicantFullName {get;set;}
    @AuraEnabled global String submissionDate {get;set;}
    @AuraEnabled global String applicationStatus {get;set;}
    @AuraEnabled global String planNumber {get;set;}
    @AuraEnabled global String paymentTermOfferMessage {get;set;}
    @AuraEnabled global List<icDTOGreenSkyLoanOffer> offers {get;set;}
    @AuraEnabled global icDTOGreenSkyError error {get;set;}

}