/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icTestREPOQuote {

    public static testMethod void test_getQuoteInfoById(){

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

        Quote q = new Quote();
        q.Name = 'testng';
        q.OpportunityId = o.Id;

        insert q;

        icRepoQuote.IClass repository = (icRepoQuote.IClass) icObjectFactory.GetSingletonInstance('icRepoQuote');

        repository.getQuoteInfoById(q.Id);
        repository.getQuoteInfoById(icTestHelperUtility.getFakeId(Quote.SObjectType));

    }

}