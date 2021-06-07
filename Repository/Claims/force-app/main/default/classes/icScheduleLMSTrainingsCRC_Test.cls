@isTest

public class icScheduleLMSTrainingsCRC_Test{

    @TestSetup
	private static void initData() {
		LearningTracAssignmentTestDataFactoryCRC.createLearningTracks();
		System.runAs(LearningTracAssignmentTestDataFactoryCRC.adminUser) {
			LearningTracAssignmentTestDataFactoryCRC.createCompanies();
		}
	}

@isTest
    public static void method1() {
        SchedulableContext sc = null;
        icScheduleLMSTrainingsCRC varLMS= new icScheduleLMSTrainingsCRC();
        varLMS.execute(sc);
    } 
}