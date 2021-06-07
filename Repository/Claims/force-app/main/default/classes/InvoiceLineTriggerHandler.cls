/**
 * Created by Gerard van Kempen on 2019-12-06.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

public with sharing class InvoiceLineTriggerHandler extends TriggerHandler {

    protected override void onBeforeInsert(List<SObject> newList) {
        List<EU_Open_Invoice_Line__c> newInvoiceLines = (List<EU_Open_Invoice_Line__c>)newList;

        InvoiceLineTriggerHandlerFunctions.mapInvoiceLinesToInvoices(newInvoiceLines);
    }

    protected override void onBeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        Map<Id, EU_Open_Invoice_Line__c> newInvoiceLines = (Map<Id, EU_Open_Invoice_Line__c>)newMap;
        Map<Id, EU_Open_Invoice_Line__c> oldInvoiceLines = (Map<Id, EU_Open_Invoice_Line__c>)oldMap;

        List<EU_Open_Invoice_Line__c> invoiceLinesToBeMatched = InvoiceLineTriggerHandlerFunctions.filterInvoiceLinesToMap(newInvoiceLines, oldInvoiceLines);

        InvoiceLineTriggerHandlerFunctions.mapInvoiceLinesToInvoices(invoiceLinesToBeMatched);
    }

    protected override void onAfterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        Map<Id, EU_Open_Invoice_Line__c> newInvoiceLineMap = (Map<Id, EU_Open_Invoice_Line__c>)newMap;
        Map<Id, EU_Open_Invoice_Line__c> oldInvoiceLineMap = (Map<Id, EU_Open_Invoice_Line__c>)oldMap;

        List<EU_Open_Invoice__c> invoicesToClose = InvoiceLineTriggerHandlerFunctions.updateInvoiceRecord(newInvoiceLineMap);

        // update the queued orders if there are any
        if(invoicesToClose.size() > 0) {
            update invoicesToClose;
        }
    }

}