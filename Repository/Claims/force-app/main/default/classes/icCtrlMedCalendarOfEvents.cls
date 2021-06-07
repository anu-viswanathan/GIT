/**
 * Created by Francois Poirier on 2019-06-03.
 */

global with sharing class icCtrlMedCalendarOfEvents {

    @AuraEnabled
    global static String getCurrentTheme(){
        return UserInfo.getUiThemeDisplayed();
    }

}