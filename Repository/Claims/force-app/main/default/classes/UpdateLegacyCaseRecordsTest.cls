/**
 * Created by sinan.bunni on 2019-11-15.
 */
@IsTest
private class UpdateLegacyCaseRecordsTest {

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
        insert testCase;
    } // end setup

    private static testMethod void execute_ValidLegacyCases_PopulateSYSRoleField() {

        Test.startTest();
        Id batchId = Database.executeBatch(new UpdateLegacyCaseRecords());
        Test.stopTest();

        // System.assertEquals(0, [SELECT COUNT() FROM Case WHERE SYS_UserRole__c != NULL], 'Expected 0 Cases with SYS User Role populated.');

    }

}