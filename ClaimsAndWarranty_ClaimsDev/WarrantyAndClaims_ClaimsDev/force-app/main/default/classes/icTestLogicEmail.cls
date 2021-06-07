/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestLogicEmail {

    static void initTest() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoEmail', new icRepoEmailMock());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoEmailMock', 'getEmailTemplateByDevName', new EmailTemplate());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoEmailMock', 'getAcountInfoById', new Account());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoEmailMock', 'getAcountByHARefKey', new Account());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoEmailMock', 'getOrgWideEmailByName', new OrgWideEmailAddress());

        //icTestMockUtilities.Mocker.SetMockSingletonInstance('icMapAccount', new icMapAccountMock());
        //icTestMockUtilities.Tracer.SetReturnValue('icMapAccountMock', 'convertCustomerDTOToAccountWithRecordType', new Account());
    }

    public static testMethod void test_getEmailTemplateByDevName(){

        initTest();
        icLogicEmail.IClass BL = (icLogicEmail.IClass) icObjectFactory.GetSingletonInstance('icLogicEmail');

        BL.getEmailTemplateByDevName('');
    }

    public static testMethod void test_getOrgWideEmailByName(){

        initTest();
        icLogicEmail.IClass BL = (icLogicEmail.IClass) icObjectFactory.GetSingletonInstance('icLogicEmail');

        BL.getOrgWideEmailByName('');
    }

    public static testMethod void test_sendPlainTextEmail(){

        initTest();
        icLogicEmail.IClass BL = (icLogicEmail.IClass) icObjectFactory.GetSingletonInstance('icLogicEmail');

        BL.sendPlainTextEmail('','', new List<String>{'test@test.com'}, new List<String>{''}, new List<String>{''}, new List<String>{''}, new List<Messaging.EmailFileAttachment>{new Messaging.EmailFileAttachment()});
    }

    public static testMethod void test_sendTemplateEmail(){

        initTest();
        icLogicEmail.IClass BL = (icLogicEmail.IClass) icObjectFactory.GetSingletonInstance('icLogicEmail');

        EmailTemplate myTemplate =new EmailTemplate(developerName = 'test', TemplateType= 'Text', Name = 'test');
        myTemplate.Body = 'Test';

        BL.sendTemplateEmail( myTemplate,icTestHelperUtility.getFakeId(User.SObjectType), icTestHelperUtility.getFakeId(Account.SObjectType), new List<String>{''}, new List<Messaging.EmailFileAttachment>{new Messaging.EmailFileAttachment()});
    }
    public static testMethod void test_RenderEmailTemplate(){

        initTest();
        icLogicEmail.IClass BL = (icLogicEmail.IClass) icObjectFactory.GetSingletonInstance('icLogicEmail');

        EmailTemplate myTemplate =new EmailTemplate(developerName = 'test', TemplateType= 'Text', Name = 'test');
        myTemplate.Body = 'Test';
        BL.RenderEmailTemplate( myTemplate,icTestHelperUtility.getFakeId(User.SObjectType), icTestHelperUtility.getFakeId(Account.SObjectType), new List<String>{''}, new List<Messaging.EmailFileAttachment>{new Messaging.EmailFileAttachment()});
    }
}