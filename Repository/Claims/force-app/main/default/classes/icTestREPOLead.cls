/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icTestREPOLead {

    public static testMethod void test_getNewLeadsByAccountId(){

        Account cust = icTestHelperUtility.generateAccount();
        insert cust;

        Lead l = new Lead();
        l.FirstName = 'test';
        l.LastName = 'testing';
        l.Status = 'In Queue';
        l.LeadSource = 'Home Advisor';
        l.Referred_Customer__c = cust.Id;
        l.OwnerId = UserInfo.getUserId();

        insert l;

        icRepoLead.IClass repository = (icRepoLead.IClass) icObjectFactory.GetSingletonInstance('icRepoLead');

        repository.getNewLeadsByAccountId(cust.Id, UserInfo.getUserId());

    }

}