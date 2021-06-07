/**
 * Created by Francois Poirier on 2019-11-29.
 */
@isTest
public with sharing class icRepoPopupNotificationMock implements icRepoPopupNotification.IClass {


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