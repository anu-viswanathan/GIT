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
* @description OrderLineService provides methods to link Orders and Order Lines.
*/

public class OrderLineService {

    /*******************************************************************************************************************
    * @description Link Open Order Lines to the appropriate Open Order.
    * @param orders a List of EU_Open_Order__c objects to be referenced
    * @param orderLines a List of EU_Open_Order_Line__c objects to be linked
    * @return a Boolean indicating whether or not all Order Lines have been linked correctly (true), or not (false)
    * @example
    * Boolean orderLinesLinkedOK = (new InvoiceLineService()).relateOrdersToOrderLines(orders, orderLines);
    */

    public Boolean relateOrdersToOrderLines(List<EU_Open_Order__c> orders, List<EU_Open_Order_Line__c> orderLines) {
        Integer matches = 0;
        // TODO: optimize algorithm
        for(EU_Open_Order__c order : orders) {
            for(EU_Open_Order_Line__c orderLine : orderLines) {
                if(
                    order.EU_Order_Number__c == orderLine.EU_Header_Order_Number__c
                    && order.EU_Account__c == orderLine.EU_Account__c
                ) {
                    orderLine.EU_Open_Order__c = order.Id;
                    matches++;
                }
            }
        }

        final Boolean allInvoiceLinesHandled = (matches == orderLines.size());
        if(!allInvoiceLinesHandled) {
            System.debug(LoggingLevel.ERROR, 'could not link all invoice lines to an invoice, or an invoice line has been multi-assigned');
        }

        return allInvoiceLinesHandled;
    }
}