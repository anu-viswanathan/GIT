trigger icTriggerOpportunity on Opportunity (before Insert, before Update, after Update){
    icHandlerOpportunity.IClass handler = (icHandlerOpportunity.IClass) icObjectFactory.GetSingletonInstance('icHandlerOpportunity');
	
	if(Trigger.isAfter && Trigger.isUpdate){
		System.debug('---> In Trigger IsAfter && isUpdate');
		handler.onAfterUpdate(Trigger.Old, Trigger.New, Trigger.OldMap);
	}
	if(Trigger.isBefore && Trigger.isUpdate){
		System.debug('---> In Trigger IsBefore && isUpdate');
		handler.onBeforeUpdate(Trigger.Old, Trigger.New, Trigger.OldMap);
	}
	if(Trigger.isBefore && Trigger.isInsert){
		System.debug('---> In Trigger IsBefore && isInsert');
		handler.onBeforeInsert(Trigger.Old, Trigger.New, Trigger.OldMap);
	}
}