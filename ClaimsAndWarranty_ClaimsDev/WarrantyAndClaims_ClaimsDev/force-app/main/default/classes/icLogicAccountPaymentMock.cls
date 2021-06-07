/**
 * Created by Francois Poirier on 2018-12-13.
 */

@isTest
public with sharing class icLogicAccountPaymentMock implements icLogicAccountPayment.IClass {

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

    public Map<String, IKOPRO_Account_Payment__c> getMapPaidRenewalByContractorId(List<IKOPRO_Account_Payment__c> payments){

        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getMapPaidRenewalByContractorId');
        params.put('payments', payments);
        return (Map<String, IKOPRO_Account_Payment__c>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getMapPaidRenewalByContractorId');

    }

    public IKOPRO_Account_Payment__c updateAccountPayment(IKOPRO_Account_Payment__c accountPayment){

        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'updateAccountPayment');
        params.put('accountPayment', accountPayment);
        return (IKOPRO_Account_Payment__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'updateAccountPayment');

    }
}