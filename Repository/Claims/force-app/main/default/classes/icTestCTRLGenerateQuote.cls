/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestCTRLGenerateQuote {

    static void inittest(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicQuote', new icLogicQuoteMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicAccount', new icLogicAccountMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicAttachment', new icLogicAttachmentMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicEmail', new icLogicEmailMock());

        icTestMockUtilities.Tracer.SetReturnValue('icLogicQuoteMock', 'getQuoteInfoById', new Quote());

        Contact c = new Contact();
        c.FirstName = 'test';
        c.LastName = 'testing';
        c.Email = 'test@gmail.com';
        c.Id = icTestHelperUtility.getFakeId(Contact.SObjectType);

        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountMock', 'getPersonAcountInfoById', c);

        icTestMockUtilities.Tracer.SetReturnValue('icLogicAttachmentMock', 'getAttachementOptionsForRecord', new List<icDTOSelectOption>{});

        ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true,
                Id = icTestHelperUtility.getFakeId(ContentVersion.SObjectType)
        );
        icTestMockUtilities.Tracer.SetReturnValue('icLogicAttachmentMock', 'getAttachementById',contentVersion);

    }

    public static testMethod void test_CTRL1(){

        inittest();

        icCTRLGenerateQuote.generateQuote(icTestHelperUtility.getFakeId(Quote.SObjectType));

    }

    public static testMethod void test_CTRL2(){
        inittest();

        icCTRLGenerateQuote.getQuoteFiles('test');
    }

    public static testMethod void test_CTRL3(){
        inittest();

        icCTRLGenerateQuote.sendQuote('test', icTestHelperUtility.getFakeId(Quote.SObjectType));
    }

}