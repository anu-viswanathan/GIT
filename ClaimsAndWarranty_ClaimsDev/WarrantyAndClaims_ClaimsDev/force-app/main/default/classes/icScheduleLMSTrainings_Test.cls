@isTest

public class icScheduleLMSTrainings_Test{

    @TestSetup
	private static void initData() {
		LearningTracAssignmentTestDataFactory.createLearningTracks();
		System.runAs(LearningTracAssignmentTestDataFactory.adminUser) {
			LearningTracAssignmentTestDataFactory.createCompanies();
		}
	}

@isTest
    public static void method1() {
        SchedulableContext sc = null;
        icScheduleLMSTrainings varLMS= new icScheduleLMSTrainings();
        varLMS.execute(sc);
    } 
}