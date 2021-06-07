/**
 * Created by Francois Poirier on 2019-12-02.
 */

public with sharing class icLogicPopupNotificationMock implements icLogicPopupNotification.IClass{

    public Popup_notification__c getCurrentPopup() {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getCurrentPopup');
        return (Popup_notification__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'getCurrentPopup');
    }

    public Popup_notification__c getCurrentPopupByTag(String tag) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getCurrentPopupByTag');
        params.put('tag', tag);
        return (Popup_notification__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'getCurrentPopupByTag');
    }


}