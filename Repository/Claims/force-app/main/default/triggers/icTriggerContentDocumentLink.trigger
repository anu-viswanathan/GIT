trigger icTriggerContentDocumentLink on ContentDocumentLink (after insert) {
	icHandlerContentDocument.IClass handler = (icHandlerContentDocument.IClass) icObjectFactory.GetSingletonInstance('icHandlerContentDocument');

	if(Trigger.isAfter && Trigger.isInsert) {
		handler.onAfterInsert(Trigger.old, Trigger.new, Trigger.newMap);
	}
}