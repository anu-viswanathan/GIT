/**
 * Created by Francois Poirier on 2019-04-17.
 */

@isTest
public with sharing class icTestDtoCalendarEvent {

    @isTest
    static void testdtoCalendar(){

        icDtoCalendarEvent dto = new icDtoCalendarEvent();
        dto.Id = icTestHelperUtility.getFakeId(CalendarEvent__c.SObjectType);
        dto.Name = icTestHelperUtility.generateRandomString(20);
        dto.Description = icTestHelperUtility.generateRandomString(100);
        dto.EventDate = Date.today();
        dto.dateToDisplay = icTestHelperUtility.generateRandomString(10);
        //dto.majorEvent = true;
        dto.EmailRecipient = icTestHelperUtility.generateRandomString(10);
        dto.ExternalLink = icTestHelperUtility.generateRandomString(15);
        dto.InternalCommunityLink = icTestHelperUtility.generateRandomString(15);
        dto.InternalMobileLink = icTestHelperUtility.generateRandomString(15);
        dto.LinkLabel = icTestHelperUtility.generateRandomString(15);
        dto.linkType = icTestHelperUtility.generateRandomString(15);
        dto.Title = icTestHelperUtility.generateRandomString(15);


    }
}