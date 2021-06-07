trigger icTriggerOpportunityLineItem on OpportunityLineItem (before insert, before delete){
    icHandlerOpportunityLineItem.IClass handler = (icHandlerOpportunityLineItem.IClass) icObjectFactory.GetSingletonInstance('icHandlerOpportunityLineItem');

	if(Trigger.isBefore && Trigger.isInsert){
		handler.onBeforeInsert(Trigger.New);
	}

	if(Trigger.isBefore && Trigger.isDelete){
		System.debug('---> In Trigger isBefore && isDelete');
		handler.onBeforeDelete(Trigger.Old, Trigger.OldMap);
	}
}