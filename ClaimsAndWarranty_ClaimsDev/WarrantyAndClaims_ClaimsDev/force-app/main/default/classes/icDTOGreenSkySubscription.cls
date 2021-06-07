/**
 * Created by Francois Poirier on 2018-09-26.
 */

global with sharing class icDTOGreenSkySubscription {

    @AuraEnabled global String merchantId {get;set;}
    @AuraEnabled global String userName {get;set;}
    @AuraEnabled global String password {get;set;}
    @AuraEnabled global String apiKey {get;set;}

}