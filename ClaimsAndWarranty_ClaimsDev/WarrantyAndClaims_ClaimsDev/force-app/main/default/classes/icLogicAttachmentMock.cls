/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icLogicAttachmentMock implements icLogicAttachment.IClass{


    public ContentVersion getAttachementById(String attachmenId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAttachementById');
        params.put('attachmenId', attachmenId);
        return (ContentVersion) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAttachementById');
    }

    public List<ContentVersion> getAttachementsForRecord(String recordId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAttachementsForRecord');
        params.put('recordId', recordId);
        return (List<ContentVersion>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAttachementsForRecord');
    }

    public List<ContentDocumentLink> getContentDocumentByIds(List<String> recordIds){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getContentDocumentByIds');
        params.put('recordIds', recordIds);
        return (List<ContentDocumentLink>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getContentDocumentByIds');
    }

    public List<ContentDocumentLink> getContentDocumentByRelatedRecordIds(List<String> recordIds){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getContentDocumentByRelatedRecordIds');
        params.put('recordIds', recordIds);
        return (List<ContentDocumentLink>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getContentDocumentByRelatedRecordIds');
    }
    
    public List<icDTOSelectOption> getAttachementOptionsForRecord(String recordId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAttachementOptionsForRecord');
        params.put('recordId', recordId);
        return (List<icDTOSelectOption>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAttachementOptionsForRecord');
    }

    public Map<String, List<ContentDocumentLink>> getMapListDocumentsByInvoiceId(List<ContentDocumentLink> relatedDocuments) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getMapListDocumentsByInvoiceId');
        params.put('relatedDocuments', relatedDocuments);
        return (Map<String, List<ContentDocumentLink>>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getMapListDocumentsByInvoiceId');
    }

    public void createDocumentInObject(String objectId, String title, String path, Blob contentData) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createDocumentInObject');
        params.put('objectId', objectId);
        params.put('title', title);
        params.put('path', path);
        params.put('contentData', contentData);
    }

    public void deleteDocumentsByIds(List<Id> documentIds) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'deleteDocumentByIds');
        params.put('documentIds', documentIds);
    }
    
    public void deleteDocumentById(Id documentId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'deleteDocumentById');
        params.put('documentId', documentId);
    }
    
    public void deleteDocumentByContracorInvoiceId(Id invoiceId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'deleteDocumentByContracorInvoiceId');
        params.put('invoiceId', invoiceId);
    }

    public List<icDtoUploadedFile> getUploadedFilesByContracorInvoiceId(Id contractorInvoiceId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getUploadedFilesByContracorInvoiceId');
        params.put('contractorInvoiceId', contractorInvoiceId);
        return (List<icDtoUploadedFile>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getUploadedFilesByContracorInvoiceId');
    }
}