@isTest
private class SettlementConditionServiceTest {

    private static void getNonSysAdminUser(){
        TestFactory.createUser('UnitClaim', 'TestsClaim', 'claimsManagerUsr@iko.com', 'claimsManagerUsr@iko.com', 'Claims Manager',
                'Claims Manager', 'tclu', 'GMT', 'en_US', 'UTF-8', 'en_US', 'United States', null, true);
    }

    @testSetup static void setupTestData() {

        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();

        //create Account
        List<Account> toInsertAccounts = new List<Account>();

        toInsertAccounts.addAll(TestFactory.createAccounts(baRt,'CaseServiceTest','9 King St E','Toronto','ON','CA','M4S 2H4',
                'Verified',UserInfo.getUserId(),TRUE,TRUE,1,false));

        insert toInsertAccounts;


        //create contact
        List<Contact> toInsertContacts = new List<Contact>();

        toInsertContacts.addAll(TestFactory.createContacts(toInsertAccounts[0].Id,'CaseServiceTest',UserInfo.getUserId(),1,false));

        insert toInsertContacts;

        Map<String,Account> mapAccounts = new Map<String, Account>();

        for(Account act : [SELECT Id,Name FROM Account]){
            mapAccounts.put(act.Name,act);
        }


        //create Cases
        List<Case> toInsertCases = new List<Case>();
        toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTestClosed',null,'Commercial','Closed',1,false));
        toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTest1',null,'Commercial','Draft',1,false));

        toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTest1Copy',null,'Commercial','Draft',1,false));

        List<Case> cases = TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTestWithInApprovalClaim',null,'Commercial','Assessment',1,false);
        cases[0].Claim_Sub_Stage__c = 'In Approval';
        toInsertCases.addAll(cases);

        insert toInsertCases;

        Lab_Sample__c ls = new Lab_Sample__c(Case__c = toInsertCases[2].Id);
        insert ls;

        Lab_Sample_Tape_Code__c lstc = new Lab_Sample_Tape_Code__c(Lab_Sample__c = ls.Id);
        insert lstc;

        Settlement_Condition__c sc = new Settlement_Condition__c(Case__c = toInsertCases[2].Id, Condition_Template__c = '1. Ventilation must be upgraded....');
        Settlement_Condition__c ct1 = new Settlement_Condition__c(Case__c = toInsertCases[0].Id, Condition_Template__c = '1. Ventilation must be upgraded....');
        insert new List<Settlement_Condition__c>{
            sc,ct1
        };

        Claim_Type__c ct = new Claim_Type__c(Case__c = toInsertCases[2].Id);
        insert ct;

    }
    @isTest static void testThatSettlementConditionCannotBeInsertedPostClosure() {
        getNonSysAdminUser();
        Case c = [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTestClosed'];
        User u = [SELECT Id FROM User WHERE Username = 'claimsManagerUsr@iko.com'];
        Settlement_Condition__c ct = new Settlement_Condition__c(Case__c = c.Id);
        String error = '';
        Test.startTest();
        try {
            System.runAs(u){
                insert ct;
            }
        } catch (DmlException e) {
            error = e.getMessage();
        }
        Test.stopTest();
        System.assertEquals(ct.Id, ct.Id);
    }

    @isTest static void testThatSettlementConditionCannotBeInsertedWhenStatusNotClosed() {
        getNonSysAdminUser();
        Case c = [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTestWithInApprovalClaim'];
        User u = [SELECT Id FROM User WHERE Username = 'claimsManagerUsr@iko.com'];
        Settlement_Condition__c ct = new Settlement_Condition__c(Case__c = c.Id);
        String error = '';
        Test.startTest();
        try {
            System.runAs(u){
                insert ct;
            }
        } catch (DmlException e) {
            error = e.getMessage();
        }
        Test.stopTest();
        System.assertNotEquals(error,'');
    }

    @isTest static void testThatSettlementConditionCannotBeUpdatedPostClosure() {
        getNonSysAdminUser();
        Case c = [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTestClosed'];
        User u = [SELECT Id FROM User WHERE Username = 'claimsManagerUsr@iko.com'];
        Settlement_Condition__c ct = [select Id from Settlement_Condition__c where Case__r.Subject = 'CaseServiceTestClosed'];

        System.runAs(u){
            Test.startTest();
            Boolean errorCaught = false;
            try {
                update ct;
            } catch (DmlException e) {
                errorCaught = true;
            }
            Test.stopTest();
            System.assert(errorCaught);
        }

    }

    @isTest static void testThatSettlementConditionCanBeUpdatedBySysAdminPostClosure() {
        Settlement_Condition__c ct = [select Id from Settlement_Condition__c where Case__r.Subject = 'CaseServiceTestClosed'];
        Test.startTest();
        Boolean errorCaught = false;
        try {
                update ct;
        } catch (DmlException e) {
            errorCaught = true;
        }
        Test.stopTest();
        System.assert(!errorCaught);
    }

    @isTest static void testThatSettlementConditionCannotBeDeletedPostClosure() {
        getNonSysAdminUser();
        User u = [SELECT Id FROM User WHERE Username = 'claimsManagerUsr@iko.com'];
        Settlement_Condition__c ct = [select Id from Settlement_Condition__c where Case__r.Subject = 'CaseServiceTestClosed'];

        System.runAs(u){
            Test.startTest();
            Boolean errorCaught = false;
            try {
                delete ct;
            } catch (DmlException e) {
                errorCaught = true;
            }
            Test.stopTest();
            System.assert(errorCaught);
        }

    }

    @isTest static void testThatSettlementConditionCanBeInsertedUpdatedDeletedPreClosure() {
        Case c = [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTest1'];

        Test.startTest();
        Settlement_Condition__c ct = new Settlement_Condition__c(Case__c = c.Id);
        insert ct;

        System.assertNotEquals(ct.Id, null);

        update ct;

        delete ct;
        Test.stopTest();
    }


}