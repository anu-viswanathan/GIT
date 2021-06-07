/**
 * Created by Francois Poirier on 2018-06-20.
 */

global with sharing class icDTOEagleViewToken {

    @AuraEnabled global String access_token {get;set;}
    @AuraEnabled global String token_type {get;set;}
    @AuraEnabled global String expires_in {get;set;}
    @AuraEnabled global String refresh_token {get;set;}
    /*@AuraEnabled global String asClientId {get;set;}
    @AuraEnabled global String issued {get;set;}
    @AuraEnabled global String expires {get;set;}
*/
}