/**
 * Created by Francois Poirier on 2019-11-18.
 */

global with sharing class icDtoPickList {

    @AuraEnabled global String label {get;set;}
    @AuraEnabled global String value {get;set;}
    @AuraEnabled global Boolean isDefault {get;set;}
    @AuraEnabled global Boolean isActive {get;set;}
    @AuraEnabled global Boolean isSelected {get;set;}
    @AuraEnabled global String type {get;set;}

}