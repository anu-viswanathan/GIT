/**
 * Created by Gerard van Kempen on 2019-12-06.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

/**
* @author Gerard van Kempen, 4C NV
* @date 2019
*
* @group Integration Services
*
* @description InvoiceSelector provides methods to retrieve EU_Open_Invoice__c objects based on parameters.
*/

public class InvoiceSelector {

    /*******************************************************************************************************************
    * @description Retrieve Open Invoices for given Invoice Numbers.
    * @param invoiceNumbers a Set of Strings containing Invoice Numbers
    * @return a List of Open Invoices with matching Invoice Numbers
    * @example
    * List<EU_Open_Invoice__c> matchingInvoices = (new InvoiceSelector()).getInvoicesForInvoiceNumbers(invoiceNumbers);
    */

    public List<EU_Open_Invoice__c> getInvoicesForInvoiceNumbers(Set<String> invoiceNumbers, Set<Id> accountIds) {
        List<EU_Open_Invoice__c> invoicesForInvoiceNumbers = null;
        try {
            invoicesForInvoiceNumbers = [
                    SELECT EU_Account__c, EU_Amount_Due_Value__c, CreatedById, CurrencyIsoCode,
                            EU_Inv_Due_Date__c, EU_Invoice_Date__c, EU_Invoice_Number__c, EU_Invoice_Type__c,
                            EU_JDE_Customer_No__c, LastModifiedById, EU_Mapics_Customer_No__c, EU_Open_Invoice__c,
                            Name, EU_Order_number_Reference__c, EU_Purchase_Order_Number__c, EU_Terms_code__c,
                            EU_Terms_Description__c, EU_Total_Invoice_Value__c
                    FROM EU_Open_Invoice__c
                    WHERE EU_Invoice_Number__c IN :invoiceNumbers AND EU_Account__c IN :accountIds
            ];
        } catch (Exception e) {
            System.debug(LoggingLevel.WARN, e.getMessage());
            invoicesForInvoiceNumbers = new List<EU_Open_Invoice__c>();
        }

        if(invoiceNumbers.isEmpty()) {System.debug(LoggingLevel.WARN, 'could not find any invoices');}

        return invoicesForInvoiceNumbers;
    }

}