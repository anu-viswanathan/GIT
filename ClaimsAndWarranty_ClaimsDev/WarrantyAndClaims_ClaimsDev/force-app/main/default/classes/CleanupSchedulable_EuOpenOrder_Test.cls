/**
 * Created by Gerard van Kempen on 2019-12-20.
 * 2019 (C) 4C NV, Mechelen Belgium.
 */

@IsTest
private class CleanupSchedulable_EuOpenOrder_Test {
    @IsTest
    static void cleanupForFourWithOneMatchingResultsInThreeRemaining() {
        SharedTestComponentFactory.AccountTestingTuple accountTT = SharedTestComponentFactory.newAccountTestingTuple();
        insert accountTT.workingAccount;

        OrderServicesTestComponentFactory.OrderTestingTuple orderTT_1 = OrderServicesTestComponentFactory.newOrderTestingTuple(accountTT.workingAccount);
        OrderServicesTestComponentFactory.OrderTestingTuple orderTT_2 = OrderServicesTestComponentFactory.newOrderTestingTuple(accountTT.workingAccount);
        OrderServicesTestComponentFactory.OrderTestingTuple orderTT_3 = OrderServicesTestComponentFactory.newOrderTestingTuple(accountTT.workingAccount);
        OrderServicesTestComponentFactory.OrderTestingTuple orderTT_4 = OrderServicesTestComponentFactory.newOrderTestingTuple(accountTT.workingAccount);

        List<EU_Open_Order__c> ordersToInsert = new List<EU_Open_Order__c>();
        List<String> orderNumbers = new List<String>();

        EU_Open_Order__c invoice_1_shouldStay = orderTT_1.workingOrder;
        invoice_1_shouldStay.EU_Open_Order__c = true;
        invoice_1_shouldStay.CreatedDate = Datetime.now().addDays(-1);
        ordersToInsert.add(invoice_1_shouldStay);
        orderNumbers.add(invoice_1_shouldStay.EU_Order_Number__c);

        EU_Open_Order__c invoice_2_shouldStay = orderTT_2.workingOrder;
        invoice_2_shouldStay.EU_Open_Order__c = true;
        invoice_2_shouldStay.CreatedDate = Datetime.now().addMonths(-48).addDays(-1);
        ordersToInsert.add(invoice_2_shouldStay);
        orderNumbers.add(invoice_2_shouldStay.EU_Order_Number__c);

        EU_Open_Order__c invoice_3_shouldStay = orderTT_3.workingOrder;
        invoice_3_shouldStay.EU_Open_Order__c = false;
        invoice_3_shouldStay.CreatedDate = Datetime.now().addDays(-1);
        ordersToInsert.add(invoice_3_shouldStay);
        orderNumbers.add(invoice_3_shouldStay.EU_Order_Number__c);

        EU_Open_Order__c invoice_4_shouldGo = orderTT_4.workingOrder;
        invoice_4_shouldGo.EU_Open_Order__c = false;
        invoice_4_shouldGo.CreatedDate = Datetime.now().addMonths(-48).addDays(-1);
        ordersToInsert.add(invoice_4_shouldGo);
        orderNumbers.add(invoice_4_shouldGo.EU_Order_Number__c);

        insert ordersToInsert;

        Test.startTest();
        
        CleanupSchedulable_EuOpenOrder.schedule();
        (new CleanupSchedulable_EuOpenOrder()).execute(null);
        
        Test.stopTest();

        List<EU_Open_Order__c> retrievedInvoices = [
                SELECT Id, EU_Order_Number__c, EU_Open_Order__c, LastModifiedDate
                FROM EU_Open_Order__c
                WHERE EU_Order_Number__c IN :orderNumbers
        ];

        // All records flagged with false will be deleted because we can't change the lastmodifieddate
        System.assertEquals(retrievedInvoices.size(), 2);

    }
}