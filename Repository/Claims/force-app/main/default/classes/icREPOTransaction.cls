/**
 * Created by Francois Poirier on 2018-12-06.
 */

public with sharing class icREPOTransaction implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {

        Transaction__c createTransaction(Transaction__c trans);
        List<Database.SaveResult> createTransactions(List<Transaction__c> transactions);
    }


    public class Impl implements IClass {

        public Transaction__c createTransaction(Transaction__c trans){

            insert trans;
            return trans;

        }

        public List<Database.SaveResult> createTransactions(List<Transaction__c> transactions){
             System.debug('create ====> ' + transactions);
            return Database.insert(transactions, false);
        }
    }

}