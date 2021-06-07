/**
 * Created by sinan.bunni on 2019-11-15.
 */
@IsTest
private class UpdateLegacyLabSampleRecordsTest {

    @TestSetup
    static void setup() {
        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();

        //create Account
        List<Account> toInsertAccounts = new List<Account>();
        toInsertAccounts.addAll(TestFactory.createAccounts(baRt, 'CaseServiceTest', '9 King St E', 'Toronto', 'ON', 'CA', 'M4S 2H4',
                'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));
        insert toInsertAccounts;

        //create contact
        List<Contact> toInsertContacts = new List<Contact>();
        toInsertContacts.addAll(TestFactory.createContacts(toInsertAccounts[0].Id, 'CaseServiceTest', UserInfo.getUserId(), 1, false));
        insert toInsertContacts;
		
        Case testCase = new Case();
        testCase = TestFactory.createCases(ccRt, toInsertAccounts.get(0).Id, toInsertContacts[0].Id, 'Distributor',
                'CaseServiceTest', null, 'Commercial', 'Draft', 1, false).get(0);
        testCase.Legacy_External_ID__c = '11111';
        testCase.Description = 'testbatch';
        insert testCase;

        Lab_Sample__c labSample = new Lab_Sample__c(Legacy_Id__c = '11111', Case__c = testCase.Id);
        insert labSample;

    } // end setup

    private static testMethod void execute_ValidLegacyLabSample_PopulateCaseDescriptionField() {

        Test.startTest();
        Id batchId = Database.executeBatch(new UpdateLegacyLabSampleRecords());
        Test.stopTest();

        // assert the data
        Integer count = 0;
        for (Lab_Sample__c labSample : [SELECT Case_Description__c FROM Lab_Sample__c]) {
            if (labSample.Case_Description__c != NULL) {
                count++;
            }
        }

        // System.assertEquals(1, count, 'Expected 1 updated Lab Sample records.');

    }

} // end UpdateLegacyLabSampleRecordsTest class