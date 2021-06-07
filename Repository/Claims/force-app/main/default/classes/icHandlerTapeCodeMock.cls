/**
 * Created by Anil Mannem (Incloud) on 21-May-2020
 */
 @isTest
public with sharing class icHandlerTapeCodeMock implements icHandlerTapeCode.IClass {
	/**
	 * Ticket ClaimsV2-118
	 * By Anil Mannem (Incloud) on 21-May-2020
	 */
	public void onBeforeInsert(List<Tape_Code__c> newTapeCodes) {
		Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'onBeforeInsert');
		params.put('newTapeCodes', newTapeCodes);
	} // end of onBeforeInsert	
}