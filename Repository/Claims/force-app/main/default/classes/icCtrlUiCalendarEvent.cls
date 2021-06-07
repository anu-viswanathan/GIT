/**
 * Created by Francois Poirier on 2019-04-01.
 */

global with sharing class icCtrlUiCalendarEvent {

    static icLogicEventCalendar.IClass logicEventCalendar = (icLogicEventCalendar.IClass) icObjectFactory.GetSingletonInstance('icLogicEventCalendar');
    static icLogicUser.IClass logicUser = (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');
    static icMapCalendarEvent.IClass mapCalendarEvent = (icMapCalendarEvent.IClass) icObjectFactory.GetSingletonInstance('icMapCalendarEvent');
    static icLogicConfig.IClass logicConfig = (icLogicConfig.IClass) icObjectFactory.GetSingletonInstance('icLogicConfig');

    @AuraEnabled
    global static Map<String, List<icDtoCalendarEvent>> getEventsByDateRange(String fistDay, String lastDay){
        system.debug('fistDay ====> ' + fistDay);
        system.debug('lastDay ====> ' + lastDay);

        User currentUser = logicUser.getUserAndAccountFromPartnerUser(UserInfo.getUserId());
        
        system.debug('UserInfo.getUserId = ' + UserInfo.getUserId());

        //IKO-240 Use the CommunityName to filter Calendar Events
        String communityName = Site.getName();
        system.debug('Community Site Name ===> ' + communityName);
        CommunitySiteNameConfiguration__mdt communityConfig = logicConfig.getCommunitySiteNameConfigByName(communityName);

        String tierNumber = '';

        if(Test.isRunningTest()){
            tierNumber = '1';
        }
        else {
            tierNumber = currentUser.Contact.Account.Present_Tier_Lookup__r.Tier_Label__c;
        }

        system.debug('tierNumber current User ===> ' + currentUser.Contact.Account.Present_Tier_Lookup__r.Tier_Label__c);

        Map<String, List<icDtoCalendarEvent>> dateEventsMap = new Map<String, List<icDtoCalendarEvent>>();
        List<CalendarEvent__c> calendarEvents = new List<CalendarEvent__c>();
        List<CalendarEvent__c> mainCalendarEvents = new List<CalendarEvent__c>();
        Set<CalendarEvent__c> allEvents = new Set<CalendarEvent__c>();

        calendarEvents = logicEventCalendar.getActiveCalendarEventsByDateRangeTierCommunityName(Date.valueOf(fistDay),Date.valueOf(lastDay), currentUser.ROOFPRO_Portal_Language__c, tierNumber, communityConfig.CommunityNameGlobalSetValue__c	);
        system.debug('calendar events ===> ' + calendarEvents);

        allEvents.addAll(calendarEvents);
        system.debug('all events after add all calendarEvents ===> ' + allEvents);

        List<icDtoCalendarEvent> dtoCalendarEvents = mapCalendarEvent.mapToDto(allEvents);

        dateEventsMap.put('currentEvents', new List<icDtoCalendarEvent>());

        for(icDtoCalendarEvent calendarEvent : dtoCalendarEvents){

            String eventDateStr;

            eventDateStr = String.valueOf(calendarEvent.EventDate.year()) + String.valueOf(calendarEvent.EventDate.month()) + String.valueOf(calendarEvent.EventDate.day());

            if(!dateEventsMap.containsKey(eventDateStr)){
                List<icDtoCalendarEvent> events = new List<icDtoCalendarEvent>();
                dateEventsMap.put(eventDateStr, events);
            }

            dateEventsMap.get(eventDateStr).add(calendarEvent);
            dateEventsMap.get('currentEvents').add(calendarEvent);
        }

        system.debug('dateEventsMap ===> ' + dateEventsMap);

        return dateEventsMap;
    }
    @AuraEnabled
    global static Map<Integer, String> getMonthNamesArray(){

        return icServiceDate.getMonthArray();

    }
}