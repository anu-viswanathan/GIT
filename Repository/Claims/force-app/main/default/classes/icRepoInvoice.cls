public class icRepoInvoice implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		List<Invoice__c> getAllInvoicesByAccountIdAndDate(String recordId, String strYear);
		List<Invoice__c> getAllInvoicesByAccountIdsAndRebateYear(List<String> recordIds, String rebateYear);
		List<Contractor_Invoice__c> getUploadedInvoiceById(List<String> recordIds);
		void updateInvoices(List<Contractor_Invoice__c> invoices);

	}

	public class Impl implements IClass {

		public List<Invoice__c> getAllInvoicesByAccountIdAndDate(String recordId, String strYear) {
			List<Invoice__c> listInvoices = new List<Invoice__c>();
			listInvoices =
					[SELECT	Id
							,Coop_Amount__c
							,Name
							,Total_Bundles__c
							,Invoice_Amount__c
							,Total_Rebates__c
							,Total_Rebate_Squares__c
							,Total_Actual_Squares__c
					FROM	Invoice__c
					WHERE	Contractor__c = :recordId
					AND		Invoice_Year__c = :strYear];
			return listInvoices;
		}

		public List<Invoice__c> getAllInvoicesByAccountIdsAndRebateYear(List<String> recordIds, String rebateYear) {
			List<Invoice__c> listInvoices = 
					[SELECT	Id
							,Contractor__c
							,Name
							,Total_Rebate_Squares__c
							,Invoice_Date__c
					FROM	Invoice__c
					WHERE	Contractor__c IN :recordIds
					AND		Invoice_Year__c = :rebateYear];
			return listInvoices;
		}

		public List<Contractor_Invoice__c> getUploadedInvoiceById(List<String> recordIds) {
			return [SELECT Id, Name, Status__c, Uploaded_Files_Long__c FROM Contractor_Invoice__c WHERE Id IN :recordIds];
		}

		public void updateInvoices(List<Contractor_Invoice__c> invoices) {
			update invoices;
		}
	}
}