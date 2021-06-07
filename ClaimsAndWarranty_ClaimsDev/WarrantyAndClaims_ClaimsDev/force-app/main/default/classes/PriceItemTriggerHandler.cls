/**
 * Created by Gerard van Kempen on 2019-12-23.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

public with sharing class PriceItemTriggerHandler extends TriggerHandler {

    protected override void onBeforeInsert(List<SObject> newList) {
        List<EU_Price_Item__c> newPriceItems = (List<EU_Price_Item__c>)newList;

        PriceItemTriggerHandlerFunctions.mapPriceItemsToPricingAgreements(newPriceItems);
    }

    protected override void onBeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        Map<Id, EU_Price_Item__c> newPriceItems = (Map<Id, EU_Price_Item__c>)newMap;
        Map<Id, EU_Price_Item__c> oldPriceItems = (Map<Id, EU_Price_Item__c>)oldMap;

        List<EU_Price_Item__c> priceItemsToBeMatched = PriceItemTriggerHandlerFunctions.filterPriceItemsToMap(newPriceItems, oldPriceItems);

        PriceItemTriggerHandlerFunctions.mapPriceItemsToPricingAgreements(priceItemsToBeMatched);
    }

    protected override void onAfterUpdate(Map<Id, sObject> newMap, Map<Id, sObject> oldMap) {
        Map<Id, EU_Price_Item__c> newPriceItems = (Map<Id, EU_Price_Item__c>)newMap;
        Map<Id, EU_Price_Item__c> oldPriceItems = (Map<Id, EU_Price_Item__c>)oldMap;

        List<EU_Price_Agreement__c> priceAgreementsToUpdate = PriceItemTriggerHandlerFunctions.updatePriceAgreementRecords(newPriceItems);
        update priceAgreementsToUpdate;
    }

}