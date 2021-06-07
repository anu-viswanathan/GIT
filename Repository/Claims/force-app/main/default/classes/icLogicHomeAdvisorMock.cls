/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icLogicHomeAdvisorMock implements icLogicHomeAdvisor.IClass{

    public icDTOHALead getHALeadFromJSON(String jsonHALead) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getHALeadFromJSON');
        params.put('jsonHALead', jsonHALead);
        return (icDTOHALead) icTestMockUtilities.Tracer.GetReturnValue(this, 'getHALeadFromJSON');
    }

    public Lead getSFLeadFromHALead(icDTOHALead haLead) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getSFLeadFromHALead');
        params.put('haLead', haLead);
        return (Lead) icTestMockUtilities.Tracer.GetReturnValue(this, 'getSFLeadFromHALead');
    }

    public void processHALead(Lead newLead) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'processHALead');
        params.put('newLead', newLead);
    }
}