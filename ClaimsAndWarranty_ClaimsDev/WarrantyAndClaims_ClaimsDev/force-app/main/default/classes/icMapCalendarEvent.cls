/**
 * Created by Francois Poirier on 2019-04-11.
 */

public with sharing class icMapCalendarEvent implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {

        icDtoCalendarEvent mapToDto(CalendarEvent__c calendarEvent);
        List<icDtoCalendarEvent> mapToDto(List<CalendarEvent__c> calendarEvents);
        List<icDtoCalendarEvent> mapToDto(Set<CalendarEvent__c> calendarEvents);
    }

    public class Impl implements IClass {

        private Map<Integer, String> monthNames = icServiceDate.getMonthArray();

        public icDtoCalendarEvent mapToDto(CalendarEvent__c calendarEvent){

            icDtoCalendarEvent tmpEvent = new icDtoCalendarEvent();
            tmpEvent.Id = calendarEvent.Id;
            tmpEvent.EventDate = calendarEvent.EventDate__c;
            //tmpEvent.Description = calendarEvent.Description__c;
            tmpEvent.Description = calendarEvent.Description_Long_Txt_Area__c;
            tmpEvent.EmailRecipient = calendarEvent.Email_Recipient__c;
            tmpEvent.ExternalLink = calendarEvent.External_Link__c;
            tmpEvent.InternalCommunityLink = calendarEvent.Internal_Community_Link__c;
            tmpEvent.InternalMobileLink = calendarEvent.Internal_Mobile_Link__c;
            tmpEvent.LinkLabel = calendarEvent.Link_Label__c;
            tmpEvent.linkType = calendarEvent.Link_Type__c;
            tmpEvent.Title = calendarEvent.Title__c;
            /*tmpEvent.majorEvent = calendarEvent.Major3event__c;*/
            tmpEvent.dateToDisplay = monthNames.get(calendarEvent.EventDate__c.month()) + ' ' + String.valueOf(calendarEvent.EventDate__c.day());

            return tmpEvent;
        }

        public List<icDtoCalendarEvent> mapToDto(List <CalendarEvent__c> calendarEvents ){

            List<icDtoCalendarEvent> dtoCalendarEvents = new List<icDtoCalendarEvent>();

            for(CalendarEvent__c calendarEvent : calendarEvents){

                dtoCalendarEvents.add(mapToDto(calendarEvent));
            }

            return dtoCalendarEvents;
        }

        public List<icDtoCalendarEvent> mapToDto(Set <CalendarEvent__c> calendarEvents ){

            List<icDtoCalendarEvent> dtoCalendarEvents = new List<icDtoCalendarEvent>();

            for(CalendarEvent__c calendarEvent : calendarEvents){

                dtoCalendarEvents.add(mapToDto(calendarEvent));
            }

            return dtoCalendarEvents;
        }

    }

}