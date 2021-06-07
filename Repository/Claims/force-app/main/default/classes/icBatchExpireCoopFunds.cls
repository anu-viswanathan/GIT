global class icBatchExpireCoopFunds implements Database.Batchable<sObject> {

    icLogicAccount.IClass logicAccount = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');
    icLogicTransaction.IClass logicTransaction = (icLogicTransaction.IClass) icObjectFactory.GetSingletonInstance('icLogicTransaction');
   
    
    global Database.QueryLocator start(Database.BatchableContext context){
        return Database.getQueryLocator('SELECT Id, Name, Available_COOP_Funds__c, Available_Premium_COOP_Funds__c FROM Account LIMIT 2');
    }

    global void execute(Database.BatchableContext context, List<Account> scope){
         List<Transaction__c> listExpiryTransactions = new List<Transaction__c>();

        System.debug('execute Batch with ' + scope.size() + ' records');

        Date dateToday = Date.today();

        for(Account thisAccount : scope) {
            thisAccount.Expired_Co_Op_Funds__c = thisAccount.Available_COOP_Funds__c;
            thisAccount.Expired_Premium_Cap__c = thisAccount.Available_Premium_COOP_Funds__c;
            thisAccount.Prior_Year_Co_Op_Funds_Remaining__c = thisAccount.Available_COOP_Funds__c;
            thisAccount.Prior_Year_Premium_Cap_Remaining__c = thisAccount.Available_Premium_COOP_Funds__c;

            listExpiryTransactions.add(new Transaction__c(
                Account_ID__c = thisAccount.Id,
                Transaction_Date__c = dateToday,
                Transaction_Sources__c = 'Expired Funds',
                Transaction_Type__c = 'Debit',
                Amount__c = thisAccount.Available_COOP_Funds__c,
                Currency_Used__c = 'Co-op $',
                Reason_for_Co_op_Entry__c = 'End of Year: funds expired'));
            listExpiryTransactions.add(new Transaction__c(
                Account_ID__c = thisAccount.Id,
                Transaction_Date__c = dateToday,
                Transaction_Sources__c = 'Expired Funds',
                Transaction_Type__c = 'Debit',
                Amount__c = thisAccount.Available_Premium_COOP_Funds__c,
                Currency_Used__c = 'Premium Co-op $',
                Reason_for_Co_op_Entry__c = 'End of Year: funds expired'));
        }

        System.debug('create ' + listExpiryTransactions.size() + ' expired transactions');

        logicAccount.saveAccounts(scope);
        logicTransaction.createTransactions(listExpiryTransactions);
    }

    global void finish(Database.BatchableContext context){
              
    }
}