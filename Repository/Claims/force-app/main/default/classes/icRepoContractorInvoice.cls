/**
* Created by Francois Poirier on 2019-11-18.
*/

public with sharing class icRepoContractorInvoice implements icIClass {
    
    public Object GetInstance() {
        return new Impl();
    }
    
    public Interface IClass {
        void saveContractorInvoice(Contractor_Invoice__c invoice);
        Contractor_Invoice__c getContractorInvoiceById(Id contractorInvoiceId);
    }
    
    public class Impl implements IClass {
        
        public void saveContractorInvoice(Contractor_Invoice__c invoice){
            upsert invoice;
        }
        
        public Contractor_Invoice__c getContractorInvoiceById(Id contractorInvoiceId){
            Contractor_Invoice__c invoice = new Contractor_Invoice__c();
            invoice = [
                SELECT  Id,
                Name,
                Status__c,
                Invoice_Date__c,
                Invoice_Number__c,
                Rebate_Program_Formula__c
                FROM    Contractor_Invoice__c
                WHERE   Id =: contractorInvoiceId
                LIMIT   1
            ];
            
            return invoice;
        }
    }   
}