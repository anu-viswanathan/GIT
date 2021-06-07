/**
 * Created by Francois Poirier on 2019-06-11.
 */

public with sharing class icLogicCalendarEventTrigger implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {

        void beforeInsert(List<CalendarEvent__c> newCalendarEvents, Map<Id, CalendarEvent__c> newCalendarEventMap);
        void beforeUpdate(List<CalendarEvent__c> oldCalendarEvents, List<CalendarEvent__c> newCalendarEvents,
                Map<Id, CalendarEvent__c> oldCalendarEventMap, Map<Id, CalendarEvent__c> newCalendarEventMap);
    }

    public class Impl implements IClass {

        public void beforeInsert(List<CalendarEvent__c> newCalendarEvents, Map<Id, CalendarEvent__c> newCalendarEventMap) {

            newCalendarEvents = validateNavigationData(newCalendarEvents);

        }

        public void beforeUpdate(List<CalendarEvent__c> oldCalendarEvents, List<CalendarEvent__c> newCalendarEvents,
                Map<Id, CalendarEvent__c> oldCalendarEventMap, Map<Id, CalendarEvent__c> newCalendarEventMap){

            newCalendarEvents = validateNavigationData(newCalendarEvents);

        }

        private List<CalendarEvent__c> validateNavigationData(List<CalendarEvent__c> calendarEvents){

            for(CalendarEvent__c calendarEvent : calendarEvents){
                Boolean hasError = false;
                String headerError = Label.icMandatory_Fields_Error_Message;

                if(calendarEvent.Link_Type__c != 'No Link' && String.isBlank(calendarEvent.Link_Label__c)){
                    calendarEvent.Link_Label__c.addError(Label.icLink_Label_Mandatory);
                    hasError = true;
                    Schema.DescribeFieldResult field = CalendarEvent__c.Link_Label__c.getDescribe();
                    headerError += field.label;
                }

                if(calendarEvent.Link_Type__c == 'Email To' && String.isBlank(calendarEvent.Email_Recipient__c)){
                    calendarEvent.Email_Recipient__c.addError(Label.icEmail_Recipient_Madatory);
                    if(hasError){
                        headerError += ', ';
                    }
                    hasError = true;
                    Schema.DescribeFieldResult field = CalendarEvent__c.Email_Recipient__c.getDescribe();
                    headerError += field.label;
                }

                if(calendarEvent.Link_Type__c == 'External' && String.isBlank(calendarEvent.External_Link__c)){
                    calendarEvent.External_Link__c.addError(Label.icExternal_Link_Mandatory);
                    if(hasError){
                        headerError += ', ';
                    }
                    hasError = true;
                    Schema.DescribeFieldResult field = CalendarEvent__c.External_Link__c.getDescribe();
                    headerError += field.label;

                }

                if(calendarEvent.Link_Type__c == 'Internal' && String.isBlank(calendarEvent.Internal_Community_Link__c)){
                    calendarEvent.Internal_Community_Link__c.addError(Label.icCommunity_Link_Mandatory);
                    if(hasError){
                        headerError += ', ';
                    }
                    hasError = true;
                    Schema.DescribeFieldResult field = CalendarEvent__c.Internal_Community_Link__c.getDescribe();
                    headerError += field.label;
                }


                if(calendarEvent.Link_Type__c == 'Internal' && String.isBlank(calendarEvent.Internal_Mobile_Link__c)){
                    calendarEvent.Internal_Mobile_Link__c.addError(Label.icMobile_Link_Mandatory);
                    if(hasError){
                        headerError += ', ';
                    }
                    hasError = true;
                    Schema.DescribeFieldResult field = CalendarEvent__c.Internal_Mobile_Link__c.getDescribe();
                    headerError += field.label;
                }

                if(hasError){
                    calendarEvent.addError(headerError);
                }
            }



            return calendarEvents;
        }
    }


}