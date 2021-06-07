global with sharing class icDTOQuickShotInfo {
	@AuraEnabled global Double newLeads {get;set;}
	@AuraEnabled global Double currentOpportunities {get;set;}
	@AuraEnabled global Double squaresYTD {get;set;}
	@AuraEnabled global Double pro4Rewards {get;set;}
	@AuraEnabled global Double coopRewards {get;set;}
	@AuraEnabled global Decimal upcomingCoopRewards {get;set;}
	@AuraEnabled global String sessionId {get;set;}
	@AuraEnabled global Integer tierLevel {get;set;}
	@AuraEnabled global Boolean hideUpcomingCoopRewards {get;set;}
}