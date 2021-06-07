/**
 * Created by Francois Poirier on 2018-12-13.
 */

@isTest
public with sharing class icREPOTransactionMock implements icREPOTransaction.IClass {

    public Transaction__c createTransaction(Transaction__c trans){

        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createTransaction');
        params.put('trans', trans);
        return (Transaction__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'createTransaction');
    }

    public List<Database.SaveResult> createTransactions(List<Transaction__c> transactions){

        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createTransactions');
        params.put('transactions', transactions);
        return (List<Database.SaveResult>) icTestMockUtilities.Tracer.GetReturnValue(this, 'createTransactions');
    }

}