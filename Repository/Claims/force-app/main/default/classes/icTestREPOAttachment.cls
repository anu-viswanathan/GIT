/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icTestREPOAttachment {

    public static testMethod void test_getAttachementById(){
        icRepoAttachment.IClass repository = (icRepoAttachment.IClass) icObjectFactory.GetSingletonInstance('icRepoAttachment');

        Account acct= icTestHelperUtility.generateAccount();
        insert acct;

        ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
        );
        insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acct.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        repository.getAttachementById(documents[0].Id);

    }

    public static testMethod void test_getAttachementByIds(){
        icRepoAttachment.IClass repository = (icRepoAttachment.IClass) icObjectFactory.GetSingletonInstance('icRepoAttachment');

        Account acct= icTestHelperUtility.generateAccount();
        insert acct;

        ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
        );
        insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acct.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        repository.getAttachementsByIds(new List<String> {documents[0].Id});

    }

    public static testMethod void test_getAttachementForRecord(){
        icRepoAttachment.IClass repository = (icRepoAttachment.IClass) icObjectFactory.GetSingletonInstance('icRepoAttachment');

        Account acct= icTestHelperUtility.generateAccount();
        insert acct;

        ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
        );
        insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acct.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;


        repository.getAttachementForRecord(acct.Id);
    }

    public static testMethod void test_createDocument(){

        icRepoAttachment.IClass repository = (icRepoAttachment.IClass) icObjectFactory.GetSingletonInstance('icRepoAttachment');

        ContentVersion v = new ContentVersion();
        v.Title = 'tst';
        v.ContentUrl = 'test';

        repository.createDocument(v);
    }

    public static testMethod void test_getContentDocumentByIds(){
        icRepoAttachment.IClass repository = (icRepoAttachment.IClass) icObjectFactory.GetSingletonInstance('icRepoAttachment');

        Account acct= icTestHelperUtility.generateAccount();
        insert acct;

        ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
        );
        insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acct.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        repository.getContentDocumentByIds(new List<String> {documents[0].Id});
    }

    public static testMethod void test_getContentDocumentByRelatedRecordIds(){
        icRepoAttachment.IClass repository = (icRepoAttachment.IClass) icObjectFactory.GetSingletonInstance('icRepoAttachment');

        Account acct= icTestHelperUtility.generateAccount();
        insert acct;

        ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
        );
        insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acct.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        repository.getContentDocumentByRelatedRecordIds(new List<String> {acct.id});
    }
}