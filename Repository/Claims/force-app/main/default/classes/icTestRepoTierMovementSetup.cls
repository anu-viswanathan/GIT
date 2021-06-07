@isTest
public with sharing class icTestRepoTierMovementSetup {

    public static testMethod void test_getTierMovementSetup(){
    	icRepoTierMovementSetup.IClass repository = (icRepoTierMovementSetup.IClass) icObjectFactory.GetSingletonInstance('icRepoTierMovementSetup');

    	Tier_Movement_Setup__c newSetupRecord = new Tier_Movement_Setup__c();
    	insert newSetupRecord;

    	Tier_Movement_Setup__c testResult = repository.getTierMovementSetup();
	}
}