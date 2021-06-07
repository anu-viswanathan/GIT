/**
 * Created by Gerard van Kempen on 2019-12-23.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

trigger EuPriceItemTrigger on EU_Price_Item__c (before insert, before update, after update) {
    (new PriceItemTriggerHandler()).run();
}