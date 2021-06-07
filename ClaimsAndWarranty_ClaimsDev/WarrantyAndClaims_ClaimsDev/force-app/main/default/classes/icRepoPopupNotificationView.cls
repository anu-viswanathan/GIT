/**
 * Created by Francois Poirier on 2019-11-29.
 */

public with sharing class icRepoPopupNotificationView implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {

        Popup_Notification_view__c getViewsByNotificationAndUserIds(Id popupId, Id userId);
        void savePopupNotificationView(Popup_Notification_view__c popupView);

    }

    public class Impl implements IClass {

        public Popup_Notification_view__c getViewsByNotificationAndUserIds(Id popupId, Id userId){

            Popup_Notification_view__c popupView = new Popup_Notification_view__c();
            List<Popup_Notification_view__c> popupViews = new List<Popup_Notification_view__c>();

            popupViews = [
                    SELECT  Id,
                            Do_not_show_again__c,
                            Number_of_views__c
                    FROM    Popup_Notification_view__c
                    WHERE   Popup_notification__c = :popupId
                    AND     User__c = :userId
            ];

            if(popupViews.size()>0){
                popupView = popupViews[0];
            }

            return popupView;

        }

        public void savePopupNotificationView(Popup_Notification_view__c popupView){

            upsert popupView;

        }
    }

}