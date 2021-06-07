@isTest
public with sharing class icTestTriggerContentVersion  {

    public static testMethod void test_ContentVersion(){
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerContentVersion', new icHandlerContentVersionMock());
        
        ContentVersion cv=new Contentversion();
        cv.title='ABC';
        cv.PathOnClient ='test';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert cv;
    }
}