/**
 * Created by Francois Poirier on 2018-12-13.
 */

@isTest
public with sharing class icLogicTransactionMock implements icLogicTransaction.IClass {

    public Transaction__c createTransaction(Transaction__c trans){

        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createTransaction');
        params.put('trans', trans);
        return (Transaction__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'createTransaction');
    }

    public void createTransactions(List<Transaction__c> transactions){

        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createTransactions');
        params.put('transactions', transactions);
        //return (CastType) icTestMockUtilities.Tracer.GetReturnValue(this, 'createTransactions');
    }
}