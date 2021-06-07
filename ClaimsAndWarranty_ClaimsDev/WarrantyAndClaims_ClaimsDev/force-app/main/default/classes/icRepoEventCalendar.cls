/**
 * Created by Francois Poirier on 2019-04-10.
 */

public with sharing class icRepoEventCalendar implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {
        List<CalendarEvent__c> getActiveCalendarEventsByDateRangeTierCommunityName(Date startDate, Date endDate, String language, String tier, String communityName);
    }

    public class Impl implements IClass {

        public List<CalendarEvent__c> getActiveCalendarEventsByDateRangeTierCommunityName(Date startDate, Date endDate, String language, String tier, String communityName){

            List<CalendarEvent__c> calendarEvents = new List<CalendarEvent__c>();

            calendarEvents = [
                    SELECT  Id,
                            Active__c,
                            ContentLanguage__c,
                            //Description__c,
                            Description_Long_Txt_Area__c,
                            Email_Recipient__c,
                            EventDate__c,
                            External_Link__c,
                            Internal_Community_Link__c,
                            Internal_Mobile_Link__c,
                            Link_Label__c,
                            Link_Type__c,
                            Tier__c,
                            Title__c
                    FROM    CalendarEvent__c
                    WHERE   EventDate__c >= :startDate
                    AND     EventDate__c <= :endDate
                    AND     Active__c = true
                    AND     ContentLanguage__c = :language
                    AND     Tier__c INCLUDES(:tier)
                    AND     Publish_in__c INCLUDES(:communityName)
                    ORDER BY EventDate__c ASC
            ];

            return calendarEvents;
        }
    }
}