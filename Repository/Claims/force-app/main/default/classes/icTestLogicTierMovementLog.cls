@isTest
public with sharing class icTestLogicTierMovementLog {

	static void setup() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoTierMovementLog', new icRepoTierMovementLogMock());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoTierMovementLogMock', 'saveTierMovementLog', new List<Database.SaveResult>());
    }

    public static testMethod void test_createNewTierMovementLog_ASCEND(){
    	icLogicTierMovementLog.IClass logic = (icLogicTierMovementLog.IClass) icObjectFactory.GetSingletonInstance('icLogicTierMovementLog');

    	Account_Tier_Movement__c testResult = logic.createNewTierMovementLog(new icDtoTierMovementConfig(), new Account(), new Contact(), 12, 100, true, 'ASCEND', 5, 6, 10, 11);
    }

    public static testMethod void test_createNewTierMovementLog_DESCEND(){
    	icLogicTierMovementLog.IClass logic = (icLogicTierMovementLog.IClass) icObjectFactory.GetSingletonInstance('icLogicTierMovementLog');

    	Account_Tier_Movement__c testResult = logic.createNewTierMovementLog(new icDtoTierMovementConfig(), new Account(), new Contact(), 12, 100, true, 'DESCEND', 5, 6, 10, 11);
    }

    public static testMethod void test_createNewTierMovementLog_MAINTAIN(){
    	icLogicTierMovementLog.IClass logic = (icLogicTierMovementLog.IClass) icObjectFactory.GetSingletonInstance('icLogicTierMovementLog');

    	Account_Tier_Movement__c testResult = logic.createNewTierMovementLog(new icDtoTierMovementConfig(), new Account(), new Contact(), 12, 100, true, 'MAINTAIN', 5, 6, 10, 11);
    }

    public static testMethod void test_saveTierMovementLog() {
    	setup();

    	icLogicTierMovementLog.IClass logic = (icLogicTierMovementLog.IClass) icObjectFactory.GetSingletonInstance('icLogicTierMovementLog');

    	logic.saveTierMovementLog(new List<Account_Tier_Movement__c>());
    }
}