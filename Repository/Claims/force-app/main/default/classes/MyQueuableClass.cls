public class MyQueuableClass implements Queueable {
    
    public List<Account> accounts {get;set;}
    
    public MyQueuableClass(List<Account> records)
    {
        this.accounts = records;
    }
    
    public void execute(QueueableContext context) {
        for(Account a : accounts){
        	system.debug('In Queuable');
        }
    }
}