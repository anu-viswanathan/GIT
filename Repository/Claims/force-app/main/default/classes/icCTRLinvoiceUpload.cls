/**
* Created by Francois Poirier on 2019-11-18.
*/
global with sharing class icCTRLinvoiceUpload {
    
    static icLogicContractorInvoice.IClass logicContractorInvoice = (icLogicContractorInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicContractorInvoice');
    static icLogicAttachment.IClass logicAttachments = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');
    static icLogicInvoice.IClass invoiceLogic = (icLogicInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicInvoice');
    
    @AuraEnabled
    global static List<icDtoPickList> getRebatePrograms() {
        
        List<icDtoPickList> rebatePrograms = new List<icDtoPickList>();
        rebatePrograms = logicContractorInvoice.getRebatePrograms();
        return rebatePrograms;
    }

    @AuraEnabled
    global static Map<String, Object> getComponentDetails(String invoiceId) {
        
        Map<String, Object> returnValues = new Map<String, Object>();

        List<icDtoPickList> rebatePrograms = new List<icDtoPickList>();
        rebatePrograms = logicContractorInvoice.getRebatePrograms();

        returnValues.put('rebatePrograms', rebatePrograms);

        if(String.isNotBlank(invoiceId)){
            Contractor_Invoice__c contractInvoice = logicContractorInvoice.getContractorInvoiceById(invoiceId);
            
            returnValues.put('contractorInvoice', contractInvoice);
            returnValues.put('files', logicAttachments.getUploadedFilesByContracorInvoiceId(invoiceId));
        }
        return returnValues;
    }
    
    @AuraEnabled
    global static Contractor_Invoice__c newContractorInvoice(String rebateProgram, Contractor_Invoice__c contractorInvoice) {
        
        logicContractorInvoice.createNewContractorInvoiceFromProgram(rebateProgram, contractorInvoice);
        return contractorInvoice;
    }
    
    @AuraEnabled
    global static List<icDtoUploadedFile> deleteUploadedFiles(List<String> fileIds, String invoiceId) {

        logicAttachments.deleteDocumentsByIds(fileIds);
        logicContractorInvoice.removeFileIdsFromContractInvoice(invoiceId, fileIds);
        return logicAttachments.getUploadedFilesByContracorInvoiceId(invoiceId);       
    }

    @AuraEnabled
    global static Contractor_Invoice__c deleteContractInvoice(String invoiceId) {

        logicAttachments.deleteDocumentByContracorInvoiceId(invoiceId);
        logicContractorInvoice.deleteContractorInvoiceById(invoiceId);
        return new Contractor_Invoice__c();
    }
    
    @AuraEnabled
    global static void saveInvoice(Contractor_Invoice__c invoice) {

        logicContractorInvoice.saveContractorInvoice(invoice);
    }
}