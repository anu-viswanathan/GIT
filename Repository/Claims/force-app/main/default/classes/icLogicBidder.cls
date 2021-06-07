/**
 * Created by Anil Mannem on 03-Aug-2020
 */
public with sharing class icLogicBidder implements icIClass {

	public Object GetInstance(){
		return new Impl();
	}

	public interface IClass {
		List<Bidder__c> getBidderInfo();
		List<Bidder__c> getBidderDetailsforPDF(String recordId);
		List<Bidder__c> getBidderDetailsforPDFAutomation(List<Id> bidderIdList);
        void updateBidderStatus(List<Bidder__c> bidderList);
	}

	public class Impl implements IClass {
		icRepoBidder.IClass repository = (icRepoBidder.IClass) icObjectFactory.GetSingletonInstance('icRepoBidder');
		
		public List<Bidder__c> getBidderInfo() {
			return repository.getBidderInfo();
		}

		public List<Bidder__c> getBidderDetailsforPDF(String recordId) {
			return repository.getBidderDetailsforPDF(recordId);
		}
		
		public List<Bidder__c> getBidderDetailsforPDFAutomation(List<Id> bidderIdList){
			return repository.getBidderDetailsforPDFAutomation(bidderIdList);
		}

		public void updateBidderStatus(List<Bidder__c> bidderList) {
			repository.updateBidderStatus(bidderList);
		}
	}
}