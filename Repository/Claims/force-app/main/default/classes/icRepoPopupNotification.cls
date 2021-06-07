/**
 * Created by Francois Poirier on 2019-11-29.
 */

public with sharing class icRepoPopupNotification  implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {

        Popup_notification__c getCurrentPopup();
        Popup_notification__c getCurrentPopupByTag(String tag);

    }

    public class Impl implements IClass {

        public Popup_notification__c getCurrentPopup(){

            List<Popup_notification__c> popupNotifications = new List<Popup_notification__c>();
            Popup_notification__c popupNotification = new Popup_notification__c();

            popupNotifications = [
                    SELECT  Id,
                            Active__c,
                            End_Date__c,
                            English_message_Rich__c,
                            French_message_Rich__c,
                            Number_of_time_to_display__c,
                            Start_Date__c,
                            Spanish_message_Rich__c
                    FROM    Popup_notification__c
                    WHERE   Current__c = true
            ];

            if(popupNotifications.size()>0){
                popupNotification = popupNotifications[0];
            }

            return popupNotification;

        }

        public Popup_notification__c getCurrentPopupByTag(String tag){

            List<Popup_notification__c> popupNotifications = new List<Popup_notification__c>();
            Popup_notification__c popupNotification = new Popup_notification__c();

            popupNotifications = [
                    SELECT  Id,
                            Active__c,
                            End_Date__c,
                            English_message_Rich__c,
                            French_message_Rich__c,
                            Number_of_time_to_display__c,
                            Start_Date__c,
                            Spanish_message_Rich__c
                    FROM    Popup_notification__c
                    WHERE   Current__c = true
                    AND     Tag__c = :tag
            ];

            if(popupNotifications.size()>0){
                popupNotification = popupNotifications[0];
            }

            return popupNotification;

        }
    }

}