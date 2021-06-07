/**
 * Created by Yves Asselin on 2018-09-13.
 */



global with sharing class icDTOCommunityNavigationAuth {
@AuraEnabled global String accountId {get;set;}
@AuraEnabled global String sessionId {get;set;}
}