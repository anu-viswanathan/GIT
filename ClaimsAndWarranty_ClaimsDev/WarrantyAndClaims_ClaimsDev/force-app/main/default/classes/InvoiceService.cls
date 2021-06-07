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
* @description InvoiceService provides two methods which can be used to create new EU_Open_Invoice__c objects
* based on data from existing EU_Open_Invoice_Line__c objects.
*/

public class InvoiceService {

    /*******************************************************************************************************************
    * @description Generate Open Invoices for Open Invoice Lines. Prevents duplicate Open Invoices from being generated
    * for similar Open Invoice Lines.
    * @param invoiceLines a List of Open Invoice Lines for which to generate Open Invoices
    * @return a List of Open Invoices
    * @example
    * List<EU_Open_Invoice__c> newInvoices = (new InvoiceService()).createNewInvoicesForInvoiceLines(invoiceLines);
    */

    public List<EU_Open_Invoice__c> createNewInvoicesForInvoiceLines(List<EU_Open_Invoice_Line__c> invoiceLines) {
        Map<String, EU_Open_Invoice__c> newInvoicesByInvoiceNumber = new Map<String, EU_Open_Invoice__c>();

        for(EU_Open_Invoice_Line__c invoiceLine : invoiceLines) {
            try {
                EU_Open_Invoice__c currentInvoice = new EU_Open_Invoice__c();
                if (newInvoicesByInvoiceNumber.containsKey(invoiceLine.EU_Header_Invoice_Number__c + invoiceLine.EU_Header_Account__c)) {
                    currentInvoice = newInvoicesByInvoiceNumber.get(invoiceLine.EU_Header_Invoice_Number__c + invoiceLine.EU_Header_Account__c);
                } else {
                    this.relateHeaderFieldsToInvoiceRecord(currentInvoice, invoiceLine);
                }
                currentInvoice.EU_Account__c = invoiceLine.EU_Header_Account__c;

                newInvoicesByInvoiceNumber.put(currentInvoice.EU_Invoice_Number__c + currentInvoice.EU_Account__c, currentInvoice);
            } catch(Exception e) {
                System.debug(LoggingLevel.WARN, e.getMessage());
                System.debug(LoggingLevel.WARN, 'could not generate invoice for invoice line due to NULL-reference');
            }
        }

        return newInvoicesByInvoiceNumber.values();
    }

    public void relateHeaderFieldsToInvoiceRecord(EU_Open_Invoice__c invoice, EU_Open_Invoice_Line__c invoiceLine) {
        invoice.CurrencyIsoCode = invoiceLine.CurrencyIsoCode;
        invoice.EU_Inv_Due_Date__c = invoiceLine.EU_Header_Inv_Due_Date__c;
        invoice.EU_Invoice_Date__c = invoiceLine.EU_Header_Invoice_Date__c;
        invoice.EU_Invoice_Number__c = invoiceLine.EU_Header_Invoice_Number__c;
        invoice.EU_Invoice_Type__c = invoiceLine.EU_Header_Invoice_Type__c;
        invoice.EU_JDE_Customer_No__c = invoiceLine.EU_Header_JDE_Customer_No__c;
        invoice.EU_Mapics_Customer_No__c = invoiceLine.EU_Header_Mapics_Customer_No__c;
        invoice.EU_Open_Invoice__c = invoiceLine.EU_Header_Open_Invoice__c;
        invoice.EU_Order_number_Reference__c = invoiceLine.EU_Header_Order_number_Reference__c;
        invoice.EU_Purchase_Order_Number__c = invoiceLine.EU_Header_Purchase_Order_Number__c;
        invoice.EU_Terms_code__c = invoiceLine.EU_Header_Terms_code__c;
        invoice.EU_Terms_Description__c = invoiceLine.EU_Header_Terms_Description__c;
        invoice.EU_Total_Invoice_Value__c = invoiceLine.EU_Header_Total_Invoice_Value__c;
    }
}