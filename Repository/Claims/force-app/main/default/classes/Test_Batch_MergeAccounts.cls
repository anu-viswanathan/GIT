@isTest
private class Test_Batch_MergeAccounts {

    @testSetup static void createTestData() {
        SandboxSetup.sandboxSetup();
    }
    
    // Call the erase batch, which is the first in our chain
    @isTest static void testAllBatches() {
        
        Test.startTest();
			Batch_MergeAccounts foo = new Batch_MergeAccounts();
			Id batchId = Database.executeBatch(foo, 50);
        Test.stopTest();
        
    }
}