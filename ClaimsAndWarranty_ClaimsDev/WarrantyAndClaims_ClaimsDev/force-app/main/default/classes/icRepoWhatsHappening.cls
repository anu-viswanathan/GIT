public class icRepoWhatsHappening implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		List<What_s_Happening__c> getActiveWhatHappeningByLanguageAndCommunityName(String language, String communityName);
	}

	public class Impl implements IClass {

		public List<What_s_Happening__c> getActiveWhatHappeningByLanguageAndCommunityName(String language, String communityName) {
            System.debug('----'+language + ' community name is ' + communityName);
			return [SELECT	Id
							,Name
							,Image_Id__c
							,Title__c
							,Description__c
							,Link_Type__c
							,Link_Label__c
							,External_Link__c
							,Internal_Community_Link__c
							,Internal_Mobile_Link__c
							,Email_Recipient__c
					FROM	What_s_Happening__c
					WHERE	Active__c = true
					AND		Content_Language__c =: language
					AND 	Publish_in__c INCLUDES(:communityName)
					ORDER BY Order__c];
		}
	}
}