@isTest
public with sharing class icTestCtrlWhatsHappening {

	public static testMethod void test_getWhatsHappening(){
		CommunitySiteNameConfiguration__mdt config = new CommunitySiteNameConfiguration__mdt();
        config.CommunityNameGlobalSetValue__c = 'IKOROOFPRO_C';

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicConfig', new icLogicConfigMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicConfigMock', 'getCommunitySiteNameConfigByName', config);
        
		icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicUser', new icLogicUserMock());
		icTestMockUtilities.Tracer.SetReturnValue('icLogicUserMock', 'getUserAndAccountFromPartnerUser', new User());
		icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicWhatsHappening', new icLogicWhatsHappeningMock());
		icTestMockUtilities.Tracer.SetReturnValue('icLogicWhatsHappeningMock', 'getActiveWhatHappeningByLanguageAndCommunityName', new List<What_s_Happening__c>());
		icTestMockUtilities.Tracer.SetReturnValue('icLogicWhatsHappeningMock', 'getListDTOFromWhatHappening', new List<icDTOWhatsHappening>());

		icCtrlWhatsHappening.getWhatsHappening();
	}
}