@isTest
public with sharing class icTestRepoTierMovementLog {

    public static testMethod void test_getAllTiers(){
    	icRepoTierMovementLog.IClass repository = (icRepoTierMovementLog.IClass) icObjectFactory.GetSingletonInstance('icRepoTierMovementLog');

    	List<Account_Tier_Movement__c> tierMovementLog = new List<Account_Tier_Movement__c>();
    	
    	Account_Tier_Movement__c newTierMovementLog = new Account_Tier_Movement__c();
		//newTierMovementLog.ATM_Contractor__c = contractor.Id;
		newTierMovementLog.ATM_Member_Since_Months__c = 12;
		newTierMovementLog.ATM_Applicable_Invoice_Year__c = '2019';
		newTierMovementLog.ATM_Purchase_Square_Volume__c = 100;
		newTierMovementLog.ATM_Sign_Up_Year__c = false;
		newTierMovementLog.ATM_Tier_Movement_Decision__c = 'Maintained Sq. Purchase Volume';
		newTierMovementLog.ATM_Business_Fundamentals_Completed__c = true;
		newTierMovementLog.ATM_Installation_Fundamentals_Completed__c = true;
		newTierMovementLog.ATM_Performance_Fundamentals_Completed__c = true;
		newTierMovementLog.ATM_Safety_Fundamentals_Completed__c = true;
		newTierMovementLog.ATM_Applied_Benchmark_Value_Tier_1_High__c = 5;
		newTierMovementLog.ATM_Applied_Benchmark_Value_Tier_2_Low__c = 6;
		newTierMovementLog.ATM_Applied_Benchmark_Value_Tier_2_High__c = 10;
		newTierMovementLog.ATM_Applied_Benchmark_Value_Tier_3_Low__c = 11;
		newTierMovementLog.ATM_Date_Present_Tier__c = Date.today();
		//newTierMovementLog.ATM_Present_Tier__c = contractor.Present_Tier_Lookup__c;
		//newTierMovementLog.ATM_Prior_Tier__c = contractor.Prior_Tier__c;
		//newTierMovementLog.ATM_TSR_Email__c = contractor.Owner.Email;
		//newTierMovementLog.ATM_Contractor_Email__c = contractor.Admin_Email_Address__c;
		tierMovementLog.add(newTierMovementLog);

        List<Database.SaveResult> testResult = repository.saveTierMovementLog(tierMovementLog);
    }
}