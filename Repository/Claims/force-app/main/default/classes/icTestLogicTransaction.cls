/**
 * Created by Francois Poirier on 2018-12-17.
 */

@isTest
public with sharing class icTestLogicTransaction {


    @isTest static void testCreateTransaction(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icREPOTransaction', new icREPOTransactionMock());
        icTestMockUtilities.Tracer.SetReturnValue('icREPOTransactionMock', 'createTransaction', new Transaction__c());
        icLogicTransaction.IClass transactionLogic = (icLogicTransaction.IClass) icObjectFactory.GetSingletonInstance('icLogicTransaction');
        Transaction__c testTransaction = new Transaction__c();
        testTransaction = transactionLogic.createTransaction(testTransaction);
        
    }

    @isTest static void testCreateTransactions(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icREPOTransaction', new icREPOTransactionMock());
        List<Database.SaveResult> mockSaveResults = new List<Database.SaveResult>();
        Database.SaveResult mockSaveResult = (Database.SaveResult)JSON.deserialize('{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', Database.SaveResult.class);
        mockSaveResults.add(mockSaveResult);        
        icTestMockUtilities.Tracer.SetReturnValue('icREPOTransactionMock', 'createTransactions', mockSaveResults);
        icLogicTransaction.IClass transactionLogic = (icLogicTransaction.IClass) icObjectFactory.GetSingletonInstance('icLogicTransaction');
        Transaction__c testTransaction = new Transaction__c();
        transactionLogic.createTransactions(new List<Transaction__c> {testTransaction});
        
    }
}