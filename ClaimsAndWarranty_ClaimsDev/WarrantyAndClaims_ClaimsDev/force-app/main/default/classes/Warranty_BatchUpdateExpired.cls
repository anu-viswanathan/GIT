public class Warranty_BatchUpdateExpired implements Database.Batchable<sObject>, Schedulable {
	public String queryString = null;
	public Integer queryNumber = 0;
    public Map<String, Account> accountsByAccountId = new Map<String, Account>();
	
    public Warranty_BatchUpdateExpired()
    {
        
     
    }

    public Warranty_BatchUpdateExpired (Integer queryNum)
    {
        queryNumber = queryNum;
        
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        
        Date todayDate = Date.today();
        
        switch on queryNumber
        {
            when 1
            {
                System.debug('First query.');
                return Database.getQueryLocator ('SELECT ID, Architect__c, Consultant__c, Warranty_Expiry_Date__c, Warranty_Substatus__c FROM Warranty__c where Expired__c = null') ;
            }
            when 2
            {
                System.debug('Second query.');
                return Database.getQueryLocator ('SELECT ID, Architect__c, Consultant__c, Warranty_Expiry_Date__c, Warranty_Substatus__c FROM Warranty__c where Warranty_Expired_Date__c = null and Expired__c = \'Yes\'') ;
            }
            when 3
            {
                System.debug('Third query.');
                return Database.getQueryLocator ('SELECT ID, Architect__c, Consultant__c, Warranty_Expiry_Date__c, Warranty_Substatus__c FROM Warranty__c where Warranty_Substatus__c = \'Not Issued\' and Expired__c = \'No\'') ;
            }
            when else
            {
                System.debug('Forth query.');
                return Database.getQueryLocator('SELECT ID, Architect__c, Consultant__c, Warranty_Expiry_Date__c, Warranty_Substatus__c FROM Warranty__c where Expired__c =  \'No\' and Warranty_Expiry_Date__c <: todayDate');                 
            	
            }
        }
        
    }
    public void execute(Database.BatchableContext bc, List<Warranty__c> scope){
        // process each batch of record
        try
        {
                
        List<Warranty__c> lstExpiredWarranty = new List<Warranty__c>();      
            
        if (accountsByAccountId.isEmpty())
            {
                String accountName = 'N/A';
                List<Account> allAccounts = new List<Account>([SELECT Id, Name FROM Account WHERE name =: accountName]);
        		for(Account a : allAccounts) {
            		accountsByAccountId.put(a.Id, a);
                }
        	}    
        Integer i = 0;
        for (Warranty__c w : scope) {
            
            i++;
            
            if(accountsByAccountId.containsKey(w.Architect__c) == true) {
             	w.Architect__c = null;
            }
            
            if(accountsByAccountId.containsKey(w.Consultant__c) == true) {
            	w.Consultant__c = null;
            }
            
            if (w.Warranty_Expiry_Date__c != null && w.Warranty_Expiry_Date__c < Date.today())
            {
                w.Expired__c = 'Yes';
                w.Warranty_Expired_Date__c = string.valueofGmt(DateTime.now()) + '_' + string.valueOf(i);
            }
            else if (w.Warranty_Substatus__c == 'Not Issued')
            {
                w.Expired__c = 'Yes';
                w.Warranty_Expired_Date__c = string.valueofGmt(DateTime.now()) + '_' + string.valueOf(i);
            }
            else 
            {
                w.Expired__c = 'No';
                w.Warranty_Expired_Date__c = null;
            }
			
            lstExpiredWarranty.add(w);  
                 
        }   
        	System.Debug('update list ' + lstExpiredWarranty);
        	List<Database.SaveResult> saveResults = Database.Update(lstExpiredWarranty,false);
            System.Debug('error  list ' + saveResults);
			icServiceErrorHandler.handleDatabaseSaveResult('Claims',lstExpiredWarranty, saveResults, 'Warranty_BatchUpdateExpired', 'execute query ' + queryNumber);
			
        }
        Catch (Exception ex)
        {
            System.debug(ex.getMessage() );
            icServiceErrorHandler.LogError('Claims', 'Warranty_BatchUpdateExpired','execute' , ex.getStackTraceString(), ex.getMessage(), '');        
        }
    }   
    public void finish(Database.BatchableContext bc){
        Id job= bc.getJobId();
        System.debug(job);
        
        
    }  
    
    public void execute(SchedulableContext sc){
        try
        {
            Database.executeBatch(new Warranty_BatchUpdateExpired (1));
            Database.executeBatch(new Warranty_BatchUpdateExpired (2));
            Database.executeBatch(new Warranty_BatchUpdateExpired (3));
            Database.executeBatch(new Warranty_BatchUpdateExpired (4));
            
        }
        catch(Exception ex)
        {
            System.debug(ex.getMessage() );
            icServiceErrorHandler.LogError('Claims', 'Warranty_BatchUpdateExpired','execute' , ex.getStackTraceString(), ex.getMessage(), '');     
        }
    
    
    }
}