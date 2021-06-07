/**
 * Created by Francois Poirier on 2018-07-16.
 */

global with sharing class icDTOGreenSkyError {

    @AuraEnabled global String code {get;set;}
    @AuraEnabled global String message {get;set;}

}