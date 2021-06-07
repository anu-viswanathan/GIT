/**
 * Created by Francois Poirier on 2018-10-10.
 */

@isTest
public with sharing class icTestHandlerContentDocument {

    @isTest
    public static void testOnBeforeDelete(){


        ContentDocument testDoc = new ContentDocument();
        ContentVersion testVersion = new ContentVersion();

        testVersion.Title = 'TestOnBeforeDeleteDoc';
        testVersion.PathOnClient = 'testBeforeDelete.jpg';
        testVersion.VersionData = Blob.valueOf('test content Data');
        testVersion.IsMajorVersion = true;

        insert testVersion;

        ContentVersion testVersion2 = new ContentVersion();

        testVersion2 = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE id = :testVersion.Id];

        testDoc.Id = testVersion2.ContentDocumentId;

        Contractor_Invoice__c newUploadedInvoice = new Contractor_Invoice__c(Uploaded_Files_Long__c = 'test');
        insert newUploadedInvoice;
        ContentDocumentLink docLink = new ContentDocumentLink(ContentDocumentId=testVersion2.ContentDocumentId,LINKEDENTITYID = newUploadedInvoice.Id,SHARETYPE='V');
        insert docLink;

        delete testDoc;
        
    }
}