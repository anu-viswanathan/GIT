/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icREPOAttachmentMock implements icRepoAttachment.IClass{


    public ContentVersion getAttachementById(String attachmenId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAttachementById');
        params.put('attachmenId', attachmenId);
        return (ContentVersion) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAttachementById');
    }
     
    public List<ContentVersion> getAttachementsByIds(List<String> attachmenIds) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAttachementsByIds');
        params.put('attachmenIds', attachmenIds);
        return (List<ContentVersion>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAttachementsByIds');
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

    public List<ContentDocumentLink> getAttachementForRecord(String recordId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAttachementForRecord');
        params.put('recordId', recordId);
        return (List<ContentDocumentLink>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAttachementForRecord');    }

    public void createDocument(ContentVersion contentDoc) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createDocument');
        params.put('contentDoc', contentDoc);
    }

    public void deleteContentDocumentById(Id documentId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'deleteContentDocumentById');
        params.put('documentId', documentId);
    }

    public void deleteContentDocumentsByIds(List<Id> documentIds) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'deleteContentDocumentsByIds');
        params.put('documentIds', documentIds);
    }

    public void deleteContentDocumentByRelatedRecordId(Id recordId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'deleteContentDocumentByRelatedRecordId');
        params.put('recordId', recordId);
    }

}