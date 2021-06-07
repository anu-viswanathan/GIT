// 2019-12-17 Skot
// Modified as per this support article https://success.salesforce.com/issues_view?id=a1p300000008XHfAAM
// Chatter answers is a deprecated feature
// this test fails. Yay.

@isTest
private class ChatterAnswersAuthProviderRegTest {

    /*
    
    static testMethod void validateCreateUpdateUser() {
Auth.UserData userData = new Auth.UserData('testId', 'testFirst', 'testLast',
'testFirst testLast', 'no-reply@salesforce.com', null, 'testuserlong', 'en_US', 'facebook',
null, new Map<String, String>{'language' => 'en_US'});
ChatterAnswersAuthProviderRegistration reg = new ChatterAnswersAuthProviderRegistration();
User newUser = reg.createUser(null, userData);
System.assert(newUser == null);


Auth.UserData updateUserData = new Auth.UserData('testId', 'updatedFirst', 'updatedLast',
'updatedFirst updatedLast', 'no-reply@new.salesforce.com', null, 'testuserlong', 'en_US', 'facebook',
null, new Map<String, String>{'language' => 'en_US'});
reg.updateUser(newUser.Id, null, updateUserData);
}

*/
}