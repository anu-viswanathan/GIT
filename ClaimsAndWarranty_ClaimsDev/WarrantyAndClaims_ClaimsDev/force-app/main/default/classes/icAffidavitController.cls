public with sharing class icAffidavitController {
    private final static String INSTALLATION_FUNDAMENTALS = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('IF_Course_Affirmation__c').getDescribe().getLabel().toLowerCase();
    private final static String SAFETY_FUNDAMENTALS = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Safety_Fundamentals_Completed__c').getDescribe().getLabel().toLowerCase();
    @AuraEnabled
    public static void submitAffidavit(String LAID, String LMS_Completion_Name, String LMS_Completion_Signature, String LMS_Completion_Title) {
        User user = [
                SELECT AccountId
                FROM User
                WHERE Id = :UserInfo.getUserId()
        ];
        Account account = [
                SELECT Name, Contractor_ID__c, IF_Course_Affirmation__c, Safety_Fundamentals_Completed__c, LMS_IF_Completion_Company__c, LMS_IF_Completion_ContractorID__c, LMS_IF_Completion_Date__c, LMS_IF_Completion_Name__c, LMS_IF_Completion_Signature__c, LMS_IF_Completion_Title__c, LMS_SF_Completion_Company__c, LMS_SF_Completion_ContractorID__c, LMS_SF_Completion_Date__c, LMS_SF_Completion_Name__c, LMS_SF_Completion_Signature__c, LMS_SF_Completion_Title__c
                FROM Account
                WHERE Id = :user.AccountId
        ];
        String learningPlanName = getContractorInfo(LAID).learningPlanName;
        if (INSTALLATION_FUNDAMENTALS.contains(learningPlanName.toLowerCase())) {
            account.IF_Course_Affirmation__c = true;

            account.LMS_IF_Completion_Date__c = Date.today();
            account.LMS_IF_Completion_Company__c = account.Name;
            account.LMS_IF_Completion_ContractorID__c = account.Contractor_ID__c;
            account.LMS_IF_Completion_Name__c = LMS_Completion_Name;
            account.LMS_IF_Completion_Signature__c = LMS_Completion_Signature;
            account.LMS_IF_Completion_Title__c = LMS_Completion_Title;


        } else if (SAFETY_FUNDAMENTALS.contains(learningPlanName.toLowerCase())) {
            account.Safety_Fundamentals_Completed__c = true;

            account.LMS_SF_Completion_Date__c = Date.today();
            account.LMS_SF_Completion_Company__c = account.Name;
            account.LMS_SF_Completion_ContractorID__c = account.Contractor_ID__c;
            account.LMS_SF_Completion_Name__c = LMS_Completion_Name;
            account.LMS_SF_Completion_Signature__c = LMS_Completion_Signature;
            account.LMS_SF_Completion_Title__c = LMS_Completion_Title;
        }
        update account;

        markLearningAsCompleted(LAID);
    }
    @AuraEnabled
    public static Contractor getContractorInfo(String LAID) {
        redwing__Learning_Assignment__c reLearningAssignment = [
                SELECT redwing__Community_Id__c, redwing__Training_Plan__r.Name
                FROM redwing__Learning_Assignment__c
                WHERE Id = :LAID
        ];
        User user = [
                SELECT AccountId
                FROM User
                WHERE Id = :UserInfo.getUserId()
        ];
        Account account = [
                SELECT Name, Contractor_ID__c, Safety_Fundamentals_Completed__c, IF_Course_Affirmation__c
                FROM Account
                WHERE Id = :user.AccountId
        ];
        Boolean isCompletedPlan = false;
        if ((INSTALLATION_FUNDAMENTALS.contains(reLearningAssignment.redwing__Training_Plan__r.Name.toLowerCase())
                && account.IF_Course_Affirmation__c == true)
                || (SAFETY_FUNDAMENTALS.contains(reLearningAssignment.redwing__Training_Plan__r.Name.toLowerCase())
                && account.Safety_Fundamentals_Completed__c == true)) {
            isCompletedPlan = true;
            markLearningAsCompleted(LAID);
        }
        return new Contractor(account.Name, account.Contractor_ID__c, reLearningAssignment.redwing__Training_Plan__r.Name, isCompletedPlan);
    }

    private static void markLearningAsCompleted(String laid) {
        
        redwing__Learning_Assignment__c affidavitLearningAssignment = [
                SELECT redwing__Progress__c, redwing__Progress_Percentage__c, redwing__Evaluation_Result__c, redwing__Completed_On__c
                FROM redwing__Learning_Assignment__c
                WHERE Id = :laid
        ];
        
        affidavitLearningAssignment.redwing__Progress__c = 'Completed';
        affidavitLearningAssignment.redwing__Progress_Percentage__c = 100;
        affidavitLearningAssignment.redwing__Evaluation_Result__c = 'N/A';

        update affidavitLearningAssignment;
    }

    public class Contractor {
        @AuraEnabled
        public String companyName { get; set; }
        @AuraEnabled
        public String contractorId { get; set; }
        @AuraEnabled
        public String learningPlanName { get; set; }
        @AuraEnabled
        public Boolean isCompletedPlan { get; set; }

        public Contractor(String companyName, String contractorId, String learningPlanName, Boolean isCompletedPlan) {
            this.companyName = companyName;
            this.contractorId = contractorId;
            this.learningPlanName = learningPlanName;
            this.isCompletedPlan = isCompletedPlan;
        }
    }
}