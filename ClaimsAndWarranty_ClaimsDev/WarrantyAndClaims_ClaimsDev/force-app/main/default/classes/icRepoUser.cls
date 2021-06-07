public with sharing class icRepoUser implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		User getAccountInfoFromPartnerUser(String partnerUserId);
		User getLoggedInUserInfo(String userId);
		List<User> getOwnerManagerIdByOwnerID(Set<ID> ownerIds);
	}

	public class Impl implements IClass {
		public User getAccountInfoFromPartnerUser(String partnerUserId) {
			return [SELECT 	Id,
							ContactId,
							Contact.AccountId,
							Contact.Account.Tier_Number__c,
							Contact.Account.Present_Tier_Lookup__r.Tier_Label__c,
							Contact.Account.BillingCountry,
							LanguageLocaleKey,
							ROOFPRO_Portal_Language__c,
							Contact.FirstName,
							Contact.LastName,
							Contact.Email,
							Contact.MobilePhone,
							Contact.Phone
					FROM User
					WHERE Id =:partnerUserId];
		}

		public User getLoggedInUserInfo(String userId) {
			return  [SELECT Id,
							UserName,
							UserRole.Name,
							Profile.Name
					 FROM User
					 WHERE Id =:userId];
		}

		public List<User> getOwnerManagerIdByOwnerID(Set<ID> ownerIds) {
			return  [SELECT Id,
							ManagerId
					 FROM 	User
					 WHERE  Id in :ownerIds];
		}
	}
}