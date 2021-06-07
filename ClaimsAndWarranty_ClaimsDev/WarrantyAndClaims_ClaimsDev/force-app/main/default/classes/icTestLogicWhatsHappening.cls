@isTest
public with sharing class icTestLogicWhatsHappening {

	static List<What_s_Happening__c> mockListWhatsHappening {get;set;}

	static void initSetup(){
		icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoWhatsHappening', new icRepoWhatsHappeningMock());

		What_s_Happening__c newWhatHappening = new What_s_Happening__c(Name = 'new name'
			,Image_Id__c = 'new image ref'
			,Title__c = 'new title'
			,Description__c = 'new desc'
			,Link_Type__c = 'Internal'
			,Active__c = true
			,Content_Language__c = 'English'
			,Order__c = 0
			,Publish_in__c = 'IKOROOFPRO_C');

		mockListWhatsHappening = new List<What_s_Happening__c>{newWhatHappening};

		icTestMockUtilities.Tracer.SetReturnValue('icRepoWhatsHappeningMock', 'getActiveWhatHappeningByLanguageAndCommunityName', mockListWhatsHappening);
	}

	public static testMethod void test_getActiveWhatHappeningByLanguageAndCommunityName(){
		initSetup();
		
		icLogicWhatsHappening.IClass logic = (icLogicWhatsHappening.IClass) icObjectFactory.GetSingletonInstance('icLogicWhatsHappening');

		List<What_s_Happening__c> result = logic.getActiveWhatHappeningByLanguageAndCommunityName('English','IKOROOFPRO_C');
		System.assertEquals(result.size(), 1);
	}

	public static testMethod void test_getListDTOFromWhatHappening(){
		initSetup();
		
		icLogicWhatsHappening.IClass logic = (icLogicWhatsHappening.IClass) icObjectFactory.GetSingletonInstance('icLogicWhatsHappening');

		List<icDTOWhatsHappening> result = logic.getListDTOFromWhatHappening(mockListWhatsHappening);
		System.assertEquals(result.size(), 1);
	}
}