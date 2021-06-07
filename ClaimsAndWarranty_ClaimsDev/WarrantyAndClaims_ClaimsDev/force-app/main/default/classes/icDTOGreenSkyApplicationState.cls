/**
 * Created by Francois Poirier on 2018-07-17.
 */

global with sharing class icDTOGreenSkyApplicationState {

    @AuraEnabled global String applicationState {get;set;}
    @AuraEnabled global String applicationStatus {get;set;}
    @AuraEnabled global String nextState {get;set;}
    @AuraEnabled global Boolean applicantAddressEntryRequired {get;set;}
    @AuraEnabled global Boolean coApplicantAddressEntryRequired {get;set;}
    @AuraEnabled global Boolean applicationInfoReviewRequired {get;set;}
    @AuraEnabled global icDTOGreenSkyError error {get;set;}

}