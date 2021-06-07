/**
 * Created by Francois Poirier on 2019-12-02.
 */

public with sharing class icRepoPopupNotificationViewMock implements icRepoPopupNotificationView.IClass {

    public Popup_Notification_view__c getViewsByNotificationAndUserIds(Id popupId, Id userId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getViewsByNotificationAndUserIds');
        params.put('popupId', popupId);
        params.put('userId', userId);
        return (Popup_Notification_view__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'getViewsByNotificationAndUserIds');
    }

    public void savePopupNotificationView(Popup_Notification_view__c popupView) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'savePopupNotificationView');
        params.put('popupView', popupView);
    }
}