@isTest
public with sharing class icTestBatchContractorInvoices {

	public static testMethod void test_batch() {
		icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicAttachment', new icLogicAttachmentMock());
		icTestMockUtilities.Tracer.SetReturnValue('icLogicAttachmentMock', 'getContentDocumentByRelatedRecordIds', new List<ContentDocumentLink>());		

		icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicInvoice', new icLogicInvoiceMock());
		icTestMockUtilities.Tracer.SetReturnValue('icLogicInvoiceMock', 'updateInvoices', new Contact());

		Account contractor = icTestHelperUtility.generateContractorAccount();
		insert contractor;

		//no docs, file empty
		
		Contractor_Invoice__c contractorInvoice1 = new Contractor_Invoice__c();
		contractorInvoice1.Contractor__c = contractor.Id;
		insert contractorInvoice1;

		//no docs, file not empty
		Contractor_Invoice__c contractorInvoice2 = new Contractor_Invoice__c();
		contractorInvoice2.Contractor__c = contractor.Id;
		contractorInvoice2.Uploaded_Files_Long__c = icTestHelperUtility.getFakeId(ContentDocumentLink.getSObjectType()) + ',';
		insert contractorInvoice2;

		//with docs, file empty
		Contractor_Invoice__c contractorInvoice3 = new Contractor_Invoice__c();
		contractorInvoice3.Contractor__c = contractor.Id;
		insert contractorInvoice3;
		List<ContentDocumentLink> contractorInvoice3Docs = new List<ContentDocumentLink>();
		contractorInvoice3Docs.add(new ContentDocumentLink(ContentDocumentId = icTestHelperUtility.getFakeId(ContentDocument.SObjectType)));

		//with docs, with file match
		String doc4Id = icTestHelperUtility.getFakeId(ContentDocument.SObjectType);
		Contractor_Invoice__c contractorInvoice4 = new Contractor_Invoice__c();
		contractorInvoice4.Contractor__c = contractor.Id;
		contractorInvoice4.Uploaded_Files_Long__c = doc4Id + ',' + icTestHelperUtility.getFakeId(ContentDocumentLink.getSObjectType()) + ',';
		insert contractorInvoice4;
		List<ContentDocumentLink> contractorInvoice4Docs = new List<ContentDocumentLink>();
		contractorInvoice4Docs.add(new ContentDocumentLink(ContentDocumentId = doc4Id));

		//with docs, with file match
		String doc5Id = icTestHelperUtility.getFakeId(ContentDocument.SObjectType);
		Contractor_Invoice__c contractorInvoice5 = new Contractor_Invoice__c();
		contractorInvoice5.Contractor__c = contractor.Id;
		contractorInvoice5.Uploaded_Files_Long__c = icTestHelperUtility.getFakeId(ContentDocumentLink.getSObjectType()) + ',';
		insert contractorInvoice5;
		List<ContentDocumentLink> contractorInvoice5Docs = new List<ContentDocumentLink>();
		contractorInvoice5Docs.add(new ContentDocumentLink(ContentDocumentId = doc5Id));

		Map<String, List<ContentDocumentLink>> mockMapDocLinks = new Map<String, List<ContentDocumentLink>>();
		mockMapDocLinks.put(contractorInvoice3.Id, contractorInvoice3Docs);
		mockMapDocLinks.put(contractorInvoice4.Id, contractorInvoice4Docs);
		mockMapDocLinks.put(contractorInvoice5.Id, contractorInvoice5Docs);
		icTestMockUtilities.Tracer.SetReturnValue('icLogicAttachmentMock', 'getMapListDocumentsByInvoiceId', mockMapDocLinks);
		
		icBatchContractorInvoices batchClass = new icBatchContractorInvoices();
		Database.executebatch(batchClass);
	}
}