/**
 * Created by Francois Poirier on 2018-12-13.
 */

@isTest
public with sharing class icRepoAccountPaymentMock implements icRepoAccountPayment.IClass {


    public IKOPRO_Account_Payment__c getAccountPaymentById(Id accountPaymentId){

        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAccountPaymentById');
        params.put('accountPaymentId', accountPaymentId);
        return (IKOPRO_Account_Payment__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAccountPaymentById');
    }

    public List<IKOPRO_Account_Payment__c> getPaidAccountPaymentByYearAndContractorIds(String strYear, List<String> contractorIds){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getPaidAccountPaymentByYearAndContractorIds');
        params.put('strYear', strYear);
        params.put('contractorIds', contractorIds);
        return (List<IKOPRO_Account_Payment__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getPaidAccountPaymentByYearAndContractorIds');   
    }

    public IKOPRO_Account_Payment__c updateAccountPayment(IKOPRO_Account_Payment__c accountPayment){

        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createTransaction');
        params.put('accountPayment', accountPayment);
        return (IKOPRO_Account_Payment__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'createTransaction');

    }

}