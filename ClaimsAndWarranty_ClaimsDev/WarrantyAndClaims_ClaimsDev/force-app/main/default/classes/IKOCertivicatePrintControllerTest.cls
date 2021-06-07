@isTest
private class IKOCertivicatePrintControllerTest {
	@isTest
	private static void IKOCertivicatePrintControllerTest() {
		redwing__Training_Plan__c plan = new redwing__Training_Plan__c(
			Name = 'Test Plan'
		);
		insert plan;

		redwing__Achievement__c ach = new redwing__Achievement__c(
			Name = 'Test Achievement',
			redwing__Enable_Printing__c = true,
			redwing__Type__c = 'Certificate'
		);
		insert ach;
        
        redwing__Training_Plan_Achievement__c plAch = new redwing__Training_Plan_Achievement__c(
			redwing__Training_Plan__c = plan.Id,
            redwing__Achievement__c = ach.Id
		);
		insert plAch;
		
		redwing__Achievement_Assignment__c aach = new redwing__Achievement_Assignment__c(
			redwing__Achievement__c = ach.Id,
			redwing__Status__c = 'Acquired',
			redwing__Training_Plan_Achievement__c = plAch.Id,
			redwing__User__c = UserInfo.getUserId()
		);
		insert aach;
		
		Test.startTest();
		PageReference pageRef = Page.IKOCertivicatePrint;
		pageRef.getParameters().put('aid', ach.Id);
		pageRef.getParameters().put('aaid', aach.Id);
		pageRef.getParameters().put('retURL',
		System.URL.getSalesforceBaseUrl().toExternalForm());
		Test.setCurrentPage(pageRef);
		IKOCertivicatePrintController controller;
		controller = new IKOCertivicatePrintController();
		controller.init();
		Test.stopTest();
		system.assertEquals(ach.Id, controller.achievement.id);
	}
}