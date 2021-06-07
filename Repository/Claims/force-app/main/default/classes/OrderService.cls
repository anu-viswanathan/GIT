/**
 * Created by Gerard van Kempen on 2019-12-06.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

/**
* @author Gerard van Kempen, 4C NV
* @date 2019
*
* @group Integration Services
*
* @description OrderService provides two methods which can be used to create new EU_Open_Order__c objects
* based on data from existing EU_Open_Order_Line__c objects.
*/

public class OrderService {

    /*******************************************************************************************************************
    * @description Generate Open Orders for Open Order Lines. Prevents duplicate Open Orders from being generated
    * for similar Open Order Lines.
    * @param invoiceLines a List of Open Order Lines for which to generate Open Orders
    * @return a List of Open Orders
    * @example
    * List<EU_Open_Order__c> newOrders = (new OrderService()).createNewOrdersForOrderLines(orderLines);
    */

    public List<EU_Open_Order__c> createNewOrdersForOrderLines(List<EU_Open_Order_Line__c> orderLines) {
        Map<String, EU_Open_Order__c> newOrdersByOrderNumber = new Map<String, EU_Open_Order__c>();

        for(EU_Open_Order_Line__c orderLine : orderLines) {
            try {
                EU_Open_Order__c currentOrder = new EU_Open_Order__c();
                if (newOrdersByOrderNumber.containsKey(orderLine.EU_Header_Order_Number__c + orderLine.EU_Account__c)) {
                    currentOrder = newOrdersByOrderNumber.get(orderLine.EU_Header_Order_Number__c + orderLine.EU_Account__c);
                } else {
                    this.relateHeaderFieldsToOrderRecord(currentOrder, orderLine);
                }
                currentOrder.EU_Account__c = orderLine.EU_Account__c;

                newOrdersByOrderNumber.put(currentOrder.EU_Order_Number__c + currentOrder.EU_Account__c, currentOrder);
            } catch(Exception e) {
                System.debug(LoggingLevel.WARN, e.getMessage());
                System.debug(LoggingLevel.WARN, 'could not generate order for order line due to NULL-reference');
            }
        }

        return newOrdersByOrderNumber.values();
    }

    public void relateHeaderFieldsToOrderRecord(EU_Open_Order__c order, EU_Open_Order_Line__c orderLine) {
        order.CurrencyIsoCode = orderLine.CurrencyIsoCode;
        order.EU_Open_Order__c = orderLine.EU_Header_Open_Order__c;
        order.EU_Open_Order_Value__c = orderLine.EU_Header_Open_Order_Value__c;
        order.EU_Order_Number__c = orderLine.EU_Header_Order_Number__c;
        order.EU_Order_number_Reference__c = orderLine.EU_Header_Order_Number_Reference__c;
        order.EU_Order_Type__c = orderLine.EU_Header_Order_Type__c;
        order.EU_Project_Number__c = orderLine.EU_Header_Project_Number__c;
        order.EU_Purchase_Order_Number__c = orderLine.EU_Header_Purchase_Order_Number__c;
        order.EU_Request_Date__c = orderLine.EU_Header_Request_Date__c;
        order.EU_Total_Order_Value__c = orderLine.EU_Header_Total_Order_Value__c;
    }
}