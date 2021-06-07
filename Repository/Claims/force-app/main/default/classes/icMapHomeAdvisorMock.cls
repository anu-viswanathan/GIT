/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icMapHomeAdvisorMock implements icMapHomeAdvisor.IClass{

    public Lead getSFLeadFromDTOHALead(icDTOHALead haLead) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getSFLeadFromDTOHALead');
        params.put('haLead', haLead);
        return (Lead) icTestMockUtilities.Tracer.GetReturnValue(this, 'getSFLeadFromDTOHALead');
    }

    public icDTOHALead getDTOHALeadFromJSONMap(Map<String, Object> untypedMapLead) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getDTOHALeadFromJSONMap');
        params.put('untypedMapLead', untypedMapLead);
        return (icDTOHALead) icTestMockUtilities.Tracer.GetReturnValue(this, 'getDTOHALeadFromJSONMap');
    }
}