/**
 * Created by Francois Poirier on 2018-06-20.
 */

global with sharing class icDTOEagleViewPlaceOrderResponse {

    @AuraEnabled global Integer OrderId {get;set;}
    @AuraEnabled global List<Integer> ReportIds {get;set;}
    @AuraEnabled global String message {get;set;}

}