/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icREPOGreenSkyMock implements icRepoGreenSky.IClass{

    public icDTOGreenSkyApplication createApplication(icDTOGreenSkyApplication application) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createApplication');
        params.put('application', application);
        return (icDTOGreenSkyApplication) icTestMockUtilities.Tracer.GetReturnValue(this, 'createApplication');    }

    public void updateApplicationStatus(String sfId, String status) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'updateApplicationStatus');
        params.put('status', status);
        params.put('sfId', sfId);
    }

    public void updateApplicationFromDecision(String sfId, icDTOGreenSkyDecision decision) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'updateApplicationFromDecision');
        params.put('decision', decision);
        params.put('sfId', sfId);
    }

    public void updateApplicationFromOffer(String sfId, icDTOGreenSkyOffer offer) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'updateApplicationFromOffer');
        params.put('offer', offer);
        params.put('sfId', sfId);
    }
}