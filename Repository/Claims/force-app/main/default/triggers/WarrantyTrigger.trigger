trigger WarrantyTrigger on Warranty__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	if (System.Trigger.isBefore && System.Trigger.isInsert) {
		WarrantyService.setSequencePrefix(System.Trigger.new);
		WarrantyService.generateRegistrationNumber(System.Trigger.new);
        WarrantyService.UpdateWarrantyExpired(System.Trigger.new, System.Trigger.oldMap);
    }

	if (System.Trigger.isBefore && System.Trigger.isUpdate) {
		WarrantyService.setSequencePrefix(System.Trigger.new);
		WarrantyService.generateRegistrationNumber(System.Trigger.new);
        WarrantyService.UpdateWarrantyExpired(System.Trigger.new, System.Trigger.oldMap);        
         
	}

    /* Ticket CLAIMSV2-624
     * Added conditions to display error Message when submitting record for Approval,
     * By: Anil Mannem (Incloud) on 12-May-2020
     */
    if(System.Trigger.isAfter && System.Trigger.isUpdate) {
		WarrantyService.validateApprovalSubmission(System.Trigger.new, System.Trigger.oldMap);
	 }
}