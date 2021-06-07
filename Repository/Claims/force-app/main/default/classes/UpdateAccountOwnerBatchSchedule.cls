/**
* @Version: 1.0
* @Author: Maarten Devos
* @Copyright: 2020 4C Consulting
* @Uses:
* -----------------------------------------------------------------------------------------------
* Description: Schedule UpdateAccountOwnerBatch class to run on a specified schedule

* Unit tests: UpdateAccountOwnerBatchScheduleTest
*
* Created: 20/01/2020
* Last Updated: 20/01/2020
*
* Change log:
* -----------------------------------------------------------------------------------------------
*/

global with sharing class UpdateAccountOwnerBatchSchedule implements Schedulable {

    global void execute(SchedulableContext ctx) {
        Id batchId = Database.executeBatch(new UpdateAccountOwnerBatch());
        System.debug('Scheduled batch Id - UpdateAccountOwnerBatch: ' + batchId);
    }

    global static String scheduleThis() {
        return scheduleThis(null);
    }

    global static String scheduleThis(String scheduleCron) {
        UpdateAccountOwnerBatchSchedule job = new UpdateAccountOwnerBatchSchedule();
        // Run job every day at 5h
        String schedule = '0 0 5 ? * * *';
        if (scheduleCron != null) {
            schedule = scheduleCron;
        }
        String batchName = 'UpdateAccountOwnerBatch - ' + schedule;
        String jobId = System.schedule(batchName, schedule, job);
        return jobId;
    }

}