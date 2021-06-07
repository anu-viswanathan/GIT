public class icHandlerBidder implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
        void onBeforeInsert(List<Bidder__c> newBidders);
        void onBeforeUpdate(List<Bidder__c> oldBidders, List<Bidder__c> newBidders, Map<Id, Bidder__c> biddersMap);
        void onAfterInsert(List<Bidder__c> newBidders, Map<Id, Bidder__c> biddersMap);
    }

	public class Impl implements IClass {

		icLogicBidder.IClass logicBidder = (icLogicBidder.IClass) icObjectFactory.GetSingletonInstance('icLogicBidder');

		public void onBeforeInsert(List<Bidder__c> newBidders) {
            List<Bidder__c> bidderList = logicBidder.getBidderInfo();
            List<String> uniqueIdList = new List<String>();
            for (Bidder__c thisBidder : bidderList) {
                uniqueIdList.add(thisBidder.Unique_ID__c);
            }
            for (Bidder__c thisBidder : newBidders) {
                thisBidder.Unique_ID__c = thisBidder.Opportunity__c + '' +thisBidder.Distributor_Account__c + '' + thisBidder.Contractor_Account__c;
                Boolean result = uniqueIdList.contains(thisBidder.Unique_ID__c);
                if(result) {
                    thisBidder.addError(System.Label.icBidderPair);
                }
            }
        }

        public void onBeforeUpdate(List<Bidder__c> oldBidders, List<Bidder__c> newBidders, Map<Id, Bidder__c> biddersOldMap) {
            List<Bidder__c> bidderList = logicBidder.getBidderInfo();
            for (Bidder__c thisBidder : newBidders) {
                Bidder__c oldBidder = biddersOldMap.get(thisBidder.ID);
                thisBidder.Unique_ID__c = thisBidder.Opportunity__c + '' +thisBidder.Distributor_Account__c + '' + thisBidder.Contractor_Account__c;
                if(oldBidder.Unique_ID__c != thisBidder.Unique_ID__c) {
                    List<String> uniqueIdList = new List<String>();
                    for (Bidder__c thisBidderList : bidderList) {
                        uniqueIdList.add(thisBidderList.Unique_ID__c);
                    }
                    Boolean result = uniqueIdList.contains(thisBidder.Unique_ID__c);
                    if(result) {
                        thisBidder.addError(System.Label.icBidderPair);
                    }
                }
            }
        }

        public void onAfterInsert(List<Bidder__c> newBidders, Map<Id, Bidder__c> biddersMap){
            List<Id> bidderIdList = new List<Id>();
            for(Bidder__c thisBidder : newBidders){
                bidderIdList.add(thisBidder.Id);
            }
            if(!bidderIdList.isEmpty()){
                icBidderGeneratePDF.bidderGeneratePDF(bidderIdList);
            }
        }
    }
}