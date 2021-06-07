@isTest
public with sharing class icRepoTierMovementLogMock implements icRepoTierMovementLog.IClass{

    public List<Database.SaveResult> saveTierMovementLog(List<Account_Tier_Movement__c> tierMovementLog) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'saveTierMovementLog');
        params.put('tierMovementLog', tierMovementLog);
        return (List<Database.SaveResult>) icTestMockUtilities.Tracer.GetReturnValue(this, 'saveTierMovementLog');
    }
}