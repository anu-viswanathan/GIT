/**
 * Created by Francois Poirier on 2018-06-20.
 */

global with sharing class icDTOEagleViewProduct {

    @AuraEnabled global Integer productID {get;set;}
    @AuraEnabled global String name {get;set;}
    @AuraEnabled global String description {get;set;}
    @AuraEnabled global String productGroup {get;set;}
    @AuraEnabled global Boolean isTemporarilyUnavailable {get;set;}
    @AuraEnabled global Decimal priceMin {get;set;}
    @AuraEnabled global Decimal priceMax {get;set;}
    @AuraEnabled global List<icDTOEagleViewProduct> deliveryProducts {get;set;}
    @AuraEnabled global List<icDTOEagleViewProduct> addOnProducts {get;set;}
    @AuraEnabled global List<Integer> measurementInstructionTypes {get;set;}
    @AuraEnabled global Integer TypeOfStructure {get;set;}
    @AuraEnabled global Boolean IsRoofProduct {get;set;}
    @AuraEnabled global Integer SortOrder {get;set;}
    @AuraEnabled global Boolean AllowsUserSubmittedPhotos {get;set;}

}