/**
 * Created by Francois Poirier on 2019-04-17.
 */

@isTest
public with sharing class icTestMapCalendarEvent {

    @isTest
    static void testMapToDto(){

        icMapCalendarEvent.IClass mapper = (icMapCalendarEvent.IClass) icObjectFactory.GetSingletonInstance('icMapCalendarEvent');

        CalendarEvent__c calendarEvent = new CalendarEvent__c();
        List<CalendarEvent__c> calendarEvents = new List<CalendarEvent__c>();
        List<icDtoCalendarEvent> dtoCalendarEvents = new List<icDtoCalendarEvent>();

        calendarEvent.Id = icTestHelperUtility.getFakeId(CalendarEvent__c.SObjectType);
        calendarEvent.EventDate__c = Date.today();
        calendarEvent.Description_Long_Txt_Area__c = icTestHelperUtility.generateRandomString(100);


        calendarEvents.add(calendarEvent);

        dtoCalendarEvents = mapper.mapToDto(calendarEvents);

        system.assertEquals(calendarEvents.size(), dtoCalendarEvents.size());
        system.assertEquals(calendarEvents[0].Description_Long_Txt_Area__c, dtoCalendarEvents[0].Description);

    }
}