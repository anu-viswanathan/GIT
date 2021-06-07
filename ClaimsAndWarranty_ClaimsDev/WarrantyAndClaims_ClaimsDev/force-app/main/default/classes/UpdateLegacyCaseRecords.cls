global class UpdateLegacyCaseRecords implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, Legacy_External_ID__c, SYS_UserRole__c, CreatedBy.UserRole.Name FROM Case ' + 
            'WHERE Legacy_External_ID__c != NULL'
        );
    }
    global void execute(Database.BatchableContext bc, List<Case> records){
        // process each batch of records

        for (Case caseRecord : records) {
            caseRecord.SYS_UserRole__c = caseRecord.CreatedBy.UserRole.Name;
        }
        update records;
        
    } 
    
    global void finish(Database.BatchableContext bc){
    	// VOID
    }    
}