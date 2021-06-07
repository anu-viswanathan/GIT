/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestLogicQuote {

    public static testMethod void test_getQuoteInfoById(){

        icLogicQuote.IClass BL = (icLogicQuote.IClass) icObjectFactory.GetSingletonInstance('icLogicQuote');

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoQuote', new icREPOQuoteMock());
        icTestMockUtilities.Tracer.SetReturnValue('icREPOQuoteMock', 'getQuoteInfoById', new Quote());

        BL.getQuoteInfoById('');

    }

}