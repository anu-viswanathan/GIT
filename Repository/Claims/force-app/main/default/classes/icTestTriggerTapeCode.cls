/**
 * Created by Anil Mannem (Incloud) on 25-May-2020
 */
@isTest
public with sharing class icTestTriggerTapeCode {
    @isTest
    static void testTapeCodeTrigger() {
    	icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerTapeCode', new icHandlerTapeCodeMock());

        Tape_Code__c newTapeCode = new Tape_Code__c();
        newTapeCode.Name = 'Test';
        insert newTapeCode;
    }
}