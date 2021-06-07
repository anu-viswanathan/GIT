global class UpdateLegacyLabSampleRecords implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, Case__c,  Legacy_Id__c, Case_Subject__c, Case_Description__c FROM Lab_Sample__c ' + 
            'WHERE Legacy_Id__c != NULL'
        );
    }
    global void execute(Database.BatchableContext bc, List<Lab_Sample__c> records){
        // process each batch of records
        Set<Id> relatedCases = new Set<Id>();
        for (Lab_Sample__c labSample : records) {
            relatedCases.add(labSample.Case__c);
        }

        Map<Id, Case> cases = new Map<Id, Case>([SELECT Id, Description, Subject FROM Case WHERE Id IN :relatedCases]);

        for (Lab_Sample__c labSample : records) {
            Case c = cases.get(labSample.Case__c);
            if (c.Description != NULL && c.Description != '' ) {
              labSample.Case_Description__c = c.Description;
            }
        }
        update records;
    } 
    
    global void finish(Database.BatchableContext bc){
    	// VOID
    }    
}