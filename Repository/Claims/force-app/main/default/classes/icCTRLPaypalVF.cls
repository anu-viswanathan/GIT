/**
 * Created by Francois Poirier on 2018-12-04.
 */

public without sharing class icCTRLPaypalVF {

    public PaymentAddress thisPaymentAddress {get;set;}
    public String strPaymentDetails {get;set;}
    public Contact paymentContact {get;set;}
    public String sfPaymentId {get;set;}
    public String contactId {get;set;}
    //public String environment {get;set;}
    public IKOPRO_Account_Payment__c accountPayment {get;set;}
    public String locale {get;set;}

    private icLogicTransaction.IClass transactionLogic = (icLogicTransaction.IClass) icObjectFactory.GetSingletonInstance('icLogicTransaction');
    private icLogicAccountPayment.IClass apLogic = (icLogicAccountPayment.IClass) icObjectFactory.GetSingletonInstance('icLogicAccountPayment');
    private icLogicUser.IClass userLogic = (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');
    private icLogicContact.IClass contactLogic = (icLogicContact.IClass) icObjectFactory.GetSingletonInstance('icLogicContact');


    public icCTRLPaypalVF(){

        String environment;
        Boolean isSandbox = [SELECT isSandbox FROM Organization LIMIT 1].isSandbox;
        system.debug('isSandbox ====> ' + isSandbox);
        /*if(isSandbox){
            environment = 'sandbox';
        }
        else {
            environment = 'production';
        }*/
        locale = UserInfo.getLocale();
        sfPaymentId = ApexPages.currentPage().getParameters().get('paymentid');
        contactId = ApexPages.currentPage().getParameters().get('contactid');
        accountPayment = apLogic.getAccountPaymentById(sfPaymentId);
        paymentContact = contactLogic.getContactById(contactId);

        system.debug('account payment ===> ' + accountPayment);
        system.debug('payment contact ===> ' + paymentContact);

        if(accountPayment.Applicant__c != null) {
            thisPaymentAddress = new PaymentAddress(accountPayment.Applicant__r.Company_Street_Applicant__c, accountPayment.Applicant__r.Company_City_Applicant__c, accountPayment.Applicant__r.Zip_Postal_Code_Applicant__c, accountPayment.Applicant__r.Company_State_Province_Code_Applicant__c, accountPayment.Applicant__r.Country_Code_Applicant__c);
        } else {
            thisPaymentAddress = new PaymentAddress(accountPayment.Contractor__r.BillingStreet, accountPayment.Contractor__r.BillingCity, accountPayment.Contractor__r.BillingPostalCode, accountPayment.Contractor__r.BillingStateCode, accountPayment.Contractor__r.BillingCountryCode);
        }

    }

    public void savePayment(){

        try {

            System.debug('payment Details ===> ' + strPaymentDetails);

            strPaymentDetails = strPaymentDetails.replaceAll('currency', 'paymentcurrency');
            System.debug('payment Details ===> ' + strPaymentDetails);

            icDTOPaypalPaymentResponse dtoPaymentDetails = new icDTOPaypalPaymentResponse();

            dtoPaymentDetails = (icDTOPaypalPaymentResponse) JSON.deserialize(strPaymentDetails, icDTOPaypalPaymentResponse.class);

            system.debug('payment detaisl DTO ===> ' + dtoPaymentDetails);

            if(String.isNotBlank(dtoPaymentDetails.state)) {

                Transaction__c trans = new Transaction__c();
                Account acc = new Account();
                Double amount = 0;

                for (icDTOPaypalTransactionItem item : dtoPaymentDetails.transactions) {

                    amount += Double.valueOf(item.amount.total);

                }
                String paymentCurrency = 'USD';
                if(dtoPaymentDetails.transactions.size()>0){
                    paymentCurrency = dtoPaymentDetails.transactions[0].amount.paymentcurrency;
                }

                trans.Amount__c = amount;
                trans.Currency_Used__c = paymentCurrency;
                trans.Transaction_Date__c = Date.today();
                trans.Transaction_reference__c = dtoPaymentDetails.id;
                trans.Transaction_User__c = UserInfo.getUserId();
                trans.Account_ID__c = accountPayment.Contractor__c;
                trans.Transaction_Type__c = 'Credit';
                trans.Transaction_Sources__c = 'Paypal';
                trans.Account_Payment__c = accountPayment.Id;
                trans.Transaction_Status__c = dtoPaymentDetails.state;
                trans.Transaction_JSON__c = strPaymentDetails;
                transactionLogic.createTransaction(trans);

                if(dtoPaymentDetails.state == 'Approved') {
                    accountPayment.Paid_Amount__c = amount;
                    accountPayment.Paid_Date__c = Date.today();
                    accountPayment.Payment_Source__c = 'Paypal';
                    accountPayment.Payment_Transaction_Code__c = dtoPaymentDetails.id;
                    apLogic.updateAccountPayment(accountPayment);
                }
            }



        } catch (Exception ex)
        {
            icServiceErrorHandler.LogError('icCTRLPaypalVF', 'savePayment', ex.getStackTraceString(), ex.getMessage(), strPaymentDetails);
        }
    }

    public Contact getPaymentContact(){

        return paymentContact;

    }

    public IKOPRO_Account_Payment__c getAccountPayment(){
        return accountPayment;
    }

    public String getLocale(){
        return locale;
    }

    public class PaymentAddress {
        public String street {get;set;}
        public String city {get;set;}
        public String zipCode {get;set;}
        public String state {get;set;}
        public String country {get;set;}

        public PaymentAddress(String street, String city, String zipCode, String state, String country){
            this.street = street;
            this.city = city;
            this.zipCode = zipCode;
            this.state = state;
            this.country = country;
        }
    }
}