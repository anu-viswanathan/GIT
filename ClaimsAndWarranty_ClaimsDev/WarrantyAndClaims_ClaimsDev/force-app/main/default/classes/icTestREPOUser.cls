/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icTestREPOUser {

    public static testMethod void test_getAccountInfoFromPartnerUser(){

        icRepoUser.IClass repository = (icRepoUser.IClass) icObjectFactory.GetSingletonInstance('icRepoUser');
        repository.getAccountInfoFromPartnerUser(UserInfo.getUserId());

    }
    public static testMethod void test_getOwnerManagerIdByOwnerID(){

        icRepoUser.IClass repository = (icRepoUser.IClass) icObjectFactory.GetSingletonInstance('icRepoUser');
        repository.getOwnerManagerIdByOwnerID(new Set<Id> {UserInfo.getUserId()});

    }

    public static testMethod void test_getLoggedInUserInfo(){
        icRepoUser.IClass repository = (icRepoUser.IClass) icObjectFactory.GetSingletonInstance('icRepoUser');
        repository.getLoggedInUserInfo(UserInfo.getUserId());
    }

}