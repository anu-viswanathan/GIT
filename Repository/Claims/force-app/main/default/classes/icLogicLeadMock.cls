/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icLogicLeadMock implements icLogicLead.IClass{

    public Integer getNewLeadsCountByAccountId(String recordId, String ownerId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getNewLeadsCountByAccountId');
        params.put('recordId', recordId);
        params.put('ownerId', ownerId);
        return (Integer) icTestMockUtilities.Tracer.GetReturnValue(this, 'getNewLeadsCountByAccountId');
    }
}