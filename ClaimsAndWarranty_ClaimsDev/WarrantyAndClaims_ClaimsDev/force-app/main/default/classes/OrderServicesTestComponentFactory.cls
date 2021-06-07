/**
 * Created by Gerard van Kempen on 2019-12-11.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 * Modified by Rudi Vermeulen on 2020-12-03: Included new field EU_Header_Order_Creation_Date__c
 */

/**
* @author Gerard van Kempen, 4C NV
* @date 2019
*
* @group Integration Services
*
* @description OrderServicesTestComponentFactory aids in the generation of test objects.
*/

@IsTest
public with sharing class OrderServicesTestComponentFactory {
    public class OrderLineTestingTuple {
        public final EU_Open_Order_Line__c referenceOrderLine;
        public EU_Open_Order_Line__c workingOrderLine;
        public OrderLineTestingTuple(EU_Open_Order_Line__c orderLine) {
            this.referenceOrderLine = orderLine.clone();
            this.workingOrderLine = orderLine.clone();
        }
    }

    public class OrderTestingTuple {
        public final EU_Open_Order__c referenceOrder;
        public EU_Open_Order__c workingOrder;
        public OrderTestingTuple(EU_Open_Order__c order) {
            this.referenceOrder = order.clone();
            this.workingOrder = order.clone();
        }
    }

    private static String newRandomString(Integer length) {
        Blob blobKey = Crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        return key.substring(0,length);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Open_Order_Line__c object wrapped in a testing tuple.
    * @param invoiceNumber a dummy order number, not null
    * @param dueValue a dummy due value, not null
    * @param acct a dummy account (may be null)
    * @return an OrderLineTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * orderLineTestingTuple orderLineTT = OrderServicesTestComponentFactory.newInvoiceLineTestingTuple(orderNumber, dueValue, acct);
    */

    public static OrderLineTestingTuple newOrderLineTestingTuple(String invoiceNumber, Decimal dueValue, Account acct) {
        EU_Open_Order_Line__c orderLine = new EU_Open_Order_Line__c();
        if(acct != null) {
            orderLine.EU_Account__c = acct.Id;
        }
        orderLine.CurrencyIsoCode = 'EUR';
//        orderLine.EU_ERP_External_Id__c = newRandomString(32);
        orderLine.EU_Extended_Price__c = Math.round(dueValue);
        orderLine.EU_Item__c = newRandomString(25);
        orderLine.EU_Item_Description__c = newRandomString(32);
        orderLine.EU_Header_Open_Order__c = true;
//        orderLine.EU_Open_Order__c = null;
        orderLine.EU_Open_Order_Line_Numer__c = newRandomString(10);
        orderLine.EU_Header_Open_Order_Value__c = Math.round(dueValue * 1.2);
        orderLine.EU_Open_Quantity__c = Math.round(dueValue * 0.7);
        orderLine.EU_Order_Line__c = newRandomString(5);
        orderLine.EU_Header_Order_Number__c = invoiceNumber;
        orderLine.EU_Header_Order_Number_Reference__c = newRandomString(15);
        orderLine.EU_Header_Order_Type__c = newRandomString(5);
        orderLine.EU_Order_UM__c = newRandomString(3);
        orderLine.EU_Price_Order_UM__c = Math.round(dueValue * 0.87);
        orderLine.EU_Header_Project_Number__c = newRandomString(15);
        orderLine.EU_Header_Purchase_Order_Number__c = newRandomString(25);
        orderLine.EU_Header_Request_Date__c = Date.today();
        orderLine.EU_Source_System__c = newRandomString(30);
        orderLine.EU_Header_Total_Order_Value__c = Math.round(dueValue * 2.1);
        orderLine.EU_Header_Order_Creation_Date__c = Date.today();
        
        return new OrderLineTestingTuple(orderLine);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Open_Order_Line__c object wrapped in a testing tuple.
    * @param dueValue a dummy due value, not null
    * @param acct a dummy account (may be null)
    * @return an OrderLineTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * orderLineTestingTuple orderLineTT = OrderServicesTestComponentFactory.newInvoiceLineTestingTuple(orderNumber, dueValue, acct);
    */

    public static OrderLineTestingTuple newOrderLineTestingTuple(Decimal dueValue, Account acct) {
        return newOrderLineTestingTuple(newRandomString(9), dueValue, acct);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Open_Order_Line__c object wrapped in a testing tuple.
    * @param acct a dummy account (may be null)
    * @return an OrderLineTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * orderLineTestingTuple orderLineTT = OrderServicesTestComponentFactory.newInvoiceLineTestingTuple(orderNumber, dueValue, acct);
    */

    public static OrderLineTestingTuple newOrderLineTestingTuple(Account acct) {
        return newOrderLineTestingTuple(1324.65, acct);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Open_Order_Line__c object wrapped in a testing tuple.
    * @return an OrderLineTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * orderLineTestingTuple orderLineTT = OrderServicesTestComponentFactory.newInvoiceLineTestingTuple(orderNumber, dueValue, acct);
    */

    public static OrderLineTestingTuple newOrderLineTestingTuple() {
        return newOrderLineTestingTuple(null);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Open_Order__c object wrapped in a testing tuple.
    * @param orderNumber a dummy order number, not null
    * @param dueValue a dummy due value, not null
    * @param acct a dummy account (may be null)
    * @return an OrderTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * OrderTestingTuple orderTT = OrderServicesTestComponentFactory.newOrderTestingTuple(orderNumber, dueValue, acct);
    */

    public static OrderTestingTuple newOrderTestingTuple(String orderNumber, Decimal dueValue, Account acct) {
        EU_Open_Order__c order = new EU_Open_Order__c();
        if(acct != null) {
            order.EU_Account__c = acct.Id;
        }
        order.CurrencyIsoCode = 'EUR';
        order.EU_Open_Order__c = true;
        order.EU_Open_Order_Value__c = Math.round(dueValue);
        order.EU_Order_Number__c = orderNumber;
        order.EU_Order_number_Reference__c = newRandomString(15);
        order.EU_Order_Type__c = newRandomString(5);
        order.EU_Project_Number__c = newRandomString(15);
        order.EU_Purchase_Order_Number__c = newRandomString(25);
        order.EU_Request_Date__c = Date.today();
        order.EU_Total_Order_Value__c = Math.round(dueValue * 2.1);

        return new OrderTestingTuple(order);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Open_Order__c object wrapped in a testing tuple.
    * @param dueValue a dummy due value, not null
    * @param acct a dummy account (may be null)
    * @return an OrderTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * OrderTestingTuple orderTT = OrderServicesTestComponentFactory.newOrderTestingTuple(orderNumber, dueValue, acct);
    */

    public static OrderTestingTuple newOrderTestingTuple(Decimal dueValue, Account acct) {
        return newOrderTestingTuple(newRandomString(9), dueValue, acct);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Open_Order__c object wrapped in a testing tuple.
    * @param acct a dummy account (may be null)
    * @return an OrderTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * OrderTestingTuple orderTT = OrderServicesTestComponentFactory.newOrderTestingTuple(orderNumber, dueValue, acct);
    */

    public static OrderTestingTuple newOrderTestingTuple(Account acct) {
        return newOrderTestingTuple(1324.65, acct);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Open_Order__c object wrapped in a testing tuple.
    * @return an OrderTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * OrderTestingTuple orderTT = OrderServicesTestComponentFactory.newOrderTestingTuple(orderNumber, dueValue, acct);
    */

    public static OrderTestingTuple newOrderTestingTuple() {
        return newOrderTestingTuple(null);
    }
}