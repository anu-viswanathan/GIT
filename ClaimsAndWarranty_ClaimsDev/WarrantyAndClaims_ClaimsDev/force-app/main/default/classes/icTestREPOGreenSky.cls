/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icTestREPOGreenSky {

    public static testMethod void test_createApplication(){

        icRepoGreenSky.IClass repository = (icRepoGreenSky.IClass) icObjectFactory.GetSingletonInstance('icRepoGreenSky');

        icDTOGreenSkyApplication a = new icDTOGreenSkyApplication();

        Id accountRecTypeID = [SELECT id from RecordType where Name ='IKOPRO Homeowner'].Id;
        Id OpportunityRecTypeID = [SELECT id from RecordType where Name ='IKO ROOFPRO Opportunity'].Id;
    

        Account acc = new Account();
        acc.RecordTypeId = accountRecTypeID;
        acc.LastName = 'testing';
        acc.FirstName = 'testing2';
        insert acc;

        Opportunity o = new Opportunity();
        o.RecordTypeId = OpportunityRecTypeID;
        o.Name = 'tsing';
        o.AccountId = acc.Id;
        o.CloseDate = Date.today().addDays(+10);
        o.StageName = 'Qualified';
        insert o;

        a.applicationId = icTestHelperUtility.getFakeId(GreenSky_Application__c.SObjectType);
        a.accountId = (acc.Id);
        a.opportunityId = o.Id;
        a.requestedAmount = '10';
        repository.createApplication(a);

    }
    public static testMethod void test_updateApplicationStatus(){
        icRepoGreenSky.IClass repository = (icRepoGreenSky.IClass) icObjectFactory.GetSingletonInstance('icRepoGreenSky');

        Id accountRecTypeID = [SELECT id from RecordType where Name ='IKOPRO Homeowner'].Id;
        Id OpportunityRecTypeID = [SELECT id from RecordType where Name ='IKO ROOFPRO Opportunity'].Id;
        
        Account acc = new Account();
        acc.RecordTypeId = accountRecTypeID;
        acc.LastName = 'testing';
        acc.FirstName = 'testing2';
        insert acc;

        Opportunity o = new Opportunity();
        o.RecordTypeId = OpportunityRecTypeID;
        o.Name = 'tsing';
        o.AccountId = acc.Id;
        o.CloseDate = Date.today().addDays(+10);
        o.StageName = 'Qualified';
        insert o;

        GreenSky_Application__c gsApplication = new GreenSky_Application__c();
        gsApplication.Account__c = acc.Id;
        gsApplication.Opportunity__c = o.Id;
        gsApplication.Application_Date__c = Date.today();
        gsApplication.Requested_Amount__c = 10;

        insert gsApplication;

        repository.updateApplicationStatus(gsApplication.Id, 'Offer');


    }
    public static testMethod void test_updateApplicationFromDecision(){

        icRepoGreenSky.IClass repository = (icRepoGreenSky.IClass) icObjectFactory.GetSingletonInstance('icRepoGreenSky');

        Id accountRecTypeID = [SELECT id from RecordType where Name ='IKOPRO Homeowner'].Id;
        Id OpportunityRecTypeID = [SELECT id from RecordType where Name ='IKO ROOFPRO Opportunity'].Id;
     
        Account acc = new Account();
        acc.RecordTypeId = accountRecTypeID;
        acc.LastName = 'testing';
        acc.FirstName = 'testing2';
        insert acc;

        Opportunity o = new Opportunity();
        o.RecordTypeId = OpportunityRecTypeID;
        o.Name = 'tsing';
        o.AccountId = acc.Id;
        o.CloseDate = Date.today().addDays(+10);
        o.StageName = 'Qualified';
        insert o;

        GreenSky_Application__c gsApplication = new GreenSky_Application__c();
        gsApplication.Account__c = acc.Id;
        gsApplication.Opportunity__c = o.Id;
        gsApplication.Application_Date__c = Date.today();
        gsApplication.Requested_Amount__c = 10;

        insert gsApplication;

        icDTOGreenSkyDecision dec = new icDTOGreenSkyDecision();
        dec.status ='Offer';
        dec.applicantFullName ='testing';
        dec.requestedLoanAmount='11';

        repository.updateApplicationFromDecision(gsApplication.Id, dec);

    }
    public static testMethod void test_updateApplicationFromOffer(){

        icRepoGreenSky.IClass repository = (icRepoGreenSky.IClass) icObjectFactory.GetSingletonInstance('icRepoGreenSky');

        Id accountRecTypeID = [SELECT id from RecordType where Name ='IKOPRO Homeowner'].Id;
        Id OpportunityRecTypeID = [SELECT id from RecordType where Name ='IKO ROOFPRO Opportunity'].Id;
    
        Account acc = new Account();
        acc.RecordTypeId = accountRecTypeID;
        acc.LastName = 'testing';
        acc.FirstName = 'testing2';
        insert acc;

        Opportunity o = new Opportunity();
        o.RecordTypeId = OpportunityRecTypeID;
        o.Name = 'tsing';
        o.AccountId = acc.Id;
        o.CloseDate = Date.today().addDays(+10);
        o.StageName = 'Qualified';
        insert o;

        GreenSky_Application__c gsApplication = new GreenSky_Application__c();
        gsApplication.Account__c = acc.Id;
        gsApplication.Opportunity__c = o.Id;
        gsApplication.Application_Date__c = Date.today();
        gsApplication.Requested_Amount__c = 10;

        insert gsApplication;

        icDTOGreenSkyOffer dec = new icDTOGreenSkyOffer();
        dec.applicantFullName = 'testing';
        dec.applicationStatus = 'Offer';
        icDTOGreenSkyLoanOffer off = new icDTOGreenSkyLoanOffer();
        off.loanAmount = 11;
        dec.offers = new List<icDTOGreenSkyLoanOffer>{off};

        repository.updateApplicationFromOffer(gsApplication.Id, dec);

    }
}