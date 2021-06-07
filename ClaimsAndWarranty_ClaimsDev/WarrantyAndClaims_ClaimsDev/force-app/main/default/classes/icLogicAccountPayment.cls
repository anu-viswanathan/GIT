/**
 * Created by Francois Poirier on 2018-12-11.
 */

public without sharing class icLogicAccountPayment implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {

        IKOPRO_Account_Payment__c getAccountPaymentById(Id accountPaymentId);
        List<IKOPRO_Account_Payment__c> getPaidAccountPaymentByYearAndContractorIds(String strYear, List<String> contractorIds);
        Map<String, IKOPRO_Account_Payment__c> getMapPaidRenewalByContractorId(List<IKOPRO_Account_Payment__c> payments);
        IKOPRO_Account_Payment__c updateAccountPayment(IKOPRO_Account_Payment__c accountPayment);

    }

    public class Impl implements IClass {

        private icRepoAccountPayment.IClass apRepo = (icRepoAccountPayment.IClass) icObjectFactory.GetSingletonInstance('icRepoAccountPayment');

        public IKOPRO_Account_Payment__c getAccountPaymentById(Id accountPaymentId){

            return apRepo.getAccountPaymentById(accountPaymentId);

        }

        public List<IKOPRO_Account_Payment__c> getPaidAccountPaymentByYearAndContractorIds(String strYear, List<String> contractorIds){
            return apRepo.getPaidAccountPaymentByYearAndContractorIds(strYear, contractorIds);
        }

        public Map<String, IKOPRO_Account_Payment__c> getMapPaidRenewalByContractorId(List<IKOPRO_Account_Payment__c> payments) {
            Map<String, IKOPRO_Account_Payment__c> returnMap = new Map<String, IKOPRO_Account_Payment__c>();

            for(IKOPRO_Account_Payment__c thisPayment : payments) {
                returnMap.put(thisPayment.Contractor__c, thisPayment);
            }

            return returnMap;
        }

        public IKOPRO_Account_Payment__c updateAccountPayment(IKOPRO_Account_Payment__c accountPayment){

            return apRepo.updateAccountPayment(accountPayment);

        }

    }


}