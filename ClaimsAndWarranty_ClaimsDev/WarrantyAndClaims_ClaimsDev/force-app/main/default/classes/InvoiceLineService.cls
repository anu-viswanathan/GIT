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
* @description InvoiceLineService provides methods to link Invoices and Invoice Lines.
*/

public class InvoiceLineService {

    /*******************************************************************************************************************
    * @description Link Open Invoice Lines to the appropriate Open Invoices with normal matching rules.
    * @param invoices a List of EU_Open_Invoice__c objects to be referenced
    * @param invoiceLines a List of EU_Open_Invoice_Line__c objects to be linked
    * @return a Boolean indicating whether or not all Invoice Lines have been linked correctly (true), or not (false)
    * @example
    * Boolean invoiceLinesLinkedOK = (new InvoiceLineService()).relateInvoicesToInvoiceLines(invoices, invoiceLines);
    */

    public Boolean relateInvoicesToInvoiceLines(List<EU_Open_Invoice__c> invoices, List<EU_Open_Invoice_Line__c> invoiceLines) {
        Integer matches = 0;
        // TODO: optimize algorithm
        for(EU_Open_Invoice__c invoice : invoices) {
            for(EU_Open_Invoice_Line__c invoiceLine : invoiceLines) {
                if(
                    invoice.EU_Invoice_Number__c == invoiceLine.EU_Header_Invoice_Number__c
                    && invoice.EU_Account__c == invoiceLine.EU_Header_Account__c
                ) {
                    invoiceLine.EU_Open_Invoice__c = invoice.Id;
                    matches++;
                }
            }
        }

        final Boolean allInvoiceLinesHandled = (matches == invoiceLines.size());
        if(!allInvoiceLinesHandled) {
            System.debug(LoggingLevel.ERROR, 'could not link all invoice lines to an invoice, or an invoice line has been multi-assigned');
        }

        return allInvoiceLinesHandled;
    }
}