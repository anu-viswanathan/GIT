global with sharing class icDTOWhatsHappeningResult {
    @AuraEnabled global List<icDTOWhatsHappening> content {get;set;}
    @AuraEnabled global String theme {get;set;}
}