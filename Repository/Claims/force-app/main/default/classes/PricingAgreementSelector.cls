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
* @description PricingAgreementSelector provides methods to retrieve EU_Price_Agreement__c objects based on parameters.
*/

public with sharing class PricingAgreementSelector {

    /*******************************************************************************************************************
    * @description Retrieve Pricing Agreements for given Contract Numbers.
    * @param contractNumbers a Set of Strings containing Contract Numbers
    * @param accountIds a Set of Ids containing Account Ids
    * @return a List of Pricing Agreements with matching Contract Numbers
    * @example
    * List<EU_Price_Agreement__c> matchingAgreements = (new PricingAgreementSelector()).getAgreementsForContractNumbers(contractNumbers, accountIds);
    */

    public List<EU_Price_Agreement__c> getAgreementsForContractNumbers(Set<String> contractNumbers, Set<Id> accountIds) {
        List<EU_Price_Agreement__c> agreementsForContractNumbers = null;
        try {
            agreementsForContractNumbers = [
                    SELECT AccountId__c, EU_Adjustment_Detail__c, EU_Adjustment_Detail_ID__c, EU_Base_Price__c,
                            EU_Base_Price_ID__c, EU_Buying_Group__c, Buying_Group_ID__c, EU_Category_Code_4__c,
                            Category_code_4_ID__c, EU_Company_Number__c, EU_Company_pricing__c, EU_Company_Pricing_ID__c,
                            EU_Contract_Description__c, EU_Contract_Number__c, CreatedById, CurrencyIsoCode,
                            EU_Discount__c, EU_Discount_ID__c, LastModifiedById, Name, EU_Price_Type__c
                    FROM EU_Price_Agreement__c
                    WHERE EU_Contract_Number__c IN :contractNumbers AND AccountId__c IN :accountIds
            ];
        } catch (Exception e) {
            System.debug(LoggingLevel.WARN, e.getMessage());
            agreementsForContractNumbers = new List<EU_Price_Agreement__c>();
        }

        if(contractNumbers.isEmpty()) {System.debug(LoggingLevel.WARN, 'could not find any agreements');}

        return agreementsForContractNumbers;
    }
}