/**
 * Created by Francois Poirier on 2019-11-29.
 */

public with sharing class icLogicPopupNotification implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {

        Popup_notification__c getCurrentPopup();
        Popup_notification__c getCurrentPopupByTag(String tag);

    }

    public class Impl implements IClass {

        icRepoPopupNotification.IClass repoPopup = (icRepoPopupNotification.IClass) icObjectFactory.GetSingletonInstance('icRepoPopupNotification');

        public Popup_notification__c getCurrentPopup() {

            return repoPopup.getCurrentPopup();

        }

        public Popup_notification__c getCurrentPopupByTag(String tag){

            return repoPopup.getCurrentPopupByTag(tag);

        }
    }

}