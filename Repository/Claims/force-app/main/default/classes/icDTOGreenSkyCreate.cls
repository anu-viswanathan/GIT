/**
 * Created by Francois Poirier on 2018-07-31.
 */

global with sharing class icDTOGreenSkyCreate {

    @AuraEnabled global String Status {get;set;}
    @AuraEnabled global icDTOGreenSkyError error {get;set;}

}