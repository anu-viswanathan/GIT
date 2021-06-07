/**
 * @description Contact sObject trigger
 * @author Sinan Bunni
 * @date
 */
trigger ContactTrigger on Contact (before insert, before update, before delete,
						after insert, after update, after delete, after undelete) {

	if (System.Trigger.IsBefore && System.Trigger.IsInsert) {
		ContactService.validateBuildingLocationContactsWithNotInDraftCaseStatus(System.Trigger.new);
	}

	if (System.Trigger.IsBefore && System.Trigger.IsUpdate) {
		ContactService.validateBuildingLocationContactsWithNotInDraftCaseStatus(System.Trigger.new);
	}

}