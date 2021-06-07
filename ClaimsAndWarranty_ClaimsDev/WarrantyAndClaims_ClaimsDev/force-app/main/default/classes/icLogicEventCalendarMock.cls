/**
 * Created by Francois Poirier on 2019-04-17.
 */

@isTest
public with sharing class icLogicEventCalendarMock implements icLogicEventCalendar.IClass {

    public List<CalendarEvent__c> getActiveCalendarEventsByDateRangeTierCommunityName(Date startDate, Date endDate, String language, String tier, String communityName){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getActiveCalendarEventsByDateRangeTierCommunityName');
        params.put('startDate', startDate);
        params.put('endDate', endDate);
        params.put('language', language);
        params.put('tier', tier);
        params.put('communityName', communityName);
        return (List<CalendarEvent__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getActiveCalendarEventsByDateRangeTierCommunityName');
    }

   /* public List<CalendarEvent__c> getNext3EventsForTier(String language, String tier) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getNext3EventsForTier');
        params.put('language', language);
        params.put('tier', tier);
        return (List<CalendarEvent__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getNext3EventsForTier');
    }

    public List<CalendarEvent__c> getTopEventsByLanguageAndTier(String language, String tier) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getTopEventsByLanguageAndTier');
        params.put('language', language);
        params.put('tier', tier);
        return (List<CalendarEvent__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getTopEventsByLanguageAndTier');
    }*/

}