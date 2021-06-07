/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icREPOUserMock implements icRepoUser.IClass{
    public User getAccountInfoFromPartnerUser(String partnerUserId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAccountInfoFromPartnerUser');
        params.put('partnerUserId', partnerUserId);
        return (User) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAccountInfoFromPartnerUser');
    }

    public User getLoggedInUserInfo(String userId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getLoggedInUserInfo');
        params.put('userId', userId);
        return (User) icTestMockUtilities.Tracer.GetReturnValue(this, 'getLoggedInUserInfo');
    }

    public List<User> getOwnerManagerIdByOwnerID(Set<ID> ownerIds) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getOwnerManagerIdByOwnerID');
        params.put('ownerIds', ownerIds);
        return (List<User>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getOwnerManagerIdByOwnerID');
    }
}