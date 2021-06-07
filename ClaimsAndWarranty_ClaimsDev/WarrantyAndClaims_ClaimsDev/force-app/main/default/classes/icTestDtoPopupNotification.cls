/**
 * Created by Francois Poirier on 2019-12-02.
 */

@isTest
public with sharing class icTestDtoPopupNotification {

    @isTest
    static void testDto(){

        icDtoPopupNotification dto = new icDtoPopupNotification();
        dto.notificationViewId = icTestHelperUtility.getFakeId(Popup_Notification_view__c.SObjectType);
        dto.message = icTestHelperUtility.generateRandomString(20);
        dto.showMessage = true;

    }
}