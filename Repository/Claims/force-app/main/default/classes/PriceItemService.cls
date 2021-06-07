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
* @description PriceItemService provides methods to link Pricing Agreements and Price Items.
*/

public class PriceItemService {

    /*******************************************************************************************************************
    * @description Link Price Items to the appropriate Pricing Agreements with normal matching rules.
    * @param pricingAgreements a List of EU_Price_Agreement__c objects to be referenced
    * @param priceItems a List of EU_Price_Item__c objects to be linked
    * @return a Boolean indicating whether or not all Invoice Lines have been linked correctly (true), or not (false)
    * @example
    * Boolean priceItemsLinkedOK = (new PriceItemService()).relatePriceItemsToPricingAgreements(pricingAgreements, priceItems);
    */

    public Boolean relatePriceItemsToPricingAgreements(List<EU_Price_Agreement__c> pricingAgreements, List<EU_Price_Item__c> priceItems) {
        Integer matches = 0;
        // TODO: optimize algorithm
        for(EU_Price_Agreement__c pricingAgreement : pricingAgreements) {
            for(EU_Price_Item__c priceItem : priceItems) {
                if(
                    pricingAgreement.EU_Contract_Number__c == priceItem.EU_Header_Contract_Number__c
                    && pricingAgreement.AccountId__c == priceItem.AccountId__c
                ) {
                    system.debug('Matched record: ' + pricingAgreement.Id);
                    priceItem.EU_Pricing_Agreement__c = pricingAgreement.Id;
                    matches++;
                }
            }
        }

        final Boolean allPriceItemsHandled = (matches == priceItems.size());
        if(!allPriceItemsHandled) {
            System.debug(LoggingLevel.ERROR, 'could not link all price items to an agreement, or a price item has been multi-assigned');
        }

        return allPriceItemsHandled;
    }
}