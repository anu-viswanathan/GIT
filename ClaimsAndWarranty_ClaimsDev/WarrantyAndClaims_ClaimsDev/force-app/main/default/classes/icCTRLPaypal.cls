/**
 * Created by Francois Poirier on 2018-12-03.
 */

global with sharing class icCTRLPaypal {

    static icLogicAccountPayment.IClass logicAccountPayment = (icLogicAccountPayment.IClass) icObjectFactory.GetSingletonInstance('icLogicAccountPayment');

    @AuraEnabled
    global static Boolean getInvoicePaidStatus(String accountPaymentId){

        Boolean retour = false;

        IKOPRO_Account_Payment__c accountPayment = new IKOPRO_Account_Payment__c();

        accountPayment = logicAccountPayment.getAccountPaymentById(accountPaymentId);

        if (accountPayment.Net_Membership_Fee__c - accountPayment.Paid_Amount__c <= 0){

            retour = true;

        }

        return retour;

    }
}