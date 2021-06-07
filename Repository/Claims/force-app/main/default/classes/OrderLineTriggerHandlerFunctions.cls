/**
 * Created by Gerard van Kempen on 2019-12-18.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

public with sharing class OrderLineTriggerHandlerFunctions {
    private OrderLineTriggerHandlerFunctions() {}

    public static void mapOrderLinesToOrders(List<EU_Open_Order_Line__c> orderLines) {
        // null check
        if(orderLines == null || orderLines.isEmpty()) {
            System.debug(LoggingLevel.ERROR, 'empty or NULL List received where value(s) were expected, terminating...');
            return;
        }

        // extract all invoice numbers referenced by Invoice Lines, no deduplication
        Set<String> orderNumbersFromInput = new Set<String>();
        Set<Id> accountIds = new Set<Id>();
        for(EU_Open_Order_Line__c orderLine : orderLines) {
            orderNumbersFromInput.add(orderLine.EU_Header_Order_Number__c);
            accountIds.add(orderLine.EU_Account__c);
        }

        // find existing Orders for order Lines
        List<EU_Open_Order__c> existingMatchingOrders = (new OrderSelector()).getOrdersForOrderNumbers(orderNumbersFromInput, accountIds);

        // try to match all Order Lines to Orders; true if success, false if certain Lines could not be matched
        Boolean cleanMatchesForExistingOrders = (new OrderLineService()).relateOrdersToOrderLines(existingMatchingOrders, orderLines);
        // field for future use
        Boolean cleanMatchesForGeneratedOrders = null;

        // only do this if not all Lines could be matched correctly
        if(!cleanMatchesForExistingOrders) {
            // collect all Order Lines which still have no linked Order
            List<EU_Open_Order_Line__c> orderLinesWhichRequireNewOrders = new List<EU_Open_Order_Line__c>();
            for(EU_Open_Order_Line__c orderLine : orderLines) {
                if(orderLine.EU_Open_Order__c == null) {
                    orderLinesWhichRequireNewOrders.add(orderLine);
                }
            }

            // create and insert new Orders for those Order Lines
            List<EU_Open_Order__c> generatedOrders = (new OrderService()).createNewOrdersForOrderLines(orderLinesWhichRequireNewOrders);
            insert generatedOrders;

            // check if the previously unmatched Lines have now been matched successfully
            cleanMatchesForGeneratedOrders = (new OrderLineService()).relateOrdersToOrderLines(generatedOrders, orderLinesWhichRequireNewOrders);
        }

        // log an error if there still exist some Lines without a linked Order
        if(!(cleanMatchesForExistingOrders == true && cleanMatchesForGeneratedOrders == null) || !(cleanMatchesForExistingOrders == false && cleanMatchesForGeneratedOrders == true)) {
            System.debug(LoggingLevel.ERROR, 'could not find or generate orders for all order lines');
        }
    }

    public static List<EU_Open_Order_Line__c> filterOrderLinesToMap(Map<Id, EU_Open_Order_Line__c> newOrderLines, Map<Id, EU_Open_Order_Line__c> oldOrderLines) {
        // check which Order Lines already have Orders set, and split into two maps indexed by Line Id
        Map<Id, EU_Open_Order_Line__c> linesWithOrders = new Map<Id, EU_Open_Order_Line__c>();
        Map<Id, EU_Open_Order_Line__c> linesToBeMatched = new Map<Id, EU_Open_Order_Line__c>();

        for(Id lineId : new List<Id>(newOrderLines.keySet())) {
            final EU_Open_Order_Line__c lineValue = newOrderLines.get(lineId);

            if(lineValue.EU_Open_Order__c != null) {
                linesWithOrders.put(lineId, lineValue);
            } else {
                linesToBeMatched.put(lineId, lineValue);
            }
        }

        // check if the Order Line Order numbers have been changed for any Lines with Orders set, and if so queue for rematching
        for(Id lineId : new List<Id>(newOrderLines.keySet())) {
            final EU_Open_Order_Line__c lineValue = linesWithOrders.get(lineId);
            final EU_Open_Order_Line__c oldLineValue = oldOrderLines.get(lineId);
            if(lineValue.EU_Header_Order_Number__c != oldLineValue.EU_Header_Order_Number__c) {
                linesToBeMatched.put(lineId, lineValue);
            }
        }

        // return all Order Lines which require new or refreshed matching
        return linesToBeMatched.values();
    }

    public static List<EU_Open_Order__c> findOrdersToCloseBasedOnOrderLines(Map<Id, EU_Open_Order_Line__c> newOrderLines) {
        Map<Id, EU_Open_Order__c> orderMap = new Map<Id, EU_Open_Order__c>();
        for (EU_Open_Order_Line__c orderLine : newOrderLines.values()) {
            EU_Open_Order__c order = new EU_Open_Order__c(Id=orderLine.EU_Open_Order__c);
            new OrderService().relateHeaderFieldsToOrderRecord(order, orderLine);
            orderMap.put(order.Id, order);
        }

        return orderMap.values();
    }
}