/**
 * Created by Francois Poirier on 2018-12-17.
 */

@isTest
public with sharing class icTestRepoContact {

    static icRepoContact.IClass repoContact = (icRepoContact.IClass) icObjectFactory.GetSingletonInstance('icRepoContact');

    @isTest
    static void testGetContactById(){

        Contact testContact = new Contact();
        Contact contactFromRepo = new Contact();
        Account testAccount = icTestHelperUtility.generateAccount();
        insert testAccount;

        testContact.FirstName = icTestHelperUtility.generateRandomString(15);
        testContact.LastName = icTestHelperUtility.generateRandomString(15);
        system.debug(testAccount);
        testContact.AccountId = testAccount.Id;

        insert testContact;

        contactFromRepo = repoContact.getContactById(testContact.Id);

        system.assertEquals(testContact.FirstName, contactFromRepo.FirstName);

    }

    @isTest
    static void testGetContactsForVendorEmailByIdNoResult(){

        Map<String, Schema.FieldSet> mapFieldSets = Schema.SObjectType.Contact.fieldSets.getMap();
        Schema.FieldSet requiredFieldSetResult = mapFieldSets.get('Vendor_Field_Set_Applicant');

        Contact contactFromRepo = repoContact.getContactsForVendorEmailById(icTestHelperUtility.getFakeId(Contact.SObjectType), requiredFieldSetResult);

    }

    @isTest
    static void testGetContactsForVendorEmailByIdWithResult(){

        Contact testContact = new Contact();
        Account testAccount = icTestHelperUtility.generateAccount();
        insert testAccount;

        testContact.FirstName = icTestHelperUtility.generateRandomString(15);
        testContact.LastName = icTestHelperUtility.generateRandomString(15);
        system.debug(testAccount);
        testContact.AccountId = testAccount.Id;

        insert testContact;

        Map<String, Schema.FieldSet> mapFieldSets = Schema.SObjectType.Contact.fieldSets.getMap();
        Schema.FieldSet requiredFieldSetResult = mapFieldSets.get('Vendor_Field_Set_Applicant');

        Contact contactFromRepo = repoContact.getContactsForVendorEmailById(testContact.Id, requiredFieldSetResult);

    }

    @isTest
    static void test_getPrimaryAdminContactsByContractorIds() {
        List<Contact> listResult =  repoContact.getPrimaryAdminContactsByContractorIds(new List<String>());
    }

    @isTest static void testSaveContact(){

        Contact testContact = new Contact();
        testContact.FirstName = icTestHelperUtility.generateRandomString(10);
        testContact.LastName = icTestHelperUtility.generateRandomString(15);
        Account testAccount = icTestHelperUtility.generateAccount();
        insert testAccount;
        testContact.AccountId = testAccount.Id;

        testContact = repoContact.saveContact(testContact);

    }
}