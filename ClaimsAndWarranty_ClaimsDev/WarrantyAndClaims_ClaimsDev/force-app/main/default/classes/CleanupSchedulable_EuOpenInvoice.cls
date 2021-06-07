/**
 * Created by Gerard van Kempen on 2019-12-18.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

global class CleanupSchedulable_EuOpenInvoice implements Schedulable {

    global static final String jobName = 'Cleanup (daily) - Closed EU_Open_Invoice__c';

    global void execute(SchedulableContext context) {
        this.run();
    }

    global static void schedule() {
        String cronExp = '0 40 3 * * ?';
        System.schedule(jobName, cronExp, (new CleanupSchedulable_EuOpenInvoice()));
    }

    global void run() {
        final Datetime today = Datetime.now();
        final List<EU_Cleanup_Schedulables_Config__mdt> configsList = [
                SELECT Target_Object_Developer_Name__c, Maximum_Age__c
                FROM EU_Cleanup_Schedulables_Config__mdt
                WHERE Target_Object_Developer_Name__c = :EU_Open_Invoice__c.class.getName()
        ];
        if(configsList.size() != 1) {
            System.debug(LoggingLevel.ERROR, 'could not load configuration for schedulable: configuration is missing or ambiguous');
            return;
        }
        final EU_Cleanup_Schedulables_Config__mdt config = configsList.get(0);
        Date maxDate = today.addDays(-((Integer)config.Maximum_Age__c)).date();

        if (System.Test.isRunningTest()) {
            // set date to tomorrow because we can't alter lastmodifieddate
            maxDate = today.addDays(1).date();
        }

        List<EU_Open_Invoice__c> invoicesToBeDeleted = [
                SELECT Id
                FROM EU_Open_Invoice__c
                WHERE EU_Open_Invoice__c = TRUE
                AND LastModifiedDate < :maxDate LIMIT 10000
        ];
        try {
            delete invoicesToBeDeleted;
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR, 'could not delete objects: DML returned an error');
            System.debug(LoggingLevel.ERROR, e);
        }
    }
}