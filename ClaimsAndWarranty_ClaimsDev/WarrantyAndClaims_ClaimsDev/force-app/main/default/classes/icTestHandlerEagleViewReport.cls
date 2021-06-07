/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestHandlerEagleViewReport {

    public static testMethod void EagleViewReport_Test(){

        icHandlerEagleViewReport.IClass hdl = (icHandlerEagleViewReport.IClass) icObjectFactory.GetSingletonInstance('icHandlerEagleViewReport');


        Account acc = icTestHelperUtility.generateAccount();
        acc.Lead_Administrator__c = UserInfo.getUserId();
        insert acc;

        EagleView_Report__c r = new EagleView_Report__c();
        r.Status__c = '1';
        r.Account__c = acc.Id;
        r.SubStatus__c = '11';
        insert r;

        r.SubStatus__c = '19';
        update r;

    }

}