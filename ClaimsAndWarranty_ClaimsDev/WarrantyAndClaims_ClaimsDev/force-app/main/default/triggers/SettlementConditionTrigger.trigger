trigger SettlementConditionTrigger on Settlement_Condition__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	if(System.Trigger.isBefore) 
		SettlementConditionService.blockCreatedUpdateDelete(System.Trigger.IsDelete ? System.Trigger.old : System.Trigger.new);

}