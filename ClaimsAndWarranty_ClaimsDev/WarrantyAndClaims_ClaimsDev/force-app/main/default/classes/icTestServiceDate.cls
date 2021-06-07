/**
 * Created by Francois Poirier on 2019-04-17.
 */

@isTest
public with sharing class icTestServiceDate {

    @isTest
    static void testGetMonthNames(){
        String monthName = '';
        monthName = icServiceDate.getMonthName(3);

        System.assert(monthName.length()>0);
    }

    @isTest
    static void testGetMonthArray(){

        Map<Integer, String> monthNames = new Map<Integer, String>();
        monthNames = icServiceDate.getMonthArray();

        system.assertEquals(12, monthNames.keySet().size());
    }

}