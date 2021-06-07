public class icLogicWhatsHappening implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		List<What_s_Happening__c> getActiveWhatHappeningByLanguageAndCommunityName(String language, String communityName);
		List<icDTOWhatsHappening> getListDTOFromWhatHappening(List<What_s_Happening__c> listWhatsHappening);
	}

	public class Impl implements IClass {

		icRepoWhatsHappening.IClass repo = (icRepoWhatsHappening.IClass) icObjectFactory.GetSingletonInstance('icRepoWhatsHappening');

		public List<What_s_Happening__c> getActiveWhatHappeningByLanguageAndCommunityName(String language, String communityName) {
			return repo.getActiveWhatHappeningByLanguageAndCommunityName(language, communityName);
		}

		public List<icDTOWhatsHappening> getListDTOFromWhatHappening(List<What_s_Happening__c> listWhatsHappening) {
			List<icDTOWhatsHappening> returnListDTO = new List<icDTOWhatsHappening>();
			
			for(What_s_Happening__c thisWhatsHappening : listWhatsHappening) {
				icDTOWhatsHappening thisDTO = new icDTOWhatsHappening();
				thisDTO.imageId = thisWhatsHappening.Image_Id__c;
				thisDTO.title = thisWhatsHappening.Title__c;
				thisDTO.description = thisWhatsHappening.Description__c;
				thisDTO.linkType = thisWhatsHappening.Link_Type__c;
				thisDTO.linkLabel = thisWhatsHappening.Link_Label__c;
				thisDTO.externalLink = thisWhatsHappening.External_Link__c;
				thisDTO.communityLink = thisWhatsHappening.Internal_Community_Link__c;
				thisDTO.mobileLink = thisWhatsHappening.Internal_Mobile_Link__c;
				thisDTO.emailToLink = thisWhatsHappening.Email_Recipient__c;

				returnListDTO.add(thisDTO);
			}

			return returnListDTO;
		}
	}
}