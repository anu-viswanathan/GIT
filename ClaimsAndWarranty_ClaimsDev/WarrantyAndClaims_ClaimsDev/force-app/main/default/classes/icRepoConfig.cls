public with sharing class icRepoConfig implements icIClass {

	public Object GetInstance(){
		return new Impl();
	}

	public interface IClass {
		API_Configuration__mdt getAPIConfigByName(String configName);
		Iko_Global_Configurations__mdt getIkoGlobalConfigByName(String configName);
		CommunitySiteNameConfiguration__mdt getCommunitySiteNameConfigByName(String configName);
	}

	public class Impl implements IClass {

		public API_Configuration__mdt getAPIConfigByName(String configName) {
			API_Configuration__mdt returnConfig;
			
			List<API_Configuration__mdt> returnConfigs = 
				[SELECT 	Id, 
							Label,
							Endpoint__c,
							Username__c,
							Password__c,
							Source_Id__c,
							Client_Secret__c,
							Client_Id__c,
							Token__c
				FROM API_Configuration__mdt
				WHERE DeveloperName =:configName];

			if(returnConfigs.size() > 0) {
				returnConfig = returnConfigs[0];
			}

			return returnConfig;
		}

		public Iko_Global_Configurations__mdt getIkoGlobalConfigByName(String configName) {
			Iko_Global_Configurations__mdt returnConfig;
			
			List<Iko_Global_Configurations__mdt> returnConfigs = 
				[SELECT 	Id, 
							Label,
							Default_Vendor_Email__c,
							Vendor_Email_CA__c,
							Vendor_Email_US__c
				FROM Iko_Global_Configurations__mdt
				WHERE DeveloperName =:configName];

			if(returnConfigs.size() > 0) {
				returnConfig = returnConfigs[0];
			}

			return returnConfig;
		}
		
		//Added for IKO-360 by Dominic Boivin on 06-10-2020
		public CommunitySiteNameConfiguration__mdt getCommunitySiteNameConfigByName(String configName) {
			CommunitySiteNameConfiguration__mdt returnConfig;
			
			List<CommunitySiteNameConfiguration__mdt> returnConfigs = 
				[SELECT 	Id, 
							Label,
							CommunityName__c,
							CommunityNameGlobalSetValue__c
							
				FROM CommunitySiteNameConfiguration__mdt
				WHERE DeveloperName =:configName];

			if(returnConfigs.size() > 0) {
				returnConfig = returnConfigs[0];
			}

			return returnConfig;
		}
	}
}