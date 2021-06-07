/**
 * Created by Francois Poirier on 2018-12-03.
 */

global with sharing class icDTOPaypalTokenResponse {

    @AuraEnabled global String scope {get;set;}
    @AuraEnabled global String nonce {get;set;}
    @AuraEnabled global String access_token {get;set;}
    @AuraEnabled global String token_type {get;set;}
    @AuraEnabled global String app_id {get;set;}
    @AuraEnabled global Integer expires_in {get;set;}

}