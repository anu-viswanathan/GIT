/**
* @Version: 1.0
* @Author: Maarten Devos
* @Copyright: 2020 4C Consulting
* @Uses:
* -----------------------------------------------------------------------------------------------
* Description: Unit tests for UpdateAccountOwnerBatchSchedule

* Unit tests: N/A
*
* Created: 20/01/2020
* Last Updated: 20/01/2020
*
* Change log:
* -----------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class UpdateAccountOwnerBatchScheduleTest {

    @isTest
    public static void testSchedule_AdaptSchedule() {
        Test.startTest();
        String cronExpr = '0 0 6 ? * * *';
        String scheduleId = UpdateAccountOwnerBatchSchedule.scheduleThis(cronExpr);

        // Get the information form the CronTrigger API Object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id= :scheduleId];

        // Verify the expressions are the same
        System.assertEquals(cronExpr, ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }

}