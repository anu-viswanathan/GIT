/**
 * Created by Francois Poirier on 2018-12-17.
 */

@isTest
public with sharing class icTestRepoAccountPayment {

    static icRepoAccountPayment.IClass accountPaymentRepo = (icRepoAccountPayment.IClass) icObjectFactory.GetSingletonInstance('icRepoAccountPayment');
    static Account testContractor {get; set;}
    static IKOPRO_Account_Payment__c testAccountPayment = new IKOPRO_Account_Payment__c();
    static String testId = '';

    @testSetup static void setup(){

        testContractor = icTestHelperUtility.generateContractorAccount();
        insert testContractor;

        IKOPRO_Payment__c testPayment = new IKOPRO_Payment__c();
        testPayment.Amount__c = 321;        
        insert testPayment;

        testAccountPayment.Payment__c = testPayment.Id;
        testAccountPayment.Due_Amount__c = 321;
        testAccountPayment.Contractor__c = testContractor.Id;
        testAccountPayment.Year__c = '2019';
        testAccountPayment.Paid_Date__c = Date.today();
        insert testAccountPayment;

    }


    @isTest
    static void testRepoAccountPayment(){
        testAccountPayment = [SELECT Id FROM IKOPRO_Account_Payment__c WHERE Due_Amount__c = 321 LIMIT 1];

        IKOPRO_Account_Payment__c accountPaymentFromRepo = new IKOPRO_Account_Payment__c();
        accountPaymentFromRepo = accountPaymentRepo.getAccountPaymentById(testAccountPayment.Id);
        system.assertEquals(testAccountPayment.Id, accountPaymentFromRepo.Id);

        testAccountPayment.Due_Amount__c = 456;
        accountPaymentFromRepo = accountPaymentRepo.updateAccountPayment(testAccountPayment);
        system.assertEquals(testAccountPayment.Due_Amount__c, accountPaymentFromRepo.Due_Amount__c);

    }

    @isTest
    static void test_getPaidAccountPaymentByYearAndContractorIds(){
        List<String> mockContractorIds = new List<String>();
        //mockContractorIds.add(testContractor.Id);

        List<IKOPRO_Account_Payment__c> listResult = accountPaymentRepo.getPaidAccountPaymentByYearAndContractorIds('2019', mockContractorIds);

    }
}