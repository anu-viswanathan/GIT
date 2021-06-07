/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icLogicEmailMock implements icLogicEmail.IClass{

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

    //IKO-96
    //public void sendPlainTextEmail(String subject, String body, List<String> recipients, List<String> ccRecipients, List<String> bccRecipients, List<String> entities, List<Messaging.EmailFileAttachment> attachments, String orgWideEmailId) {
    public void sendPlainTextEmail(String subject, String body, List<String> recipients, List<String> ccRecipients, List<String> bccRecipients, List<String> entities, List<Messaging.EmailFileAttachment> attachments) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'sendPlainTextEmail');
        params.put('subject', subject);
        params.put('body', body);
        params.put('recipients', recipients);
        params.put('ccRecipients', ccRecipients);
        params.put('bccRecipients', bccRecipients);
        params.put('entities', entities);
        params.put('attachments', attachments);
        //IKO-96 params.put('orgWideEmailId', orgWideEmailId);
    }

    public void sendTemplateEmail(EmailTemplate template, String recipientId, String relatedObjectId, List<String> entities, List<Messaging.EmailFileAttachment> attachments) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'sendTemplateEmail');
        params.put('template', template);
        params.put('recipientId', recipientId);
        params.put('relatedObjectId', relatedObjectId);
        params.put('entities', entities);
        params.put('attachments', attachments);
    }
    
    public Messaging.SingleEmailMessage RenderEmailTemplate(EmailTemplate template, String userId, String whatId, List<String> entities, List<Messaging.EmailFileAttachment> attachments) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'RenderEmailTemplate');
        params.put('template', template);
        params.put('userId', userId);
        params.put('whatId', whatId);
        params.put('entities', entities);
        params.put('attachments', attachments);
        return (Messaging.SingleEmailMessage) icTestMockUtilities.Tracer.GetReturnValue(this, 'RenderEmailTemplate');
    }

}