/**
 * Created by Francois Poirier on 2018-08-01.
 */

global with sharing class icDTOGreenSkyEmail {

    @AuraEnabled global String status {get;set;}
    @AuraEnabled global icDTOGreenSkyError error {get;set;}
    
}