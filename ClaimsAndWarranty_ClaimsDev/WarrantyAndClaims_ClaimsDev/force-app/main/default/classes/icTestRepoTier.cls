@isTest
public with sharing class icTestRepoTier {

    public static testMethod void test_getAllTiers(){
    	icRepoTier.IClass repository = (icRepoTier.IClass) icObjectFactory.GetSingletonInstance('icRepoTier');

        List<Tier__c> testResult = repository.getAllTiers();
    }
}