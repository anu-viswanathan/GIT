/**
 * Created by Francois Poirier on 2019-12-02.
 */

@isTest
public with sharing class icTestLogicPopupNotificationView {

    @isTest
    static void testGetViewsByNotificationAndUserIds(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoPopupNotificationView', new icRepoPopupNotificationViewMock());
        icLogicPopupNotificationView.IClass logicPopupView = (icLogicPopupNotificationView.IClass) icObjectFactory.GetSingletonInstance('icLogicPopupNotificationView');

        icTestMockUtilities.Tracer.SetReturnValue('icRepoPopupNotificationViewMock', 'getViewsByNotificationAndUserIds', new Popup_Notification_view__c());

        Popup_Notification_view__c popupView = new Popup_Notification_view__c();

        popupView = logicPopupView.getViewsByNotificationAndUserIds(icTestHelperUtility.getFakeId(Popup_Notification__c.SObjectType), UserInfo.getUserId());

    }

    @isTest
    static void testSavePopupNotificationView(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoPopupNotificationView', new icRepoPopupNotificationViewMock());
        icLogicPopupNotificationView.IClass logicPopupView = (icLogicPopupNotificationView.IClass) icObjectFactory.GetSingletonInstance('icLogicPopupNotificationView');
        Popup_Notification_view__c popupView = new Popup_Notification_view__c();

        logicPopupView.savePopupNotificationView(popupView);

    }
}