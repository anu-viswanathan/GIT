/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icTestREPOHomeAdvisor {

    public static testMethod void test_createLead(){

        icRepoHomeAdvisor.IClass repository = (icRepoHomeAdvisor.IClass) icObjectFactory.GetSingletonInstance('icRepoHomeAdvisor');

        Lead l = new Lead();
        l.FirstName = 'test';
        l.LastName = 'testing';
        l.Status = 'In Queue';
        l.LeadSource = 'Home Advisor';

        repository.createLead(l);

    }

}