/**
 * Created by Francois Poirier on 2019-11-01.
 */

global with sharing class icCtrlMembershipRenewal {

    static icLogicUser.IClass logicUser = (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');

    @AuraEnabled
    global static icDTOMembershipRenewal getMembershipInfos(String accountId, String accountPaymentId){

        icDTOMembershipRenewal retour = new icDTOMembershipRenewal();
        retour.remoteAuth = new icDTOProzoneRemoteAuth();
        retour.remoteAuth = logicUser.getCommunityUserInfoById(UserInfo.getUserId());
        system.debug('user Id in membership renewal ===> ' + UserInfo.getUserId());
        String sId = UserInfo.getSessionId();
        system.debug('session Id in membership renewal ===> ' + sId);
        retour.remoteAuth.accountId = accountId;
        retour.remoteAuth.sessionId = UserInfo.getSessionId();
        retour.accountPaymentId = accountPaymentId;

        return retour;

    }

}