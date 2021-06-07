/**
 * Created by Francois Poirier on 2019-04-17.
 */

@isTest
public with sharing class icTestCtrlUiCalendarEvent {
    static String descriptionEvent;
    static String descriptionMajorEvent;

    static void InitTestWithoutData(){

        List<CalendarEvent__c> newEvents = new List<CalendarEvent__c>();
        List<CalendarEvent__c> newMajorEvents = new List<CalendarEvent__c>();
        
        CommunitySiteNameConfiguration__mdt config = new CommunitySiteNameConfiguration__mdt();
        config.CommunityNameGlobalSetValue__c = 'IKOROOFPRO_C';

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicEventCalendar', new icLogicEventCalendarMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicConfig', new icLogicConfigMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicEventCalendarMock', 'getActiveCalendarEventsByDateRangeTierCommunityName', newEvents);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicEventCalendarMock', 'getTopEventsByLanguageAndTier', newMajorEvents);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicEventCalendarMock', 'getNext3EventsForTier', newEvents);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicConfigMock', 'getCommunitySiteNameConfigByName', config);
    }

    static void InitTestWithData(){
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
        newEvent.EventDate__c = Date.today();

        newEvents.add(newEvent);

        newMajorEvent.Active__c = true;
        newMajorEvent.Tier__c = '1';
        newMajorEvent.ContentLanguage__c = 'English';
        newMajorEvent.Publish_in__c = 'IKOROOFPRO_C';
        newMajorEvent.Description_Long_Txt_Area__c = icTestHelperUtility.generateRandomString(100);
        descriptionMajorEvent = newMajorEvent.Description_Long_Txt_Area__c;
        newMajorEvent.EventDate__c = Date.today();

        newMajorEvents.add(newMajorEvent);
        CommunitySiteNameConfiguration__mdt config = new CommunitySiteNameConfiguration__mdt();
        config.CommunityNameGlobalSetValue__c = 'IKOROOFPRO_C';

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicEventCalendar', new icLogicEventCalendarMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicConfig', new icLogicConfigMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicEventCalendarMock', 'getActiveCalendarEventsByDateRangeTierCommunityName', newEvents);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicEventCalendarMock', 'getTopEventsByLanguageAndTier', newMajorEvents);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicEventCalendarMock', 'getNext3EventsForTier', newEvents);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicConfigMock', 'getCommunitySiteNameConfigByName', config);
    }

    @isTest
    static void testgetEventsByDateRange_WhitoutData(){
        InitTestWithoutData();
        Map<String, List<icDtoCalendarEvent>> eventsEmpty = icCtrlUiCalendarEvent.getEventsByDateRange(String.valueOf(Date.today()), String.valueOf(Date.today()));
    }

    @isTest
    static void testgetEventsByDateRange_WithData(){
        InitTestWithData();
        Map<String, List<icDtoCalendarEvent>> events = icCtrlUiCalendarEvent.getEventsByDateRange(String.valueOf(Date.today()), String.valueOf(Date.today()));
    }

    @isTest
    static void testGetMonthNamesArray(){
        icCtrlUiCalendarEvent.getMonthNamesArray();
    }

}