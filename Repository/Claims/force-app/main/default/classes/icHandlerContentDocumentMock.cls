@isTest
public with sharing class icHandlerContentDocumentMock implements icHandlerContentDocument.IClass{

    public void onAfterInsert(List<ContentDocumentLink> oldContentDocumentLink, List<ContentDocumentLink> newContentDocumentLink, Map<Id, ContentDocumentLink> contentDocumentLinkMap) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onAfterInsert');
        params.put('oldContentDocumentLink', oldContentDocumentLink);
        params.put('newContentDocumentLink', newContentDocumentLink);
        params.put('contentDocumentLinkMap', contentDocumentLinkMap);
        //return (void) icTestMockUtilities.Tracer.GetReturnValue(this, 'onAfterInsert');
    }
    
    public void onBeforeDelete(List<ContentDocument> oldContentDocument, Map<Id, ContentDocument> contentDocumentMap) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onBeforeDelete');
        params.put('oldContentDocument', oldContentDocument);
        params.put('contentDocumentMap', contentDocumentMap);
        //return (void) icTestMockUtilities.Tracer.GetReturnValue(this, 'onBeforeDelete');
    }
    public void onBeforeInsert(List<ContentDocument> contentDocuments) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onBeforeInsert');
        params.put('contentDocuments', contentDocuments);
    }
}