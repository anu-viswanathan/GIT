public with sharing class PaymentRequestService {

	/*
		Block all updates for Case when the Claim_Stage__c is Closed, *unless* it is being re-opened
	*/
	public static void blockCreatedUpdateDelete(List<Payment_Request__c> records) {
		User runningUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];

		Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
		List<Id> caseIds = new List<Id>();

		for (Payment_Request__c rp : records)
			caseIds.add(rp.Case__c);

		Map<Id, Case> caseMap = new Map<Id, Case>([
				SELECT Id, RecordTypeId, Claim_Stage__c
				FROM Case
				WHERE Id IN :caseIds AND RecordTypeId IN :claimRecordTypes.keySet() AND Claim_Stage__c = 'Closed']);

		if (caseMap.isEmpty())
			return;

		for (Payment_Request__c rp : records) {
			if (caseMap.get(rp.Case__c) <> NULL && runningUser.Profile.Name != 'System Administrator') {
				rp.addError('Payment Requests cannot be modified for a closed case');
			}
		}
	}


	public static void checkValidationForDecra(List<Payment_Request__c> records, Map<Id, Payment_Request__c> oldMap){

		set<Id> accountIds = new Set<Id>();
		set<Id> contactIds = new Set<Id>();
		set<Id> caseIds = new Set<Id>();
        Map<Id, Account> accountsMap = new Map<Id, Account>();
		Map<Id, Contact> contactsMap = new Map<Id, Contact>();
		Map<Id, Case> caseMap = new Map<Id, Case>();
        List<Payment_Request__c> paymentsToProcess = new List<Payment_Request__c>();
        for(Payment_Request__c paymentRequestObj : records){
            
				System.debug('before if condition');
                if(oldMap == null || (oldMap.get(paymentRequestObj.Id).Second_Payee__C != paymentRequestObj.Second_Payee__C 
                                        || oldMap.get(paymentRequestObj.Id).Account__c != paymentRequestObj.Account__c 
                                        || oldMap.get(paymentRequestObj.Id).Contact__C != paymentRequestObj.Contact__C 
                                       ))
                {
					System.debug('coming till here in the if condition');
                    if(paymentRequestObj.Account__C != null){
                        accountIds.add(paymentRequestObj.Account__C);
                    }
    
                    if(paymentRequestObj.Contact__C != null){
                        contactIds.add(paymentRequestObj.Contact__C);
                    }
    
                    if(paymentRequestObj.Second_Payee__C != null){
                        contactIds.add(paymentRequestObj.Second_Payee__C);
                    }
    
                   
					paymentsToProcess.add(paymentRequestObj);
					caseIds.add(paymentRequestObj.Case__c);
                }
            
		}

		if(!accountIds.isEmpty()){
            accountsMap = new Map<Id, Account>([SELECT Id, Iko_Division_Visible_To__c FROM Account WHERE Id IN :accountIds]);
        }

        if(!contactIds.isEmpty()){
            contactsMap = new Map<Id, Contact>([SELECT Id, Account.Iko_Division_Visible_To__c, AccountId FROM Contact WHERE Id IN :contactIds]);
		}
		
		if(!caseIds.isEmpty()){
			caseMap = new Map<Id, Case>([SELECT Id, Payment_Request__c, Sector__C FROM  Case WHERE ID IN : caseIds]);
		}
		System.debug('accountsMap' + accountsMap);
		for(Payment_Request__c paymentRequestObj : paymentsToProcess){
        {
			if(paymentRequestObj.Case__c != null && caseMap.get(paymentRequestObj.Case__c).Sector__C == 'Decra' )
			{
           
                if(paymentRequestObj.Account__C != null){
					System.debug('coming till here');
                    if(accountsMap.get(paymentRequestObj.Account__C).Iko_Division_Visible_To__c != 'Decra'){
						System.debug('coming  not till here');
                        paymentRequestObj.addError('Please select decra account');
                    }
                }

                if(paymentRequestObj.Contact__C != null){
                    if(contactsMap.get(paymentRequestObj.Contact__C).AccountId != null && contactsMap.get(paymentRequestObj.Contact__C).Account.Iko_Division_Visible_To__c != 'Decra'){
                        paymentRequestObj.addError('Please select Decra contact');
                    }
                }

                if(paymentRequestObj.Second_Payee__C != null){
                    if(contactsMap.get(paymentRequestObj.Second_Payee__C).AccountId != null && contactsMap.get(paymentRequestObj.Second_Payee__C).Account.Iko_Division_Visible_To__c != 'Decra'){
                        paymentRequestObj.addError('Please select Decra  second payee');
                    }
                }

            }else{

                if(paymentRequestObj.Account__C != null){
                    if(accountsMap.get(paymentRequestObj.Account__C).Iko_Division_Visible_To__c == 'Decra'){
                        paymentRequestObj.addError('Please select non Decra account');
                    }
                }


                if(paymentRequestObj.Contact__c != null){
                    if(contactsMap.get(paymentRequestObj.Contact__C).AccountId != null && contactsMap.get(paymentRequestObj.Contact__C).Account.Iko_Division_Visible_To__c == 'Decra'){
                        paymentRequestObj.addError('Please select non Decra contact');
                    }
                }

                if(paymentRequestObj.Second_Payee__C != null){
                    if(contactsMap.get(paymentRequestObj.Second_Payee__C).AccountId != null && contactsMap.get(paymentRequestObj.Second_Payee__C).Account.Iko_Division_Visible_To__c == 'Decra'){
                        paymentRequestObj.addError('Please select non Decra second payee');
                    }
                }

               
            }

        }

	}
	}
}