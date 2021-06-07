/**
 * Created by Francois Poirier on 2018-12-17.
 */

@isTest(SeeAllData=true)
public with sharing class icTestLogicContact {

    static void setup(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoContact', new icRepoContactMock() );
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicEmail', new icLogicEmailMock() );
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicConfig',new icLogicConfigMock());

        icTestMockUtilities.Tracer.SetReturnValue('icLogicConfigMock', 'getIkoGlobalConfigByName', new Iko_Global_Configurations__mdt());

        //icTestMockUtilities.Tracer.SetReturnValue('icLogicEmailMock', 'getOrgWideEmailByName', new OrgWideEmailAddress());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicEmailMock', 'getEmailTemplateByDevName', new EmailTemplate(Subject='Subject', Body='Body'));

        icTestMockUtilities.Tracer.SetReturnValue('icRepoContactMock', 'getContactById', new Contact());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoContactMock', 'getPrimaryAdminContactsByContractorIds', new List<Contact>());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoContactMock', 'saveContact', new Contact());

    }
    //This Setup is does't not use the Mock Patern and generate Account and Contacts 
    static void setup2(){
        List<Contact> contacts = new List<Contact>();
        Account testAccount = new Account(name = 'Unit TEST Account');
        Insert testAccount;

        contacts.add(new Contact(accountId=testAccount.Id, Country_Code_Applicant__c = 'US', firstName = 'UnitTestUSContact', email='UnitTestUSContact@unitTest.ca', lastName='lUS'));
        contacts.add(new Contact(accountId=testAccount.Id, Country_Code_Applicant__c = 'CA', firstName = 'UnitTestCAContact', email='UnitTestCAContact@unitTest.ca', lastName='lCA'));
        insert contacts;
    }

    private static String getContactQueryStringbyContactFirstName( String contactFirstName) {
        Map<String, Schema.FieldSet> mapFieldSets = Schema.SObjectType.Contact.fieldSets.getMap();
        Schema.FieldSet vendorFieldSet = mapFieldSets.get('Vendor_Field_Set_Applicant');

        String query = 'SELECT ';
        if(vendorFieldSet != null) {
            for(Schema.FieldSetMember field : vendorFieldSet.getFields()) {
                query += field.getFieldPath() + ', ';
            }
        }
        System.debug('query : ' + query);
        query += 'Id, Name,Company_Name_Applicant__c, Country_Code_Applicant__c, Account.BillingCountryCode FROM Contact WHERE firstName=\'' + contactFirstName + '\' LIMIT 1';
        return query;
    }

    


    @isTest static void testGetContactById(){

        setup();

        icLogicContact.IClass contactLogic = (icLogicContact.IClass) icObjectFactory.GetSingletonInstance('icLogicContact');

        Contact testContact = contactLogic.getContactById(icTestHelperUtility.getFakeId(Contact.SObjectType));

    }

    @isTest static void test_getPrimaryAdminContactsByContractorIds(){

        setup();

        icLogicContact.IClass contactLogic = (icLogicContact.IClass) icObjectFactory.GetSingletonInstance('icLogicContact');

        List<String> contractorIds = new List<String>();

        List<Contact> testResult = contactLogic.getPrimaryAdminContactsByContractorIds(contractorIds);

    }

    @isTest static void test_getMapPrimaryAdminContactByContractorId(){

        setup();

        icLogicContact.IClass contactLogic = (icLogicContact.IClass) icObjectFactory.GetSingletonInstance('icLogicContact');

        List<Contact> contacts = new List<Contact>();
        Contact newContact = new Contact(AccountId = icTestHelperUtility.getFakeId(Account.SObjectType));
        contacts.add(newContact);

        Map<String, Contact> testContact = contactLogic.getMapPrimaryAdminContactByContractorId(contacts);

    }

    @isTest static void testSaveContact(){

        setup();

        icLogicContact.IClass contactLogic = (icLogicContact.IClass) icObjectFactory.GetSingletonInstance('icLogicContact');

        Contact testContact = new Contact();
        testContact.FirstName = icTestHelperUtility.generateRandomString(10);
        testContact.LastName = icTestHelperUtility.generateRandomString(15);
        Account testAccount = icTestHelperUtility.generateAccount();
        insert testAccount;
        testContact.AccountId = testAccount.Id;

        testContact = contactLogic.saveContact(testContact);

    }

    @isTest static void test_handleVendorEmail_US_Applicant(){
        setup2();
        String query = getContactQueryStringbyContactFirstName('UnitTestUSContact');
        Test.startTest();
        Contact contactCA = Database.query(query);
        icTestMockUtilities.Tracer.SetReturnValue('icRepoContactMock', 'getContactsForVendorEmailById', contactCA);
        icLogicContact.IClass contactLogic = (icLogicContact.IClass) icObjectFactory.GetSingletonInstance('icLogicContact');
        contactLogic.handleVendorEmail(contactCA.Id);
        Test.stopTest();
        System.assert(contactCA != null, 'Was expecting to find at least one contact');
    }

    @isTest static void test_handleVendorEmail_CA_Applicant(){
        setup2();
        String query = getContactQueryStringbyContactFirstName('UnitTestCAContact');
        Test.startTest();
        Contact contactCA = Database.query(query);
        icTestMockUtilities.Tracer.SetReturnValue('icRepoContactMock', 'getContactsForVendorEmailById', contactCA);
        icLogicContact.IClass contactLogic = (icLogicContact.IClass) icObjectFactory.GetSingletonInstance('icLogicContact');
        contactLogic.handleVendorEmail(contactCA.Id);
        Test.stopTest();
        System.assert(contactCA != null, 'Was expecting to find at least one contact');
    }
}