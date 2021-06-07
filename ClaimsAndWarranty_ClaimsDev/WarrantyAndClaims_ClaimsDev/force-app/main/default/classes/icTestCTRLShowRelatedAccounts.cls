@isTest
public class icTestCTRLShowRelatedAccounts {

    @testSetup static void setupTestData() {

		Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
		Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();

		//create Account
		List<Account> toInsertAccounts = new List<Account>();

		toInsertAccounts.addAll(TestFactory.createAccounts(baRt,'CaseServiceTest','9 King St E','Toronto','ON','CA','M4S 2H4',
				'Verified',UserInfo.getUserId(),TRUE,TRUE,1,false));
        
        toInsertAccounts.addAll(TestFactory.createAccounts(baRt,'CaseServiceTest1','9 King St E','Toronto','ON','CA','M4S 2H4',
				'Verified',UserInfo.getUserId(),TRUE,TRUE,1,false));
        
        toInsertAccounts[1].Iko_Division_Visible_To__c = 'Decra';
        
		insert toInsertAccounts;
        
        List<Contact> toInsertContacts = new List<Contact>();

		toInsertContacts.addAll(TestFactory.createContacts(toInsertAccounts[0].Id,'CaseServiceTest',UserInfo.getUserId(),2,false));
		toInsertContacts.addAll(TestFactory.createContacts(toInsertAccounts[1].Id,'CaseServiceTest1',UserInfo.getUserId(),1,false));
		toInsertContacts.addAll(TestFactory.createContacts(toInsertAccounts[1].Id,'CaseServiceTest1',UserInfo.getUserId(),1,false));
        
		insert toInsertContacts;

		Map<String,Account> mapAccounts = new Map<String, Account>();

		for(Account act : [SELECT Id,Name FROM Account]){
			mapAccounts.put(act.Name,act);
		}
		List<Case> toInsertCases = new List<Case>();
		toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTestClosed',null,'Commercial','Closed',1,false));
		toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTest1',null,'Commercial','Draft',1,false));
        toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTest2',null,'Commercial','Draft',1,false));
		toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest1').Id,toInsertContacts[2].Id,'Distributor','CaseServiceTest3',null,'Commercial','Draft',1,false));
        
        toInsertCases[3].Sector__c = 'Decra';
		insert toInsertCases;
    }
    
    @isTest
    public static void getAllRelatedAccountsTest(){
        icCTRLShowRelatedAccounts.getAllRelatedAccounts('9 King St E', 'Toronto', 'ON', 'M4S 2H4', 'CA');
    }
    
    @isTest
    public static void getRelatedAccountsByCaseIdTest(){
        List<Case> cases = [SELECT Id FROM Case];
        icCTRLShowRelatedAccounts.getRelatedAccountsByCaseId(cases[0].Id);
    }
}