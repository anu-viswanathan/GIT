/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icTestREPOEmail {

    public static testMethod void test_getEmailTemplateByDevName(){

        icRepoEmail.IClass repository = (icRepoEmail.IClass) icObjectFactory.GetSingletonInstance('icRepoEmail');

        EmailTemplate t = new EmailTemplate();
        t.DeveloperName = 'testing';
        t.Name = 'testname';
        t.FolderId = UserInfo.getUserId();
        t.TemplateType = 'Text';
        insert t;

        repository.getEmailTemplateByDevName('testing');

    }

    public static testMethod void test_getOrgWideEmailByName(){

        icRepoEmail.IClass repository = (icRepoEmail.IClass) icObjectFactory.GetSingletonInstance('icRepoEmail');
        repository.getOrgWideEmailByName('IKO ROOFPRO');
    }

}