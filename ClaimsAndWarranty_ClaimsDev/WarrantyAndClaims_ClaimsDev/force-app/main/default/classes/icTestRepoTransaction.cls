/**
 * Created by Francois Poirier on 2018-12-17.
 */

@isTest
public with sharing class icTestRepoTransaction {

    static icREPOTransaction.IClass transactionRepo = (icREPOTransaction.IClass) icObjectFactory.GetSingletonInstance('icREPOTransaction');

    @isTest
    static void testCreateTransaction(){

        Account newAccount = new Account();
        newAccount = icTestHelperUtility.generateOtherAccount();
        insert newAccount;

        Transaction__c testTransaction = new Transaction__c();
        testTransaction.Account_ID__c = newAccount.Id;
        testTransaction.Amount__c = 1;
        testTransaction.Currency_Used__c = 'USD';
        testTransaction.Transaction_Sources__c = 'Other';
        testTransaction.Transaction_Type__c = 'Debit';

        testTransaction = transactionRepo.createTransaction(testTransaction);

        system.assert(String.isNotBlank(testTransaction.id));

    }

    @isTest
    static void testCreateTransactions(){
        Account newAccount = new Account();
        newAccount = icTestHelperUtility.generateOtherAccount();
        insert newAccount;

        Transaction__c testTransaction = new Transaction__c();
        testTransaction.Account_ID__c = newAccount.Id;
        testTransaction.Amount__c = 1;
        testTransaction.Currency_Used__c = 'USD';
        testTransaction.Transaction_Sources__c = 'Other';
        testTransaction.Transaction_Type__c = 'Debit';

        List<Database.SaveResult> results = transactionRepo.createTransactions(new List<Transaction__c>{testTransaction});
    }

}