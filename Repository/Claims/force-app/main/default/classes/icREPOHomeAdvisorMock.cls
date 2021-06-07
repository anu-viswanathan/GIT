/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icREPOHomeAdvisorMock implements icRepoHomeAdvisor.IClass{

    public void createLead(Lead newLead) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createLead');
        params.put('newLead', newLead);
    }
}