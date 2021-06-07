/* To Run

Batch_MergeAccounts foo = new Batch_MergeAccounts();
Id batchId = Database.executeBatch(foo, 10);

*/

global class Batch_MergeAccounts implements
    Database.Batchable<sObject>, Database.Stateful {
        
        global Database.QueryLocator start(Database.BatchableContext bc) {
            String q = 'SELECT Id, Master__c, Duplicates__c FROM To_Merge__c';
            
            return Database.getQueryLocator(q);
        }
        
        global void execute(Database.BatchableContext bc, List<To_Merge__c> scope) {
        for(To_Merge__c m : scope) {
            
            Account master = new Account();
                master.Id = m.Master__c;
            
            Account duplicate = new Account();
                duplicate.Id = m.Duplicates__c.trim();
            
            merge master duplicate;
        }

		delete scope;
        }
	
        global void finish(Database.BatchableContext bc) {
            // do nothing
        }
        
    }