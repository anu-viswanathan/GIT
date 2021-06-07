@isTest
public with sharing class icLogicTierMovementLogMock implements icLogicTierMovementLog.IClass{

    public Account_Tier_Movement__c createNewTierMovementLog(icDtoTierMovementConfig processConfig, Account contractor, Contact primaryContact, Integer calculatedMonth, Double calculatedSqares, Boolean isSignupYear, String tierMovement, Double tier1High, Double tier2Low, Double tier2High, Double tier3Low) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createNewTierMovementLog');
        params.put('processConfig', processConfig);
        params.put('contractor', contractor);
        params.put('primaryContact', primaryContact);
        params.put('calculatedMonth', calculatedMonth);
        params.put('calculatedSqares', calculatedSqares);
        params.put('isSignupYear', isSignupYear);
        params.put('tierMovement', tierMovement);
        params.put('tier1High', tier1High);
        params.put('tier2Low', tier2Low);
        params.put('tier2High', tier2High);
        params.put('tier3Low', tier3Low);
        return (Account_Tier_Movement__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'createNewTierMovementLog');
    }

    public void saveTierMovementLog(List<Account_Tier_Movement__c> tierMovementLogs) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'saveTierMovementLog');
        params.put('tierMovementLogs', tierMovementLogs);
        //return (void) icTestMockUtilities.Tracer.GetReturnValue(this, 'saveTierMovementLog');
    }
}