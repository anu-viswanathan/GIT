/**
 * Created by Gerard van Kempen on 2019-12-09.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

/**
* @author Gerard van Kempen, 4C NV
* @date 2019
*
* @group Integration Services
*
* @description InvoiceServicesTestComponentFactory aids in the generation of test objects.
*/

@IsTest
public class InvoiceServicesTestComponentFactory {
    public class InvoiceLineTestingTuple {
        public final EU_Open_Invoice_Line__c referenceInvoiceLine;
        public EU_Open_Invoice_Line__c workingInvoiceLine;
        public InvoiceLineTestingTuple(EU_Open_Invoice_Line__c invoiceLine) {
            this.referenceInvoiceLine = invoiceLine.clone();
            this.workingInvoiceLine = invoiceLine.clone();
        }
    }

    public class InvoiceTestingTuple {
        public final EU_Open_Invoice__c referenceInvoice;
        public EU_Open_Invoice__c workingInvoice;
        public InvoiceTestingTuple(EU_Open_Invoice__c invoice) {
            this.referenceInvoice = invoice.clone();
            this.workingInvoice = invoice.clone();
        }
    }

    private static String newRandomString(Integer length) {
        Blob blobKey = Crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        return key.substring(0,length);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Open_Invoice_Line__c object wrapped in a testing tuple.
    * @param invoiceNumber a dummy invoice number, not null
    * @param dueValue a dummy due value, not null
    * @param acct a dummy account (may be null)
    * @return an InvoiceLineTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * InvoiceLineTestingTuple invoiceLineTT = InvoiceServicesTestComponentFactory.newInvoiceLineTestingTuple(invoiceNumber, dueValue, acct);
    */

    public static InvoiceLineTestingTuple newInvoiceLineTestingTuple(String invoiceNumber, Decimal dueValue, Account acct) {
        EU_Open_Invoice_Line__c invoiceLine = new EU_Open_Invoice_Line__c();
        invoiceLine.EU_Days_Past_Due__c = 0;
        if(acct != null) {
            invoiceLine.EU_Header_Account__c = acct.Id;
        }
//        invoiceLine_1.CreatedById; // automatically set
        invoiceLine.CurrencyIsoCode = 'EUR';
        invoiceLine.EU_Header_Inv_Due_Date__c = Date.today().addDays(7);
        invoiceLine.EU_Header_Invoice_Date__c = Date.today();
        invoiceLine.EU_Invoice_Line_Number__c = newRandomString(4);
        invoiceLine.EU_Header_Invoice_Number__c = invoiceNumber;
        invoiceLine.EU_Header_Invoice_Type__c = 'Invoice';
        invoiceLine.EU_Header_JDE_Customer_No__c = newRandomString(16);
//        invoiceLine_1.LastModifiedById; // automatically set
        invoiceLine.EU_Header_Mapics_Customer_No__c = newRandomString(16);
//        invoiceLine_1.EU_Open_Invoice__c; // related Invoice, cannot be set yet
        invoiceLine.EU_Header_Open_Invoice__c = true; // info: what does this field do?
        invoiceLine.EU_Open_Invoice_Line__c = true; // info: what does this field do?
//        invoiceLine_1.Name; // autonumber
        invoiceLine.EU_Order_Number__c = newRandomString(8);
        invoiceLine.EU_Header_Order_number_Reference__c = newRandomString(8);
        invoiceLine.EU_Header_Purchase_Order_Number__c = newRandomString(12);
        invoiceLine.EU_Header_Terms_code__c = newRandomString(5);
        invoiceLine.EU_Header_Terms_Description__c = newRandomString(32);
        invoiceLine.EU_Header_Total_Invoice_Value__c = dueValue * 2.1;
        return new InvoiceLineTestingTuple(invoiceLine);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Open_Invoice_Line__c object wrapped in a testing tuple.
    * @param dueValue a dummy due value, not null
    * @param acct a dummy account (may be null)
    * @return an InvoiceLineTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * InvoiceLineTestingTuple invoiceLineTT = InvoiceServicesTestComponentFactory.newInvoiceLineTestingTuple(dueValue, acct);
    */

    public static InvoiceLineTestingTuple newInvoiceLineTestingTuple(Decimal dueValue, Account acct) {
        return newInvoiceLineTestingTuple(newRandomString(9), dueValue, acct);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Open_Invoice_Line__c object wrapped in a testing tuple.
    * @param acct a dummy account (may be null)
    * @return an InvoiceLineTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * InvoiceLineTestingTuple invoiceLineTT = InvoiceServicesTestComponentFactory.newInvoiceLineTestingTuple(acct);
    */

    public static InvoiceLineTestingTuple newInvoiceLineTestingTuple(Account acct) {
        return newInvoiceLineTestingTuple(1324.65, acct);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Open_Invoice_Line__c object wrapped in a testing tuple.
    * @return an InvoiceLineTestingTuple setup using random values as to avoid collisions
    * @example
    * InvoiceLineTestingTuple invoiceLineTT = InvoiceServicesTestComponentFactory.newInvoiceLineTestingTuple();
    */

    public static InvoiceLineTestingTuple newInvoiceLineTestingTuple() {
        return newInvoiceLineTestingTuple(null);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Open_Invoice__c object wrapped in a testing tuple.
    * @param invoiceNumber a dummy invoice number, not null
    * @param dueValue a dummy due value, not null
    * @param acct a dummy account (may be null)
    * @return an InvoiceTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * InvoiceTestingTuple invoiceLineTT = InvoiceServicesTestComponentFactory.InvoiceTestingTuple(invoiceNumber, dueValue, acct);
    */

    public static InvoiceTestingTuple newInvoiceTestingTuple(String invoiceNumber, Decimal dueValue, Account acct) {
        EU_Open_Invoice__c invoice = new EU_Open_Invoice__c();
        if(acct != null) {
            invoice.EU_Account__c = acct.Id;
        }
        invoice.EU_Amount_Due_Value__c = dueValue;
//        testingInvoice_1.CreatedById; // automatically set
        invoice.CurrencyIsoCode = 'EUR';
        invoice.EU_Inv_Due_Date__c = Date.today().addDays(7);
        invoice.EU_Invoice_Date__c = Date.today();
        invoice.EU_Invoice_Number__c = invoiceNumber;
        invoice.EU_Invoice_Type__c = 'Invoice';
        invoice.EU_JDE_Customer_No__c = newRandomString(16);
//        testingInvoice_1.LastModifiedById; // automatically set
        invoice.EU_Mapics_Customer_No__c = newRandomString(16);
//        testingInvoice_1.EU_Open_Invoice__c;
        invoice.EU_Open_Invoice__c = false; // info: what does this field do?
//        testingInvoice_1.Name; // autonumber
        invoice.EU_Order_number_Reference__c = newRandomString(8);
        invoice.EU_Purchase_Order_Number__c = newRandomString(12);
        invoice.EU_Terms_code__c = newRandomString(5);
        invoice.EU_Terms_Description__c = newRandomString(32);
        invoice.EU_Total_Invoice_Value__c = dueValue * 2.1;
        return new InvoiceTestingTuple(invoice);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Open_Invoice__c object wrapped in a testing tuple.
    * @param dueValue a dummy due value, not null
    * @param acct a dummy account (may be null)
    * @return an InvoiceTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * InvoiceTestingTuple invoiceLineTT = InvoiceServicesTestComponentFactory.InvoiceTestingTuple(dueValue, acct);
    */

    public static InvoiceTestingTuple newInvoiceTestingTuple(Decimal dueValue, Account acct) {
        return newInvoiceTestingTuple(newRandomString(9), dueValue, acct);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Open_Invoice__c object wrapped in a testing tuple.
    * @param acct a dummy account (may be null)
    * @return an InvoiceTestingTuple setup using the provided values, and some random values as to avoid collisions
    * @example
    * InvoiceTestingTuple invoiceLineTT = InvoiceServicesTestComponentFactory.InvoiceTestingTuple(acct);
    */

    public static InvoiceTestingTuple newInvoiceTestingTuple(Account acct) {
        return newInvoiceTestingTuple(1324.65, acct);
    }

    /*******************************************************************************************************************
    * @description Generate a fully populated EU_Open_Invoice__c object wrapped in a testing tuple.
    * @return an InvoiceTestingTuple setup using random values as to avoid collisions
    * @example
    * InvoiceTestingTuple invoiceLineTT = InvoiceServicesTestComponentFactory.InvoiceTestingTuple();
    */

    public static InvoiceTestingTuple newInvoiceTestingTuple() {
        return newInvoiceTestingTuple(null);
    }
}