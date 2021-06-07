/**
 * Created by Francois Poirier on 2019-11-29.
 */

global with sharing class icDtoPopupNotification {

    @AuraEnabled global String notificationViewId {get;set;}
    @AuraEnabled global String message {get;set;}
    @AuraEnabled global Boolean showMessage {get;set;}
    
}