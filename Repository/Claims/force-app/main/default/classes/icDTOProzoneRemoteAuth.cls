global with sharing class icDTOProzoneRemoteAuth {
	@AuraEnabled global String accountId {get;set;}
	@AuraEnabled global String sessionId {get;set;}
	@AuraEnabled global String theme {get;set;}
	@AuraEnabled global String userLanguage {get;set;}
    @AuraEnabled global Integer tierLevel {get;set;}
}