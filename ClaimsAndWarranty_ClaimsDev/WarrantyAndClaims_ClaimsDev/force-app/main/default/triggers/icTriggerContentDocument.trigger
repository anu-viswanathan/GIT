trigger icTriggerContentDocument on ContentDocument (before delete) {
	icHandlerContentDocument.IClass handler = (icHandlerContentDocument.IClass) icObjectFactory.GetSingletonInstance('icHandlerContentDocument');

	if(Trigger.isBefore && Trigger.isDelete) {
		handler.onBeforeDelete(Trigger.old, Trigger.oldMap);
	}
}