/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestLogicGreenSky {

    static void initTest() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoGreenSky', new icRepoGreenSkyMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicUser', new icLogicUserMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicSubscription', new icLogicSubscriptionMock());

        icTestMockUtilities.Tracer.SetReturnValue('icLogicUserMock', 'getAccountIdFromPartnerUser', icTestHelperUtility.getFakeId(Account.SObjectType));
        icTestMockUtilities.Tracer.SetReturnValue('icLogicSubscriptionMock', 'getGreenSkySubscriptionForCustomer',
                new IKOPRO_Contractor_Subscription__c(Username__c='test', Client_Secret__c='abc123'));

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicOpportunity', new icLogicOpportunityMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicOpportunityMock', 'getOpportunityDataForGreenSky', new Opportunity());



        //icTestMockUtilities.Mocker.SetMockSingletonInstance('icMapAccount', new icMapAccountMock());
        //icTestMockUtilities.Tracer.SetReturnValue('icMapAccountMock', 'convertCustomerDTOToAccountWithRecordType', new Account());

    }

    public static testMethod void test_merchantValidation(){
        initTest();

        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());
        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');

        BL.merchantValidation();
    }

    public static testMethod void test_asynchronousSubmit(){
        initTest();
        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());

        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');
        BL.asynchronousSubmit('0x328b07830077b259f9cf570ce1dbb8ea9cf45e22','{"channel":"External-API-IKO","product":"Installment","program":"GreenSky Consumer Projects","referral":"81006534-9999","requestedLoanAmount":5000,"role":"Merchant","coApplicantIndicator":false,"contractLanguage":"English","youAre":"Applicant / Co-Applicant","applicantFirstName":"Gloria","applicantLastName":"Brawner","applicantStreetNumber":"604","applicantStreetAddress":"604 Sears ave","applicantStreetName":"Sears ave","applicantCity":"Sunny Isles Beach","applicantState":"FL","applicantZipCode":"338811746","applicantZipCode4":"1746","applicantPhoneNumber":"123-123-1234","applicantEmailAddress":"a@b.com","applicantSSN":"666140961","applicantDateOfBirth":"1963-09-03","applicantGrossIncome":"100000","applicantAgree1":true,"applicantAgree2":true}');

    }

    public static testMethod void test_asynchronousSubmitERR(){
        initTest();
        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceErrMock());

        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');
        BL.asynchronousSubmit('0x328b07830077b259f9cf570ce1dbb8ea9cf45e22','{"channel":"External-API-IKO","product":"Installment","program":"GreenSky Consumer Projects","referral":"81006534-9999","requestedLoanAmount":5000,"role":"Merchant","coApplicantIndicator":false,"contractLanguage":"English","youAre":"Applicant / Co-Applicant","applicantFirstName":"Gloria","applicantLastName":"Brawner","applicantStreetNumber":"604","applicantStreetAddress":"604 Sears ave","applicantStreetName":"Sears ave","applicantCity":"Sunny Isles Beach","applicantState":"FL","applicantZipCode":"338811746","applicantZipCode4":"1746","applicantPhoneNumber":"123-123-1234","applicantEmailAddress":"a@b.com","applicantSSN":"666140961","applicantDateOfBirth":"1963-09-03","applicantGrossIncome":"100000","applicantAgree1":true,"applicantAgree2":true}');

    }

    public static testMethod void test_state(){
        initTest();

        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());

        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');
        icDTOGreenSkyApplication a = new icDTOGreenSkyApplication();
        a.token = '0x328b07830077b259f9cf570ce1dbb8ea9cf45e22';
        BL.state(a);
    }

    public static testMethod void test_stateERR(){
        initTest();

        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceErrMock());

        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');
        icDTOGreenSkyApplication a = new icDTOGreenSkyApplication();
        a.token = '0x328b07830077b259f9cf570ce1dbb8ea9cf45e22';
        BL.state(a);
    }

    public static testMethod void test_Decision(){
        initTest();
        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());

        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');
        icDTOGreenSkyApplication a = new icDTOGreenSkyApplication();
        a.token = '0x328b07830077b259f9cf570ce1dbb8ea9cf45e22';
        BL.decision(a);

    }

    public static testMethod void test_DecisionERR(){
        initTest();
        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceErrMock());

        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');
        icDTOGreenSkyApplication a = new icDTOGreenSkyApplication();
        a.token = '0x328b07830077b259f9cf570ce1dbb8ea9cf45e22';
        BL.decision(a);

    }

    public static testMethod void test_offer(){
        initTest();
        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());

        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');
        icDTOGreenSkyApplication a = new icDTOGreenSkyApplication();
        a.token = '0x328b07830077b259f9cf570ce1dbb8ea9cf45e22';
        BL.offer(a);

    }

    public static testMethod void test_offerERR(){
        initTest();
        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceErrMock());

        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');
        icDTOGreenSkyApplication a = new icDTOGreenSkyApplication();
        a.token = '0x328b07830077b259f9cf570ce1dbb8ea9cf45e22';
        BL.offer(a);

    }
    public static testMethod void test_create(){
        initTest();
        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());

        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');
        icDTOGreenSkyOffer o = new icDTOGreenSkyOffer();
        o.offers = new List<icDTOGreenSkyLoanOffer>{new icDTOGreenSkyLoanOffer()};

        icDTOGreenSkyApplication a = new icDTOGreenSkyApplication();
        a.token = '0x328b07830077b259f9cf570ce1dbb8ea9cf45e22';
        BL.create(o,a);

    }
    public static testMethod void test_createErr(){
        initTest();
        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceErrMock());

        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');
        icDTOGreenSkyOffer o = new icDTOGreenSkyOffer();
        o.offers = new List<icDTOGreenSkyLoanOffer>{new icDTOGreenSkyLoanOffer()};

        icDTOGreenSkyApplication a = new icDTOGreenSkyApplication();
        a.token = '0x328b07830077b259f9cf570ce1dbb8ea9cf45e22';
        BL.create(o,a);

    }

    public static testMethod void test_loanAgreement(){
        initTest();

        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());

        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');
        icDTOGreenSkyOffer o = new icDTOGreenSkyOffer();
        o.offers = new List<icDTOGreenSkyLoanOffer>{new icDTOGreenSkyLoanOffer()};

        icDTOGreenSkyApplication a = new icDTOGreenSkyApplication();
        a.token = '0x328b07830077b259f9cf570ce1dbb8ea9cf45e22';
        BL.loanAgreement(a);
    }

    public static testMethod void test_loanAgreementErr(){
        initTest();

        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceErrMock());

        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');
        icDTOGreenSkyOffer o = new icDTOGreenSkyOffer();
        o.offers = new List<icDTOGreenSkyLoanOffer>{new icDTOGreenSkyLoanOffer()};

        icDTOGreenSkyApplication a = new icDTOGreenSkyApplication();
        a.token = '0x328b07830077b259f9cf570ce1dbb8ea9cf45e22';
        BL.loanAgreement(a);
    }

    public static testMethod void test_email(){
        initTest();

        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());

        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');

        icDTOGreenSkyLoanAgreement ag = new icDTOGreenSkyLoanAgreement();
        ag.applicantEmail = 'test@test.com';

        icDTOGreenSkyApplication a = new icDTOGreenSkyApplication();
        a.token = '0x328b07830077b259f9cf570ce1dbb8ea9cf45e22';
        BL.email(ag, a);

    }

    public static testMethod void test_emailErr(){
        initTest();

        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceErrMock());

        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');

        icDTOGreenSkyLoanAgreement ag = new icDTOGreenSkyLoanAgreement();
        ag.applicantEmail = 'test@test.com';

        icDTOGreenSkyApplication a = new icDTOGreenSkyApplication();
        a.token = '0x328b07830077b259f9cf570ce1dbb8ea9cf45e22';
        BL.email(ag, a);

    }

    public static testMethod void test_getListsFromGreenSkyAPI(){
        initTest();

        Test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());

        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');

        icDTOGreenSkyLoanAgreement ag = new icDTOGreenSkyLoanAgreement();
        ag.applicantEmail = 'test@test.com';

        icDTOGreenSkyApplication a = new icDTOGreenSkyApplication();
        a.token = '0x328b07830077b259f9cf570ce1dbb8ea9cf45e22';
        BL.getListsFromGreenSkyAPI();

    }
    public static testMethod void test_getGreenSkyLoanForm(){
        initTest();
        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');
        icDTOGreenSkyMerchantValidation v = new icDTOGreenSkyMerchantValidation();
        v.creditProduct = 'testing';
        BL.getGreenSkyLoanForm(v,icTestHelperUtility.getFakeId(Opportunity.SObjectType));
    }
    public static testMethod void test_isCustomerSubscribed(){
        initTest();
        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');
        BL.isCustomerSubscribed();

    }
    public static testMethod void test_saveSubscription(){
        initTest();
        icLogicGreenSky.IClass BL = (icLogicGreenSky.IClass) icObjectFactory.GetSingletonInstance('icLogicGreenSky');
        BL.saveSubscription('{"test":"test"}');

    }
}