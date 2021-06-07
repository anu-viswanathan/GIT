/**
 * Created by Gerard van Kempen on 2019-12-23.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

/**
* @author Gerard van Kempen, 4C NV
* @date 2019
*
* @group Integration Services
*
* @description PricingAgreementService provides two methods which can be used to create new EU_Price_Agreement__c objects
* based on data from existing EU_Price_Item__c objects.
*/

public with sharing class PricingAgreementService {

    /*******************************************************************************************************************
    * @description Generate Pricing Agreements for Price Items. Prevents duplicate Pricing Agreements from being generated
    * for similar Price Items.
    * @param priceItems a List of Price Items for which to generate Pricing Agreements
    * @return a List of Pricing Agreements
    * @example
    * List<EU_Price_Agreement__c> newAgreements = (new PricingAgreementService()).createNewPriceAgreementsForPriceItems(priceItems);
    */

    public List<EU_Price_Agreement__c> createNewPriceAgreementsForPriceItems(List<EU_Price_Item__c> priceItems) {
        Map<String, EU_Price_Agreement__c> newAgreementsByContractNumber = new Map<String, EU_Price_Agreement__c>();

        for(EU_Price_Item__c priceItem : priceItems) {
            try {
                EU_Price_Agreement__c currentAgreement = new EU_Price_Agreement__c();
                if (newAgreementsByContractNumber.containsKey(priceItem.EU_Header_Contract_Number__c + priceItem.AccountId__c)) {
                    currentAgreement = newAgreementsByContractNumber.get(priceItem.EU_Header_Contract_Number__c + priceItem.AccountId__c);
                } else {
                    this.relateHeaderFieldsToPriceAgreementRecord(currentAgreement, priceItem);
                }
                currentAgreement.AccountId__c = priceItem.AccountId__c;
                newAgreementsByContractNumber.put(currentAgreement.EU_Contract_Number__c + currentAgreement.AccountId__c, currentAgreement);
            } catch(Exception e) {
                System.debug(LoggingLevel.WARN, e.getMessage());
                System.debug(LoggingLevel.WARN, 'could not generate agreement for price item due to NULL-reference');
            }
        }

        return newAgreementsByContractNumber.values();
    }

    public void relateHeaderFieldsToPriceAgreementRecord(EU_Price_Agreement__c priceAgreement, EU_Price_Item__c priceItem) {
        priceAgreement.EU_Adjustment_Detail__c = priceItem.EU_Header_Adjustment_Detail__c;
        priceAgreement.EU_Adjustment_Detail_ID__c = priceItem.EU_Header_Adjustment_Detail_ID__c;
        priceAgreement.EU_Base_Price__c = priceItem.EU_Header_Base_Price__c;
        priceAgreement.EU_Base_Price_ID__c = priceItem.EU_Header_Base_Price_ID__c;
        priceAgreement.EU_Buying_Group__c = priceItem.EU_Header_Buying_Group__c;
        priceAgreement.Buying_Group_ID__c = priceItem.EU_Header_Buying_Group_ID__c;
        priceAgreement.EU_Category_Code_4__c = priceItem.EU_Header_Category_Code_4__c;
        priceAgreement.Category_code_4_ID__c = priceItem.EU_Header_Category_code_4_ID__c;
        priceAgreement.EU_Company_Number__c = priceItem.EU_Header_Company_Number__c;
        priceAgreement.EU_Company_pricing__c = priceItem.EU_Header_Company_pricing__c;
        priceAgreement.EU_Company_Pricing_ID__c = priceItem.EU_Header_Company_Pricing_ID__c;
        priceAgreement.EU_Contract_Description__c = priceItem.EU_Header_Contract_Description__c;
        priceAgreement.EU_Contract_Number__c = priceItem.EU_Header_Contract_Number__c;
        priceAgreement.CurrencyIsoCode = priceItem.CurrencyIsoCode;
        priceAgreement.EU_Discount__c = priceItem.EU_Header_Discount__c;
        priceAgreement.EU_Discount_ID__c = priceItem.EU_Header_Discount_ID__c;
        priceAgreement.EU_Price_Type__c = priceItem.EU_Header_Price_Type__c;
    }
}