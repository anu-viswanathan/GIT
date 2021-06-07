/**
 * Created by Gerard van Kempen on 2019-12-23.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

public with sharing class PriceItemTriggerHandlerFunctions {
    private PriceItemTriggerHandlerFunctions() {}

    public static void mapPriceItemsToPricingAgreements(List<EU_Price_Item__c> priceItems) {
        // null check
        if(priceItems == null || priceItems.isEmpty()) {
            System.debug(LoggingLevel.ERROR, 'empty or NULL List received where value(s) were expected, terminating...');
            return;
        }

        // extract all invoice numbers referenced by Invoice Lines, no deduplication
        Set<String> contractNumbersFromInput = new Set<String>();
        Set<Id> accountIds = new Set<Id>();
        for(EU_Price_Item__c invoiceLine : priceItems) {
            contractNumbersFromInput.add(invoiceLine.EU_Header_Contract_Number__c);
            accountIds.add(invoiceLine.AccountId__c);
        }

        // find existing Orders for order Lines
        List<EU_Price_Agreement__c> existingMatchingAgreements = (new PricingAgreementSelector()).getAgreementsForContractNumbers(contractNumbersFromInput, accountIds);

        // try to match all Order Lines to Orders; true if success, false if certain Lines could not be matched
        Boolean cleanMatchForExistingAgreements = (new PriceItemService()).relatePriceItemsToPricingAgreements(existingMatchingAgreements, priceItems);
        // field for future use
        Boolean cleanMatchForGeneratedAgreements = null;

        // only do this if not all Lines could be matched correctly
        if(!cleanMatchForExistingAgreements) {
            // collect all Order Lines which still have no linked Order
            List<EU_Price_Item__c> priceItemsWhichRequireNewAgreements = new List<EU_Price_Item__c>();
            for(EU_Price_Item__c invoiceLine : priceItems) {
                if(invoiceLine.EU_Pricing_Agreement__c == null) {
                    priceItemsWhichRequireNewAgreements.add(invoiceLine);
                }
            }

            // create and insert new Orders for those Order Lines
            List<EU_Price_Agreement__c> generatedAgreements = (new PricingAgreementService()).createNewPriceAgreementsForPriceItems(priceItemsWhichRequireNewAgreements);
            insert generatedAgreements;

            // check if the previously unmatched Lines have now been matched successfully
            cleanMatchForGeneratedAgreements = (new PriceItemService()).relatePriceItemsToPricingAgreements(generatedAgreements, priceItemsWhichRequireNewAgreements);
        }

        // log an error if there still exist some Lines without a linked Order
        if(!(cleanMatchForExistingAgreements == true && cleanMatchForGeneratedAgreements == null) || !(cleanMatchForExistingAgreements == false && cleanMatchForGeneratedAgreements == true)) {
            System.debug(LoggingLevel.ERROR, 'could not find or generate agreements for all price items');
        }
    }

    public static List<EU_Price_Item__c> filterPriceItemsToMap(Map<Id, EU_Price_Item__c> newPriceItems, Map<Id, EU_Price_Item__c> oldPriceItems) {
        // check which Invoice Lines already have Invoices set, and split into two maps indexed by Line Id
        Map<Id, EU_Price_Item__c> priceItemsWithAgreements = new Map<Id, EU_Price_Item__c>();
        Map<Id, EU_Price_Item__c> priceItemsToBeMatched = new Map<Id, EU_Price_Item__c>();

        for(Id lineId : new List<Id>(newPriceItems.keySet())) {
            final EU_Price_Item__c lineValue = newPriceItems.get(lineId);

            if(lineValue.EU_Pricing_Agreement__c != null) {
                priceItemsWithAgreements.put(lineId, lineValue);
            } else {
                priceItemsToBeMatched.put(lineId, lineValue);
            }
        }

        // check if the Invoice Line Order numbers have been changed for any Lines with Invoices set, and if so queue for rematching
        for(Id lineId : new List<Id>(newPriceItems.keySet())) {
            final EU_Price_Item__c lineValue = priceItemsWithAgreements.get(lineId);
            final EU_Price_Item__c oldLineValue = oldPriceItems.get(lineId);
            if(lineValue.EU_Header_Contract_Number__c != oldLineValue.EU_Header_Contract_Number__c) {
                priceItemsToBeMatched.put(lineId, lineValue);
            }
        }

        // return all Invoice Lines which require new or refreshed matching
        return priceItemsToBeMatched.values();
    }

    public static List<EU_Price_Agreement__c> updatePriceAgreementRecords(Map<Id, EU_Price_Item__c> newPriceItems) {
        Map<Id, EU_Price_Agreement__c> pricingAgreements = new Map<Id, EU_Price_Agreement__c>();
        for (EU_Price_Item__c item : newPriceItems.values()) {
            EU_Price_Agreement__c priceAgreement = new EU_Price_Agreement__c(Id=item.EU_Pricing_Agreement__c);
            new PricingAgreementService().relateHeaderFieldsToPriceAgreementRecord(priceAgreement, item);
            pricingAgreements.put(priceAgreement.Id, priceAgreement);
        }

        return pricingAgreements.values();
    }
}