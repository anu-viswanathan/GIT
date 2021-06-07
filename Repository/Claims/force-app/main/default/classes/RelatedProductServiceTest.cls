@isTest
private class RelatedProductServiceTest {
	@future
    private static void createUsers(){
       List<User> toInsertUsers = new List<User>();
        toInsertUsers.add(TestFactory.createUser('Unit','Tests','salesrsmmgr@iko.com','salesrsmmgr@iko.com','USRS Manager',
                'RSM West','salesmgr','GMT','en_US','UTF-8','en_US',null,null,false));
        toInsertUsers.add(TestFactory.createUser('UnitClaim', 'TestsClaim', 'claimsManagerUsr@iko.com', 'claimsManagerUsr@iko.com', 'Claims Manager',
                'Claims Manager', 'tclu', 'GMT', 'en_US', 'UTF-8', 'en_US', 'United States', null, false));
        toInsertUsers.add(TestFactory.createUser('UnitClaim1','TestsClaim','sysAdminUsr@iko.com','sysAdminUsr@iko.com','System Administrator',
                'CEO','tsAdmU','GMT','en_US','UTF-8','en_US','United States',null,false));

        insert toInsertUsers;
       /* TestFactory.createUser('Unit','Tests','salesrsmmgr@iko.com','salesrsmmgr@iko.com','USRS Manager',
                'RSM West','salesmgr','GMT','en_US','UTF-8','en_US',null,null,true);*/
    }

    @testSetup static void setupTestData() {
		createUsers();
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

        toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTestWithApprovedClaim',null,'Commercial','Draft',1,false));
		toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTestWithAssessmentStage',null,'Commercial','Assessment',1,false));
        //toInsertCases[3].ClaimApproved__c=true;
        insert toInsertCases;

        Lab_Sample__c ls = new Lab_Sample__c(Case__c = toInsertCases[2].Id);
        insert ls;
        Lab_Sample_Tape_Code__c lstc = new Lab_Sample_Tape_Code__c(Lab_Sample__c = ls.Id);
        insert lstc;

        Settlement_Condition__c sc = new Settlement_Condition__c(Case__c = toInsertCases[2].Id, Condition_Template__c = '1. Ventilation must be upgraded....');
        insert sc;

        Claim_Type__c ct = new Claim_Type__c(Case__c = toInsertCases[2].Id);
        insert ct;

        //create products
        List<Product2> toInsertProducts = new List<Product2>();
        toInsertProducts.addAll(TestFactory.createProducts('IkoSampleProduct',TRUE,'IkoSampleProduct','US;CA;Commercial;Blair',null,1,false));

        insert toInsertProducts;

        //create related products
        List<Related_Product__c> toInsertRelatedProducts = new List<Related_Product__c>();

        toInsertRelatedProducts.addAll(TestFactory.createRelatedProducts(toInsertCases[0],toInsertProducts[0],1,false));
        toInsertRelatedProducts.addAll(TestFactory.createRelatedProducts(toInsertCases[1],toInsertProducts[0],1,false));
        toInsertRelatedProducts.addAll(TestFactory.createRelatedProducts(toInsertCases[1],toInsertProducts[0],1,false));
        toInsertRelatedProducts.addAll(TestFactory.createRelatedProducts(toInsertCases[2],toInsertProducts[0],1,false));
		toInsertRelatedProducts.addAll(TestFactory.createRelatedProducts(toInsertCases[3],toInsertProducts[0],1,false));
        insert toInsertRelatedProducts;


    }

    @isTest static void testThatRelatedProductsCannotBeDeletedPostCaseApproval() {
        Case c1 = [select Id, ClaimApproved__c from Case where Subject = 'CaseServiceTest1'];
        Product2 prod = [SELECT Id FROM Product2 WHERE Name = 'IkoSampleProduct'];

        Related_Product__c relatedProduct = [SELECT Id FROM Related_Product__c WHERE Case__c = :c1.Id AND Product__c = :prod.Id LIMIT 1];
        Test.startTest();

        c1.ClaimApproved__c = true;
        update c1;


        Boolean deletionBlocked = false;
        try {
            delete relatedProduct;
        } catch (DmlException e) {
            deletionBlocked = true;
        }
        System.debug('@@@Queries-->'+Limits.getQueries());
        Test.stopTest();  
        System.assert(deletionBlocked);
    }

    @isTest static void testThatRelatedProductsCannotBeDeletedBeforeCaseApproval() {
        Case c1 = [select Id, ClaimApproved__c from Case where Subject = 'CaseServiceTest1'];
        Product2 prod = [SELECT Id FROM Product2 WHERE Name = 'IkoSampleProduct'];

        Related_Product__c relatedProduct = [SELECT Id FROM Related_Product__c WHERE Case__c = :c1.Id AND Product__c = :prod.Id LIMIT 1];

        Boolean deletionBlocked = false;
        try {
            delete relatedProduct;
        } catch (DmlException e) {
            deletionBlocked = true;
        }
        System.assertEquals(deletionBlocked, false);

    }

