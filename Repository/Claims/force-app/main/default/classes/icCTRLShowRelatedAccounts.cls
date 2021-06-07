// CLAIMSV2-967- Vivek (Incloud)
    // This method will get the addresses related to the street which we entred in the new claim form 

public with sharing class icCTRLShowRelatedAccounts {
    @AuraEnabled
    public static List<RelatedAccountDetails> getAllRelatedAccounts(String street, String city, String state, String postalCode, String country ){

        List<RelatedAccountDetails> relatedAccounts = new List<RelatedAccountDetails>();
        street =  ('%'+ street + '%');
        Map<ID, List<Case>> accountIdWithcaseObjs = new Map<Id, List<Case>>();

        List<Account> accounts = [SELECT Id, Name, BillingStreet, BillingCountry, BillingState, BillingCity, BillingPostalCode FROM Account 
                                    WHERE BillingStreet LIKE :street AND
                                    RecordType.Name = 'Building Location' Order By BillingStreet,BillingCity,BillingState LIMIT 10];

        List<Case> cases = [SELECT Id, AccountId, CaseNumber, Claim_Number__c FROM Case WHERE AccountId IN :accounts AND ParentId = NULL];
        // Earlier we were checking for single account for single case, now we are checking for all the related cases for the account.
        for(Case caseObj : cases){
            if(!accountIdWithcaseObjs.containsKey(caseObj.AccountId)){
                accountIdWithcaseObjs.put(caseObj.AccountId, new List<Case>());
            }
            accountIdWithcaseObjs.get(caseObj.AccountId).add(caseObj);
        }

        for(Account accObj : accounts){

            if(accountIdWithcaseObjs.containsKey(accObj.Id)){
                for(Case caseObj : accountIdWithcaseObjs.get(accObj.Id)){
                    RelatedAccountDetails relatedAccountObj = new RelatedAccountDetails();
                    relatedAccountObj.caseObj = caseObj;
                    relatedAccountObj.isAssociated = true;
                    prepareAddress(relatedAccountObj, accObj);
                    relatedAccounts.add(relatedAccountObj);
                }
            }else{
                RelatedAccountDetails relatedAccountObj = new RelatedAccountDetails();
                prepareAddress(relatedAccountObj, accObj);
                relatedAccountObj.isAssociated = false;
                relatedAccounts.add(relatedAccountObj);
            }
        }
        return relatedAccounts;
    }
    public static void prepareAddress( RelatedAccountDetails relatedAccountObj, Account accObj){
        relatedAccountObj.relatedAccountObj = accObj;
        relatedAccountObj.fullAddress = '';
        if(accObj.BillingStreet != null){
            relatedAccountObj.fullAddress += (accObj.BillingStreet + ' ');
        }
        
        if(accObj.BillingCity != null){
            relatedAccountObj.fullAddress += (accObj.BillingCity + ' ');
        }

        if(accObj.BillingPostalCode != null){
            relatedAccountObj.fullAddress += (accObj.BillingPostalCode + ' ');
        }

        if(accObj.BillingState != null){
            relatedAccountObj.fullAddress += (accObj.BillingState + ' ');
        }
        
        if(accObj.BillingCountry != null){
            relatedAccountObj.fullAddress += (accObj.BillingCountry + ' ');
        }
    }

    @AuraEnabled
    public static List<RelatedAccountDetails> getRelatedAccountsByCaseId(String caseId){

        Case caseObj = [SELECT Id, Account.BillingStreet, Account.BillingCountry,  Account.BillingState,  Account.BillingCity, Account.BillingPostalCode FROM Case WHERE ID = :caseId];
        return getAllRelatedAccounts(caseObj.Account.BillingStreet, caseObj.Account.BillingCity, caseObj.Account.BillingState, caseObj.Account.BillingPostalCode, caseObj.Account.BillingCountry);
    }


    public class RelatedAccountDetails{

        @AuraEnabled
        public Account relatedAccountObj {get; set;}
        @AuraEnabled
        public String fullAddress {get; set;}
        @AuraEnabled
        public Boolean isAssociated;
        @AuraEnabled
        public Case caseObj{get; set;}

    }
}