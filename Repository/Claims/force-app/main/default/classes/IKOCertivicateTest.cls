@isTest
public class IKOCertivicateTest {

    private static final String ACHIEVEMENT_NAME = 'Test Achievement';
    private static final String CERTIFICATION_USERNAME = 'coalitionCertUser123@test321.com';
    private static final String LARNING_PLAN_NAME = 'Test Learning Plan';
    private static final String COMMUNITY_PROFILE_NAME = 'Decra Platform User';

    @testSetup static void setup() {
        Account account = AntiTrustTestDataFactory.createAccount('Test Account' + Datetime.now());
        insert account;

        Contact contact = AntiTrustTestDataFactory.createContact('Test Contact 1', account.Id);
        insert contact;

        Profile profile =  [ SELECT Id, Name
                             FROM Profile 
                             WHERE Name = :COMMUNITY_PROFILE_NAME];

        User currentUser = [ SELECT Id 
                             FROM User 
                             WHERE Id = :UserInfo.getUserId() ];

        User user = AntiTrustTestDataFactory.createCommunityUserRecord(profile.Id, contact.Id); 
        user.Username = CERTIFICATION_USERNAME;

        System.RunAs(currentUser) {
            insert user;
        }

        redwing__Training_Plan__c learningPlan = AntiTrustTestDataFactory.createTrainingPlan();
        learningPlan.Name = LARNING_PLAN_NAME;
        insert learningPlan;

        redwing__Achievement__c achievement = AntiTrustTestDataFactory.createAchievement();
        achievement.Name = ACHIEVEMENT_NAME;
        achievement.redwing__Enable_Printing__c = true;
        insert achievement;

        redwing__Training_Plan_Achievement__c traningPlanAchievement = AntiTrustTestDataFactory.createTrainingPlanAchievement(learningPlan.id, achievement.Id);
        insert traningPlanAchievement;
        
        redwing__Achievement_Assignment__c achievementAssignment = AntiTrustTestDataFactory.createAchievementAssignment();
        achievementAssignment.redwing__Training_Plan_Achievement__c = traningPlanAchievement.Id;
        achievementAssignment.redwing__User__c = user.Id;
        achievementAssignment.redwing__Contact__c = contact.Id;
        achievementAssignment.redwing__Achievement__c = achievement.Id;
        achievementAssignment.redwing__Status__c = 'Acquired'; 
        insert achievementAssignment;
    }

    @isTest
    static void  updateCertificateAssignmentAchievement() {

        redwing__Achievement__c achievement = [ SELECT Id, Name
                                                FROM redwing__Achievement__c
                                                WHERE Name = :ACHIEVEMENT_NAME 
                                                LIMIT 1 ];

        redwing__Achievement_Assignment__c achievementAssignment = [ SELECT Id, redwing__Achievement__c
                                                                     FROM redwing__Achievement_Assignment__c
                                                                     WHERE redwing__Achievement__c = :achievement.Id
                                                                     LIMIT 1 ];

        Test.startTest();
        IKOCertificateCompletionEmail.sendCertificateByEmail(achievement.Id, achievementAssignment.Id);
        Test.stopTest();
    }

    @isTest
    static void generateIKOCertification() {

        redwing__Achievement__c achievement = [ SELECT Id, Name
                                                FROM redwing__Achievement__c
                                                WHERE Name = :ACHIEVEMENT_NAME 
                                                LIMIT 1 ];
        redwing__Achievement_Assignment__c achievementAssignment = [ SELECT Id, redwing__Achievement__c
                                                                     FROM redwing__Achievement_Assignment__c
                                                                     WHERE redwing__Achievement__c = :achievement.Id
                                                                     LIMIT 1 ];

        PageReference pageRefNoCoalition = page.IKOCertivicatePrint;
        Test.setCurrentPage(pageRefNoCoalition);
        ApexPages.currentPage().getParameters().put('aid', achievement.Id);
        ApexPages.currentPage().getParameters().put('aaid', achievementAssignment.Id);

        Test.startTest();
        IKOCertivicatePrintController ikoCertivicateController = new IKOCertivicatePrintController();
        ikoCertivicateController.init();
        Test.stopTest();

        System.assertNotEquals(null, ikoCertivicateController.user, 
                               'No certification user found');
        System.assertNotEquals(null, ikoCertivicateController.achievement, 
                               'No achievement found');
        System.assertNotEquals(null, ikoCertivicateController.achievementAssignment, 
                               'No achievementAssignment found');

    }

    @isTest static void sendCertificateAfterLearningPlanCompletionTest() {
             
        redwing__Achievement__c achievement = [ SELECT Id, Name
                                                FROM redwing__Achievement__c
                                                WHERE Name = :ACHIEVEMENT_NAME 
                                                LIMIT 1 ];
        redwing__Achievement_Assignment__c achievementAssignment = [ SELECT Id, redwing__Achievement__c
                                                                     FROM redwing__Achievement_Assignment__c
                                                                     WHERE redwing__Achievement__c = :achievement.Id
                                                                     LIMIT 1 ];

        SendCertificate__e sendCertificationEvent = new SendCertificate__e();

        sendCertificationEvent.AchievementAssignmentId__c = achievementAssignment.Id;
        sendCertificationEvent.AchievementId__c = achievement.Id;

        Test.startTest();
        Database.SaveResult sr = EventBus.publish(sendCertificationEvent);
        Test.stopTest();

        System.assertEquals(true, sr.isSuccess());
    }
}