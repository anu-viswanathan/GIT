trigger icTriggerAccount on Account (before insert, after insert, before update, after update) {
	icHandlerAccount.IClass handler = (icHandlerAccount.IClass) icObjectFactory.GetSingletonInstance('icHandlerAccount');

	if(Trigger.isAfter && Trigger.isInsert) {
		//handler.onAfterInsert(Trigger.new, Trigger.oldMap);
	}

	if(Trigger.isAfter && Trigger.isUpdate) {
		handler.onAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap);
		/*
		if(icAvoidRecursion.runOnce()){
			handler.onAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap);
		}
		*/
	}

	if(Trigger.isBefore && Trigger.isUpdate){
		handler.onBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap);
	}

}