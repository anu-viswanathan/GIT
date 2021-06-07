@isTest
public with sharing class icTestCTRLRelatedFiles {

    public static testMethod void test_userCTRL(){
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicAttachment', new icLogicAttachmentMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicAttachmentMock', 'getAttachementsForRecord', new List<ContentVersion>());

        List<ContentVersion> result = icCTRLRelatedFiles.getAttachedFiles('recordId');
    }

}