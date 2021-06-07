public class MyBatchClass implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator('SELECT Id, Name, Description FROM Account');
    }
    public void execute(Database.BatchableContext context, List<Account> records){
        // process each batch of records
        for(Account s : records)
        {
            s.Description = 'Test 1';
        }
        
       Database.update(records, false);
       
    }
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }
}