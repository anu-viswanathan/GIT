public with sharing class icLogicSubscription implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		List<IKOPRO_Contractor_Subscription__c> getEagleViewSubscriptionForCustomer(String accountId);
		void createEagleViewSubscription(String customerId, String eagleviewUsername);
		void updateEagleViewSubscription(IKOPRO_Contractor_Subscription__c subscription);
		IKOPRO_Contractor_Subscription__c getGreenSkySubscriptionForCustomer(String accountId);
		void createGreenSkySubscription(icDTOGreenSkySubscription gsSubscription);
	}

	public class Impl implements IClass {

		icRepoSubscription.IClass repo = (icRepoSubscription.IClass) icObjectFactory.GetSingletonInstance('icRepoSubscription');
		icLogicUser.IClass userLogic = (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');

		public List<IKOPRO_Contractor_Subscription__c> getEagleViewSubscriptionForCustomer(String accountId) {
			String eagleViewSubscriptionRecordTypeId = Schema.SObjectType.IKOPRO_Contractor_Subscription__c.getRecordTypeInfosByName().get('EagleView').getRecordTypeId();
			return repo.getSubscriptionsByAccountIdAndRecordTypeId(accountId, eagleViewSubscriptionRecordTypeId);
		}

		public void createEagleViewSubscription(String customerId, String eagleviewUsername) {
			String recordTypeEagleView = Schema.SObjectType.IKOPRO_Contractor_Subscription__c.getRecordTypeInfosByName().get('EagleView').getRecordTypeId();

			IKOPRO_Contractor_Subscription__c newSubscription = new IKOPRO_Contractor_Subscription__c(RecordTypeId = recordTypeEagleView, Contractor_Account__c = customerId, Username__c = eagleviewUsername);

			repo.createSubscription(newSubscription);
		}

		public void updateEagleViewSubscription(IKOPRO_Contractor_Subscription__c subscription) {			
			repo.updateSubscription(subscription);
		}

		public IKOPRO_Contractor_Subscription__c getGreenSkySubscriptionForCustomer(String accountId){
			List<IKOPRO_Contractor_Subscription__c> subscriptions = new List<IKOPRO_Contractor_Subscription__c>();
			IKOPRO_Contractor_Subscription__c retour = new IKOPRO_Contractor_Subscription__c();

			String greenSkyRecordTypeId = Schema.SObjectType.IKOPRO_Contractor_Subscription__c.getRecordTypeInfosByName().get('GreenSky').getRecordTypeId();

			subscriptions = repo.getSubscriptionsByAccountIdAndRecordTypeId(accountId, greenSkyRecordTypeId);
			if(subscriptions.size()>0){
				retour = subscriptions[0];
			}
			return retour;
		}

		public void createGreenSkySubscription(icDTOGreenSkySubscription gsSubscription){

			IKOPRO_Contractor_Subscription__c newSubscription = new IKOPRO_Contractor_Subscription__c();
			String greenSkyRecordTypeId = Schema.SObjectType.IKOPRO_Contractor_Subscription__c.getRecordTypeInfosByName().get('GreenSky').getRecordTypeId();

			newSubscription.Membership_ID__c = gsSubscription.merchantId;
			newSubscription.Username__c = gsSubscription.userName;
			newSubscription.Password__c = gsSubscription.password;
			newSubscription.Client_Secret__c = gsSubscription.apiKey;
			newSubscription.Contractor_Account__c = userLogic.getAccountIdFromPartnerUser(UserInfo.getUserId());
			newSubscription.RecordTypeId = greenSkyRecordTypeId;

			repo.createSubscription(newSubscription);

		}

	}
}