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
* @description PricingServicesTestComponentFactory aids in the generation of test objects.
*/

@IsTest
public class PricingServicesTestComponentFactory {
    public class PriceItemTestingTuple {
        public final EU_Price_Item__c referencePriceItem;
        public EU_Price_Item__c workingPriceItem;
        public PriceItemTestingTuple(EU_Price_Item__c priceItem) {
            this.referencePriceItem = priceItem.clone();
            this.workingPriceItem = priceItem.clone();
        }
    }

    public class PricingAgreementTestingTuple {
        public final EU_Price_Agreement__c referencePricingAgreement;
        public EU_Price_Agreement__c workingPricingAgreement;
        public PricingAgreementTestingTuple(EU_Price_Agreement__c pricingAgreement) {
            this.referencePricingAgreement = pricingAgreement.clone();
            this.workingPricingAgreement = pricingAgreement.clone();
        }
    }

    private static String newRandomString(Integer length) {
        Blob blobKey = Crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        return key.substring(0,length);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Price_Item__c object wrapped in a testing tuple.
    * @param contractNumber a dummy contract number, not null
    * @param acct a dummy account (may be null)
    * @return an PriceItemTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * PriceItemTestingTuple priceItemTT = PricingServicesTestComponentFactory.newPriceItemTestingTuple(contractNumber, acct);
    */

    public static PriceItemTestingTuple newPriceItemTestingTuple(String contractNumber, Account acct) {
        EU_Price_Item__c priceItem = new EU_Price_Item__c();
        if(acct != null) {
            priceItem.AccountId__c = acct.Id;
        }
        priceItem.EU_Header_Adjustment_Detail__c = newRandomString(5);
        priceItem.EU_Header_Adjustment_Detail_ID__c = newRandomString(5);
        priceItem.EU_Header_Base_Price__c = newRandomString(5);
        priceItem.EU_Header_Base_Price_ID__c = newRandomString(5);
        priceItem.EU_Header_Buying_Group__c = newRandomString(5);
        priceItem.EU_Header_Buying_Group_ID__c = newRandomString(5);
        priceItem.EU_Calculated_Price__c = 123.45;
        priceItem.EU_Header_Category_Code_4__c = newRandomString(5);
        priceItem.EU_Header_Category_code_4_ID__c = newRandomString(5);
        priceItem.EU_Header_Company_Number__c = newRandomString(5);
        priceItem.EU_Header_Company_pricing__c = newRandomString(5);
        priceItem.EU_Header_Company_Pricing_ID__c = newRandomString(5);
        priceItem.EU_Header_Contract_Description__c = newRandomString(5);
        priceItem.EU_Header_Contract_Number__c = contractNumber;
        priceItem.CurrencyIsoCode = 'EUR';
        priceItem.EU_Header_Discount__c = newRandomString(5);
        priceItem.EU_Header_Discount_ID__c = newRandomString(5);
        priceItem.EU_Effective_Date__c = Datetime.now().date();
        priceItem.EU_Expiry_Date__c = Datetime.now().addYears(1).date();
        priceItem.EU_Item_Description__c = newRandomString(5);
        priceItem.EU_Item_Number__c = newRandomString(5);
        priceItem.EU_Item_Price_Class__c = newRandomString(5);
        priceItem.EU_Item_Price_Class_ID__c = newRandomString(5);
        priceItem.EU_Header_Price_Type__c = newRandomString(5);
        priceItem.EU_Price_Unit_of_Measure__c = newRandomString(5);
        priceItem.EU_Quantity_Break__c = 543.21;
        priceItem.EU_Unit_Price__c = 23.14;
        return new PriceItemTestingTuple(priceItem);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Price_Item__c object wrapped in a testing tuple.
    * @param acct a dummy account (may be null)
    * @return an PriceItemTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * PriceItemTestingTuple priceItemTT = PricingServicesTestComponentFactory.newPriceItemTestingTuple(acct);
    */

    public static PriceItemTestingTuple newPriceItemTestingTuple(Account acct) {
        return newPriceItemTestingTuple(newRandomString(10), acct);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Price_Item__c object wrapped in a testing tuple.
    * @return an PriceItemTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * PriceItemTestingTuple priceItemTT = PricingServicesTestComponentFactory.newPriceItemTestingTuple();
    */

    public static PriceItemTestingTuple newPriceItemTestingTuple() {
        return newPriceItemTestingTuple(null);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Price_Agreement__c object wrapped in a testing tuple.
    * @param contractNumber a dummy invoice number, not null
    * @param acct a dummy account (may be null)
    * @return an PricingAgreementTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * PricingAgreementTestingTuple agreementTT = PricingServicesTestComponentFactory.newPricingAgreementTestingTuple(contractNumber, acct);
    */

    public static PricingAgreementTestingTuple newPricingAgreementTestingTuple(String contractNumber, Account acct) {
        EU_Price_Agreement__c agreement = new EU_Price_Agreement__c();
        if(acct != null) {
            agreement.AccountId__c = acct.Id;
        }
        agreement.EU_Adjustment_Detail__c = newRandomString(5);
        agreement.EU_Adjustment_Detail_ID__c = newRandomString(5);
        agreement.EU_Base_Price__c = newRandomString(5);
        agreement.EU_Base_Price_ID__c = newRandomString(5);
        agreement.EU_Buying_Group__c = newRandomString(5);
        agreement.Buying_Group_ID__c = newRandomString(5);
        agreement.EU_Category_Code_4__c = newRandomString(5);
        agreement.Category_code_4_ID__c = newRandomString(5);
        agreement.EU_Company_Number__c = newRandomString(5);
        agreement.EU_Company_pricing__c = newRandomString(5);
        agreement.EU_Company_Pricing_ID__c = newRandomString(5);
        agreement.EU_Contract_Description__c = newRandomString(5);
        agreement.EU_Contract_Number__c = newRandomString(5);
        agreement.CurrencyIsoCode = 'EUR';
        agreement.EU_Discount__c = newRandomString(5);
        agreement.EU_Discount_ID__c = newRandomString(5);
        agreement.EU_Price_Type__c = newRandomString(5);
        return new PricingAgreementTestingTuple(agreement);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Price_Agreement__c object wrapped in a testing tuple.
    * @param acct a dummy account (may be null)
    * @return an PricingAgreementTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * PricingAgreementTestingTuple agreementTT = PricingServicesTestComponentFactory.newPricingAgreementTestingTuple(contractNumber, acct);
    */

    public static PricingAgreementTestingTuple newPricingAgreementTestingTuple(Account acct) {
        return newPricingAgreementTestingTuple(newRandomString(10), acct);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Open_Invoice__c object wrapped in a testing tuple.
    * @return an InvoiceTestingTuple setup using random values as to avoid collisions
    * @example
    * InvoiceTestingTuple invoiceLineTT = InvoiceServicesTestComponentFactory.InvoiceTestingTuple();
    */

    public static PricingAgreementTestingTuple newPricingAgreementTestingTuple() {
        return newPricingAgreementTestingTuple(null);
    }
}