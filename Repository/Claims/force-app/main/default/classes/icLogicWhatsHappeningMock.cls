@isTest
public with sharing class icLogicWhatsHappeningMock implements icLogicWhatsHappening.IClass{

	public List<What_s_Happening__c> getActiveWhatHappeningByLanguageAndCommunityName(String language,String communityName) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getActiveWhatHappeningByLanguageAndCommunityName');
		params.put('language', language);
		params.put('communityName', communityName);
		return (List<What_s_Happening__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getActiveWhatHappeningByLanguageAndCommunityName');
	}

	public List<icDTOWhatsHappening> getListDTOFromWhatHappening(List<What_s_Happening__c> listWhatsHappening) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getListDTOFromWhatHappening');
		params.put('listWhatsHappening', listWhatsHappening);
		return (List<icDTOWhatsHappening>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getListDTOFromWhatHappening');
	}
}