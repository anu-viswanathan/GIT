/**
 * Created by Gerard van Kempen on 2019-12-24.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

@IsTest
public class CleanupSchedulable_EuPricingAgreemt_Test {
    @IsTest
    static void cleanupForTwoWithOneMatchingResultsInOneRemaining() {
        SharedTestComponentFactory.AccountTestingTuple accountTT = SharedTestComponentFactory.newAccountTestingTuple();
        insert accountTT.workingAccount;

        PricingServicesTestComponentFactory.PricingAgreementTestingTuple agreementTT1 = PricingServicesTestComponentFactory.newPricingAgreementTestingTuple(accountTT.workingAccount);
        PricingServicesTestComponentFactory.PricingAgreementTestingTuple agreementTT2 = PricingServicesTestComponentFactory.newPricingAgreementTestingTuple(accountTT.workingAccount);

        List<EU_Price_Agreement__c> agreementsToInsert = new List<EU_Price_Agreement__c>();
        List<String> contractNumbers = new List<String>();
        Set<Id> accountIds = new Set<Id>();

        // should not be deleted
        EU_Price_Agreement__c agreement_1 = agreementTT1.workingPricingAgreement;
        agreementsToInsert.add(agreement_1);
        contractNumbers.add(agreement_1.EU_Contract_Number__c);
        accountIds.add(agreement_1.AccountId__c);

        // should be deleted
        EU_Price_Agreement__c agreement_2 = agreementTT2.workingPricingAgreement;
        agreementsToInsert.add(agreement_2);
        contractNumbers.add(agreement_2.EU_Contract_Number__c);
        accountIds.add(agreement_2.AccountId__c);

        insert agreementsToInsert;

        List<EU_Price_Agreement__c> agreementsAsInserted = (new PricingAgreementSelector()).getAgreementsForContractNumbers(new Set<String> (contractNumbers), accountIds);
        Map<String, EU_Price_Agreement__c> agreementsByContractNumber = new Map<String, EU_Price_Agreement__c>();
        for(EU_Price_Agreement__c agreement : agreementsAsInserted) {
            agreementsByContractNumber.put(agreement.EU_Contract_Number__c, agreement);
        }


        PricingServicesTestComponentFactory.PriceItemTestingTuple priceItemTT_1_1 = PricingServicesTestComponentFactory.newPriceItemTestingTuple(contractNumbers.get(0), accountTT.workingAccount);
        PricingServicesTestComponentFactory.PriceItemTestingTuple priceItemTT_1_2 = PricingServicesTestComponentFactory.newPriceItemTestingTuple(contractNumbers.get(0), accountTT.workingAccount);
        PricingServicesTestComponentFactory.PriceItemTestingTuple priceItemTT_2_1 = PricingServicesTestComponentFactory.newPriceItemTestingTuple(contractNumbers.get(1), accountTT.workingAccount);
        PricingServicesTestComponentFactory.PriceItemTestingTuple priceItemTT_2_2 = PricingServicesTestComponentFactory.newPriceItemTestingTuple(contractNumbers.get(1), accountTT.workingAccount);

        List<EU_Price_Item__c> priceItemsToInsert = new List<EU_Price_Item__c>();

        // expired
        EU_Price_Item__c priceItem_1_1 = priceItemTT_1_1.workingPriceItem;
        priceItem_1_1.EU_Pricing_Agreement__c = agreementsByContractNumber.get(priceItem_1_1.EU_Header_Contract_Number__c).Id;
        priceItem_1_1.EU_Expiry_Date__c = Datetime.now().addMonths(-4).date();
        priceItemsToInsert.add(priceItem_1_1);

        // valid
        EU_Price_Item__c priceItem_1_2 = priceItemTT_1_2.workingPriceItem;
        priceItem_1_2.EU_Pricing_Agreement__c = agreementsByContractNumber.get(priceItem_1_2.EU_Header_Contract_Number__c).Id;
        priceItem_1_2.EU_Expiry_Date__c = Datetime.now().date();
        priceItemsToInsert.add(priceItem_1_2);

        // expired
        EU_Price_Item__c priceItem_2_1 = priceItemTT_2_1.workingPriceItem;
        priceItem_2_1.EU_Pricing_Agreement__c = agreementsByContractNumber.get(priceItem_2_1.EU_Header_Contract_Number__c).Id;
        priceItem_2_1.EU_Expiry_Date__c = Datetime.now().addMonths(-4).date();
        priceItemsToInsert.add(priceItem_2_1);

        // expired
        EU_Price_Item__c priceItem_2_2 = priceItemTT_2_2.workingPriceItem;
        priceItem_2_2.EU_Pricing_Agreement__c = agreementsByContractNumber.get(priceItem_2_2.EU_Header_Contract_Number__c).Id;
        priceItem_2_2.EU_Expiry_Date__c = Datetime.now().addMonths(-4).date();
        priceItemsToInsert.add(priceItem_2_2);

        insert priceItemsToInsert;


        Test.startTest();

        (new CleanupSchedulable_EuPricingAgreement()).execute(null);

        Test.stopTest();

        List<EU_Price_Agreement__c> retrievedAgreements = [
                SELECT Id, EU_Contract_Number__c, (SELECT Id FROM Price_Items__r)
                FROM EU_Price_Agreement__c
                WHERE EU_Contract_Number__c IN :contractNumbers
        ];

        System.assertEquals(retrievedAgreements.size(), 1);
        System.assertEquals(retrievedAgreements.get(0).Price_Items__r.size(), 1);
    }
}