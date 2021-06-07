/**
 * Created by Francois Poirier on 2019-04-16.
 */

public with sharing class icServiceDate {

    public static String getMonthName(Integer monthNumber){

        String monthName = '';

        Map<Integer, String> monthNames = getMonthArray();
        monthName = monthNames.get(monthNumber);

        return monthName;


    }

    public static Map<Integer, String> getMonthArray(){

        Map<Integer, String> monthNames = new Map<Integer, String>();

        monthNames.put(1, Label.January);
        monthNames.put(2, Label.February);
        monthNames.put(3, Label.March);
        monthNames.put(4, Label.April);
        monthNames.put(5, Label.May);
        monthNames.put(6, Label.June);
        monthNames.put(7, Label.July);
        monthNames.put(8, Label.August);
        monthNames.put(9, Label.September);
        monthNames.put(10, Label.October);
        monthNames.put(11, Label.November);
        monthNames.put(12, Label.December);

        return monthNames;

    }
}