@isTest
private class Test_Batch_DeleteAllOrders {

    @testSetup static void createTestData() {
        SandboxSetup.sandboxSetup();
    }
    
    // Call the erase batch, which is the first in our chain
    @isTest static void testAllBatches() {
        
        Test.startTest();
            Batch_DeleteAllOrders foo = new Batch_DeleteAllOrders();
            Id batchId = Database.executeBatch(foo, 200);
        Test.stopTest();
        
    }
}