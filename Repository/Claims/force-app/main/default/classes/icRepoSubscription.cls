public with sharing class icRepoSubscription implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		List<IKOPRO_Contractor_Subscription__c> getSubscriptionsByAccountIdAndRecordTypeId(String accountId, String recordTypeId);
		void createSubscription(IKOPRO_Contractor_Subscription__c subscription);
		void updateSubscription(IKOPRO_Contractor_Subscription__c subscription);
	}

	public class Impl implements IClass {
		
		public List<IKOPRO_Contractor_Subscription__c> getSubscriptionsByAccountIdAndRecordTypeId(String accountId, String recordTypeId) {
			return [SELECT Id, Name, Username__c, Membership_ID__c, Password__c, SourceId__c, Client_Secret__c FROM IKOPRO_Contractor_Subscription__c WHERE Contractor_Account__c =:accountId AND RecordTypeId =:recordTypeId];
		}

		public void createSubscription(IKOPRO_Contractor_Subscription__c subscription) {
			insert subscription;
		}

		public void updateSubscription(IKOPRO_Contractor_Subscription__c subscription) {
			update subscription;
		}
	}
}