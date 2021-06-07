/**
 * Created by Gerard van Kempen on 2019-12-18.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

public with sharing class InvoiceLineTriggerHandlerFunctions {
    private InvoiceLineTriggerHandlerFunctions() {}

    public static void mapInvoiceLinesToInvoices(List<EU_Open_Invoice_Line__c> invoiceLines) {
        // null check
        if(invoiceLines == null || invoiceLines.isEmpty()) {
            System.debug(LoggingLevel.ERROR, 'empty or NULL List received where value(s) were expected, terminating...');
            return;
        }

        // extract all invoice numbers referenced by Invoice Lines, no deduplication
        Set<String> invoiceNumbersForInput = new Set<String>();
        Set<Id> accountIds = new Set<Id>();
        for(EU_Open_Invoice_Line__c invoiceLine : invoiceLines) {
            invoiceNumbersForInput.add(invoiceLine.EU_Header_Invoice_Number__c);
            accountIds.add(invoiceLine.EU_Header_Account__c);
        }

        // find existing Orders for order Lines
        List<EU_Open_Invoice__c> existingMatchingInvoices = (new InvoiceSelector()).getInvoicesForInvoiceNumbers(invoiceNumbersForInput, accountIds);

        // try to match all Order Lines to Orders; true if success, false if certain Lines could not be matched
        Boolean cleanMatchesForExistingInvoices = (new InvoiceLineService()).relateInvoicesToInvoiceLines(existingMatchingInvoices, invoiceLines);
        // field for future use
        Boolean cleanMatchesForGeneratedInvoices = null;

        // only do this if not all Lines could be matched correctly
        if(!cleanMatchesForExistingInvoices) {
            // collect all Order Lines which still have no linked Order
            List<EU_Open_Invoice_Line__c> invoiceLinesWhichRequireNewInvoices = new List<EU_Open_Invoice_Line__c>();
            for(EU_Open_Invoice_Line__c invoiceLine : invoiceLines) {
                if(invoiceLine.EU_Open_Invoice__c == null) {
                    invoiceLinesWhichRequireNewInvoices.add(invoiceLine);
                }
            }

            // create and insert new Orders for those Order Lines
            List<EU_Open_Invoice__c> generatedInvoices = (new InvoiceService()).createNewInvoicesForInvoiceLines(invoiceLinesWhichRequireNewInvoices);
            insert generatedInvoices;

            // check if the previously unmatched Lines have now been matched successfully
            cleanMatchesForGeneratedInvoices = (new InvoiceLineService()).relateInvoicesToInvoiceLines(generatedInvoices, invoiceLinesWhichRequireNewInvoices);
        }

        // log an error if there still exist some Lines without a linked Order
        if(!(cleanMatchesForExistingInvoices == true && cleanMatchesForGeneratedInvoices == null) || !(cleanMatchesForExistingInvoices == false && cleanMatchesForGeneratedInvoices == true)) {
            System.debug(LoggingLevel.ERROR, 'could not find or generate invoices for all invoice lines');
        }
    }

    public static List<EU_Open_Invoice_Line__c> filterInvoiceLinesToMap(Map<Id, EU_Open_Invoice_Line__c> newInvoiceLines, Map<Id, EU_Open_Invoice_Line__c> oldInvoiceLines) {
        // check which Invoice Lines already have Invoices set, and split into two maps indexed by Line Id
        Map<Id, EU_Open_Invoice_Line__c> linesWithOrders = new Map<Id, EU_Open_Invoice_Line__c>();
        Map<Id, EU_Open_Invoice_Line__c> linesToBeMatched = new Map<Id, EU_Open_Invoice_Line__c>();

        for(Id lineId : new List<Id>(newInvoiceLines.keySet())) {
            final EU_Open_Invoice_Line__c lineValue = newInvoiceLines.get(lineId);

            if(lineValue.EU_Open_Invoice__c != null) {
                linesWithOrders.put(lineId, lineValue);
            } else {
                linesToBeMatched.put(lineId, lineValue);
            }
        }

        // check if the Invoice Line Order numbers have been changed for any Lines with Invoices set, and if so queue for rematching
        for(Id lineId : new List<Id>(newInvoiceLines.keySet())) {
            final EU_Open_Invoice_Line__c lineValue = linesWithOrders.get(lineId);
            final EU_Open_Invoice_Line__c oldLineValue = oldInvoiceLines.get(lineId);
            if(lineValue.EU_Header_Invoice_Number__c != oldLineValue.EU_Header_Invoice_Number__c) {
                linesToBeMatched.put(lineId, lineValue);
            }
        }

        // return all Invoice Lines which require new or refreshed matching
        return linesToBeMatched.values();
    }

    public static List<EU_Open_Invoice__c> updateInvoiceRecord(Map<Id, EU_Open_Invoice_Line__c> newInvoiceLines) {
        Map<Id, EU_Open_Invoice__c> invoiceMap = new Map<Id, EU_Open_Invoice__c>();
        for (EU_Open_Invoice_Line__c invoiceLine : newInvoiceLines.values()) {
            EU_Open_Invoice__c invoice = new EU_Open_Invoice__c(Id=invoiceLine.EU_Open_Invoice__c);
            new InvoiceService().relateHeaderFieldsToInvoiceRecord(invoice, invoiceLine);
            invoiceMap.put(invoice.Id, invoice);
        }

        return invoiceMap.values();
    }
}