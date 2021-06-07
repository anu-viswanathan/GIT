/**
 * Created by Gerard van Kempen on 2019-12-24.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

public class CleanupSchedulable_Activator {
    public static void activateAll() {
        CleanupSchedulable_EuPricingAgreement.schedule();
        CleanupSchedulable_EuOpenInvoice.schedule();
        CleanupSchedulable_EuOpenOrder.schedule();
    }

    public static void deactivateAll() {
        List<String> jobNames = new List<String>();
        jobNames.add(CleanupSchedulable_EuPricingAgreement.jobName);
        jobNames.add(CleanupSchedulable_EuOpenInvoice.jobName);
        jobNames.add(CleanupSchedulable_EuOpenOrder.jobName);

        List<CronTrigger> matchedJobs = [
                SELECT Id
                FROM CronTrigger
                WHERE CronJobDetailId IN (
                        SELECT Id
                        FROM CronJobDetail
                        WHERE Name IN :jobNames
                )
        ];

        for(CronTrigger job : matchedJobs) {
            System.abortJob(job.Id);
        }
    }
}