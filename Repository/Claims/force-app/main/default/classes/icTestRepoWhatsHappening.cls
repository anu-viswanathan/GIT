@isTest
public with sharing class icTestRepoWhatsHappening {
	public static testMethod void test_getActiveWhatHappeningByLanguageAndCommunityName(){
		What_s_Happening__c newWhatHappening = new What_s_Happening__c(Name = 'new name'
			,Image_Id__c = 'new image ref'
			,Title__c = 'new title'
			,Description__c = 'new desc'
			,Link_Type__c = 'Internal'
			,Link_Label__c = 'Label'
			,Internal_Community_Link__c = 'com link'
			,Internal_Mobile_Link__c = 'mob link'
			,Active__c = true
			,Content_Language__c = 'English'
			,Order__c = 0
			,Publish_in__c = 'IKOROOFPRO_C');
		
		insert newWhatHappening;

        icRepoWhatsHappening.IClass repository = (icRepoWhatsHappening.IClass) icObjectFactory.GetSingletonInstance('icRepoWhatsHappening');
        List<What_s_Happening__c> withResult = repository.getActiveWhatHappeningByLanguageAndCommunityName('English','IKOROOFPRO_C');
		List<What_s_Happening__c> withoutResult = repository.getActiveWhatHappeningByLanguageAndCommunityName('English','FORCE_NO_RESULT');
		
		System.assertEquals(withResult.size(), 1);
		System.assertEquals(withoutResult.size(), 0);
    }
}