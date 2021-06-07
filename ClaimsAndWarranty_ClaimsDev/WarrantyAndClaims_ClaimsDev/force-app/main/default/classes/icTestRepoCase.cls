/**
 * Created by Anil Mannem (Incloud) on 28-July-2020
 */
@isTest
public with sharing class icTestRepoCase {

    static void setupTestData() {
        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();
        Id daRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();

        //create Account
        // Order of Parameters
        // recordTypeId, accountName, bStreet, bCity, bStateCode, bCountryCode, bPostalCode, AddVerifiedStatus, ownerId, Boolean nmVerificationStatus, Boolean actVerifiedStatus, numOfAccounts, isInsert
        List<Account> toInsertAccounts = new List<Account>();
		
        toInsertAccounts.addAll(TestFactory.createAccounts(baRt, 'CaseServiceTest', '9 King St E', 'Toronto', 'ON', 'CA', 'M4S 2H4',
                'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));
        toInsertAccounts.addAll(TestFactory.createAccounts(daRt, 'Slalom Distribution', '8 King St E', 'Toronto', 'ON', 'CA', 'M4S 2H4',
                'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));
        toInsertAccounts.addAll(TestFactory.createAccounts(daRt, 'CaseServiceTestNewYork', '9 King St E', 'New York', 'NY', 'US', '99899',
                'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));
        toInsertAccounts.addAll(TestFactory.createAccounts(baRt, 'CaseServiceTestQuebec', '9 King St E', 'Montreal', 'QC', 'CA', 'M4S 2H4',
                'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));
        toInsertAccounts.addAll(TestFactory.createAccounts(baRt, 'CaseServiceTestQuebec2', '69 King St E', 'Montreal', 'QC', 'CA', 'M4S 2H4',
                'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));
        toInsertAccounts.addAll(TestFactory.createAccounts(baRt, 'ClaimNumber', '19 King St E', 'Toronto', 'ON', 'CA', 'M4S 2H4',
                'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));
        toInsertAccounts.addAll(TestFactory.createAccounts(baRt, 'CaseServiceTestWashington', '9 King St E', 'Seattle', 'WA', 'US', '12111',
                'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));

        insert toInsertAccounts;

        //create contact
        List<Contact> toInsertContacts = new List<Contact>();

        toInsertContacts.addAll(TestFactory.createContacts(toInsertAccounts[0].Id, 'CaseServiceTest', UserInfo.getUserId(), 1, false));
        toInsertContacts.addAll(TestFactory.createContacts(toInsertAccounts[1].Id, 'CaseServiceTestAccount', UserInfo.getUserId(), 1, false));
        toInsertContacts.addAll(TestFactory.createContacts(toInsertAccounts[0].Id, 'CaseServiceTestForQueue', UserInfo.getUserId(), 1, false));

        insert toInsertContacts;

        Map<String, Account> mapAccounts = new Map<String, Account>();

        for (Account act : [SELECT Id,Name FROM Account]) {
            mapAccounts.put(act.Name, act);
        }

        //create products
        List<Product2> toInsertProducts = new List<Product2>();
        toInsertProducts.addAll(TestFactory.createProducts('IkoSampleProduct', TRUE, 'IkoSampleProduct', 'US;CA;Commercial;Blair', null, 1, false));

        insert toInsertProducts;

        //create Cases
        List<Case> toInsertCases = new List<Case>();

        toInsertCases.addAll(TestFactory.createCases(ccRt, mapAccounts.get('CaseServiceTest').Id, toInsertContacts[0].Id, 'Distributor', 'CaseServiceTestClosed', null, 'Commercial', 'Closed', 1, false));
        toInsertCases.addAll(TestFactory.createCases(ccRt, mapAccounts.get('CaseServiceTest').Id, toInsertContacts[0].Id, 'Distributor', 'CaseServiceTest', null, 'Commercial', 'Draft', 1, false));
        toInsertCases.addAll(TestFactory.createCases(ccRt, mapAccounts.get('CaseServiceTest').Id, toInsertContacts[0].Id, 'Distributor', 'CaseServiceTest1', null, 'Commercial', 'Draft', 1, false));
        toInsertCases.addAll(TestFactory.createCases(ccRt, mapAccounts.get('CaseServiceTestNewYork').Id, toInsertContacts[0].Id, 'Distributor', 'CaseServiceNewYork', date.newInstance(2006, 5, 5), 'Commercial', 'Draft', 1, false));
        toInsertCases.addAll(TestFactory.createCases(ccRt, mapAccounts.get('CaseServiceTestQuebec').Id, toInsertContacts[0].Id, 'Distributor', 'CaseServiceQuebec', date.newInstance(2006, 5, 5), 'Commercial', 'Draft', 1, false));
        toInsertCases.addAll(TestFactory.createCases(ccRt, mapAccounts.get('CaseServiceTestQuebec2').Id, toInsertContacts[0].Id, 'Distributor', 'CaseServiceQuebec2', date.newInstance(2016, 5, 5), 'Commercial', 'Draft', 1, false));

        toInsertCases.addAll(TestFactory.createCases(ccRt, mapAccounts.get('CaseServiceTestWashington').Id, toInsertContacts[0].Id, 'Distributor', 'CaseServiceWashington', date.newInstance(2006, 5, 5), 'US', 'Draft', 1, false));

        List<Case> c1 = TestFactory.createCases(ccRt, mapAccounts.get('ClaimNumber').Id, toInsertContacts[0].Id, 'Owner', 'ClaimNumberCase', null, 'CA', null, 1, false);
        c1[0].Job_In_Progress__c = TRUE;
        c1[0].Leaking__c = TRUE;
        toInsertCases.addAll(c1);

        List<Case> c2 = TestFactory.createCases(ccRt, mapAccounts.get('CaseServiceTest').Id, toInsertContacts[0].Id, 'Distributor', 'CaseServiceTest2', null, 'Commercial', 'Draft', 1, false);

        c2[0].Origin = 'Owner';
        c2[0].Samples_Collected__c = 'Not Required';
        c2[0].All_Claim_Photos_Attached__c = true;
        c2[0].Distributor__c = mapAccounts.get('Slalom Distribution').Id;
        c2[0].Product__c = toInsertProducts[0].Id;
        c2[0].Type_Of_Structure__c = 'Barn';
        c2[0].OwnerId = UserInfo.getUserId();

        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = true;
        c2[0].setOptions(dmo);

        toInsertCases.addAll(c2);

        List<Case> c3 = TestFactory.createCases(ccRt, mapAccounts.get('CaseServiceTest').Id, toInsertContacts[0].Id, 'Owner', 'CaseServiceTestSubmitted', null, 'US', 'Draft', 1, false);
        c3[0].Samples_Collected__c = 'Not Required';
        c3[0].All_Claim_Photos_Attached__c = TRUE;
        c3[0].Product__c = toInsertProducts[0].Id;
        c3[0].Type_of_Structure__c = 'Barn';
        toInsertCases.addAll(c3);

        insert toInsertCases;

        //create Claim type
        List<Claim_Type__c> toInsertClaimTypes = new List<Claim_Type__c>();
        toInsertClaimTypes.addAll(TestFactory.createClaimTypes(toInsertCases[0], 1, false));
        toInsertClaimTypes.addAll(TestFactory.createClaimTypes(toInsertCases[1], 1, false));
        toInsertClaimTypes.addAll(TestFactory.createClaimTypes(toInsertCases[2], 1, false));
        toInsertClaimTypes.addAll(TestFactory.createClaimTypes(toInsertCases[3], 1, false));
        toInsertClaimTypes.addAll(TestFactory.createClaimTypes(toInsertCases[4], 1, false));
        toInsertClaimTypes.addAll(TestFactory.createClaimTypes(toInsertCases[5], 1, false));
        toInsertClaimTypes.addAll(TestFactory.createClaimTypes(toInsertCases[6], 1, false));
        toInsertClaimTypes.addAll(TestFactory.createClaimTypes(toInsertCases[7], 1, false));
        toInsertClaimTypes.addAll(TestFactory.createClaimTypes(toInsertCases[8], 1, false));
        toInsertClaimTypes.addAll(TestFactory.createClaimTypes(toInsertCases[9], 1, false));

        insert toInsertClaimTypes;
    }

	/**
	 * Ticket ClaimsV2-931
	 * By Anil Mannem (Incloud) on 28-July-2020
	 */
    @isTest
    static void testGetCaseById () {
        icRepoCase.IClass repository = (icRepoCase.IClass) icObjectFactory.GetSingletonInstance('icRepoCase');
        setupTestData();
        List<Case> caseList = repository.getCaseById(new Set<String>{''});
    }
}