    @isTest static void testThatRelatedProductCannotBeInsertedPostClosure() {
        Case c1 = [SELECT Id, Claim_Stage__c FROM Case where Subject = 'CaseServiceTestClosed'];
        Product2 prod = [SELECT Id FROM Product2 WHERE Name = 'IkoSampleProduct'];

        Related_Product__c ct = [SELECT Id FROM Related_Product__c WHERE Case__c = :c1.Id AND Product__c = :prod.Id];

        try {
            insert ct;
        } catch (DmlException e) {
        }
        System.assertEquals(ct.Id, ct.Id);
    }

    @isTest static void testThatRelatedProductCannotBeUpdatedPostClosure() {
        
        Related_Product__c ct = [select Id from Related_Product__c where Case__r.Subject = 'CaseServiceTestClosed'];
        Boolean errorCaught = false;
        User salesMngUser = [SELECT Id FROM User WHERE Username = 'salesrsmmgr@iko.com' ];
        User sysAdmin = [SELECT Id FROM User WHERE Username = 'sysAdminUsr@iko.com' ];
        // Running as a Sales Mgr

        try {
            System.runAs(sysAdmin){
            update ct;
            }
        } catch (DmlException e) {
            errorCaught = true;
        }
        System.assert(!errorCaught);
        //Boolean errorCaught = false;
        // Running as a different user


        System.runAs(salesMngUser) {
            try {
                delete ct;
            } catch (DMLException e) {
                errorCaught = true;
            }
        }
        System.assert(errorCaught);
    }

    @isTest static void testThatRelatedProductCannotBeDeletedPostClosure() {
        //createUsers();
        Related_Product__c ct = [select Id from Related_Product__c where Case__r.Subject = 'CaseServiceTestClosed'];
        // Running as a System Administrator
        User sysAdmin = [SELECT Id FROM User WHERE Username = 'sysAdminUsr@iko.com' ];
        Boolean errorCaught = false;
        try {
            System.runAs(sysAdmin){
                delete ct;
            }
        } catch (DmlException e) {
            errorCaught = true;
        }
        System.assert(!errorCaught);

        // Running as a different user
         User salesMngUser = [SELECT Id FROM User WHERE Username = 'salesrsmmgr@iko.com' ];

        System.runAs(salesMngUser) {
            try {
                delete ct;
            } catch (DMLException e) {
                errorCaught = true;
            }
        }
        System.assert(errorCaught);

    }

