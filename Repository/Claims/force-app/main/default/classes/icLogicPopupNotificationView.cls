/**
 * Created by Francois Poirier on 2019-11-29.
 */

public with sharing class icLogicPopupNotificationView implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {

        Popup_Notification_view__c getViewsByNotificationAndUserIds(Id popupId, Id userId);
        void savePopupNotificationView(Popup_Notification_view__c popupView);

    }

    public class Impl implements IClass {

        icRepoPopupNotificationView.IClass repoPopupView = (icRepoPopupNotificationView.IClass) icObjectFactory.GetSingletonInstance('icRepoPopupNotificationView');

        public Popup_Notification_view__c getViewsByNotificationAndUserIds(Id popupId, Id userId){

            return repoPopupView.getViewsByNotificationAndUserIds(popupId, userId);

        }

        public void savePopupNotificationView(Popup_Notification_view__c popupView){

            repoPopupView.savePopupNotificationView(popupView);

        }
    }


}