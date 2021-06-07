/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icTestLogicEagleViewReport {

    static void initTest() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoEagleViewReport', new icRepoEagleViewReportMock());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoEagleViewReportMock', 'getEagleViewReportById', new EagleView_Report__c());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoEagleViewReportMock', 'createEagleViewReport', new Account());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoEagleViewReportMock', 'getAcountByHARefKey',new Account());

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicSubscription', new icLogicSubscriptionMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicSubscriptionMock', 'getEagleViewSubscriptionForCustomer', new List<IKOPRO_Contractor_Subscription__c>{new IKOPRO_Contractor_Subscription__c()});

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icBLeagleView', new icBLeagleViewMock());
        icTestMockUtilities.Tracer.SetReturnValue('icBLeagleViewMock', 'getDownloadLink', '');

        //icTestMockUtilities.Mocker.SetMockSingletonInstance('icMapAccount', new icMapAccountMock());
        //icTestMockUtilities.Tracer.SetReturnValue('icMapAccountMock', 'convertCustomerDTOToAccountWithRecordType', new Account());

    }

    public static testMethod void test_generateEagleViewReportFromOrderForm(){
        initTest();
        icLogicEagleViewReport.IClass BL = (icLogicEagleViewReport.IClass) icObjectFactory.GetSingletonInstance('icLogicEagleViewReport');

        icDTOEagleViewOrderForm f = new icDTOEagleViewOrderForm();
        f.streetAddress = '11';
        f.city = '11';
        f.state = '11';
        f.postalCode = '11';
        f.country = '11';
        f.propertyType = 11;
        icDTOEagleViewProduct p1 = new icDTOEagleViewProduct();
        p1.name ='test1';
        f.product = p1;
        icDTOEagleViewProduct p2 = new icDTOEagleViewProduct();
        p2.name = 'testin2';
        f.delivery = p2;
        f.measurementType = 11;
        f.specialInstructions = '11';
        f.changesInLast4Years = true;

        BL.generateEagleViewReportFromOrderForm(f);

    }

    public static testMethod void test_getEagleViewReportById(){
        initTest();
        icLogicEagleViewReport.IClass BL = (icLogicEagleViewReport.IClass) icObjectFactory.GetSingletonInstance('icLogicEagleViewReport');

        BL.getEagleViewReportById('');

    }
    public static testMethod void test_getEagleViewDownloadReportLink(){
        initTest();

        icLogicEagleViewReport.IClass BL = (icLogicEagleViewReport.IClass) icObjectFactory.GetSingletonInstance('icLogicEagleViewReport');

        EagleView_Report__c evReport = new EagleView_Report__c();
        evReport.Id = icTestHelperUtility.getFakeId(EagleView_Report__c.SObjectType);
        evReport.Account__c = icTestHelperUtility.getFakeId(Account.SObjectType);
        evReport.Report_Id__c ='';

        BL.getEagleViewDownloadReportLink(evReport);

    }
    public static testMethod void test_createEagleViewReport(){
        initTest();
        icLogicEagleViewReport.IClass BL = (icLogicEagleViewReport.IClass) icObjectFactory.GetSingletonInstance('icLogicEagleViewReport');

        BL.createEagleViewReport(new EagleView_Report__c());
    }
    public static testMethod void test_updateEagleViewReport(){
        initTest();
        icLogicEagleViewReport.IClass BL = (icLogicEagleViewReport.IClass) icObjectFactory.GetSingletonInstance('icLogicEagleViewReport');

        BL.updateEagleViewReport(new EagleView_Report__c());
    }
    public static testMethod void test_deleteEagleViewReport(){
        initTest();
        icLogicEagleViewReport.IClass BL = (icLogicEagleViewReport.IClass) icObjectFactory.GetSingletonInstance('icLogicEagleViewReport');

        BL.deleteEagleViewReport(new EagleView_Report__c());
    }


}