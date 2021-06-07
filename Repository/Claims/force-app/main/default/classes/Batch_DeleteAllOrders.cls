/*
TO RUN

Batch_DeleteAllOrders foo = new Batch_DeleteOrders();
Id batchId = Database.executeBatch(foo, 50);
*/

global class Batch_DeleteAllOrders implements 
    Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {

        String q;
        q = 'SELECT Id ';
        q += 'FROM Order ';
        // q += 'WHERE EffectiveDate = 2018-12-01 ';
		// use this to filter some testing
        
        return Database.getQueryLocator( q );
    }

        
    global void execute(Database.BatchableContext bc, List<Order> scope){
		System.Debug('Size of List ' + scope.size());

        Integer counter = 1;

        List<Order> n = new List<Order>();
	        
        for(Order o : scope) {
        
            If(Math.floor(counter/2) == counter/2) {
                n.add(o);
            }
            counter +=1;
            }
          System.Debug(n.size());
          delete n;
    }
        
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed. Shazam!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        // call some utility to send email
        // EmailUtils.sendMessage(job, recordsProcessed);
    }    
}