/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icTestLogicAttachment {

    static void initTest() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoAttachment', new icREPOAttachmentMock());
        icTestMockUtilities.Tracer.SetReturnValue('icREPOAttachmentMock', 'getAttachementById', new ContentVersion());
        icTestMockUtilities.Tracer.SetReturnValue('icREPOAttachmentMock', 'getAttachementsByIds', new List<ContentVersion> {new ContentVersion()});
        icTestMockUtilities.Tracer.SetReturnValue('icREPOAttachmentMock', 'getContentDocumentByIds', new List<ContentDocumentLink> {new ContentDocumentLink()});
        icTestMockUtilities.Tracer.SetReturnValue('icREPOAttachmentMock', 'getContentDocumentByRelatedRecordIds', new List<ContentDocumentLink> {new ContentDocumentLink()});
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = icTestHelperUtility.getFakeId(Account.SObjectType);
        cdl.ContentDocumentId = icTestHelperUtility.getFakeId(ContentDocument.SObjectType);
        cdl.shareType = 'V';
        icTestMockUtilities.Tracer.SetReturnValue('icREPOAttachmentMock', 'getAttachementForRecord', new List<ContentDocumentLink>{cdl});
        icTestMockUtilities.Tracer.SetReturnValue('icREPOAttachmentMock', 'createDocument',new Account());

        //icTestMockUtilities.Mocker.SetMockSingletonInstance('icMapAccount', new icMapAccountMock());
        //icTestMockUtilities.Tracer.SetReturnValue('icMapAccountMock', 'convertCustomerDTOToAccountWithRecordType', new Account());

    }

    public static testMethod void test_getAttachementById(){

        initTest();

        icLogicAttachment.IClass logic = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');

        logic.getAttachementById('');
    }

    public static testMethod void test_deleteDocumentById(){

        initTest();

        icLogicAttachment.IClass logic = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');

        logic.deleteDocumentById(null);
    }

    public static testMethod void test_deleteDocumentsByIds(){

        initTest();

        icLogicAttachment.IClass logic = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');
        List<Id> documentIds = new List<Id>();
        logic.deleteDocumentsByIds(documentIds);

    }

    public static testMethod void test_deleteDocumentByContracorInvoiceId(){

        initTest();

        icLogicAttachment.IClass logic = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');
        logic.deleteDocumentByContracorInvoiceId(null);

    }

    public static testMethod void test_getUploadedFilesByContracorInvoiceId(){

        initTest();

        icLogicAttachment.IClass logic = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');
        logic.getUploadedFilesByContracorInvoiceId(null);

    }

    public static testMethod void test_getAttachementsForRecord(){

        initTest();

        icLogicAttachment.IClass logic = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');

        logic.getAttachementsForRecord(null);
    }

    public static testMethod void test_getContentDocumentByIds(){

        initTest();

        icLogicAttachment.IClass logic = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');

        logic.getContentDocumentByIds(new List<String> {''});
    }

    public static testMethod void test_getContentDocumentByRelatedRecordIds(){

        initTest();

        icLogicAttachment.IClass logic = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');

        logic.getContentDocumentByRelatedRecordIds(new List<String> {''});
    }

    public static testMethod void test_getAttachementOptionsForRecord(){

        initTest();

        icLogicAttachment.IClass logic = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');

        logic.getAttachementOptionsForRecord('');

    }

    public static testMethod void test_createDocumentInObject(){

        initTest();

        icLogicAttachment.IClass logic = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');

        logic.createDocumentInObject(icTestHelperUtility.getFakeId(Account.SObjectType),'','',null);

    }

    public static testMethod void test_getMapListDocumentsByInvoiceId(){
        List<ContentDocumentLink> relatedDocuments = new List<ContentDocumentLink>();
        relatedDocuments.add(new ContentDocumentLink(LinkedEntityId = icTestHelperUtility.getFakeId(Account.SObjectType)));

        icLogicAttachment.IClass logic = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');

        Map<String, List<ContentDocumentLink>> mapResult = logic.getMapListDocumentsByInvoiceId(relatedDocuments);
    }

    /*
    ContentVersion getAttachementById(String attachmenId);
        List<ContentVersion> getAttachementsForRecord(String recordId);
        List<ContentDocumentLink> getContentDocumentByIds(List<String> recordIds);
        List<icDTOSelectOption> getAttachementOptionsForRecord(String recordId);
        void createDocumentInObject(String objectId, String title, String path, blob contentData);
    */

}