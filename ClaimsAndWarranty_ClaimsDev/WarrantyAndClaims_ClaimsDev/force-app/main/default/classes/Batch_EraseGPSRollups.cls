/*
SF-91
- We need to erase all the values int he various account fields so that they're null
- If this isn't done, a value that was calculated will stay in perpetuity even if an account is no longer ordering
- It will also screw up the logic for the field (which depends on the null values)

Batch_EraseGPSRollups foo = new Batch_EraseGPSRollups();
Id batchId = Database.executeBatch(foo, 50);

This is called after the UpdateAccountStatistics method is finished
*/

global class Batch_EraseGPSRollups implements 
    Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {

		// In theory if the 
        String q;
        q = 'SELECT Id, Name ';
        q += 'FROM Account ';
        q += 'WHERE (';
        q += 'YTD_Dollars__c != null ';
        q += 'OR Order_Summary_Previous_Year_Full__c != null)';
        

        q += 'ORDER BY Name ASC';
		System.Debug(q);
        
        return Database.getQueryLocator( q );
    }

        
    global void execute(Database.BatchableContext bc, List<Account> scope){
		System.Debug('Size of List ' + scope.size());
        
		List<Account> accounts = new List<Account>();
        	accounts.addAll(scope);
        
        // Really straightforward: loop throug the list and set all the fields we care about to NULL
        // then update them
        for(Account a : accounts) {
            a.Order_Summary_Bundles_Current_YTD__c = null;
            a.Order_Summary_Bundles_Previous_Year__c = null;
            a.Order_Summary_Bundles_Previous_YTD__c = null;
            a.YTD_Dollars__c = null;
            a.Last_Month_Dollars__c = null;
            a.Last_Year_Month_Dollars__c = null;
            a.Order_Summary_Last_Month_Year_Qty__c = null;
            a.Order_Summary_Last_Month_Qty__c = null;
            a.Order_Summary_Previous_Year_Full__c = null;
            a.Previous_Year_YTD_Dollars__c = null;
            a.YTD_Quantity__c = null;
            a.Order_Summary_Quantity_Previous_Year__c = null;
            a.Previous_Year_YTD_Quantity__c = null;
            a.Order_Summary_Month__c = null;
        }
        
        update accounts;
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

        Database.executeBatch(new Batch_UpdateAccountOrderAmounts());

    }    
}