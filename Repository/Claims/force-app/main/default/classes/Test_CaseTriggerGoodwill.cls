/**
* ClaimsV2-926
* By Anil Mannem(Incloud) on 18-Jun-2020
* Added test methods to check assignment of user role heirarchy
*/
@istest
public class Test_CaseTriggerGoodwill {
    @isTest static void testUsersForGoodwill() {
        Profile profileVP = [SELECT Id FROM Profile WHERE Name='USRS Director']; 
        UserRole vpRole = [SELECT Id, Name from UserRole WHERE Name = 'VP Sales West'];
        User userVP = new User(Alias = 'usvp', Email='uservp@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profileVP.Id, UserRoleId = vpRole.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='uservp@testorg.com');
        insert userVP;
		
		Profile profileManager = [SELECT Id FROM Profile WHERE Name = 'USRS Manager']; 
        UserRole rsmRole = [SELECT Id, Name from UserRole WHERE Name = 'RSM North'];
        User userDirector = new User(Alias = 'usdir', Email='userdirector@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profileManager.Id, UserRoleId = rsmRole.Id, ManagerId = userVP.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='userdirector@testorg.com');
        insert userDirector;
        
        UserRole dsmRole = [SELECT Id, Name from UserRole WHERE Name = 'DSM North (1)'];
        User userManager = new User(Alias = 'usman', Email='usermanager@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profileManager.Id, UserRoleId = dsmRole.Id, ManagerId = userDirector.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='usermanager@testorg.com');
        insert userManager;
		
        Profile profileSalesRep = [SELECT Id FROM Profile WHERE Name = 'USRS Sales Rep']; 
        UserRole tsrRole = [SELECT Id, Name from UserRole WHERE Name = 'TSR North (1)'];
        User userSalesRep = new User(Alias = 'ussalrep', Email='userSalesRep@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profileSalesRep.Id, UserRoleId = tsrRole.Id, ManagerId = userManager.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='userSalesRep@testorg.com');
        insert userSalesRep;
    }
    @isTest static void testSetGoodwillHierarchyBySalesRep() {
        Test.startTest();
        testUsersForGoodwill();
        User userSalesRep = [SELECT Id from User where UserName = 'userSalesRep@testorg.com'];        
        system.runAs(userSalesRep) {
            //create Account
            Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
            List<Account> toInsertAccounts = new List<Account>();
            toInsertAccounts.addAll(TestFactory.createAccounts(baRt, 'CaseServiceTest', '123 King St W', 'Toronto', 'ON', 'CA', 'M4S 2H6',
                    'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));
            insert toInsertAccounts;
    
            //create contact
            List<Contact> toInsertContacts = new List<Contact>();
            toInsertContacts.addAll(TestFactory.createContacts(toInsertAccounts[0].Id, 'CaseServiceTest', UserInfo.getUserId(), 1, false));
            insert toInsertContacts;
    
            Map<String, Account> mapAccounts = new Map<String, Account>();
            for (Account act : [SELECT Id,Name FROM Account]) {
                mapAccounts.put(act.Name, act);
            }
            //Create cases
            Id rcRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId();
            List<Case> toInsertCases = new List<case>();
            toInsertCases.addAll(TestFactory.createCases(rcRt, mapAccounts.get('CaseServiceTest').Id, toInsertContacts[0].Id, 'Distributor', 'CaseServiceTest', date.newInstance(2006, 5, 5), 'US', 'Draft', 1, false));
            system.debug('Cases are :'+toInsertCases);
            insert toInsertCases;
            Case c = [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTest'];
            c.GoodwillClaimAmount__c = 100;
            update c;
        }
        Test.stopTest();
    }
    @isTest static void testSetGoodwillHierarchyByManager() {
        Test.startTest();
        testUsersForGoodwill();
        User userManager = [SELECT Id from User where UserName = 'usermanager@testorg.com'];        
        system.runAs(userManager) {
            //create Account
            Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
            List<Account> toInsertAccounts = new List<Account>();
            toInsertAccounts.addAll(TestFactory.createAccounts(baRt, 'CaseServiceTest', '123 King St W', 'Toronto', 'ON', 'CA', 'M4S 2H6',
                    'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));
            insert toInsertAccounts;
    
            //create contact
            List<Contact> toInsertContacts = new List<Contact>();
            toInsertContacts.addAll(TestFactory.createContacts(toInsertAccounts[0].Id, 'CaseServiceTest', UserInfo.getUserId(), 1, false));
            insert toInsertContacts;
    
            Map<String, Account> mapAccounts = new Map<String, Account>();
            for (Account act : [SELECT Id,Name FROM Account]) {
                mapAccounts.put(act.Name, act);
            }
            //Create cases
            Id rcRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId();
            List<Case> toInsertCases = new List<case>();
            toInsertCases.addAll(TestFactory.createCases(rcRt, mapAccounts.get('CaseServiceTest').Id, toInsertContacts[0].Id, 'Distributor', 'CaseServiceTest', date.newInstance(2006, 5, 5), 'US', 'Draft', 1, false));
            system.debug('Cases are :'+toInsertCases);
            insert toInsertCases;
            Case c = [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTest'];
            c.GoodwillClaimAmount__c = 100;
            update c;
        }
        Test.stopTest();
    }
    @isTest static void testSetGoodwillHierarchyByDirector() {
        Test.startTest();
        testUsersForGoodwill();
        User userDirector = [SELECT Id from User where UserName = 'userdirector@testorg.com'];        
        system.runAs(userDirector) {
            //create Account
            Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
            List<Account> toInsertAccounts = new List<Account>();
            toInsertAccounts.addAll(TestFactory.createAccounts(baRt, 'CaseServiceTest', '123 King St W', 'Toronto', 'ON', 'CA', 'M4S 2H6',
                    'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));
            insert toInsertAccounts;
    
            //create contact
            List<Contact> toInsertContacts = new List<Contact>();
            toInsertContacts.addAll(TestFactory.createContacts(toInsertAccounts[0].Id, 'CaseServiceTest', UserInfo.getUserId(), 1, false));
            insert toInsertContacts;
    
            Map<String, Account> mapAccounts = new Map<String, Account>();
            for (Account act : [SELECT Id,Name FROM Account]) {
                mapAccounts.put(act.Name, act);
            }
            //Create cases
            Id rcRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId();
            List<Case> toInsertCases = new List<case>();
            toInsertCases.addAll(TestFactory.createCases(rcRt, mapAccounts.get('CaseServiceTest').Id, toInsertContacts[0].Id, 'Distributor', 'CaseServiceTest', date.newInstance(2006, 5, 5), 'US', 'Draft', 1, false));
            system.debug('Cases are :'+toInsertCases);
            insert toInsertCases;
            Case c = [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTest'];
            c.GoodwillClaimAmount__c = 100;
            update c;
        }
       Test.stopTest();
    }
}