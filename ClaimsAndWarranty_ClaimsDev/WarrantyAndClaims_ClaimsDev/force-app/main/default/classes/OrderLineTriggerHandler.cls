/**
 * Created by Gerard van Kempen on 2019-12-11.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

public with sharing class OrderLineTriggerHandler extends TriggerHandler {

    protected override void onBeforeInsert(List<SObject> newList) {
        List<EU_Open_Order_Line__c> newOrderLines = (List<EU_Open_Order_Line__c>)newList;

        OrderLineTriggerHandlerFunctions.mapOrderLinesToOrders(newOrderLines);
    }

    protected override void onBeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        Map<Id, EU_Open_Order_Line__c> newOrderLineMap = (Map<Id, EU_Open_Order_Line__c>)newMap;
        Map<Id, EU_Open_Order_Line__c> oldOrderLineMap = (Map<Id, EU_Open_Order_Line__c>)oldMap;

        List<EU_Open_Order_Line__c> orderLinesToBeMatched = OrderLineTriggerHandlerFunctions.filterOrderLinesToMap(newOrderLineMap, oldOrderLineMap);

        OrderLineTriggerHandlerFunctions.mapOrderLinesToOrders(orderLinesToBeMatched);
    }

    protected override void onAfterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        Map<Id, EU_Open_Order_Line__c> newOrderLineMap = (Map<Id, EU_Open_Order_Line__c>)newMap;
        Map<Id, EU_Open_Order_Line__c> oldOrderLineMap = (Map<Id, EU_Open_Order_Line__c>)oldMap;

        List<EU_Open_Order__c> ordersToClose = OrderLineTriggerHandlerFunctions.findOrdersToCloseBasedOnOrderLines(newOrderLineMap);

        // update the queued orders if there are any
        if(!ordersToClose.isEmpty()) {
            update ordersToClose;
        }
    }

}