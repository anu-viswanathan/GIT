@isTest
public class icTestTriggerBidder {
    static Account newBuildingLocation;
    static Account newDistributor;
    static Opportunity newOpportunity;
    static Bidder__c newBidder;

    static void createData(){
    	icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerBidder', new icHandlerBidderMock());
        newBuildingLocation = icTestHelperDataCreator.generateAccountByRecordType('Building Location');
        Insert newBuildingLocation;
        newDistributor = icTestHelperDataCreator.generateAccountByRecordType('US Distributor');
        insert newDistributor;
        newOpportunity = icTestHelperDataCreator.generateOpportunityByRecordType('US Sales Bid', newBuildingLocation.Id);
        insert newOpportunity;
        newBidder = new Bidder__c(Opportunity__c = newOpportunity.Id, Distributor_Account__c = newDistributor.Id );
        insert newBidder;        
    }
    public static testMethod void test_triggerOnBeforeInsert(){
        createData();
    }
    public static testMethod void test_triggerOnBeforeUpdate(){
        createData();
        newBidder.Status__c = 'Won';
        update newBidder;
    }
}