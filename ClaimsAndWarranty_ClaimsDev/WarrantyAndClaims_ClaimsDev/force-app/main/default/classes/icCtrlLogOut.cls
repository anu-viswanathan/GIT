/**
 * Created by Francois Poirier on 2019-02-12.
 */

global with sharing class icCtrlLogOut {

    @AuraEnabled
    global static String getBaseURL(){
        return Site.getBaseURL();
    }
}