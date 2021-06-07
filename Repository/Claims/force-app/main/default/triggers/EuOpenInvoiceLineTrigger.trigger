/**
 * Created by Gerard van Kempen on 2019-12-09.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

trigger EuOpenInvoiceLineTrigger on EU_Open_Invoice_Line__c (before insert, before update, after update) {
    (new InvoiceLineTriggerHandler()).run();
}