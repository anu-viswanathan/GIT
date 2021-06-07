global with sharing class icDTOWhatsHappening {
    @AuraEnabled global String imageId {get;set;}
    @AuraEnabled global String title {get;set;}
    @AuraEnabled global String description {get;set;}
    @AuraEnabled global String linkType {get;set;}
    @AuraEnabled global String linkLabel {get;set;}
    @AuraEnabled global String externalLink {get;set;}
    @AuraEnabled global String communityLink {get;set;}
    @AuraEnabled global String mobileLink {get;set;}
    @AuraEnabled global String emailToLink {get;set;}
}