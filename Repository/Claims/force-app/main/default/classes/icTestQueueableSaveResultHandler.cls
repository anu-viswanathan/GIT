@isTest
public with sharing class icTestQueueableSaveResultHandler {

	public static testMethod void testQueueablePlexSync(){
		List<Database.SaveResult> mockSaveResults = new List<Database.SaveResult>();
		Database.SaveResult mockSaveResult = (Database.SaveResult) JSON.deserialize('{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', Database.SaveResult.class);
		mockSaveResults.add(mockSaveResult);

		List<Order> mockQuotes = new List<Order>();
		Order mockQuote = new Order(Name = 'ORder1');
		mockQuotes.add(mockQuote);

		Test.StartTest();
		System.enqueueJob(new icQueueableSaveResultHandler(mockSaveResults, mockQuotes));
		Test.stopTest();
	}

}