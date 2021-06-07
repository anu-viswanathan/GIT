global with sharing class icDTOGenericResult {
	@AuraEnabled global Boolean isSuccess {get;set;}
	@AuraEnabled global String message {get;set;}
}