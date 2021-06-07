/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icREPOEmailMock implements icRepoEmail.IClass{

    public EmailTemplate getEmailTemplateByDevName(String templateDevName) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getEmailTemplateByDevName');
        params.put('templateDevName', templateDevName);
        return (EmailTemplate) icTestMockUtilities.Tracer.GetReturnValue(this, 'getEmailTemplateByDevName');
    }

    public OrgWideEmailAddress getOrgWideEmailByName(String orgWideEmailName) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getOrgWideEmailByName');
        params.put('orgWideEmailName', orgWideEmailName);
        return (OrgWideEmailAddress) icTestMockUtilities.Tracer.GetReturnValue(this, 'getOrgWideEmailByName');
    }
}