/**
 * Created by Francois Poirier on 2019-04-10.
 */

public with sharing class icLogicEventCalendar implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {
        List<CalendarEvent__c> getActiveCalendarEventsByDateRangeTierCommunityName(Date startDate, Date endDate, String language, String tier, String communityName);
       
    }

    public class Impl implements IClass {

        private icRepoEventCalendar.IClass eventCalendarRepo = (icRepoEventCalendar.IClass) icObjectFactory.GetSingletonInstance('icRepoEventCalendar');

        public List<CalendarEvent__c> getActiveCalendarEventsByDateRangeTierCommunityName(Date startDate, Date endDate, String language, String tier,String communityName){

            return eventCalendarRepo.getActiveCalendarEventsByDateRangeTierCommunityName(startDate, endDate, language, tier, communityName);

        }

    }
}