    @isTest static void testThatRelatedProductCanBeInsertedUpdatedDeletedPreClosure() {
        Case c1 = [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTest1'];

        Product2 prod = [SELECT Id FROM Product2 WHERE Name = 'IkoSampleProduct'];

        Related_Product__c ct = [SELECT Id FROM Related_Product__c WHERE Case__c = :c1.Id AND Product__c = :prod.Id LIMIT 1];

        System.assertNotEquals(ct.Id, null);
        update ct;
        delete ct;
    }

    @isTest static void blockCreatedUpdateDelete_ApprovedCaseWithOpenClaimUponInsert_ThrowValidationError() {
        Test.startTest();
        Case c1 = [SELECT Id, Claim_Stage__c FROM Case WHERE Subject = 'CaseServiceTestWithApprovedClaim'];
        c1.ClaimApproved__c = TRUE;
        update c1;

        Boolean errorCaught = false;
        Related_Product__c ct = [SELECT Id FROM Related_Product__c WHERE Case__c = :c1.Id];

        
        try {
            insert ct;
        } catch (DmlException e) {
            errorCaught = true;
        }
        Test.stopTest();

        System.assert(errorCaught);
    }

    @isTest static void blockCreatedUpdateDelete_ApprovedCaseWithOpenClaimUponUpdate_ThrowValidationError() {
        Test.startTest();
        Case c1 = [SELECT Id, Claim_Stage__c FROM Case WHERE Subject = 'CaseServiceTestWithApprovedClaim'];
        c1.ClaimApproved__c = TRUE;
        update c1;

        Related_Product__c ct = [SELECT Id FROM Related_Product__c WHERE Case__c = :c1.Id];

        Boolean errorCaught = false;

        
        try {
            update ct;
        } catch (DmlException e) {
            errorCaught = true;
        }
        Test.stopTest();

        System.assertEquals(errorCaught, true, 'An error has caught and thrown to the user.');
    }

    @isTest static void blockCreatedUpdateDelete_ApprovedCaseWithOpenClaimUponDelete_ThrowValidationError() {
        Test.startTest();
        Case c1 = [SELECT Id, Claim_Stage__c FROM Case WHERE Subject = 'CaseServiceTestWithApprovedClaim'];
        c1.ClaimApproved__c = TRUE;
        update c1;

        Related_Product__c ct = [SELECT Id FROM Related_Product__c WHERE Case__c = :c1.Id];
        Boolean errorCaught = false;
        try {
            delete ct;
        } catch (Exception e) {
            errorCaught = true;
        }
        Test.stopTest();

        System.assertEquals(errorCaught, true, 'An error has caught and throw to the user.');
    }

    @isTest static void calculateTotalCostOfSettlementItemsOnRelatedCase_populateTotalCostOfSettlementItemsField_onUpdate(){
        List<Related_Product__c> ct = [SELECT Id,Quantity__c FROM Related_Product__c WHERE Case__r.Subject = 'CaseServiceTest1'];

        Test.startTest();
        ct[0].Quantity__c = 1;
        ct[1].Quantity__c = 2;
        update ct;
        Test.stopTest();

        Case c = [SELECT Total_Cost_of_Additional_Settlement_Item__c,Bundle_Rate__c FROM Case WHERE Subject = 'CaseServiceTest1'];

        System.assertEquals((3 * c.Bundle_Rate__c),c.Total_Cost_of_Additional_Settlement_Item__c);

    }

    @isTest static void calculateTotalCostOfSettlementItemsOnRelatedCase_populateTotalCostOfSettlementItemsField_onDelete(){
        List<Related_Product__c> ct = [SELECT Id,Quantity__c FROM Related_Product__c WHERE Case__r.Subject = 'CaseServiceTest1'];

        Test.startTest();
        ct[0].Quantity__c = 1;
        ct[1].Quantity__c = 2;
        update ct;

        Case c = [SELECT Total_Cost_of_Additional_Settlement_Item__c,Bundle_Rate__c FROM Case WHERE Subject = 'CaseServiceTest1'];
        System.assertEquals((3 * c.Bundle_Rate__c),c.Total_Cost_of_Additional_Settlement_Item__c);

        delete ct[1];
        Case c1 = [SELECT Total_Cost_of_Additional_Settlement_Item__c,Bundle_Rate__c FROM Case WHERE Subject = 'CaseServiceTest1'];
        System.assertEquals((1 * c1.Bundle_Rate__c),c1.Total_Cost_of_Additional_Settlement_Item__c);

        Test.stopTest();
    }

    @isTest static void calculateTotalCostOfSettlementItemsOnRelatedCase_populateTotalCostOfSettlementItemsField_onInsert(){

        Case c1 = [select Id from Case where Subject = 'CaseServiceTest1'];
        Product2 p = [SELECT Id FROM Product2 WHERE Name = 'IkoSampleProduct'];

        Related_Product__c rp = new Related_Product__c(Case__c = c1.Id,Product__c = p.id,Quantity__c = 1);

        Test.startTest();
        insert rp;
        Test.stopTest();

        Case c = [SELECT Total_Cost_of_Additional_Settlement_Item__c,Bundle_Rate__c FROM Case WHERE Subject = 'CaseServiceTest1'];

        System.assertEquals((1 * c.Bundle_Rate__c),c.Total_Cost_of_Additional_Settlement_Item__c);

    }
    
    @isTest static void testSuccessfulDeleteRelatedProduct(){
        User claimsMngUser = [SELECT Id FROM User WHERE Username = 'claimsManagerUsr@iko.com' LIMIT 1 ];
        Case caseToTest = [SELECT Id, Subject, Claim_Stage__c, AccountId, ContactId From Case Where Subject = 'CaseServiceTestClosed' Limit 1];
        //List<Case> caseToInsert = TestFactory.createCases(ccRt,caseToClone.AccountId,caseToClone.AccountId,'Distributor','CaseServiceTestDelete',null,'Commercial','Closed',1,false);
        //Insert caseToClose;
        
        
        Test.startTest();
        Related_Product__c relatedProductToTest= [Select Id, Case__c from Related_Product__c Where Case__c= :caseToTest.Id LIMIT 1];
        
        System.runAs(claimsMngUser){
            try{
                //relatedProductToTest.Quantity__c = 5;
        		delete relatedProductToTest;
            }
            catch(Exception e){
                System.debug('Exception Message: '+e.getMessage());
            }  
        }
        
        Test.stopTest();
        
        
    }
    
    @isTest static void testSuccessfulDeleteRelatedProductForApprovedCase(){
        Test.startTest();
        User claimsMngUser = [SELECT Id FROM User WHERE Username = 'claimsManagerUsr@iko.com' LIMIT 1 ];
        Case caseApprovedToTest = [SELECT Id, Subject, Claim_Stage__c, AccountId, ContactId From Case Where Subject = 'CaseServiceTestWithAssessmentStage' Limit 1];
        Related_Product__c relatedProductApprovedToTest= [Select Id, Case__c from Related_Product__c Where Case__c= :caseApprovedToTest.Id LIMIT 1];
        caseApprovedToTest.ClaimApproved__c=true;
        update caseApprovedToTest;
        System.runAs(claimsMngUser){
            try{
                //relatedProductToTest.Quantity__c = 5;
        		delete relatedProductApprovedToTest;
            }
            catch(Exception e){
                System.debug('Exception Message: '+e.getMessage());
            }  
        }
        Test.stopTest();
    }
}