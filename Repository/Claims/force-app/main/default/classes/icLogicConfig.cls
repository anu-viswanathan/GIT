public with sharing class icLogicConfig implements icIClass {

	public Object GetInstance(){
		return new Impl();
	}

	public interface IClass {
		API_Configuration__mdt getAPIConfigByName(String configName);
		Iko_Global_Configurations__mdt getIkoGlobalConfigByName(String configName);
		CommunitySiteNameConfiguration__mdt getCommunitySiteNameConfigByName(String configName);
	}

	public class Impl implements IClass {
		icRepoConfig.IClass repository = (icRepoConfig.IClass) icObjectFactory.GetSingletonInstance('icRepoConfig');

		public API_Configuration__mdt getAPIConfigByName(String configName) {
			return repository.getAPIConfigByName(configName);
		}

		public Iko_Global_Configurations__mdt getIkoGlobalConfigByName(String configName) {
			return repository.getIkoGlobalConfigByName(configName);
		}
 		//Added for IKO-360 by Dominic Boivin on 06-10-2020
		public CommunitySiteNameConfiguration__mdt getCommunitySiteNameConfigByName(String configName) {
			return repository.getCommunitySiteNameConfigByName(configName);
		}
        
	}
}