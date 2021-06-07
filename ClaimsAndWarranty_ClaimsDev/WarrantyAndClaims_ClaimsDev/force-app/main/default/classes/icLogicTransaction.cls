/**
 * Created by Francois Poirier on 2018-12-06.
 */

public with sharing class icLogicTransaction implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {

        Transaction__c createTransaction(Transaction__c trans);
        void createTransactions(List<Transaction__c> transactions);
    }


    public class Impl implements IClass {

        private icREPOTransaction.IClass repoTransaction = (icREPOTransaction.IClass) icObjectFactory.GetSingletonInstance('icREPOTransaction');

        public Transaction__c createTransaction(Transaction__c trans){

            return repoTransaction.createTransaction(trans);


        }

        public void createTransactions(List<Transaction__c> transactions) {
            List<Database.SaveResult> saveResults = repoTransaction.createTransactions(transactions);
            Integer resultCounter = 0;
            List<IMT_Invoice_Log__c> errors = new List<IMT_Invoice_Log__c>();
            for(Database.SaveResult saveResult : saveResults) {
                if(!saveResult.isSuccess()) {
                    Transaction__c thisRecord = transactions.get(resultCounter);

                    Database.Error[] saveErrors = saveResult.getErrors();
                    String stackTrace = 'Errors:';
                    for(Database.Error upsertError : saveErrors) {
                        stackTrace += '\r\n - ' + upsertError.getMessage();
                    }

                    errors.add(icServiceErrorHandler.GenerateError('icLogicTransaction', 'createTransactions', stackTrace, saveResult.getErrors()[0].getMessage(), JSON.serialize(thisRecord)));
                }
                resultCounter++;
            }
            icServiceErrorHandler.LogErrors(errors);
        }
    }

}