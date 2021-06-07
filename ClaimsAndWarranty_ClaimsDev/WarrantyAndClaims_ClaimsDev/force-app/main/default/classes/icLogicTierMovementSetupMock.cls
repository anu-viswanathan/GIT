@isTest
public with sharing class icLogicTierMovementSetupMock implements icLogicTierMovementSetup.IClass{

    public Tier_Movement_Setup__c getTierMovementSetup() {
        //Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getTierMovementSetup');
        //params.put('param', param);
        return (Tier_Movement_Setup__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'getTierMovementSetup');
    }

    public icDtoTierMovementConfig getTierMovementConfigDto(Tier_Movement_Setup__c tierMovementSetup) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getTierMovementConfigDto');
        params.put('tierMovementSetup', tierMovementSetup);
        return (icDtoTierMovementConfig) icTestMockUtilities.Tracer.GetReturnValue(this, 'getTierMovementConfigDto');
    }
}