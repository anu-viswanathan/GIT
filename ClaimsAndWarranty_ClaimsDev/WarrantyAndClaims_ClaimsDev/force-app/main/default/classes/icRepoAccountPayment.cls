/**
 * Created by Francois Poirier on 2018-12-11.
 */

public without sharing class icRepoAccountPayment  implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {

        IKOPRO_Account_Payment__c getAccountPaymentById(Id accountPaymentId);
        List<IKOPRO_Account_Payment__c> getPaidAccountPaymentByYearAndContractorIds(String strYear, List<String> contractorIds);
        IKOPRO_Account_Payment__c updateAccountPayment(IKOPRO_Account_Payment__c accountPayment);

    }

    public class Impl implements IClass {

        public IKOPRO_Account_Payment__c getAccountPaymentById(Id accountPaymentId){

            List<IKOPRO_Account_Payment__c> accountPayments = new List<IKOPRO_Account_Payment__c>();
            IKOPRO_Account_Payment__c retour = new IKOPRO_Account_Payment__c();

            accountPayments = [
                    SELECT  Id,
                            Contractor__c,
                            Contractor__r.Primary_Contact_FirstName_Applicant__pc,
                            Contractor__r.Primary_Contact_LastName_Applicant__pc,
                            Contractor__r.BillingStreet,
                            Contractor__r.BillingCity,
                            Contractor__r.BillingStateCode,
                            Contractor__r.BillingCountryCode,
                            Contractor__r.BillingPostalCode,
                            Applicant__c,
                            Applicant__r.Company_Street_Applicant__c,
                            Applicant__r.Company_City_Applicant__c,
                            Applicant__r.Zip_Postal_Code_Applicant__c,
                            Applicant__r.Company_State_Province_Code_Applicant__c,
                            Applicant__r.Country_Code_Applicant__c,
                            Contractor_Email__c,
                            Currency__c,
                            Name,
                            Net_Membership_Fee__c,
                            Paid_Amount__c,
                            Paid_Date__c,
                            Year__c
                    FROM    IKOPRO_Account_Payment__c
                    WHERE   Id =: accountPaymentId
            ];

            if(accountPayments.size()>0){
                retour = accountPayments[0];
            }

            return retour;

        }

        public List<IKOPRO_Account_Payment__c> getPaidAccountPaymentByYearAndContractorIds(String strYear, List<String> contractorIds) {
            return [SELECT Id
                            ,Contractor__c
                    FROM IKOPRO_Account_Payment__c
                    WHERE Year__c = :strYear
                    AND Contractor__c IN :contractorIds
                    AND Paid_Date__c != null];
        }

        public IKOPRO_Account_Payment__c updateAccountPayment(IKOPRO_Account_Payment__c accountPayment){

            update accountPayment;
            return accountPayment;

        }

    }
}