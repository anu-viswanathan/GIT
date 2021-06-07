/**
 * Created by Gerard van Kempen on 2019-12-23.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

@IsTest
private class PriceItemTriggerTests {
    @IsTest
    static void handlingPriceItemForExistingAgreementResultsInLink() {
        SharedTestComponentFactory.AccountTestingTuple accountTT = SharedTestComponentFactory.newAccountTestingTuple();
        insert accountTT.workingAccount;

        PricingServicesTestComponentFactory.PriceItemTestingTuple priceItemTT
                = PricingServicesTestComponentFactory.newPriceItemTestingTuple(accountTT.workingAccount);
        final String contractNumber = priceItemTT.referencePriceItem.EU_Header_Contract_Number__c;

        List<EU_Price_Item__c> priceItems = new List<EU_Price_Item__c>();
        priceItems.add(priceItemTT.workingPriceItem);
        System.assert(priceItems.size() == 1);

        List<EU_Price_Agreement__c> generatedAgreements = (new PricingAgreementService()).createNewPriceAgreementsForPriceItems(priceItems);
        System.assert(generatedAgreements.size() == 1);

        insert generatedAgreements;
        EU_Price_Agreement__c refAgreement = generatedAgreements.get(0);


        Test.startTest();

        insert priceItems;

        EU_Price_Agreement__c retrievedAgreement = null;
        EU_Price_Item__c retrievedPriceItem = null;

        try{
            retrievedAgreement = ((List<EU_Price_Agreement__c>) [
                    SELECT Id, EU_Contract_Number__c, AccountId__c
                    FROM EU_Price_Agreement__c
                    WHERE EU_Contract_Number__c = :contractNumber
            ]).get(0);
        } catch(Exception e) {
            System.assert(false, 'failed due to SOQL query not returning correctly');
        }

        try {
            retrievedPriceItem = ((List<EU_Price_Item__c>)[
                    SELECT Id, EU_Header_Contract_Number__c, AccountId__c, EU_Pricing_Agreement__c
                    FROM EU_Price_Item__c
                    WHERE EU_Header_Contract_Number__c = :contractNumber
            ]).get(0);
        } catch(Exception e) {
            System.assert(false, 'failed due to SOQL query not returning correctly');
        }

        if(retrievedAgreement != null && retrievedPriceItem != null) {
            System.assert(retrievedAgreement.Id == refAgreement.Id);
            System.assert(retrievedAgreement.AccountId__c == accountTT.workingAccount.Id);
            System.assert(retrievedPriceItem.EU_Pricing_Agreement__c == retrievedAgreement.Id);
        } else {
            System.assert(false, 'failed due to unexpected NULL pointers');
        }

        Test.stopTest();
    }

    @IsTest
    static void handlingPriceItemForNewAgreementResultsInCreation() {
        SharedTestComponentFactory.AccountTestingTuple accountTT = SharedTestComponentFactory.newAccountTestingTuple();
        insert accountTT.workingAccount;

        PricingServicesTestComponentFactory.PriceItemTestingTuple priceItemTT
                = PricingServicesTestComponentFactory.newPriceItemTestingTuple(accountTT.workingAccount);
        final String contractNumber = priceItemTT.referencePriceItem.EU_Header_Contract_Number__c;

        List<EU_Price_Item__c> priceItems = new List<EU_Price_Item__c>();
        priceItems.add(priceItemTT.workingPriceItem);
        System.assert(priceItems.size() == 1);


        Test.startTest();

        insert priceItems;

        EU_Price_Agreement__c retrievedAgreement = null;
        EU_Price_Item__c retrievedPriceItem = null;

        try{
            retrievedAgreement = ((List<EU_Price_Agreement__c>) [
                    SELECT Id, EU_Contract_Number__c, AccountId__c
                    FROM EU_Price_Agreement__c
                    WHERE EU_Contract_Number__c = :contractNumber
            ]).get(0);
        } catch(Exception e) {
            System.assert(false, 'failed due to SOQL query not returning correctly');
        }

        try {
            retrievedPriceItem = ((List<EU_Price_Item__c>)[
                    SELECT Id, EU_Header_Contract_Number__c, AccountId__c, EU_Pricing_Agreement__c
                    FROM EU_Price_Item__c
                    WHERE EU_Header_Contract_Number__c = :contractNumber
            ]).get(0);
        } catch(Exception e) {
            System.assert(false, 'failed due to SOQL query not returning correctly');
        }

        if(retrievedAgreement != null && retrievedPriceItem != null) {
            System.assert(retrievedAgreement.AccountId__c == accountTT.workingAccount.Id);
            System.assert(retrievedPriceItem.EU_Pricing_Agreement__c == retrievedAgreement.Id);
        } else {
            System.assert(false, 'failed due to unexpected NULL pointers');
        }

        Test.stopTest();
    }

    @IsTest
    static void handlingPriceItemUpdates() {
        SharedTestComponentFactory.AccountTestingTuple accountTT = SharedTestComponentFactory.newAccountTestingTuple();
        insert accountTT.workingAccount;

        PricingServicesTestComponentFactory.PriceItemTestingTuple priceItemTT
                = PricingServicesTestComponentFactory.newPriceItemTestingTuple(accountTT.workingAccount);
        final String contractNumber = priceItemTT.referencePriceItem.EU_Header_Contract_Number__c;

        List<EU_Price_Item__c> priceItems = new List<EU_Price_Item__c>();
        priceItems.add(priceItemTT.workingPriceItem);
        System.assertEquals(priceItems.size(), 1);

        Test.startTest();

        insert priceItems;

        EU_Price_Agreement__c retrievedAgreement = null;
        EU_Price_Item__c retrievedPriceItem = null;

        try{
            retrievedAgreement = ((List<EU_Price_Agreement__c>) [
                    SELECT Id, EU_Contract_Number__c, AccountId__c
                    FROM EU_Price_Agreement__c
                    WHERE EU_Contract_Number__c = :contractNumber
            ]).get(0);
        } catch(Exception e) {
            System.assert(false, 'failed due to SOQL query not returning correctly');
        }

        try {
            retrievedPriceItem = ((List<EU_Price_Item__c>)[
                    SELECT Id, EU_Header_Contract_Number__c, AccountId__c, EU_Pricing_Agreement__c
                    FROM EU_Price_Item__c
                    WHERE EU_Header_Contract_Number__c = :contractNumber
            ]).get(0);
        } catch(Exception e) {
            System.assert(false, 'failed due to SOQL query not returning correctly');
        }

        if(retrievedAgreement != null && retrievedPriceItem != null) {
            System.assert(retrievedAgreement.AccountId__c == accountTT.workingAccount.Id);
            System.assert(retrievedPriceItem.EU_Pricing_Agreement__c == retrievedAgreement.Id);
        } else {
            System.assert(false, 'failed due to unexpected NULL pointers');
        }

        priceItems[0].EU_Header_Contract_Description__c = 'Test update Item';
        update priceItems;

        List<EU_Price_Agreement__c> priceAgreements = [SELECT Id, EU_Contract_Description__c FROM EU_Price_Agreement__c WHERE EU_Contract_Number__c = :contractNumber];
        System.assertEquals(priceAgreements.size(), 1);
        System.assertEquals(priceAgreements[0].EU_Contract_Description__c, priceItems[0].EU_Header_Contract_Description__c);

        Test.stopTest();
    }
}