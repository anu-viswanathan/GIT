public with sharing class QueueCaseSharingFieldUpdates implements Queueable{

    List<Account> newAccounts{get;set;}
    Map<Id, Account> oldAccountsByIds{get;set;}

    
    public QueueCaseSharingFieldUpdates(List<Account> newAccts, Map<Id, Account> oldAcctsByIds) {
            this.newAccounts = newAccts;
            this.oldAccountsByIds = oldAcctsByIds;
    }

    public void execute(QueueableContext context) {

        try {
            CaseSharingRulesUtility.afterUpdateAccounts(newAccounts, oldAccountsByIds);
        } 
        catch (Exception ex) {
            System.debug('Error occurred in QueueCaseSharingFieldUpdates : ' + ex.getMessage());
        }
    }

}