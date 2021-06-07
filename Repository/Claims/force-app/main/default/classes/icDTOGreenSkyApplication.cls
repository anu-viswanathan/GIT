/**
 * Created by Francois Poirier on 2018-07-16.
 */

global with sharing class icDTOGreenSkyApplication {

    @AuraEnabled global String applicationId {get;set;}
    @AuraEnabled global String token {get;set;}
    @AuraEnabled global icDTOGreenSkyError error {get;set;}
    @AuraEnabled global String GreenSkyApplicationSFId {get;Set;}
    @AuraEnabled global String opportunityId {get;set;}
    @AuraEnabled global String accountId {get;set;}
    @AuraEnabled global String requestedAmount {get;set;}
    
}