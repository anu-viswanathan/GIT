public class icRepoAccount implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		Contact getPersonAcountInfoById(String recordId);
		Account getAcountInfoById(String recordId);
		List<Account> getAcountsInfoByIds(List<Id> accountIds);
		Account getAcountByHARefKey(String haRefKey);
		Account getContractorContactUsInfo(String customerId);
		List<Account> getContractorsWithExpiringFunds();
		Account saveAccount(Account record);
		List<Database.SaveResult> saveAccounts(List<Account> accounts);
		List<Account> getAccountsByMapicsExternalId(Set<String> externalId);
	}

	public class Impl implements IClass {

		public Contact getPersonAcountInfoById(String recordId) {
			List<Contact> listContact = [SELECT	Id
							,FirstName
							,LastName
							,Email
					FROM	Contact
					WHERE	AccountId = :recordId
					LIMIT	1];
			if(listContact.size() == 1) {
				return listContact[0];
			}
			return null;
		}

		public Account getAcountInfoById(String recordId) {
			List<Account> listAccount = [SELECT	Id
							,Name
							,IKOPRO_Approved_On__c
							,Quote_Logo__c
							,BillingStreet
							,BillingCity
							,BillingState
							,BillingCountry
							,BillingPostalCode
							,IKOPRO_QueueID__c
							,Available_COOP_Funds__c
							,Central_Station_Short_URL__c
							,Hide_Upcoming_Coop_Rewards__c
							,Present_Tier_Formula__c
					FROM	Account
					WHERE	Id = :recordId
					LIMIT	1];
			if(listAccount.size() == 1) {
				return listAccount[0];
			}
			return null;
		}

		public List<Account> getAcountsInfoByIds(List<Id> accountIds){

			List<Account> listAccount = new List<Account>();
			listAccount =
				[SELECT	Id,
						Name,
						DBA_Account__c,
						Website,
						Contractor_ID__c,
						Contractor_Name_Formula__c,
						IKOPRO_QueueID__c,
						Phone,
						Fax,
						BillingStreet,
						BillingCity,
						BillingState,
						BillingStateCode__c,
						BillingPostalCode,
						BillingCountry,
						IsPartner__c,
						IsPartner,
						IKO_com__c,
						Applicant_Information__r.Wants_To_Be_Listed_On_IKO_com__c,
						Tier_Prozone__c,
                        Admin_Email_Address__c,
						Language_Preferences__c,
						Business_Operating_Language_ROOFPRO__c
				FROM	Account
				WHERE	Id IN: accountIds];

			return listAccount;
		}

		public Account getAcountByHARefKey(String haRefKey) {
			List<Account> listAccount = [SELECT	Id
							,Name
					FROM	Account
					WHERE	IKOPRO_QueueID__c = :haRefKey
					LIMIT	1];
			if(listAccount.size() == 1) {
				return listAccount[0];
			}
			return null;
		}

		public Account getContractorContactUsInfo(String customerId) {
			List<Account> listAccount = [SELECT	Id
							,Name
							,Sales_Rep_Info__c
							,Owner.Name
							,Owner.Phone
							,Owner.MobilePhone
							,Owner.Email
					FROM	Account
					WHERE	Id = :customerId
					LIMIT	1];
			if(listAccount.size() == 1) {
				return listAccount[0];
			}
			return null;
		}

		public List<Account> getContractorsWithExpiringFunds() {
			return [SELECT Id, Name, Available_COOP_Funds__c, Available_Premium_COOP_Funds__c FROM Account WHERE Available_COOP_Funds__c > 0 OR Available_Premium_COOP_Funds__c > 0];
		}

		public Account saveAccount(Account reccord){
			upsert reccord;
			return reccord;
		}

		public List<Database.SaveResult> saveAccounts(List<Account> accounts){
			return Database.update(accounts, false);
		}

		/**
         * Query salesforce for a list of Account by Mapics external Id
         *
         * @param   externalId  a unique list of Mapics external ids
         * @return  a list of accounts
         */
		public List<Account> getAccountsByMapicsExternalId(Set<String> externalId) {
			return [SELECT Id, Name, OwnerId, Mapics_ERP_ID__c FROM Account WHERE Mapics_ERP_ID__c IN :externalId];
		}
	}
}