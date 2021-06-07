@isTest
public with sharing class icTestLogicTier {

	static void setup() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoTier', new icRepoTierMock());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoTierMock', 'getAllTiers', new List<Tier__c>());
    }

    public static testMethod void test_getAllTiers(){
    	setup();

    	icLogicTier.IClass logic = (icLogicTier.IClass) icObjectFactory.GetSingletonInstance('icLogicTier');

        List<Tier__c> testResult = logic.getAllTiers();
    }

    public static testMethod void test_getMapTiersByName() {
    	setup();

    	icLogicTier.IClass logic = (icLogicTier.IClass) icObjectFactory.GetSingletonInstance('icLogicTier');

    	List<Tier__c> tiers = new List<Tier__c>();
    	Tier__c newTier = new Tier__c(Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType));
    	tiers.add(newTier);

    	Map<String, Tier__c> testResult = logic.getMapTiersByName(tiers);
    }
}