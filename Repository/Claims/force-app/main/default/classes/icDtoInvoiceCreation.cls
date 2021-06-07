/**
 * Created by incloud on 2020-03-05.
 */

global with sharing class icDtoInvoiceCreation {

    @AuraEnabled global String invoiceNumber{get;set;}
    @AuraEnabled global Date invoiceDate{get;set;}
    @AuraEnabled global List <Blob> files{get;set;}
    @AuraEnabled global String rebateProgram{get;set;}
    @AuraEnabled global String contractorInvoice{get;set;}
    @AuraEnabled global Boolean InvoiceCreated{get;set;}
    @AuraEnabled global Boolean FilesCreated{get;set;}
}