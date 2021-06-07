/**
 * Created by Francois Poirier on 2019-11-01.
 */

global with sharing class icDTOMembershipRenewal {

    @AuraEnabled global icDTOProzoneRemoteAuth remoteAuth {get;set;}
    @AuraEnabled global String accountPaymentId {get;set;}

}