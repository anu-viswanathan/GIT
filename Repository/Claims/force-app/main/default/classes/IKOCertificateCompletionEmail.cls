public class IKOCertificateCompletionEmail {

    @future(callout=true)
    public static void sendCertificateByEmail(Id achievementId, Id achievementAssignmentId) {

        redwing__Achievement_Assignment__c achievementAssignment = IKOCertivicateUtils.getAchievementAssignmentById(achievementAssignmentId);
            
        User certificationUser = IKOCertivicateUtils.getUserById(achievementAssignment.redwing__User__c);
        User usersManager = IKOCertivicateUtils.getUserByContactId(achievementAssignment.redwing__User__r.Contact.ReportsToId);

        AntiTrustSetting__mdt certificationSettingsForUserProfile = IKOCertivicateUtils.getAntiTrustSettingByProfileName(certificationUser.Profile.Name); 

        if (certificationUser != null && certificationSettingsForUserProfile != null) {
            
            Messaging.SingleEmailMessage email = prepareCertificationEmail(certificationUser, usersManager, certificationSettingsForUserProfile);

            Messaging.EmailFileAttachment emailAttachement = prepareCertificationEmailAttachement(certificationSettingsForUserProfile.EmailAttachmentName__c);
            emailAttachement.Body = generateCertificationPDF(achievementId, achievementAssignmentId);

            email.setFileAttachments(new Messaging.EmailFileAttachment[] { emailAttachement });

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }
    }

    public static Blob generateCertificationPDF(Id achievementId, Id achievementAssignmentId) {
        PageReference pref = page.IKOCertivicatePrint;
        pref.getParameters().put('aid', achievementId);
        pref.getParameters().put('aaid', achievementAssignmentId);
        pref.setRedirect(true);

        return !Test.isRunningTest() ? pref.getContent() : Blob.valueOf('Unit Test');
    }

    public static Messaging.EmailFileAttachment prepareCertificationEmailAttachement(String attachementName) {
        Messaging.EmailFileAttachment emailAttachement = new Messaging.EmailFileAttachment();
        emailAttachement.setContentType('application/pdf');
        emailAttachement.setFileName(attachementName + '.pdf');
        emailAttachement.setInline(false);

        return emailAttachement;
    }

    public static Messaging.SingleEmailMessage prepareCertificationEmail(User destinationUser, User manager, AntiTrustSetting__mdt certificationSettingsForUserProfile) {

        OrgWideEmailAddress owea = IKOCertivicateUtils.getOrgWideEmailAddressByEmailAddress(certificationSettingsForUserProfile.OrganizationWideEmailAddress__c); 
        EmailTemplate emailTemplate = IKOCertivicateUtils.getEmailTemplateByDeveloperName(certificationSettingsForUserProfile.EmailTemplateDeveloperName__c);
                        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 

        if (owea != null) {
            email.setOrgWideEmailAddressId(owea.Id);
        }  

        List<String> ccAddresses = new List<String>();
        if (manager != null) {
            ccAddresses.add(manager.Email);
        }
        if (certificationSettingsForUserProfile.OrganizationWideEmailAddress__c != null) {
            ccAddresses.add(certificationSettingsForUserProfile.OrganizationWideEmailAddress__c);
        }
        
        if (emailTemplate != null) {
            email.setCcAddresses(ccAddresses);
            email.setTemplateId(emailTemplate.Id);    
            email.setTargetObjectId(destinationUser.Id);
            email.setUseSignature(false);
            email.setSaveAsActivity(false);
            email.setToAddresses(new String[] { destinationUser.Email });
        }

        return email;
    }

}