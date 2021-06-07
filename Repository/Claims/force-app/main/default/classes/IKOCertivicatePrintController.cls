public without sharing class IKOCertivicatePrintController {

    public redwing__Achievement__c achievement 						{ get; private set; }
	public redwing__Achievement_Assignment__c achievementAssignment { get; private set; }
	public DateTime acquiredDate 									{ get; private set; }
	public User user 	   											{ get; private set; }
	public String backgroundImage									{ get; private set; }
	public Boolean isIKOCertification								{ get; private set; }

	public PageReference init() {

		Id achievementId = ApexPages.currentPage().getParameters().get('aid');
		Id achievementAssignmentId = ApexPages.currentPage().getParameters().get('aaid');

		List<redwing__Achievement_Assignment__c> achievementAssignments = [ SELECT Id, CreatedDate, LastModifiedDate, redwing__Status__c, 
																				   redwing__User__c, redwing__Achievement__c, 
																				   redwing__Contact__c, redwing__Contact__r.OwnerId
																			FROM redwing__Achievement_Assignment__c
																			WHERE Id = :achievementAssignmentId
																			AND redwing__Achievement__r.redwing__Enable_Printing__c = true
																			AND redwing__Status__c = 'Acquired' ];

		if (!achievementAssignments.isEmpty()) {

			Id userId = achievementAssignments[0].redwing__User__c != null ? 
						achievementAssignments[0].redwing__User__c : 
						achievementAssignments[0].redwing__Contact__r.OwnerId;
	
			user = [ SELECT Id, Name, UserRole.Name, Profile.Name, IsActive
					 FROM User
					 WHERE Id = :userId ];

			achievement = [ SELECT Id, Name 
							FROM redwing__Achievement__c
							WHERE Id = :achievementAssignments[0].redwing__Achievement__c ];

			List<AntiTrustSetting__mdt> profilesBackground = [ SELECT BackgroundName__c, ProfileName__c
															   FROM AntiTrustSetting__mdt
															   WHERE ProfileName__c = :user.Profile.Name ];

			backgroundImage = !profilesBackground.isEmpty() ? profilesBackground[0].BackgroundName__c : 'IKO.png';
			isIKOCertification = profilesBackground.isEmpty();
			achievementAssignment = achievementAssignments[0];
			acquiredDate = achievementAssignment.LastModifiedDate;
		}

		return null;
	}


}