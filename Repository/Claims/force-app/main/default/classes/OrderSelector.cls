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
* @description OrderSelector provides methods to retrieve EU_Open_Order__c objects based on parameters.
*/

public class OrderSelector {

    /*******************************************************************************************************************
    * @description Retrieve Open Orders for given Order Numbers.
    * @param orderNumbers a Set of Strings containing Order Numbers
    * @return a List of Open Orders with matching Order Numbers
    * @example
    * List<EU_Open_Order__c> matchingOrders = (new OrderSelector()).getOrdersForOrderNumbers(orderNumbers);
    */

    public List<EU_Open_Order__c> getOrdersForOrderNumbers(Set<String> orderNumbers, Set<Id> accountIds) {
        List<EU_Open_Order__c> ordersForOrderNumbers = null;
        try {
            ordersForOrderNumbers = [
                    SELECT EU_Account__c, CreatedById, CurrencyIsoCode, LastModifiedById,
                            EU_Open_Order__c, Name, EU_Open_Order_Value__c, EU_Order_Number__c,
                            EU_Order_number_Reference__c, EU_Order_Type__c, EU_Project_Number__c,
                            EU_Purchase_Order_Number__c, EU_Request_Date__c, EU_Total_Order_Value__c
                    FROM EU_Open_Order__c
                    WHERE EU_Order_Number__c IN :orderNumbers AND EU_Account__c IN :accountIds
            ];
        } catch (Exception e) {
            System.debug(LoggingLevel.WARN, e.getMessage());
            ordersForOrderNumbers = new List<EU_Open_Order__c>();
        }

        if(ordersForOrderNumbers.isEmpty()) {System.debug(LoggingLevel.WARN, 'could not find any orders');}

        return ordersForOrderNumbers;
    }
}