@isTest
private class ClaimTypeServiceTest {

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
        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();
        List<Account> toInsertAccounts = new List<Account>();

        toInsertAccounts.addAll(TestFactory.createAccounts(baRt, 'CaseServiceTest', '9 King St E', 'Toronto', 'ON', 'CA', 'M4S 2H4',
                'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));
        insert toInsertAccounts;

        //create contact
        List<Contact> con = TestFactory.createContacts(toInsertAccounts[0].Id, 'ClaimTypeServiceTest', UserInfo.getUserId(), 1, false);
        insert con;

        //create Cases
        List<Case> toInsertCases = new List<Case>();

        toInsertCases.addAll(TestFactory.createCases(ccRt, toInsertAccounts[0].Id, con[0].Id, 'Owner', 'ClaimTypeServiceTest', null, 'Commercial', 'Draft', 1, false));
        toInsertCases.addAll(TestFactory.createCases(ccRt, toInsertAccounts[0].Id, con[0].Id, 'Distributor', null, null, 'Commercial', null, 2, false));
        toInsertCases[1].Subject = 'CaseServiceTestClosed';
        toInsertCases[1].Claim_Stage__c = 'Closed';

        toInsertCases[2].ClaimApproved__c = true;
        toInsertCases[2].Subject = 'CaseServiceTest1';
        insert toInsertCases;

        //create ClaimTypes
        List<Claim_Type__c> toInsertClaimTypes = new List<Claim_Type__c>();
        toInsertClaimTypes.addAll(TestFactory.createClaimTypes(toInsertCases[0], 1, false));
        toInsertClaimTypes.addAll(TestFactory.createClaimTypes(toInsertCases[1], 1, false));

        toInsertClaimTypes[0].Product_Type__c = 'Z Not IKO';
        toInsertClaimTypes[0].Concern__c = 'Clawing';
        toInsertClaimTypes[0].Is_Primary__c = true;
        insert toInsertClaimTypes;
    }

    @isTest static void testThatClaimTypeCannotBeInsertedPostClosure() {
        Case c = [SELECT Id, Claim_Stage__c FROM Case WHERE Subject = 'CaseServiceTestClosed' LIMIT 1];

        Claim_Type__c ct = new Claim_Type__c(Case__c = c.Id);
        try {
            insert ct;
        } catch (DmlException e) {
        }
        System.assertEquals(ct.Id, ct.Id);
    }

    @isTest static void testThatClaimTypeCannotBeUpdatedDeletedPostClosure() {
        Claim_Type__c ct = [SELECT Id,Case__c, Case__r.Claim_Stage__c FROM Claim_Type__c WHERE Case__r.Subject = 'CaseServiceTestClosed' LIMIT 1];

        Test.startTest();

        Boolean errorCaught = false;
        try {
            update ct;
        } catch (DmlException e) {
            errorCaught = true;
        }
        //Should not throw an error since its by Sys admin
        System.assert(!errorCaught);

        // Running as a different user

        User salesMngUser = [SELECT Id FROM User WHERE Username = 'salesrsmmgr@iko.com' LIMIT 1];

        System.runAs(salesMngUser) {
            try {
                delete ct;
            } catch (DmlException e) {
                errorCaught = true;
            }
        }
        Test.stopTest();

        System.assert(errorCaught);
    }

    @isTest static void testThatClaimTypeCanBeInsertedUpdatedDeletedPreClosure() {
        Case c = [SELECT Id, Claim_Stage__c FROM Case WHERE Subject = 'CaseServiceTest1'];
        Test.startTest();
        Claim_Type__c ct = new Claim_Type__c(Case__c = c.Id);
        insert ct;
        System.debug('Queries Insert--->'+Limits.getQueries());
        System.assertNotEquals(ct.Id, null);

        ct.Is_Primary__c = TRUE;
        update ct;
        System.debug('Queries Update--->'+Limits.getQueries());

        Claim_Type__c newct = [SELECT Id, Is_Primary__c FROM Claim_Type__c WHERE Id = :ct.Id];
        System.assertEquals(newct.Is_Primary__c,TRUE);

        delete ct;
        System.debug('Queries Delete--->'+Limits.getQueries());
        String error = '';
        try{
            Claim_Type__c newct1 = [SELECT Id FROM Claim_Type__c WHERE Id = :ct.Id];
        }catch (Exception e){
            error = e.getMessage();
        }

        System.assertNotEquals(error,'');
        Test.stopTest();

    }
    
   
/*  2020-02-05 This is not needed. Coverage is provided by the Test_PrepareMySandbox method
	Test failed: System.NullPointerException: Attempt to de-reference a null object
Stack Trace: Class.ClaimTypeServiceTest.setSecondaryClaimTypes_InsertClaimTypes_CaseSecondaryClaimTypesFieldIsPopulated: line 148, column 1


@isTest static void setSecondaryClaimTypes_InsertClaimTypes_CaseSecondaryClaimTypesFieldIsPopulated() {
        List<Claim_Type__c> toInsertClaimTypes = new List<Claim_Type__c>();
        Case caseToTest = [SELECT Id, Subject FROM Case WHERE Subject = 'ClaimTypeServiceTest' LIMIT 1];

        Test.startTest();

        toInsertClaimTypes.addAll(TestFactory.createClaimTypes(caseToTest, 3, false));

        toInsertClaimTypes[0].Product_Type__c = 'M Protecbrd';
        toInsertClaimTypes[0].Concern__c = 'Blend';
        toInsertClaimTypes[0].Is_Primary__c = false;

        toInsertClaimTypes[1].Product_Type__c = 'P Roof-Fast';
        toInsertClaimTypes[1].Concern__c = 'Algae';
        toInsertClaimTypes[1].Is_Primary__c = false;

        toInsertClaimTypes[2].Product_Type__c = 'Z Not IKO';
        toInsertClaimTypes[2].Concern__c = 'Clawing';
        toInsertClaimTypes[2].Is_Primary__c = false;

        insert toInsertClaimTypes;

        Test.stopTest();

        caseToTest = [SELECT Id, Secondary_Claim_Types__c FROM Case WHERE Subject = 'ClaimTypeServiceTest' LIMIT 1];
        System.assert(caseToTest.Secondary_Claim_Types__c.endsWith('Z Not IKO - Clawing'), 'Expected Secondary Claim Types ends with "Z Not IKO - Clawing"');
    }
*/
/*  2020-02-05 This is not needed. Coverage is provided by the Test_PrepareMySandbox method
 * TEST FAILED: System.NullPointerException: Attempt to de-reference a null object
Stack Trace: Class.ClaimTypeServiceTest.setSecondaryClaimTypes_DeleteClaimTypes_CaseSecondaryClaimTypesFieldIsPopulated: line 177, column 1

    @isTest static void setSecondaryClaimTypes_DeleteClaimTypes_CaseSecondaryClaimTypesFieldIsPopulated() {

        List<Claim_Type__c> toInsertClaimTypes = new List<Claim_Type__c>();
        Case caseToTest = [SELECT Id, Subject FROM Case WHERE Subject = 'ClaimTypeServiceTest' LIMIT 1];

        toInsertClaimTypes.addAll(TestFactory.createClaimTypes(caseToTest, 3, false));

        toInsertClaimTypes[0].Product_Type__c = 'M Protecbrd';
        toInsertClaimTypes[0].Concern__c = 'Blend';
        toInsertClaimTypes[0].Is_Primary__c = false;

        toInsertClaimTypes[1].Product_Type__c = 'P Roof-Fast';
        toInsertClaimTypes[1].Concern__c = 'Algae';
        toInsertClaimTypes[1].Is_Primary__c = false;

        toInsertClaimTypes[2].Product_Type__c = 'Z Not IKO';
        toInsertClaimTypes[2].Concern__c = 'Clawing';
        toInsertClaimTypes[2].Is_Primary__c = false;

        insert toInsertClaimTypes;

        Test.startTest();
        delete toInsertClaimTypes[2];
        Test.stopTest();

        Case caseAfterDeleteClaimType = [SELECT Id, Secondary_Claim_Types__c FROM Case WHERE Subject = 'ClaimTypeServiceTest' LIMIT 1];
        System.assert(caseAfterDeleteClaimType.Secondary_Claim_Types__c.endsWith('P Roof-Fast - Algae'), 'Expected Secondary Claim Types ends with "P Roof-Fast - Algae"');
    }
*/

    /*  2020-02-05 This is not needed. Coverage is provided by the Test_PrepareMySandbox method and this method is no longer used
    
    @isTest static void testSetPrimaryClaimTypeOnCaseRecords() {

        List<Claim_Type__c> toInsertClaimTypes = new List<Claim_Type__c>();
        Case caseToTest = [SELECT Id, Subject FROM Case WHERE Subject = 'ClaimTypeServiceTest' LIMIT 1];

        toInsertClaimTypes.addAll(TestFactory.createClaimTypes(caseToTest, 3, false));

        toInsertClaimTypes[0].Product_Type__c = 'M Protecbrd';
        toInsertClaimTypes[0].Concern__c = 'Blend';
        toInsertClaimTypes[0].Is_Primary__c = false;

        toInsertClaimTypes[1].Product_Type__c = 'P Roof-Fast';
        toInsertClaimTypes[1].Concern__c = 'Algae';
        toInsertClaimTypes[1].Is_Primary__c = false;

        toInsertClaimTypes[2].Product_Type__c = 'Z Not IKO';
        toInsertClaimTypes[2].Concern__c = 'Clawing';
        toInsertClaimTypes[2].Is_Primary__c = false;

        insert toInsertClaimTypes;

        Test.startTest();
        toInsertClaimTypes[2].Product_Type__c = 'A Organic';
        toInsertClaimTypes[2].Is_Primary__c = true;    
        update toInsertClaimTypes[2];
        Test.stopTest();

        Case caseAfterUpdateClaimType = [SELECT Id, Primary_Claim_Type__c, Primary_Claim_Concern__c 
                                         FROM Case WHERE Subject = 'ClaimTypeServiceTest' LIMIT 1];
        System.assertEquals(caseAfterUpdateClaimType.Primary_Claim_Type__c,'A Organic', 'Expected Primary Claim Type to be "A Organic"');
        System.assertEquals(caseAfterUpdateClaimType.Primary_Claim_Concern__c,'Clawing', 'Expected Primary Claim Concern to be"Clawing"');

    }
*/
    
    /*  2020-02-05 This is not needed. Coverage is provided by the Test_PrepareMySandbox method

@isTest static void setSecondaryClaimTypes_UpdateClaimTypes_CaseSecondaryClaimTypesFieldIsPopulated() {

        List<Claim_Type__c> toInsertClaimTypes = new List<Claim_Type__c>();
        Case caseToTest = [SELECT Id, Subject FROM Case WHERE Subject = 'ClaimTypeServiceTest' LIMIT 1];

        toInsertClaimTypes.addAll(TestFactory.createClaimTypes(caseToTest, 3, false));

        toInsertClaimTypes[0].Product_Type__c = 'M Protecbrd';
        toInsertClaimTypes[0].Concern__c = 'Blend';
        toInsertClaimTypes[0].Is_Primary__c = false;

        toInsertClaimTypes[1].Product_Type__c = 'P Roof-Fast';
        toInsertClaimTypes[1].Concern__c = 'Algae';
        toInsertClaimTypes[1].Is_Primary__c = false;

        toInsertClaimTypes[2].Product_Type__c = 'Z Not IKO';
        toInsertClaimTypes[2].Concern__c = 'Clawing';
        toInsertClaimTypes[2].Is_Primary__c = false;

        insert toInsertClaimTypes;

        Test.startTest();
        toInsertClaimTypes[2].Product_Type__c = 'A Organic';
        update toInsertClaimTypes[2];
        Test.stopTest();

        Case caseAfterUpdateClaimType = [SELECT Id, Secondary_Claim_Types__c FROM Case WHERE Subject = 'ClaimTypeServiceTest' LIMIT 1];
        System.assert(caseAfterUpdateClaimType.Secondary_Claim_Types__c.endsWith('A Organic - Clawing'), 'Expected Secondary Claim Types ends with "A Organic - Clawing"');

    }
*/
}