/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icREPOQuoteMock implements icRepoQuote.IClass{

    public Quote getQuoteInfoById(String recordId) {

        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getQuoteInfoById');
        params.put('recordId', recordId);
        return (Quote) icTestMockUtilities.Tracer.GetReturnValue(this, 'getQuoteInfoById');

    }
}