public with sharing class icLogicUser implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		String getAccountIdFromPartnerUser(String partnerUserId);
		User getUserAndAccountFromPartnerUser(String partnerUserId);
		String getContactIdFromUserId(String userId);
		icDTOProzoneRemoteAuth getCommunityUserInfoById(String userId);
		User getLoggedInUserInfo(String userId);
		Map<Id,Id> getOwnerManagerIdByOwnerID( Set<Id> OwnerIds);
	}

	public class Impl implements IClass {

		icRepoUser.IClass repo = (icRepoUser.IClass) icObjectFactory.GetSingletonInstance('icRepoUser');
		
		public String getAccountIdFromPartnerUser(String partnerUserId) {
			String returnAccountId;
			User thisPartnerUserInfo = repo.getAccountInfoFromPartnerUser(partnerUserId);
			if(thisPartnerUserInfo != null && thisPartnerUserInfo.Contact != null) {
				returnAccountId = thisPartnerUserInfo.Contact.AccountId;
			}
			return returnAccountId;
		}

		public User getUserAndAccountFromPartnerUser(String partnerUserId){
			
			User tmpUser = new User();
			tmpUser = repo.getAccountInfoFromPartnerUser(partnerUserId);

			return tmpUser;

		}
		public String getContactIdFromUserId(String userId) {
			String returnContactId;
			User thisPartnerUserInfo = repo.getAccountInfoFromPartnerUser(userId);
			if(thisPartnerUserInfo != null && thisPartnerUserInfo.ContactId != null) {
				returnContactId = thisPartnerUserInfo.ContactId;
			}
			return returnContactId;
		}

		public icDTOProzoneRemoteAuth getCommunityUserInfoById (String userId) {
			icDTOProzoneRemoteAuth dtoCommunityUser = new icDTOProzoneRemoteAuth();

			User thisPartnerUserInfo = repo.getAccountInfoFromPartnerUser(userId);
			if(thisPartnerUserInfo != null && thisPartnerUserInfo.ContactId != null) {
				dtoCommunityUser.accountId = thisPartnerUserInfo.Contact.AccountId;
				dtoCommunityUser.userLanguage = thisPartnerUserInfo.LanguageLocaleKey;
			}
			return dtoCommunityUser;
		}
		
		public User getLoggedInUserInfo(String userId) {
			return repo.getLoggedInUserInfo(userId);
		}

		// return un Maps of Id User to Id Manager
		public Map<Id,Id> getOwnerManagerIdByOwnerID( Set<Id> OwnerIds){
			map<id,id> UserManagers = new map<id,id>();
			List<User> thisUserManagers = repo.getOwnerManagerIdByOwnerID(OwnerIds);
			for (User userManager : thisUserManagers){
				if(userManager.Id != null && userManager.ManagerId != null){
					UserManagers.put( userManager.Id, userManager.ManagerId); 
				}	
			}
			return UserManagers;
		}
	}
}