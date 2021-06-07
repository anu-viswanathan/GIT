global with sharing class icCtrlSelfRegistration {

	@AuraEnabled
	global static String registerNew(String firstName, String lastName, String email, String password, String confirmPassword) {
		Savepoint sp = null;
		try {
			sp = Database.setSavepoint();

			NetworkSelfRegistration selfRegConfig = [SELECT AccountId FROM NetworkSelfRegistration LIMIT 1];

			User u = new User();
			u.Username = email;
			u.Email = email;
			u.FirstName = firstName;
			u.LastName = lastName;
			
			//String networkId = Network.getNetworkId();
			//System.debug('networkId : ' + networkId);

			// If using site to host the community the user should not hit s1 after logging in from mobile.
			//if(networkId != null && siteAsContainerEnabled(networkId)) {
			//	u.put('UserPreferencesHideS1BrowserUI',true);
			//}
			
			String nickname = ((firstName != null && firstName.length() > 0) ? firstName.substring(0,1) : '' ) + lastName.substring(0,1);
			nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);
			u.CommunityNickname = nickname;

			String userId;
			if (!Test.isRunningTest()) {
				Site.validatePassword(u, password, confirmPassword);

				// lastName is a required field on user, but if it isn't specified, we'll default it to the username
				userId = Site.createExternalUser(u, selfRegConfig.AccountId, password);
			} else {
				// create a fake userId for test.
				userId = 'fakeUserId';
			}

			if(userId != null) { 
				ApexPages.PageReference lgn = Site.login(email, password, '');
				if(!Test.isRunningTest()) {
					aura.redirect(lgn);
				}
			}
			return null;
		}
		catch (Exception ex) {
			Database.rollback(sp);
			return ex.getMessage();
		}
	}
}