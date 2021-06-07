/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icREPOLeadMock implements icRepoLead.IClass{

    public List<Lead> getNewLeadsByAccountId(String recordId, String ownerId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getNewLeadsByAccountId');
        params.put('recordId', recordId);
        params.put('ownerId', ownerId);
        return (List<Lead>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getNewLeadsByAccountId');
    }
}