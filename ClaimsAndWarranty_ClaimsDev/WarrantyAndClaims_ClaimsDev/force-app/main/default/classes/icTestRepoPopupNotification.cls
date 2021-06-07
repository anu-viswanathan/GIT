/**
 * Created by Francois Poirier on 2019-12-02.
 */

@isTest
public with sharing class icTestRepoPopupNotification {

    static icRepoPopupNotification.IClass repoPopupNotification = (icRepoPopupNotification.IClass) icObjectFactory.GetSingletonInstance('icRepoPopupNotification');

    @isTest
    static void testGetCurrentPopup(){

        Popup_notification__c popup = new Popup_notification__c();
        popup.Start_Date__c = Date.today();
        popup.End_Date__c = Date.today();
        popup.Active__c = true;
        insert popup;

        Popup_notification__c popupFromRepo = new Popup_notification__c();
        popupFromRepo = repoPopupNotification.getCurrentPopup();

        System.assertEquals(popup.Id, popupFromRepo.Id);

    }

    @isTest
    static void testGetCurrentPopupByTag(){

        Popup_notification__c popup = new Popup_notification__c();
        popup.Start_Date__c = Date.today();
        popup.End_Date__c = Date.today();
        popup.Active__c = true;
        String myTag = icTestHelperUtility.generateRandomString(5);
        popup.Tag__c = myTag;
        insert popup;

        Popup_notification__c popupFromRepo = new Popup_notification__c();
        popupFromRepo = repoPopupNotification.getCurrentPopupByTag(myTag);

        System.assertEquals(popup.Id, popupFromRepo.Id);

    }

}