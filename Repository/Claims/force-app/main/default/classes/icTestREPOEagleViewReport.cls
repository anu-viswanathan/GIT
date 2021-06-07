/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icTestREPOEagleViewReport {

    public static testMethod void test_getEagleViewReportById(){
        icRepoEagleViewReport.IClass repository = (icRepoEagleViewReport.IClass) icObjectFactory.GetSingletonInstance('icRepoEagleViewReport');

        Account acc = icTestHelperUtility.generateAccount();
        acc.Lead_Administrator__c = UserInfo.getUserId();
        insert acc;

        EagleView_Report__c r = new EagleView_Report__c();
        r.Status__c = '1';
        r.Account__c = acc.Id;
        insert r;

        repository.getEagleViewReportById(r.Id);

    }

    public static testMethod void test_createEagleViewReport(){
        icRepoEagleViewReport.IClass repository = (icRepoEagleViewReport.IClass) icObjectFactory.GetSingletonInstance('icRepoEagleViewReport');

        Account acc = icTestHelperUtility.generateAccount();
        acc.Lead_Administrator__c = UserInfo.getUserId();
        insert acc;

        EagleView_Report__c r = new EagleView_Report__c();
        r.Status__c = '1';
        r.Account__c = acc.Id;

        repository.createEagleViewReport(r);

    }

    public static testMethod void test_updateEagleViewReport(){
        icRepoEagleViewReport.IClass repository = (icRepoEagleViewReport.IClass) icObjectFactory.GetSingletonInstance('icRepoEagleViewReport');

        Account acc = icTestHelperUtility.generateAccount();
        acc.Lead_Administrator__c = UserInfo.getUserId();
        insert acc;

        EagleView_Report__c r = new EagleView_Report__c();
        r.Status__c = '1';
        r.Account__c = acc.Id;
        insert r;

        repository.updateEagleViewReport(r);

    }

    public static testMethod void test_deleteEagleViewReport(){
        icRepoEagleViewReport.IClass repository = (icRepoEagleViewReport.IClass) icObjectFactory.GetSingletonInstance('icRepoEagleViewReport');

        Account acc = icTestHelperUtility.generateAccount();
        acc.Lead_Administrator__c = UserInfo.getUserId();
        insert acc;

        EagleView_Report__c r = new EagleView_Report__c();
        r.Status__c = '1';
        r.Account__c = acc.Id;
        insert r;

        repository.deleteEagleViewReport(r);
    }

}