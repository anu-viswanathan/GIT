@isTest
private class Warranty_BatchUpdateExpiredTest {
//@testSetup static void createTestData() {
//        SandboxSetup.sandboxSetup();
//    }
    
    // Call the erase batch, which is the first in our chain
    @isTest static void testAllBatches() {
        
        Test.startTest();
            Warranty_BatchUpdateExpired obj = new Warranty_BatchUpdateExpired();
            DataBase.executeBatch(obj);

        Test.stopTest();
        
    }
}