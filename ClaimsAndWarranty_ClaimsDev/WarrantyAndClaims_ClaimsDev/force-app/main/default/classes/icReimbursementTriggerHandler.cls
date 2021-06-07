public class icReimbursementTriggerHandler implements icIClass{
    
     public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {
	
		void handleApprovementValidation(Reimbursement_Claims__c newReimbursement, Reimbursement_Claims__c oldReimbursement);
    }


    public class Impl implements IClass {
        
         public void handleApprovementValidation(Reimbursement_Claims__c newReimbursement, Reimbursement_Claims__c oldReimbursement){

			if(oldReimbursement.Internal_Status__c != 'Approved' && newReimbursement.Internal_Status__c == 'Approved' && newReimbursement.Net_Claim_Amount__c == null) {
            	newReimbursement.addError('TO APPROVE THIS CLAIM, PLEASE ENTER APPROVED AMOUNT ON CLAIM IN THE NET REIMBURSABLE AMOUNT.');
        	}

        }
        
    }


}