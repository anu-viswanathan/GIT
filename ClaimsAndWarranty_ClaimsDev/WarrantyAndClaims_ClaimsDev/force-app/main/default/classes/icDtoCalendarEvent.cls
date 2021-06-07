/**
 * Created by Francois Poirier on 2019-04-01.
 */

public with sharing class icDtoCalendarEvent {

    @AuraEnabled public String Id {get;set;}
    @AuraEnabled public String dateToDisplay {get;set;}
    @AuraEnabled public String Description {get;set;}
    @AuraEnabled public String EmailRecipient {get;set;}
    @AuraEnabled public Date EventDate {get;set;}
    @AuraEnabled public String ExternalLink {get;set;}
    @AuraEnabled public String InternalCommunityLink {get;set;}
    @AuraEnabled public String InternalMobileLink {get;set;}
    @AuraEnabled public String LinkLabel {get;set;}
    @AuraEnabled public String linkType {get;set;}
    //@AuraEnabled public Boolean majorEvent {get;set;}
    @AuraEnabled public String  Name {get;set;}
    @AuraEnabled public String Title {get;set;}

}