/**
 * Created by Gerard van Kempen on 2019-12-24.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

public class CleanupSchedulable_EuPricingAgreement implements Schedulable {

    public static final String jobName = 'Cleanup (daily) - Expired EU_Price_Agreement__c';

    public void execute(SchedulableContext context) {
        this.run();
    }

    public static void schedule() {
        String cronExp = '0 0 3 * * ?';
        System.schedule(jobName, cronExp, (new CleanupSchedulable_EuPricingAgreement()));
    }

    private class IntTuple {
        public Integer field_0 = 0;
        public Integer field_1 = 0;
    }

    private void run() {
        final Datetime today = Datetime.now();
        final List<EU_Cleanup_Schedulables_Config__mdt> configsList = [
                SELECT Target_Object_Developer_Name__c, Maximum_Age__c
                FROM EU_Cleanup_Schedulables_Config__mdt
                WHERE Target_Object_Developer_Name__c = :EU_Price_Item__c.class.getName()
        ];
        if(configsList.size() != 1) {
            System.debug(LoggingLevel.ERROR, 'could not load configuration for schedulable: configuration is missing or ambiguous');
            return;
        }
        final EU_Cleanup_Schedulables_Config__mdt config = configsList.get(0);
        Date maxDate = today.addDays(-((Integer)config.Maximum_Age__c)).date();

        if (System.Test.isRunningTest()) {
            maxDate = today.addDays(-48).date();
        }

        List<EU_Price_Item__c> expiredPriceItems = [
                SELECT Id, EU_Pricing_Agreement__c, EU_Expiry_Date__c
                FROM EU_Price_Item__c
                WHERE EU_Expiry_Date__c < :maxDate
        ];

        Set<Id> priceAgreementsWithExpiredItemsIds = new Set<Id>();
        for(EU_Price_Item__c item : expiredPriceItems) {
            priceAgreementsWithExpiredItemsIds.add(item.EU_Pricing_Agreement__c);
        }

        try {
            delete expiredPriceItems;
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR, 'could not delete objects: DML returned an error');
            System.debug(LoggingLevel.ERROR, e);
        }


        List<EU_Price_Agreement__c> agreementsToCheckForHavingChildren = [
                SELECT Id, (SELECT Id FROM Price_Items__r)
                FROM EU_Price_Agreement__c
                WHERE Id IN :priceAgreementsWithExpiredItemsIds
        ];

        List<EU_Price_Agreement__c> agreementsWithoutChildren = new List<EU_Price_Agreement__c>();
        for(EU_Price_Agreement__c agreement : agreementsToCheckForHavingChildren) {
            if(agreement.Price_Items__r.isEmpty()) {
                agreementsWithoutChildren.add(agreement);
            }
        }

        try {
            delete agreementsWithoutChildren;
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR, 'could not delete objects: DML returned an error');
            System.debug(LoggingLevel.ERROR, e);
        }
    }
}