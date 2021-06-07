// Test class for scheduler

@istest
class Test_Schedule_UpdateOrderSummary {

    @testSetup static void createTestData() {
        SandboxSetup.sandboxSetup();
    }

    @istest
    static void testScheduler() {
    Test.startTest();
    	Schedule_UpdateOrderSummary foo = new Schedule_UpdateOrderSummary();
        String sch = '0 0 23 * * ?';
        System.Schedule('Testing the Update Order Summary stuff', sch, foo);
    Test.stopTest();
	}
}