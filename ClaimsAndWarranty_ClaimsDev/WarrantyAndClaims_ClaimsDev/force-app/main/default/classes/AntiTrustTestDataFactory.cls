@isTest
public class AntiTrustTestDataFactory {
   
    public static Account createAccount(String accountName) {
        Account account = new Account();
        account.Name = accountName;
        return account;
    }

    public static Contact createContact(String lastName, Id accountId) {
        Contact contact = new Contact();
        contact.AccountId = accountId;
        contact.LastName = lastName;
        return contact;
    }

    public static User createCommunityUserRecord(Id profileId, Id contactId) {
        User user = new User();
        user.email ='test.user@test.com';
        user.profileid = profileId; 
        user.Username = 'testUser123zxv893@testo.com'; 
        user.Alias = 'TU';
        user.TimeZoneSidKey ='America/New_York';
        user.EmailEncodingKey ='ISO-8859-1';
        user.LocaleSidKey = 'en_US'; 
        user.LanguageLocaleKey = 'en_US';
        user.ContactId = contactId;
        user.PortalRole = 'Manager';
        user.FirstName = 'John';
        user.LastName = 'Testington';

        return user;
    }

    public static redwing__Instructor__c createInstructor(Id user) {
        redwing__Instructor__c instructor = new redwing__Instructor__c();
        instructor.redwing__User__c = user;
        return instructor;
    }

    public static redwing__Training_Plan_Instructor__c createTrainingPlanInstructor(Id learningPlanId, Id instructorId) {
        redwing__Training_Plan_Instructor__c learningPlanInstructor = new redwing__Training_Plan_Instructor__c();
        learningPlanInstructor.redwing__Training_Plan__c = learningPlanId;
        learningPlanInstructor.redwing__Instructor__c = instructorId;
        return learningPlanInstructor;
    }

    public static redwing__Achievement__c createAchievement() {
        redwing__Achievement__c achievement = new redwing__Achievement__c();
        achievement.Name = 'achievement';
        return achievement;
    }

    public static redwing__Training_Plan_Achievement__c createTrainingPlanAchievement(Id learningPlanId, Id achievementId) {
        redwing__Training_Plan_Achievement__c learningPlanAchievement = new redwing__Training_Plan_Achievement__c();
        learningPlanAchievement.redwing__Training_Plan__c = learningPlanId;
        learningPlanAchievement.redwing__Achievement__c = achievementId;
        return learningPlanAchievement;
    }

    public static redwing__Achievement_Assignment__c createAchievementAssignment() {
        redwing__Achievement_Assignment__c achievementAssignment = new redwing__Achievement_Assignment__c();
        achievementAssignment.redwing__Training_Plan_Achievement__c = null;
        achievementAssignment.redwing__User__c = null;
        achievementAssignment.redwing__Contact__c = null;
        return achievementAssignment;
    }

    public static redwing__Training_Plan__c createTrainingPlan() {
        redwing__Training_Plan__c learningPlan = new redwing__Training_Plan__c();
        learningPlan.Name = 'Test';
        learningPlan.redwing__Description__c = 'Test';
        return learningPlan;
    }

}