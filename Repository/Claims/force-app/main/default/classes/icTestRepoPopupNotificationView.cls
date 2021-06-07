/**
 * Created by Francois Poirier on 2019-12-02.
 */

@isTest
public with sharing class icTestRepoPopupNotificationView {

    static icRepoPopupNotificationView.IClass repoPopupView = (icRepoPopupNotificationView.IClass) icObjectFactory.GetSingletonInstance('icRepoPopupNotificationView');

    @isTest
    static void testRepo(){

        Popup_notification__c popup = new Popup_notification__c();
        popup.Start_Date__c = Date.today();
        popup.End_Date__c = Date.today();
        popup.Active__c = true;
        insert popup;

        Popup_Notification_view__c popupView = new Popup_Notification_view__c();
        popupView.Popup_notification__c = popup.Id;
        popupView.User__c = UserInfo.getUserId();

        repoPopupView.savePopupNotificationView(popupView);

        Popup_Notification_view__c popupViewFromRepo = new Popup_Notification_view__c();

        popupViewFromRepo = repoPopupView.getViewsByNotificationAndUserIds(popup.Id, UserInfo.getUserId());

        system.assertEquals(popupView.Id, popupViewFromRepo.Id);

    }
}