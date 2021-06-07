@isTest
public with sharing class icRepoWhatsHappeningMock implements icRepoWhatsHappening.IClass{

	public List<What_s_Happening__c> getActiveWhatHappeningByLanguageAndCommunityName(String language, String communityName) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getActiveWhatHappeningByLanguageAndcCmmunityName');
		params.put('language', language);
		params.put('communityName', communityName);
		return (List<What_s_Happening__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getActiveWhatHappeningByLanguageAndCommunityName');
	}
}