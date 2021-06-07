/**
 * Created by Francois Poirier on 2019-12-02.
 */

@isTest
public with sharing class icTestLogicPopupNotification {


    @isTest
    static void testGetCurrentPopup() {

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoPopupNotification', new icRepoPopupNotificationMock());
        icLogicPopupNotification.IClass logicPopup = (icLogicPopupNotification.IClass) icObjectFactory.GetSingletonInstance('icLogicPopupNotification');

        Popup_notification__c popup = new Popup_notification__c();
        popup.Start_Date__c = Date.today();
        popup.End_Date__c = Date.today();
        popup.Active__c = true;

        icTestMockUtilities.Tracer.SetReturnValue('icRepoPopupNotificationMock', 'getCurrentPopup', popup);

        logicPopup.getCurrentPopup();

    }

    @isTest
    static void testGetCurrentPopupByTag() {

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoPopupNotification', new icRepoPopupNotificationMock());
        icLogicPopupNotification.IClass logicPopup = (icLogicPopupNotification.IClass) icObjectFactory.GetSingletonInstance('icLogicPopupNotification');

        Popup_notification__c popup = new Popup_notification__c();
        popup.Start_Date__c = Date.today();
        popup.End_Date__c = Date.today();
        String myTag = icTestHelperUtility.generateRandomString(5);
        popup.Tag__c = myTag;
        popup.Active__c = true;

        icTestMockUtilities.Tracer.SetReturnValue('icRepoPopupNotificationMock', 'getCurrentPopupByTag', popup);

        logicPopup.getCurrentPopupByTag(myTag);

    }
}