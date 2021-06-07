@isTest
private class Test_Batch_UpdateAccountRollups {

    @testSetup static void createTestData() {
        SandboxSetup.sandboxSetup();
    }
    
    // Call the erase batch, which is the first in our chain
    @isTest static void testAllBatches() {
        
        Test.startTest();
			Batch_EraseGPSRollups foo = new Batch_EraseGPSRollups();
			Id batchId = Database.executeBatch(foo, 50);
        Test.stopTest();
        
    }
}