/**
 * Created by sinan.bunni on 2019-09-17.
 */
@IsTest
public with sharing class SharinPixPermissionsControllerTest {

    private static void createUsers() {

        List<User> toInsertUsers = new List<User>();

        toInsertUsers.add(TestFactory.createUser('UnitClaim', 'TestsClaim', 'claimsManagerUsr@iko.com', 'claimsManagerUsr@iko.com', 'Claims Manager',
                'Claims Manager', 'tclu', 'GMT', 'en_US', 'UTF-8', 'en_US', 'United States', null, false));
        toInsertUsers.add(TestFactory.createUser('UnitClaim3', 'TestsClaim', 'labTechnicianUsr@iko.com', 'labTechnicianUsr@iko.com', 'Lab Technician',
                'Lab Tech', 'tsAUr', 'GMT', 'en_US', 'UTF-8', 'en_US', 'United States', null, false));
        toInsertUsers.add(TestFactory.createUser('Unit', 'Tests', 'salesrep@iko1.com', 'salesrep@iko.com',
                'USRS Sales Rep', 'RSM West', 'salesrep', 'GMT', 'en_US', 'UTF-8', 'en_US', null, null, false));

        insert toInsertUsers;
    }

    @TestSetup
    private static void setupTestData() {
        initTestData();
    }

    private static void initTestData() {
        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();
        List<Account> toInsertAccounts = new List<Account>();

        toInsertAccounts.addAll(TestFactory.createAccounts(baRt, 'CaseServiceTest', '9 King St E', 'Toronto', 'ON', 'CA', 'M4S 2H4',
                'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));
        insert toInsertAccounts;

        //create contact
        List<Contact> con = TestFactory.createContacts(toInsertAccounts[0].Id, 'LabSampleTapeCodeServiceTest', UserInfo.getUserId(), 1, false);
        insert con;

        //create Cases
        List<Case> toInsertCases = new List<Case>();

        toInsertCases.addAll(TestFactory.createCases(ccRt, toInsertAccounts[0].Id, con[0].Id, 'Owner', 'CaseServiceTest1', null, 'Commercial', 'Draft', 1, false));
        Insert toInsertCases;

        Product2 prod = new Product2(IsActive = true, Name = 'IkoSampleProduct', ProductCode = 'IkoSampleProduct', Sectors__c = 'US;CA;Commercial;Blair');
        Product2 prod00270021 = new Product2(Iko_Product_Family__c = '0270000', IsActive = true, Name = 'Iko270000', ProductCode = 'Iko270000', Sectors__c = 'US;CA;Commercial;Blair');
        Product2 prod0900055 = new Product2(Iko_Product_Family__c = '0900000', IsActive = true, Name = 'Iko900000', ProductCode = 'Iko900000', Sectors__c = 'US;CA;Commercial;Blair');
        Product2 prod0070020 = new Product2(Iko_Product_Family__c = '0070000', IsActive = true, Name = 'Iko70000', ProductCode = 'Iko70000', Sectors__c = 'US;CA;Commercial;Blair');
        Product2 prod580000 = new Product2(Iko_Product_Family__c = '0580000', IsActive = true, Name = 'Iko580000', ProductCode = 'Iko580000', Sectors__c = 'US;CA;Commercial;Blair');
        Product2 prodNoFamily = new Product2(IsActive = true, Name = 'NoFamily', ProductCode = 'NoFamily', Sectors__c = 'US;CA;Commercial;Blair');
        insert new List<Product2>{
                prod, prod00270021, prod0900055, prod0070020, prod580000, prodNoFamily
        };

    }

    private static testMethod void getSharinPixPermissions_ClaimWithDraftStage_ReturnedAnnotatePermissionId() {

        //Prepare the data
        Case testCase = getTestCase('Draft', NULL);

        //Test the data
        Test.startTest();
        update testCase;
        Test.stopTest();

        //Assert the data
        System.assertEquals(
                SharinPixPermissionsController.getSharinPixPermissions(testCase.Id, 'Case'),
                Claims_Config__c.getOrgDefaults().SharinPix_Annotate_Permission_Id__c
        );
    }

    private static testMethod void getSharinPixPermissions_ClaimWithSubmittedStageAndSalesProfile_ReturnedReadPermissionId() {

        Case testCase = getTestCase('Submitted', NULL);
        //Prepare the data

        //Test the data
        Test.startTest();
        update testCase;
        Test.stopTest();

        //Assert the data
        System.assertEquals(
                SharinPixPermissionsController.getSharinPixPermissions(testCase.Id, 'Case'),
                Claims_Config__c.getOrgDefaults().SharinPix_Read_Only_Permission__c
        );

    }

    private static testMethod void getSharinPixPermissions_ClaimWithAssessmentStageAndSalesUser_ReturnedReadPermissionId() {

        //Prepare the data
        Case testCase = getTestCase('Assessment', NULL);

        //Test the data
        Test.startTest();
        update testCase;
        Test.stopTest();

        //Assert the data
        System.assertEquals(
                SharinPixPermissionsController.getSharinPixPermissions(testCase.Id, 'Case'),
                Claims_Config__c.getOrgDefaults().SharinPix_Read_Only_Permission__c
        );

    }

    private static testMethod void getSharinPixPermissions_ClaimWithClosedStageAndSalesUser_ReturnedReadPermissionId() {

        //Prepare the data
        Case testCase = getTestCase('Closed', NULL);

        //Test the data
        Test.startTest();
        update testCase;
        Test.stopTest();

        //Assert the data
        System.assertEquals(
                SharinPixPermissionsController.getSharinPixPermissions(testCase.Id, 'Case'),
                Claims_Config__c.getOrgDefaults().SharinPix_Read_Only_Permission__c
        );
    }

    private static testMethod void getSharinPixPermissions_ClaimWithDraftStageOnLabSample_ReturnedAnnotatePermissionId() {

        //Prepare the data
        Case testCase = getTestCase('Draft', NULL);

        //Test the data
        Test.startTest();
        update testCase;
        Test.stopTest();

        //Assert the data
        Lab_Sample__c labSample = [SELECT Id FROM Lab_Sample__c LIMIT 1];
        System.assertEquals(
                SharinPixPermissionsController.getSharinPixPermissions(labSample.Id, 'Lab_Sample__c'),
                Claims_Config__c.getOrgDefaults().SharinPix_Annotate_Permission_Id__c
        );
    }

    private static Case getTestCase(final String claimStage, final String claimSubStage) {

        Product2 testProduct = [SELECT Id FROM Product2 WHERE Name = 'Iko270000'];
        Case testCase = [SELECT Id, AccountId FROM Case WHERE Subject = 'CaseServiceTest1'];

        Claim_Type__c claimType = new Claim_Type__c(Case__c = testCase.Id, Concern__c = 'Asphalt bleedthrough', Product_Type__c = 'B Glass',Is_Primary__c = TRUE);
        insert claimType;

        Lab_Sample__c labSample = new Lab_Sample__c(Case__c = testCase.Id);
        insert labSample;

        Account testAccount = new Account(Id = testCase.AccountId, Address_Verification_Status__c = 'Verified');
        update testAccount;

        testCase.Origin = 'Owner';
        testCase.All_Claim_Photos_Attached__c = true;
        testCase.Product__c = testProduct.Id;
        testCase.Samples_Collected__c = 'Yes';
        testCase.Courier__c = 'USPS';
        testCase.Tracking_Number__c = 'abcdefg';
        testCase.Samples_Ship_Date__c = Date.today().addDays(1);
        testCase.Type_of_Structure__c = 'Barn';
        testCase.Pitch__c = '5/12';
        testCase.Sector__c = 'CA';
        testCase.Claim_Stage__c = claimStage;
        testCase.Claim_Sub_Stage__c = claimSubStage;
        testCase.Installation_Date__c = Date.newInstance(2007, 6, 6);
        testCase.Bundles_Causing_Concern__c = 26;
        testCase.Call_Received_Date__c = Date.newInstance(2018, 05, 08);

        return testCase;
    } // end getTestCase method

    @isTest
    private static void testGetCaseIdByLabSampleIdNullLabSampleId(){
        Test.startTest();
        String strResult = SharinPixPermissionsController.getCaseIdByLabSampleId(null);
        Test.stopTest();
        System.assertEquals(strResult,'');
    }

    @isTest
    private static void testGetCaseIdByLabSampleIdWithValidLabSampleId(){
        Test.startTest();
        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();
        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();

        Id accountId = TestFactory.createAccounts(baRt,'CaseServiceTest','99876 King St E','Toronto','ON','CA','M4S 2H4',
                'Verified',UserInfo.getUserId(),TRUE,TRUE,1,true)[0].Id;
        Id contactId = TestFactory.createContacts(accountId,'CaseServiceTest',UserInfo.getUserId(),1,true)[0].Id;
        Id caseId = TestFactory.createCases(ccRt,accountId,contactId,'Distributor','CaseServiceTest1',null,'Commercial','Draft',1,true)[0].Id;

        Lab_Sample__c ls = new Lab_Sample__c(Case__c = caseId);
        insert ls;

        String strResult = SharinPixPermissionsController.getCaseIdByLabSampleId(ls.Id);
        Test.stopTest();

        System.assertEquals(String.valueOf(caseId),strResult);
    }

    @isTest
    private static void testGetSharinPixPermissionIdByLabTech() {
        createUsers();
        List<Case> toInsertCases = new List<Case>();

        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();
        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        User u = [SELECT Id FROM User WHERE Username = 'labTechnicianUsr@iko.com'];

        Test.startTest();
        System.runAs(u) {
            Id accountId = TestFactory.createAccounts(baRt, 'CaseServiceTest', '976 King St E', 'Toronto', 'ON', 'CA', 'M4S 2H4',
                    'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, true)[0].Id;
            Id contactId = TestFactory.createContacts(accountId, 'CaseServiceTest', UserInfo.getUserId(), 1, true)[0].Id;

            toInsertCases = TestFactory.createCases(ccRt, accountId, contactId, 'Distributor', 'CaseServiceTestLabTech', null, 'Commercial', 'In Lab', 1, true);

            Claim_Type__c ct = new Claim_Type__c(Case__c = toInsertCases[0].Id);
            insert ct;
        }
        Test.stopTest();

        System.assertEquals(SharinPixPermissionsController.getSharinPixPermissions(toInsertCases[0].Id, 'Case'), Claims_Config__c.getOrgDefaults().SharinPix_Annotate_Permission_Id__c);

    }

} // end SharinPixPermissionsControllerTest method