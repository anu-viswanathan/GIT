@isTest
public with sharing class icRepoTierMovementSetupMock implements icRepoTierMovementSetup.IClass{

    public Tier_Movement_Setup__c getTierMovementSetup() {
        //Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getTierMovementSetup');
        //params.put('param', param);
        return (Tier_Movement_Setup__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'getTierMovementSetup');
    }
}