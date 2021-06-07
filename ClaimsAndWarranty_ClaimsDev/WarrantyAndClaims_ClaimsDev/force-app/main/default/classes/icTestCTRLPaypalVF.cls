/**
 * Created by Francois Poirier on 2018-12-13.
 */

@isTest
public with sharing class icTestCTRLPaypalVF {

    static String jsonSample = '{"id": "PAY-1B56960729604235TKQQIYVY","create_time": "2017-09-22T20:53:43Z","update_time": "2017-09-22T20:53:44Z","state": "approved","intent": "sale","payer": {"payment_method": "paypal"},"transactions": [{"amount": { "total": "30.11", "currency": "USD", "details": { "subtotal": "30.00","tax": "0.07", "shipping": "0.03", "handling_fee": "1.00", "insurance": "0.01", "shipping_discount": "-1.00"   }}, "description": "The payment transaction description.", "custom": "EBAY_EMS_90048630024435", "invoice_number": "48787589673","item_list": {"items": [{"name": "hat", "sku": "1", "price": "3.00", "currency": "USD", "quantity": "5", "description": "Brown hat.", "tax": "0.01"},{"name": "handbag", "sku": "product34", "price": "15.00", "currency": "USD", "quantity": "1", "description": "Black handbag.", "tax": "0.02"}], "shipping_address": {"recipient_name": "Brian Robinson", "line1": "4th Floor", "line2": "Unit #34", "city": "San Jose", "state": "CA", "phone": "011862212345678","postal_code": "95131", "country_code": "US"}}}],"links": [{"href": "https://api.sandbox.paypal.com/v1/payments/payment/PAY-1B56960729604235TKQQIYVY","rel": "self", "method": "GET"},{"href": "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-60385559L1062554J","rel": "approval_url", "method": "REDIRECT"}, {"href": "https://api.sandbox.paypal.com/v1/payments/payment/PAY-1B56960729604235TKQQIYVY/execute","rel": "execute", "method": "POST"}]}copy';
    static IKOPRO_Account_Payment__c testAccountPayment = new IKOPRO_Account_Payment__c();

    static void setup(){

        IKOPRO_Payment__c testPayment = new IKOPRO_Payment__c();
        Account testAccount = icTestHelperUtility.generateContractorAccount();
        insert testAccount;
        system.debug('test account ===> ' + testAccount);

        //testAccountPayment.Id = icTestHelperUtility.getFakeId(IKOPRO_Account_Payment__c.SObjectType);
        testAccountPayment.Contractor__c = testAccount.Id;
        insert testPayment;

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicTransaction', new icLogicTransactionMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicAccountPayment', new icLogicAccountPaymentMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicUser', new icLogicUserMock());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicContact', new icLogicContactMock());


        icTestMockUtilities.Tracer.SetReturnValue('icLogicTransactionMock', 'createTransaction', new Transaction__c());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountPaymentMock', 'getAccountPaymentById', testAccountPayment);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountPaymentMock', 'updateAccountPayment', new IKOPRO_Account_Payment__c());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicUserMock', 'getContactIdFromUserId', icTestHelperUtility.getFakeId(Contact.SObjectType));
        icTestMockUtilities.Tracer.SetReturnValue('icLogicContactMock', 'saveContact', new Contact());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicContactMock', 'getContactById', new Contact());

        PageReference myVfPage = Page.icPaypalCheckout;
        Test.setCurrentPage(myVfPage);
    }

    @isTest static void testSavePayment(){

        setup();
        icCTRLPaypalVF ctrl = new icCTRLPaypalVF();
        ctrl.strPaymentDetails = jsonSample;
        ctrl.accountPayment = testAccountPayment;
        ctrl.savePayment();
        ctrl.getPaymentContact();
        ctrl.getAccountPayment();
        ctrl.getLocale();
    }
}