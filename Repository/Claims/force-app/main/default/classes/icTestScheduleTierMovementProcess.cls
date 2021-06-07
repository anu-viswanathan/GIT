@isTest
public with sharing class icTestScheduleTierMovementProcess {

    public static void initTest() {
		icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicTierMovementSetup', new icLogicTierMovementSetupMock());
		icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicTier', new icLogicTierMock());

		icTestMockUtilities.Tracer.SetReturnValue('icLogicTierMovementSetupMock', 'getTierMovementSetup', new Tier_Movement_Setup__c());

		icDtoTierMovementConfig processConfigMock = new icDtoTierMovementConfig();
		processConfigMock.runProcess = true;
		processConfigMock.rebateYear = '2019';
		processConfigMock.adminEmail = 'test@test.com';
		icTestMockUtilities.Tracer.SetReturnValue('icLogicTierMovementSetupMock', 'getTierMovementConfigDto', processConfigMock);

		icTestMockUtilities.Tracer.SetReturnValue('icLogicTierMock', 'getAllTiers', new List<Tier__c>());
		icTestMockUtilities.Tracer.SetReturnValue('icLogicTierMock', 'getMapTiersByName', new Map<String, Tier__c>());
	}

	static testMethod void test_scheduleProcess() {
		initTest();

		icScheduleTierMovementProcess schedulableClass = new icScheduleTierMovementProcess();
		
		String schedule = '0 0 23 * * ?'; 

		Test.startTest();
		System.schedule('Scheduled Tier Movement Process', schedule, schedulableClass); 
		Test.stopTest();
	}
}