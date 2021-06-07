/**
 * Created by Francois Poirier on 2019-05-15.
 */

global with sharing class icCtrlMedAccountId {

    static icLogicUser.IClass logicUser = (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');

    @AuraEnabled
    global static String getAccountId(){


        return logicUser.getAccountIdFromPartnerUser(UserInfo.getUserId());

    }
}