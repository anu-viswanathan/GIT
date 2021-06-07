trigger icReimbursementTrigger on Reimbursement_Claims__c (before update) {

    if(Trigger.isBefore && Trigger.isUpdate){
        
        icReimbursementTriggerHandler.IClass approvalValidationHandler = (icReimbursementTriggerHandler.IClass) icObjectFactory.GetSingletonInstance('icReimbursementTriggerHandler');
    
        if(Trigger.new.size() == 1){
            
            approvalValidationHandler.handleApprovementValidation(Trigger.new[0], Trigger.old[0]);
            
        }
        
         
    }
    
}