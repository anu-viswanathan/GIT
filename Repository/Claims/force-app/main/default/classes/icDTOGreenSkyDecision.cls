/**
 * Created by Francois Poirier on 2018-07-30.
 */

global with sharing class icDTOGreenSkyDecision {

    @AuraEnabled global String applicantFullName {get;set;}
    @AuraEnabled global String requestedLoanAmount {get;set;}
    @AuraEnabled global String status {get;set;}
    @AuraEnabled global icDTOGreenSkyError error {get;set;}

}