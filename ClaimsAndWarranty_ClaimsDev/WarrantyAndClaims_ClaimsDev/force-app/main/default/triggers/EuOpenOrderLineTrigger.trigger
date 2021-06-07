/**
 * Created by Gerard van Kempen on 2019-12-11.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

trigger EuOpenOrderLineTrigger on EU_Open_Order_Line__c (before insert, before update, after update) {
    (new OrderLineTriggerHandler()).run();
}