/**
 * Created by Francois Poirier on 2019-12-02.
 */

@isTest
public with sharing class icTestCtrlPopupNotification {

    @isTest
    static void testGetPopupNotification(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicPopupNotification', new icLogicPopupNotificationMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicPopupNotificationView', new icLogicPopupNotificationViewMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicUser', new icLogicUserMock());

        User testUser = new User();

        testUser.Id = icTestHelperUtility.getFakeId(User.SObjectType);

        icTestMockUtilities.Tracer.SetReturnValue('icLogicUserMock', 'getUserAndAccountFromPartnerUser', testUser);

        Popup_notification__c popup = new Popup_notification__c();
        popup.Start_Date__c = Date.today();
        popup.End_Date__c = Date.today();
        popup.Active__c = true;
        popup.Number_of_time_to_display__c = 10;
        popup.English_message__c = icTestHelperUtility.generateRandomString(20);
        popup.French_message__c = icTestHelperUtility.generateRandomString(20);
        popup.Spanish_message__c = icTestHelperUtility.generateRandomString(20);
        popup.Id = icTestHelperUtility.getFakeId(Popup_Notification__c.SObjectType);
        String myTag = icTestHelperUtility.generateRandomString(5);
        popup.Tag__c = myTag;


        icTestMockUtilities.Tracer.SetReturnValue('icLogicPopupNotificationMock', 'getCurrentPopup', popup);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicPopupNotificationMock', 'getCurrentPopupByTag', popup);

        //test null number of views & English message
        icTestMockUtilities.Tracer.SetReturnValue('icLogicPopupNotificationViewMock', 'getViewsByNotificationAndUserIds', new Popup_Notification_view__c());
        testUser.ROOFPRO_Portal_Language__c = 'English';

        icCtrlPopupNotification.getPopupNotification();
        icCtrlPopupNotification.getPopupNotificationByTag(myTag);

        //test valid number pf views & French message
        Popup_Notification_view__c popupView = new Popup_Notification_view__c();
        popupView.Number_of_views__c = 1;

        icTestMockUtilities.Tracer.SetReturnValue('icLogicPopupNotificationViewMock', 'getViewsByNotificationAndUserIds', popupView);
        testUser.ROOFPRO_Portal_Language__c = 'Quebec French';
        icCtrlPopupNotification.getPopupNotification();

        //test Spanish message
        testUser.ROOFPRO_Portal_Language__c = 'Spanish';
        icCtrlPopupNotification.getPopupNotification();

    }

    @isTest
    static void testStopShowingPopupNotification(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicPopupNotificationView', new icLogicPopupNotificationViewMock());

        icCtrlPopupNotification.stopShowingPopupNotification(icTestHelperUtility.getFakeId(Popup_Notification_view__c.SObjectType));
        
    }

}