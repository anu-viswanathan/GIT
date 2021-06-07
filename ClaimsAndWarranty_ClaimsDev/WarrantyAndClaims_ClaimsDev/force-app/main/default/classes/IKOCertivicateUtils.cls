public class IKOCertivicateUtils {
   
    public static User getUserById(Id userId) {
        List<User> users = [ SELECT Id, Name, Profile.Name, Email 
                             FROM User
                             WHERE Id = :userId ];
        return users.isEmpty() ? null : users[0];
    }

    public static User getUserByContactId(Id contactId) {
        List<User> users = [ SELECT Id, Name, Profile.Name, ContactId, Email 
                             FROM User
                             WHERE ContactId = :contactId ];
        return users.isEmpty() ? null : users[0];
    }

    public static AntiTrustSetting__mdt getAntiTrustSettingByProfileName(String profileName) {
        List<AntiTrustSetting__mdt> antiTrustSettings = [ SELECT BackgroundName__c, ProfileName__c, EmailTemplateDeveloperName__c, 
                                                                 OrganizationWideEmailAddress__c, EmailAttachmentName__c
                                                          FROM AntiTrustSetting__mdt
                                                          WHERE ProfileName__c = :profileName ];
        return antiTrustSettings.isEmpty() ? null : antiTrustSettings[0];
    }

    public static OrgWideEmailAddress getOrgWideEmailAddressByEmailAddress(String emailAddress) {
        List<OrgWideEmailAddress> orgWideEmailAddress = [ SELECT Id
                                                          FROM OrgWideEmailAddress 
                                                          WHERE Address = :emailAddress ];
        return orgWideEmailAddress.isEmpty() ? null : orgWideEmailAddress[0];            
    }   

    public static EmailTemplate getEmailTemplateByDeveloperName(String developerName) {
        List<EmailTemplate> emailTemplates = [ SELECT Id, Subject, Body, HtmlValue
                                               FROM EmailTemplate 
                                               WHERE DeveloperName = :developerName ];
        return emailTemplates.isEmpty() ? null : emailTemplates[0];
    }

    public static redwing__Achievement_Assignment__c getAchievementAssignmentById(Id achievementAssignmentId) {
        return [ SELECT Id, redwing__User__c, redwing__User__r.ManagerId,  redwing__Contact__r.Owner.Id, redwing__Contact__c,
                        redwing__User__r.Contact.ReportsToId
                 FROM redwing__Achievement_Assignment__c
                 WHERE Id =: achievementAssignmentId ];
    }
}