@isTest
public with sharing class icTestScheduleCSSyncProcess {

    static testMethod void test_scheduleProcess() {
		icScheduleCSSyncProcess schedulableClass = new icScheduleCSSyncProcess();
		
		String schedule = '0 0 23 * * ?'; 

		Test.startTest();
		System.schedule('Scheduled CS Sync Process', schedule, schedulableClass); 
		Test.stopTest();
	}
}