/**
 * Created by Francois Poirier on 2019-04-17.
 */

@isTest
public with sharing class icTestRepoEventCalendar {

    static icRepoEventCalendar.IClass repo = (icRepoEventCalendar.IClass) icObjectFactory.GetSingletonInstance('icRepoEventCalendar');

    @isTest
    static void testgetActiveCalendarEventsByDateRangeTierCommunityName(){

        CalendarEvent__c testEvent = new CalendarEvent__c();
        testEvent.EventDate__c = Date.today();
        testEvent.Description_Long_Txt_Area__c = 'test event';
        testEvent.Active__c = true;
        testEvent.ContentLanguage__c = 'English';
        testEvent.Tier__c = '1';
        testEvent.Link_Type__c = 'No Link';
        testEvent.Title__c = 'test Event';
        testEvent.Publish_in__C = 'IKOROOFPRO_C';
        
        insert testEvent;


        List<CalendarEvent__c> testEventsFromRepoWithResult  = repo.getActiveCalendarEventsByDateRangeTierCommunityName(Date.today(), Date.today(), 'English', '1','IKOROOFPRO_C');
        List<CalendarEvent__c> testEventsFromRepoWithout  = repo.getActiveCalendarEventsByDateRangeTierCommunityName(Date.today(), Date.today(), 'English', '1','FORCE_NO_RESULT');
        
        system.assert(testEventsFromRepoWithResult.size()>0);
        system.assertEquals(testEventsFromRepoWithout.size(), 0);

    }

}