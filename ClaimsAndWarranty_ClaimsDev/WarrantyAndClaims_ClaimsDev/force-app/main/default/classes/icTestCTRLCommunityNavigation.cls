/**
 * Created by Andrea Pissinis on 2018-09-27.
 */
@isTest
public with sharing class icTestCTRLCommunityNavigation {

    /**
     * Updated by Anil Mannem on 17-Aug-2020
     */
    public static testMethod void test_getSummitBlogAuthDetails(){
        Test.startTest();
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicUser', new icLogicUserMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicUserMock', 'getAccountIdFromPartnerUser', 'test');
        icCTRLCommunityNavigation.getSummitBlogAuthDetails('');
        Test.stopTest();
    }
    
    /**
     * Updated by Anil Mannem on 30-Oct-2020
     * To get code coverage for changes from VRP (Dmitry)
     */
    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }
    public static testMethod void test_getCurrentTheme(){
        Test.startTest();
		Profile profileId = [
                SELECT Id
                FROM Profile
                WHERE Name = 'IKOPRO Contractor'
                LIMIT 1
        ];
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IKO ROOFPRO APPLICANTS').getRecordTypeId();
        Account account = new Account(
                Name = generateRandomString(5) +'(ROOFPRO)',
                BillingCountryCode = 'CA',
                BillingStateCode = 'ON',
                BillingPostalCode = 'L7Y 6T5',
                BillingCity = 'Brampton',
                BillingStreet = '123 street',
                Phone = '555-555-5555',
                RecordTypeId = recordTypeId
        );
        insert account;
        Contact contact = new Contact(
                LastName = generateRandomString(7),
                AccountId = account.Id,
                FirstName = generateRandomString(7)
        );
        insert contact;
        User user = new User(
                LastName = 'Tester',
                FirstName = 'Tester',
                Alias = 'testtes',
                Email = UserInfo.getUserId().substring(8) + String.valueOf(Date.today()) + '@test.com',
                Username = UserInfo.getUserId().substring(8) + String.valueOf(Date.today()) + '@test.com',
                ProfileId = profileId.id,
                TimeZoneSidKey = 'GMT',
                LanguageLocaleKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LocaleSidKey = 'en_US',
                ContactId = contact.Id
        );
        insert user;
        System.runAs(user){
	        icCTRLCommunityNavigation.getCurrentTheme();
        }
        Test.stopTest();
    }
}