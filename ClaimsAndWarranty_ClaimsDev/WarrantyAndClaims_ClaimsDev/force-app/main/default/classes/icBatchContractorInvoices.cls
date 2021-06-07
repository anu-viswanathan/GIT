global class icBatchContractorInvoices implements Database.Batchable<sObject> {

	icLogicAttachment.IClass documentLogic = (icLogicAttachment.IClass) icObjectFactory.GetSingletonInstance('icLogicAttachment');
	icLogicInvoice.IClass invoiceLogic = (icLogicInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicInvoice');

	global Database.QueryLocator start(Database.BatchableContext context) {

		return Database.getQueryLocator('SELECT Id, File_Mistmatch__c, Uploaded_Files_Long__c, Status__c FROM Contractor_Invoice__c ');
	}

	global void execute(Database.BatchableContext context, List<Contractor_Invoice__c> scope) {
		List<String> listInvoiceIds = new List<String>();

		for(Contractor_Invoice__c thisInvoice : scope) {
			listInvoiceIds.add(thisInvoice.Id);
		}

		List<ContentDocumentLink> relatedDocuments = documentLogic.getContentDocumentByRelatedRecordIds(listInvoiceIds);
		Map<String, List<ContentDocumentLink>> mapListDocumentsByInvoiceId = documentLogic.getMapListDocumentsByInvoiceId(relatedDocuments);

		system.debug('invoices ===> ' + scope);

		for(Contractor_Invoice__c thisInvoice : scope) {
			String actualFileIds = '';
			String deltaFileIds = '';

			thisInvoice.File_Mistmatch__c = false;

			system.debug('thisInvoice ===> ' + thisInvoice);

			List<ContentDocumentLink> thisInvoiceRelatedDocs = mapListDocumentsByInvoiceId.get(thisInvoice.Id);
			system.debug('thisInvoiceRelatedDocs ===> ' + thisInvoiceRelatedDocs);

			if(thisInvoiceRelatedDocs == null) {
				system.debug('thisInvoiceRelatedDocs is null');

				if(thisInvoice.Uploaded_Files_Long__c != null) {
					thisInvoice.File_Mistmatch__c = true;
				}
			}
			else
			{

				system.debug('thisInvoiceRelatedDocs is not null');

				if(thisInvoice.Uploaded_Files_Long__c == null) {
					thisInvoice.File_Mistmatch__c = true;
				} /*else {*/

				Set<Id> thisInvoiceRelatedDocIds = new Set<Id>();
				List<String> thisInvoiceRelatedDocStrings = new List<String>();

				if(thisInvoice.Uploaded_Files_Long__c != null){
					thisInvoice.Uploaded_Files_Long__c = thisInvoice.Uploaded_Files_Long__c.replaceAll(' ', '');
					thisInvoiceRelatedDocStrings = thisInvoice.Uploaded_Files_Long__c.split(',');
				}

				for(String tmpStrId : thisInvoiceRelatedDocStrings ){
					//try {
						Id tmpId = tmpStrId;
						thisInvoiceRelatedDocIds.add(tmpId);
					/*}
					catch (Exception ex){
						system.debug('Error processin id ===> ' + tmpStrId);
					}*/
				}

				for(ContentDocumentLink thisDoc : thisInvoiceRelatedDocs) {
					actualFileIds += thisDoc.ContentDocumentId + ', ';
					if(!thisInvoiceRelatedDocIds.contains(thisDoc.ContentDocumentId)) {
						thisInvoice.File_Mistmatch__c = true;
						deltaFileIds += thisDoc.ContentDocumentId + ', ';
					}
				}

			}

			if(thisInvoice.Status__c == 'Uploaded' || thisInvoice.Status__c == 'Ready for Upload' || thisInvoice.Status__c == 'Draft' ){
				system.debug('invoice in status uploaded or ready for upload');
				thisInvoice.File_Mistmatch__c = false;
				thisInvoice.Uploaded_Files_Long__c = actualFileIds;
				thisInvoice.ACTUAL_FILE_IDS__c = actualFileIds;
				thisInvoice.DELTA_FILE_IDS__c = '';
			}
			else {
				thisInvoice.ACTUAL_FILE_IDS__c = actualFileIds;
				thisInvoice.DELTA_FILE_IDS__c = deltaFileIds;
			}

		}

		invoiceLogic.updateInvoices(scope);
	}

	global void finish(Database.BatchableContext context) {
	}
}