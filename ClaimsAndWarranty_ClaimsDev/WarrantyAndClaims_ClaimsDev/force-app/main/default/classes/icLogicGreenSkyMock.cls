/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icLogicGreenSkyMock implements icLogicGreenSky.IClass{

    public icDTOGreenSkyMerchantValidation merchantValidation() {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'merchantValidation');
        return (icDTOGreenSkyMerchantValidation) icTestMockUtilities.Tracer.GetReturnValue(this, 'merchantValidation');
    }

    public icDTOGreenSkyApplication asynchronousSubmit(String token, String payload) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'asynchronousSubmit');
        params.put('token', token);
        params.put('payload', payload);
        return (icDTOGreenSkyApplication) icTestMockUtilities.Tracer.GetReturnValue(this, 'asynchronousSubmit');
    }

    public icDTOGreenSkyApplicationState state(icDTOGreenSkyApplication gsApplication) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'state');
        params.put('gsApplication', gsApplication);
        return (icDTOGreenSkyApplicationState) icTestMockUtilities.Tracer.GetReturnValue(this, 'state');
    }

    public icDTOGreenSkyDecision Decision(icDTOGreenSkyApplication gsApplication) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'Decision');
        params.put('gsApplication', gsApplication);
        return (icDTOGreenSkyDecision) icTestMockUtilities.Tracer.GetReturnValue(this, 'Decision');
    }

    public icDTOGreenSkyOffer offer(icDTOGreenSkyApplication gsApplication) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'offer');
        params.put('gsApplication', gsApplication);
        return (icDTOGreenSkyOffer) icTestMockUtilities.Tracer.GetReturnValue(this, 'offer');
    }

    public icDTOGreenSkyCreate create(icDTOGreenSkyOffer gsOffer, icDTOGreenSkyApplication gsApplication) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'create');
        params.put('gsOffer', gsOffer);
        params.put('gsApplication', gsApplication);
        return (icDTOGreenSkyCreate) icTestMockUtilities.Tracer.GetReturnValue(this, 'create');
    }

    public icDTOGreenSkyLoanAgreement loanAgreement(icDTOGreenSkyApplication gsApplication) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'loanAgreement');
        params.put('gsApplication', gsApplication);
        return (icDTOGreenSkyLoanAgreement) icTestMockUtilities.Tracer.GetReturnValue(this, 'loanAgreement');
    }

    public icDTOGreenSkyEmail email(icDTOGreenSkyLoanAgreement loanAgreement, icDTOGreenSkyApplication gsApplication) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'email');
        params.put('loanAgreement', loanAgreement);
        params.put('gsApplication', gsApplication);
        return (icDTOGreenSkyEmail) icTestMockUtilities.Tracer.GetReturnValue(this, 'email');
    }

    public icDTOGreenSkyLists getListsFromGreenSkyAPI() {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getListsFromGreenSkyAPI');
        return (icDTOGreenSkyLists) icTestMockUtilities.Tracer.GetReturnValue(this, 'getListsFromGreenSkyAPI');
    }

    public icDTOLoanForm getGreenSkyLoanForm(icDTOGreenSkyMerchantValidation merchantValidation, String str) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getGreenSkyLoanForm');
        params.put('merchantValidation', merchantValidation);
        return (icDTOLoanForm) icTestMockUtilities.Tracer.GetReturnValue(this, 'getGreenSkyLoanForm');
    }

    public Boolean isCustomerSubscribed() {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'isCustomerSubscribed');
        return (Boolean) icTestMockUtilities.Tracer.GetReturnValue(this, 'isCustomerSubscribed');
    }

    public void saveSubscription(String gsSubscriptionString) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'saveSubscription');
        params.put('gsSubscriptionString', gsSubscriptionString);
    }
}