/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestLogicUser {

    static icLogicUser.IClass BL;
    static User u = new User();
    static Contact c= new Contact();

    static void setup(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoUser', new icREPOUserMock());
        BL = (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');
        c.AccountId = icTestHelperUtility.getFakeId(Account.SObjectType);
        c.Id = icTestHelperUtility.getFakeId(Contact.SObjectType);
        u.Contact=c;
        u.ContactId = c.Id;

        icTestMockUtilities.Tracer.SetReturnValue('icREPOUserMock', 'getAccountInfoFromPartnerUser', u);
    }

    public static testMethod void test_getAccountIdFromPartnerUser(){

        setup();
        BL.getAccountIdFromPartnerUser('');

    }

    @isTest static void testgetContactIdFromUserId(){

        setup();
        BL.getContactIdFromUserId(icTestHelperUtility.getFakeId(User.SObjectType));

    }

    @isTest static void testgetCommunityUserInfoById(){

        setup();
        icDTOProzoneRemoteAuth result = BL.getCommunityUserInfoById(icTestHelperUtility.getFakeId(User.SObjectType));

    }

    @isTest static void testgetUserAndAccountFromPartnerUser() {

        setup();
        BL.getUserAndAccountFromPartnerUser(icTestHelperUtility.getFakeId(User.SObjectType));

    }

    @isTest static void test_getLoggedInUserInfo() {
        setup();
        BL.getLoggedInUserInfo(icTestHelperUtility.getFakeId(User.SObjectType));
    }

    @isTest static void testgetOwnerManagerIdByOwnerID() {

        setup();
        icTestMockUtilities.Tracer.SetReturnValue('icREPOUserMock', 'getOwnerManagerIdByOwnerID', new List<User>{new User()});
        BL.getOwnerManagerIdByOwnerID(new Set<Id> {icTestHelperUtility.getFakeId(User.SObjectType)});
    }
}