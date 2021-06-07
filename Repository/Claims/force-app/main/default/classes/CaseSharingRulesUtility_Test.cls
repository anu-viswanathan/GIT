@isTest
public class CaseSharingRulesUtility_Test {
	
    @testSetup static void setupTestData() {
        initData();
        initUser();
    }

    @future
    private static void initUser() {
        User salesManagerUser = TestFactory.createUser('Unit', 'Tests', 'salesrsmmgr@iko.com', 'salesrsmmgr@iko.com', 'USRS Manager',
                'RSM West', 'salesmgr', 'GMT', 'en_US', 'UTF-8', 'en_US', null, null, false);
        insert salesManagerUser;
    }
    
    private static void initData() {

        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        Id conRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        Id disRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        //Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();
        List<Account> toInsertAccounts = new List<Account>();

        toInsertAccounts.addAll(TestFactory.createAccounts(baRt, 'AccountCA', '9 King St E', 'Toronto', 'ON', 'CA', 'M4S 2H4',
                'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));
        //insert toInsertAccounts;

        toInsertAccounts.addAll(TestFactory.createAccounts(conRt, 'AccountQC', '9 King St E', 'Toronto', 'QC', 'CA', 'M4S 2H4',
                'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));
        
		toInsertAccounts.addAll(TestFactory.createAccounts(disRt, 'AccountQC', '9 King St E', 'Toronto', 'QC', 'CA', 'M4S 2H4',
                'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));        
        
        insert toInsertAccounts;
        
        Product2 p = new Product2(
        	Name = 'IKO CAMBRIDGE',
            Sectors__c = 'CA',
            Is_Legacy__c = false,
            Unit_of_Measure__c = 'BD'
        );
        insert p;
        
        
        //create contact
        List<Contact> con = TestFactory.createContacts(toInsertAccounts[0].Id, 'ClaimTypeServiceTest', UserInfo.getUserId(), 1, false);
        insert con;

        
    }
    
    @isTest static void testCaseRegionFields() {
        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        Id conRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        Id disRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Set<Id> recordTypeSet = new Set<Id>();    
        recordTypeSet.add (baRt);
        recordTypeSet.add (conRt);
        recordTypeSet.add (disRt);
        Account accountBuilding = [select Id, Account_Owner_Region__c from Account where RecordTypeId = : baRt limit 1];
        Account accountContractor = [select Id, Account_Owner_Region__c from Account where RecordTypeId = : conRt limit 1];
        Account accountDistributor = [select Id, Account_Owner_Region__c from Account where RecordTypeId = : disRt limit 1];
        /*
        List<Account> allAccounts = new List<Account>([SELECT Id, RecordTypeId, Account_Owner_Region__c FROM Account WHERE RecordTypeId IN :recordTypeSet]);
        Map<Id, Account> accountsByAccountRecordTypeId = new Map<Id, Account>();
        for(Account a : allAccounts) {
            accountsByAccountRecordTypeId.put(a.RecordTypeId, a);
        }
		*/	
		Contact contact = [select Id from Contact limit 1];        
        Case c1 = new Case(
            Description = 'Residential Claim created by Test Case',
        	RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId(),
            Claim_Stage__c = 'Assessment',
            Settlement_Type__c = 'Manual Calculation',
            Preferred_Language__c = 'English', 
            AccountId = accountBuilding.Id,  // accountsByAccountRecordTypeId.get(baRt).Id,
            Contractor__c = accountContractor.Id,  //accountsByAccountRecordTypeId.get(conRt).Id,
            Distributor__c =  accountDistributor.Id, //accountsByAccountRecordTypeId.get(disRt).Id,
            ContactId = contact.Id,
            Sector__c = 'CA'
        );
        //system.debug('c1: ' + c1);
        insert c1;
        
        Case cCheck		= [select Id, Account_Owner_Region__c, Contractor_Owner_Region__c, Distributor_Owner_Region__c from Case where Id = :c1.Id limit 1];
        System.assertEquals( accountBuilding.Account_Owner_Region__c, cCheck.Account_Owner_Region__c ); 
        System.assertEquals( accountContractor.Account_Owner_Region__c, cCheck.Contractor_Owner_Region__c ); 
        System.assertEquals( accountDistributor.Account_Owner_Region__c, cCheck.Distributor_Owner_Region__c ); 
        system.debug('case info: ' + cCheck);
        System.debug ('account building: ' + accountBuilding.Account_Owner_Region__c);
        System.debug ('contractor: ' + accountContractor.Account_Owner_Region__c);
        System.debug ('distributor: ' + accountDistributor.Account_Owner_Region__c);
        /*
        System.assertEquals( accountsByAccountRecordTypeId.get(baRt).Account_Owner_Region__c, cCheck.Account_Owner_Region__c ); 
        System.assertEquals( accountsByAccountRecordTypeId.get(conRt).Account_Owner_Region__c, cCheck.Contractor_Owner_Region__c ); 
        System.assertEquals( accountsByAccountRecordTypeId.get(disRt).Account_Owner_Region__c, cCheck.Distributor_Owner_Region__c ); 
        system.debug('c1: ' + cCheck);
        system.debug('account: ' + accountsByAccountRecordTypeId.get(baRt).Account_Owner_Region__c);
        system.debug('contractor: ' + accountsByAccountRecordTypeId.get(conRt).Account_Owner_Region__c);
        system.debug('distributor: ' + accountsByAccountRecordTypeId.get(disRt).Account_Owner_Region__c);
		*/
    }
    
}