public class icLogicInvoice implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		List<Invoice__c> getAllYTDInvoicesByAccountId(String recordId);
		List<Invoice__c> getAllInvoicesByAccountIdsAndRebateYear(List<String> recordIds, String rebateYear);
		Map<String, List<Invoice__c>> getMapInvoicesByAccount(List<Invoice__c> invoices);
		List<Contractor_Invoice__c> getUploadedInvoiceById(List<String> recordIds);
		Double getSquaresFromInvoices(List<Invoice__c> invoices, Boolean isProrated, Date startDate);
		Double getPro4RewardsFromInvoices(List<Invoice__c> invoices);
		Double getCoopRewardsFromInvoices(List<Invoice__c> invoices);
		Double getUpcomingCoopRewardsFromInvoices(List<Invoice__c> invoices);
		void updateInvoices(List<Contractor_Invoice__c> invoices);
	}

	public class Impl implements IClass {

		icRepoInvoice.IClass repository = (icRepoInvoice.IClass) icObjectFactory.GetSingletonInstance('icRepoInvoice');

		public List<Invoice__c> getAllYTDInvoicesByAccountId(String recordId) {
			Date fromDate = Date.today();
			String strYear = String.valueOf(fromDate.year());

			List<Invoice__c> listInvoices = repository.getAllInvoicesByAccountIdAndDate(recordId, strYear);
			return listInvoices;
		}

		public List<Invoice__c> getAllInvoicesByAccountIdsAndRebateYear(List<String> recordIds, String rebateYear) {
			return repository.getAllInvoicesByAccountIdsAndRebateYear(recordIds, rebateYear);
		}

		public Map<String, List<Invoice__c>> getMapInvoicesByAccount(List<Invoice__c> invoices) {
			Map<String, List<Invoice__c>> returnMap = new Map<String, List<Invoice__c>>();

			for(Invoice__c thisInvoice : invoices) {
				List<Invoice__c> thisAccountInvoices = returnMap.get(thisInvoice.Contractor__c);
				if(thisAccountInvoices == null) {
					thisAccountInvoices = new List<Invoice__c>();
				}
				thisAccountInvoices.add(thisInvoice);
				returnMap.put(thisInvoice.Contractor__c, thisAccountInvoices);
			}

			return returnMap;
		}

		public List<Contractor_Invoice__c> getUploadedInvoiceById(List<String> recordIds) {
			return repository.getUploadedInvoiceById(recordIds);
		}

		public Double getSquaresFromInvoices(List<Invoice__c> invoices, Boolean isProrated, Date startDate) {
			Double returnTotal = 0;
			for(Invoice__c thisInvoice : invoices) {
				if(!isProrated || thisInvoice.Invoice_Date__c >= startDate) {
					returnTotal += thisInvoice.Total_Rebate_Squares__c;
				}
			}
			return returnTotal;
		}

		public Double getPro4RewardsFromInvoices(List<Invoice__c> invoices) {
			Double returnTotal = 0;
			for(Invoice__c thisInvoice : invoices) {
				returnTotal += thisInvoice.Total_Rebates__c;
			}
			return returnTotal;
		}

		public Double getCoopRewardsFromInvoices(List<Invoice__c> invoices) {
			Invoice__c temp;
			if(invoices.size() > 0) {
				temp = invoices[0];
			}
			return temp.Total_Bundles__c;
		}

		public Double getUpcomingCoopRewardsFromInvoices(List<Invoice__c> invoices){

			Double returnTotal = 0;
			for(Invoice__c thisInvoice : invoices) {
				if(thisInvoice.Coop_Amount__c != null) {
					returnTotal += thisInvoice.Coop_Amount__c;
				}
			}
			return returnTotal;

		}

		public void updateInvoices(List<Contractor_Invoice__c> invoices) {
			repository.updateInvoices(invoices);
		}
	}
}