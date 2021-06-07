@isTest
public class icTestReimbursementTriggerHandler {
    
    static testmethod void test_handleApprovementValidation(){
        
        Reimbursement_Claims__c newOne = new Reimbursement_Claims__c(Internal_Status__c = 'Approved');
        Reimbursement_Claims__c oldOne = new Reimbursement_Claims__c(Internal_Status__c = 'NotApproved');
        
    	icReimbursementTriggerHandler.IClass approvalValidationHandler = (icReimbursementTriggerHandler.IClass) icObjectFactory.GetSingletonInstance('icReimbursementTriggerHandler');
        
		Test.startTest();
        approvalValidationHandler.handleApprovementValidation(newOne, oldOne);
        
        Reimbursement_Claims__c testClaim = new Reimbursement_Claims__c();
        insert testClaim;
        update testClaim;
        Test.stopTest();
        
    }

}