public class icRepoLead implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		List<Lead> getNewLeadsByAccountId(String recordId, String ownerId);
	}

	public class Impl implements IClass {

		public List<Lead> getNewLeadsByAccountId(String recordId, String ownerId) {
			String currentUserId = UserInfo.getUserId();
			List<Lead> listLeads = new List<Lead>();
			listLeads = [SELECT	Id
							,Name
					FROM	Lead
					WHERE	IsUnreadByOwner = true];
			//Referred_Customer__c = :recordId
			/*
							AND	(
								OwnerId = :currentUserId
								OR
								OwnerId = :ownerId
							)
			*/
			return listLeads;
		}
	}
}