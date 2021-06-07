/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icLogicUserMock implements icLogicUser.IClass{

    public String getAccountIdFromPartnerUser(String partnerUserId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAccountIdFromPartnerUser');
        params.put('partnerUserId', partnerUserId);
        return (String) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAccountIdFromPartnerUser');
    }

    public User getUserAndAccountFromPartnerUser(String partnerUserId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getUserAndAccountFromPartnerUser');
        params.put('partnerUserId', partnerUserId);
        return (User) icTestMockUtilities.Tracer.GetReturnValue(this, 'getUserAndAccountFromPartnerUser');
    }
    
    public String getContactIdFromUserId(String userId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getContactIdFromUserId');
        params.put('userId', userId);
        return (String) icTestMockUtilities.Tracer.GetReturnValue(this, 'getContactIdFromUserId');
    }

    public icDTOProzoneRemoteAuth getCommunityUserInfoById(String userId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getCommunityUserInfoById');
        params.put('userId', userId);
        return (icDTOProzoneRemoteAuth) icTestMockUtilities.Tracer.GetReturnValue(this, 'getCommunityUserInfoById');
    }

    public User getLoggedInUserInfo(String userId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getLoggedInUserInfo');
        params.put('userId', userId);
        return (User) icTestMockUtilities.Tracer.GetReturnValue(this, 'getLoggedInUserInfo');
    }
    public Map<Id,Id> getOwnerManagerIdByOwnerID( Set<Id> OwnerIds){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getOwnerManagerIdByOwnerID');
        params.put('OwnerIds', OwnerIds);
        return (Map<Id,Id>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getOwnerManagerIdByOwnerID');
    }
}