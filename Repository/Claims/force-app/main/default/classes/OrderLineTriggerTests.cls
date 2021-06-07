/**
 * Created by Gerard van Kempen on 2019-12-11.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

@IsTest
private class OrderLineTriggerTests {
    @IsTest
    static void handlingOrderLineForExistingOrderResultsInLink() {
        SharedTestComponentFactory.AccountTestingTuple accountTT = SharedTestComponentFactory.newAccountTestingTuple();
        insert accountTT.workingAccount;

        OrderServicesTestComponentFactory.OrderLineTestingTuple orderLineTT
                = OrderServicesTestComponentFactory.newOrderLineTestingTuple(accountTT.workingAccount);
        final String orderNumber = orderLineTT.referenceOrderLine.EU_Header_Order_Number__c;

        List<EU_Open_Order_Line__c> orderLines = new List<EU_Open_Order_Line__c>();
        orderLines.add(orderLineTT.workingOrderLine);
        System.assert(orderLines.size() == 1);

        List<EU_Open_Order__c> generatedMatchingOrders = (new OrderService()).createNewOrdersForOrderLines(orderLines);
        System.assert(generatedMatchingOrders.size() == 1);

        insert generatedMatchingOrders;
        EU_Open_Order__c refOrder = generatedMatchingOrders.get(0);


        Test.startTest();

        insert orderLines;

        EU_Open_Order__c retrievedOrder = null;
        EU_Open_Order_Line__c retrievedOrderLine = null;

        try {
            retrievedOrder = ((List<EU_Open_Order__c>) [
                    SELECT Id, EU_Order_Number__c, EU_Account__c
                    FROM EU_Open_Order__c
                    WHERE EU_Order_Number__c = :orderNumber
            ]).get(0);
        } catch(Exception e) {
            System.assert(false, 'failed due to SOQL query not returning correctly');
        }

        try {
            retrievedOrderLine = ((List<EU_Open_Order_Line__c>)[
                    SELECT Id, EU_Header_Order_Number__c, EU_Account__c, EU_Open_Order__c
                    FROM EU_Open_Order_Line__c
                    WHERE EU_Header_Order_Number__c = :orderNumber
            ]).get(0);
        } catch(Exception e) {
            System.assert(false, 'failed due to SOQL query not returning correctly');
        }

        if(retrievedOrder != null && retrievedOrderLine != null) {
            System.assert(retrievedOrder.Id == refOrder.Id);
            System.assert(retrievedOrder.EU_Account__c == accountTT.workingAccount.Id);
            System.assert(retrievedOrderLine.EU_Open_Order__c == retrievedOrder.Id);
        } else {
            System.assert(false, 'failed due to unexpected NULL pointers');
        }

        Test.stopTest();
    }

    @IsTest
    static void handlingOrderLineForNewOrderResultsInCreation() {
        SharedTestComponentFactory.AccountTestingTuple accountTT = SharedTestComponentFactory.newAccountTestingTuple();
        insert accountTT.workingAccount;

        OrderServicesTestComponentFactory.OrderLineTestingTuple orderLineTT
                = OrderServicesTestComponentFactory.newOrderLineTestingTuple(accountTT.workingAccount);
        final String orderNumber = orderLineTT.referenceOrderLine.EU_Header_Order_Number__c;

        List<EU_Open_Order_Line__c> orderLines = new List<EU_Open_Order_Line__c>();
        orderLines.add(orderLineTT.workingOrderLine);
        System.assert(orderLines.size() == 1);


        Test.startTest();

        insert orderLines;

        EU_Open_Order__c retrievedOrder = null;
        EU_Open_Order_Line__c retrievedOrderLine = null;

        try {
            retrievedOrder = ((List<EU_Open_Order__c>) [
                    SELECT Id, EU_Order_Number__c, EU_Account__c
                    FROM EU_Open_Order__c
                    WHERE EU_Order_Number__c = :orderNumber
            ]).get(0);
        } catch(Exception e) {
            System.assert(false, 'failed due to SOQL query not returning correctly');
        }

        try {
            retrievedOrderLine = ((List<EU_Open_Order_Line__c>)[
                    SELECT Id, EU_Header_Order_Number__c, EU_Account__c, EU_Open_Order__c
                    FROM EU_Open_Order_Line__c
                    WHERE EU_Header_Order_Number__c = :orderNumber
            ]).get(0);
        } catch(Exception e) {
            System.assert(false, 'failed due to SOQL query not returning correctly');
        }

        if(retrievedOrder != null && retrievedOrderLine != null) {
            System.assert(retrievedOrder.EU_Account__c == accountTT.workingAccount.Id);
            System.assert(retrievedOrderLine.EU_Open_Order__c == retrievedOrder.Id);
        } else {
            System.assert(false, 'failed due to unexpected NULL pointers');
        }

        Test.stopTest();
    }

    @IsTest
    static void closedOrderLineResultsInClosedOrder() {

        SharedTestComponentFactory.AccountTestingTuple accountTT = SharedTestComponentFactory.newAccountTestingTuple();
        insert accountTT.workingAccount;

        OrderServicesTestComponentFactory.OrderLineTestingTuple orderLineTT = OrderServicesTestComponentFactory.newOrderLineTestingTuple(accountTT.workingAccount);
        final String orderNumber = orderLineTT.referenceOrderLine.EU_Header_Order_Number__c;

        List<EU_Open_Order_Line__c> orderLines = new List<EU_Open_Order_Line__c>();
        orderLines.add(orderLineTT.workingOrderLine);
        System.assert(orderLines.size() == 1);

        List<EU_Open_Order__c> generatedMatchingOrders = (new OrderService()).createNewOrdersForOrderLines(orderLines);
        System.assert(generatedMatchingOrders.size() == 1);

        insert generatedMatchingOrders;

        EU_Open_Order__c refOrder = generatedMatchingOrders.get(0);
        System.assert(refOrder.EU_Open_Order__c == true);

        insert orderLines;

        List<EU_Open_Order__c> retrievedOrders = (List<EU_Open_Order__c>)[
                SELECT Id, EU_Order_Number__c, EU_Account__c, EU_Open_Order__c
                FROM EU_Open_Order__c
                WHERE EU_Order_Number__c = :orderNumber
        ];

        List<EU_Open_Order_Line__c> retrievedOrderLines = (List<EU_Open_Order_Line__c>)[
                SELECT Id, EU_Header_Order_Number__c, EU_Account__c, EU_Open_Order__c, EU_Header_Open_Order__c
                FROM EU_Open_Order_Line__c
                WHERE EU_Header_Order_Number__c = :orderNumber
        ];

        System.assert(retrievedOrders.size() == 1);
        System.assert(retrievedOrderLines.size() == 1);

        EU_Open_Order__c retrievedOrder = retrievedOrders.get(0);
        EU_Open_Order_Line__c retrievedOrderLinePreUpdate = retrievedOrderLines.get(0);

        System.assert(retrievedOrderLinePreUpdate.EU_Open_Order__c == retrievedOrder.Id);


        Test.startTest();

        retrievedOrderLinePreUpdate.EU_Header_Open_Order__c = false;
        update retrievedOrderLinePreUpdate;
        System.assert(retrievedOrderLinePreUpdate.EU_Header_Open_Order__c == false);

        EU_Open_Order__c retrievedOpenOrderPostUpdate = ((List<EU_Open_Order__c>)[
                SELECT Id, EU_Order_Number__c, EU_Account__c, EU_Open_Order__c
                FROM EU_Open_Order__c
                WHERE EU_Order_Number__c = :orderNumber
        ]).get(0);

        System.assert(retrievedOpenOrderPostUpdate.EU_Open_Order__c == false);

        Test.stopTest();
    }
}