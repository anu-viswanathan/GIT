/**
 * Created by Anil Mannem (Incloud) on 19-May-2020
 */
trigger icTriggerTapeCode on Tape_Code__c (before insert, before update) {
    icHandlerTapeCode.IClass handler = (icHandlerTapeCode.IClass) icObjectFactory.GetSingletonInstance('icHandlerTapeCode');
    /**
     * Ticket ClaimsV2-118
     * Added logic to find and Map available Products with given Product Code on beforeInsert
     * By Anil Mannem (Incloud) on 20-May-2020
     */
	if (System.Trigger.isBefore && System.Trigger.isInsert) {
        handler.onBeforeInsert(System.Trigger.new);
 	}
}