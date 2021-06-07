/**
 * Created by Francois Poirier on 2019-04-17.
 */

@isTest
public with sharing class icTestLogicEventCalendar {

    static String descriptionEvent;
    static String descriptionMajorEvent;

    static void setup(){

        CalendarEvent__c newEvent = new CalendarEvent__c();
        CalendarEvent__c newMajorEvent = new CalendarEvent__c();
        List<CalendarEvent__c> newEvents = new List<CalendarEvent__c>();
        List<CalendarEvent__c> newMajorEvents = new List<CalendarEvent__c>();

        newEvent.Active__c = true;
        newEvent.Tier__c = '1';
        newEvent.ContentLanguage__c = 'English';
        newEvent.Publish_in__c = 'IKOROOFPRO_C';
        newEvent.Description_Long_Txt_Area__c = icTestHelperUtility.generateRandomString(100);
        descriptionEvent = newEvent.Description_Long_Txt_Area__c;
        newEvent.EventDate__c = Date.today().addDays(1);

        newEvents.add(newEvent);

        newMajorEvent.Active__c = true;
        newMajorEvent.Tier__c = '1';
        newMajorEvent.ContentLanguage__c = 'English';
        newEvent.Publish_in__c = 'IKOROOFPRO_C';
        newMajorEvent.Description_Long_Txt_Area__c = icTestHelperUtility.generateRandomString(100);
        descriptionMajorEvent = newMajorEvent.Description_Long_Txt_Area__c;
        newMajorEvent.EventDate__c = Date.today();

        newMajorEvents.add(newMajorEvent);


        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoEventCalendar', new icRepoEventCalendarMock());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoEventCalendarMock', 'getActiveCalendarEventsByDateRangeTierCommunityName', newEvents);
        icTestMockUtilities.Tracer.SetReturnValue('icRepoEventCalendarMock', 'getNext3EventsForTier', newEvents);
        icTestMockUtilities.Tracer.SetReturnValue('icRepoEventCalendarMock', 'getTopEventsByLanguageAndTier', newMajorEvents);

    }

    @isTest
    static void testgetActiveCalendarEventsByDateRangeTierCommunityName(){

        setup();
        icLogicEventCalendar.IClass logic = (icLogicEventCalendar.IClass) icObjectFactory.GetSingletonInstance('icLogicEventCalendar');
        List<CalendarEvent__c> eventsFromLogic = new List<CalendarEvent__c>();
        eventsFromLogic = logic.getActiveCalendarEventsByDateRangeTierCommunityName(Date.today(), Date.today(), 'English', '1', 'IKOROOFPRO_C');

        system.assertEquals(descriptionEvent, eventsFromLogic[0].Description_Long_Txt_Area__c);
    }
   
}