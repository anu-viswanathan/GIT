@isTest
public with sharing class icTestLogicTierMovementSetup {

	static void setup() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoTierMovementSetup', new icRepoTierMovementSetupMock());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoTierMovementSetupMock', 'getTierMovementSetup', new Tier_Movement_Setup__c());
    }

    public static testMethod void test_getTierMovementSetup(){
    	setup();

    	icLogicTierMovementSetup.IClass logic = (icLogicTierMovementSetup.IClass) icObjectFactory.GetSingletonInstance('icLogicTierMovementSetup');

        Tier_Movement_Setup__c testResult = logic.getTierMovementSetup();
    }

    public static testMethod void test_getTierMovementConfigDto_Weekly_byStart() {
    	icLogicTierMovementSetup.IClass logic = (icLogicTierMovementSetup.IClass) icObjectFactory.GetSingletonInstance('icLogicTierMovementSetup');

    	Date dateToday = Date.today();

    	Tier_Movement_Setup__c tierMovementSetup = new Tier_Movement_Setup__c(
    		Id = icTestHelperUtility.getFakeId(Tier_Movement_Setup__c.SObjectType)
    		,Tier_Advancement_Start_Date__c = dateToday
    		,Tier_Advancement_End_Date__c = dateToday.addMonths(9)
    		,Tier_Maintenance_Descend_Date__c = dateToday.addDays(7));

    	icDtoTierMovementConfig testResult = logic.getTierMovementConfigDto(tierMovementSetup);
    }

    public static testMethod void test_getTierMovementConfigDto_Weekly_byEnd() {
    	icLogicTierMovementSetup.IClass logic = (icLogicTierMovementSetup.IClass) icObjectFactory.GetSingletonInstance('icLogicTierMovementSetup');

    	Date dateToday = Date.today();

    	Tier_Movement_Setup__c tierMovementSetup = new Tier_Movement_Setup__c(
    		Id = icTestHelperUtility.getFakeId(Tier_Movement_Setup__c.SObjectType)
    		,Tier_Advancement_Start_Date__c = dateToday.addMonths(-9)
    		,Tier_Advancement_End_Date__c = dateToday
    		,Tier_Maintenance_Descend_Date__c = dateToday.addDays(7));

    	icDtoTierMovementConfig testResult = logic.getTierMovementConfigDto(tierMovementSetup);
    }

    public static testMethod void test_getTierMovementConfigDto_Weekly_byDOW() {
    	icLogicTierMovementSetup.IClass logic = (icLogicTierMovementSetup.IClass) icObjectFactory.GetSingletonInstance('icLogicTierMovementSetup');

    	Date dateToday = Date.today();

    	Tier_Movement_Setup__c tierMovementSetup = new Tier_Movement_Setup__c(
    		Id = icTestHelperUtility.getFakeId(Tier_Movement_Setup__c.SObjectType)
    		,Tier_Advancement_Start_Date__c = dateToday.addDays(-7)
    		,Tier_Advancement_End_Date__c = dateToday.addMonths(9)
    		,Tier_Maintenance_Descend_Date__c = dateToday.addDays(7));

    	icDtoTierMovementConfig testResult = logic.getTierMovementConfigDto(tierMovementSetup);
    }

    public static testMethod void test_getTierMovementConfigDto_Yearly() {
    	icLogicTierMovementSetup.IClass logic = (icLogicTierMovementSetup.IClass) icObjectFactory.GetSingletonInstance('icLogicTierMovementSetup');

    	Date dateToday = Date.today();

    	Tier_Movement_Setup__c tierMovementSetup = new Tier_Movement_Setup__c(
    		Id = icTestHelperUtility.getFakeId(Tier_Movement_Setup__c.SObjectType)
    		,Tier_Advancement_Start_Date__c = dateToday.addDays(7)
    		,Tier_Advancement_End_Date__c = dateToday.addMonths(9)
    		,Tier_Maintenance_Descend_Date__c = dateToday);

    	icDtoTierMovementConfig testResult = logic.getTierMovementConfigDto(tierMovementSetup);
    }
}