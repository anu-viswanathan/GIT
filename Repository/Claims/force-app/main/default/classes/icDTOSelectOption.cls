global with sharing class icDTOSelectOption {
	@AuraEnabled global String value {get;set;}
	@AuraEnabled global String label {get;set;}
	@AuraEnabled global Boolean isDisabled {get;set;}
}