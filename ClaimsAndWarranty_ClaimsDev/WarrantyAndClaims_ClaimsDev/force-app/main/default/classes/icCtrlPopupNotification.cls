/**
 * Created by Francois Poirier on 2019-11-29.
 */

global with sharing class icCtrlPopupNotification {


    static icLogicPopupNotification.IClass logicPopupNotifcation = (icLogicPopupNotification.IClass) icObjectFactory.GetSingletonInstance('icLogicPopupNotification');
    static icLogicPopupNotificationView.IClass logicPopupNotifcationView = (icLogicPopupNotificationView.IClass) icObjectFactory.GetSingletonInstance('icLogicPopupNotificationView');
    static icLogicUser.IClass logicUser = (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');

    @AuraEnabled global static icDtoPopupNotification getPopupNotification(){

        icDtoPopupNotification dtoNotification = new icDtoPopupNotification();

        Popup_notification__c notification = new Popup_notification__c();

        notification = logicPopupNotifcation.getCurrentPopup();
        system.debug('notification ====> ' + notification);

        dtoNotification = validateNofication(notification);

        return dtoNotification;

    }

    @AuraEnabled global static icDtoPopupNotification getPopupNotificationByTag(String tag){

        icDtoPopupNotification dtoNotification = new icDtoPopupNotification();

        Popup_notification__c notification = new Popup_notification__c();

        system.debug('tag ===> ' + tag);
        notification = logicPopupNotifcation.getCurrentPopupByTag(tag);
        system.debug('notification ====> ' + notification);

        dtoNotification = validateNofication(notification);

        return dtoNotification;

    }

    @AuraEnabled global static void stopShowingPopupNotification(String notificationViewId){

        Popup_Notification_view__c popupNotificationView = new Popup_Notification_view__c();
        popupNotificationView.Id = notificationViewId;
        popupNotificationView.Do_not_show_again__c = true;
        logicPopupNotifcationView.savePopupNotificationView(popupNotificationView);

    }


    private static icDtoPopupNotification validateNofication(Popup_notification__c notification){
        icDtoPopupNotification dtoNotification = new icDtoPopupNotification();
        dtoNotification.showMessage = false;


        Popup_Notification_view__c notificationView = new Popup_Notification_view__c();
        User currentUser = new User();

        currentUser = logicUser.getUserAndAccountFromPartnerUser(UserInfo.getUserId());
        system.debug('current user ====> ' + currentUser);
        //currentUser = logicUser.getUserAndAccountFromPartnerUser('0051F000004sBhR');

        if(String.isNotBlank(notification.Id)){
            notificationView = logicPopupNotifcationView.getViewsByNotificationAndUserIds(notification.Id, currentUser.Id);
            if(notificationView.Number_of_views__c == null) {
                notificationView.Number_of_views__c = 0;
                notificationView.Popup_notification__c = notification.Id;
                notificationView.User__c = currentUser.Id;
                notificationView.Do_not_show_again__c = false;
            }
            notificationView.Number_of_views__c ++;

            if (notificationView.Number_of_views__c <= notification.Number_of_time_to_display__c && !notificationView.Do_not_show_again__c) {
                dtoNotification.showMessage = true;

                logicPopupNotifcationView.savePopupNotificationView(notificationView);

                dtoNotification.notificationViewId = notificationView.Id;

                if (currentUser.ROOFPRO_Portal_Language__c == 'English') {

                    dtoNotification.message = notification.English_Message_Rich__c;

                }
                if (currentUser.ROOFPRO_Portal_Language__c == 'Quebec French') {

                    dtoNotification.message = notification.French_Message_Rich__c;

                }

                if (currentUser.ROOFPRO_Portal_Language__c == 'Spanish') {

                    dtoNotification.message = notification.Spanish_Message_Rich__c;

                }

            }

        }

        return dtoNotification;
    }
}