/**
 * Created by Gerard van Kempen on 2019-12-20.
 * 2019 (C) 4C NV, Mechelen Belgium.
 */

@IsTest
private class CleanupSchedulable_EuOpenInvoice_Test {
    @IsTest
    static void cleanupForFourWithOneMatchingResultsInThreeRemaining() {
        SharedTestComponentFactory.AccountTestingTuple accountTT = SharedTestComponentFactory.newAccountTestingTuple();
        insert accountTT.workingAccount;

        InvoiceServicesTestComponentFactory.InvoiceTestingTuple invoiceTT_1 = InvoiceServicesTestComponentFactory.newInvoiceTestingTuple(accountTT.workingAccount);
        InvoiceServicesTestComponentFactory.InvoiceTestingTuple invoiceTT_2 = InvoiceServicesTestComponentFactory.newInvoiceTestingTuple(accountTT.workingAccount);
        InvoiceServicesTestComponentFactory.InvoiceTestingTuple invoiceTT_3 = InvoiceServicesTestComponentFactory.newInvoiceTestingTuple(accountTT.workingAccount);
        InvoiceServicesTestComponentFactory.InvoiceTestingTuple invoiceTT_4 = InvoiceServicesTestComponentFactory.newInvoiceTestingTuple(accountTT.workingAccount);

        List<EU_Open_Invoice__c> invoicesToInsert = new List<EU_Open_Invoice__c>();
        List<String> invoiceNumbers = new List<String>();

        EU_Open_Invoice__c invoice_1_shouldStay = invoiceTT_1.workingInvoice;
        invoice_1_shouldStay.EU_Open_Invoice__c = false;
        invoice_1_shouldStay.CreatedDate = Datetime.now().addDays(-1);
        invoicesToInsert.add(invoice_1_shouldStay);
        invoiceNumbers.add(invoice_1_shouldStay.EU_Invoice_Number__c);

        EU_Open_Invoice__c invoice_2_shouldStay = invoiceTT_2.workingInvoice;
        invoice_2_shouldStay.EU_Open_Invoice__c = false;
        invoice_2_shouldStay.CreatedDate = Datetime.now().addMonths(-48).addDays(-1);
        invoicesToInsert.add(invoice_2_shouldStay);
        invoiceNumbers.add(invoice_2_shouldStay.EU_Invoice_Number__c);

        EU_Open_Invoice__c invoice_3_shouldStay = invoiceTT_3.workingInvoice;
        invoice_3_shouldStay.EU_Open_Invoice__c = true;
        invoice_3_shouldStay.CreatedDate = Datetime.now().addDays(-1);
        invoicesToInsert.add(invoice_3_shouldStay);
        invoiceNumbers.add(invoice_3_shouldStay.EU_Invoice_Number__c);

        EU_Open_Invoice__c invoice_4_shouldGo = invoiceTT_4.workingInvoice;
        invoice_4_shouldGo.EU_Open_Invoice__c = true;
        invoice_4_shouldGo.CreatedDate = Datetime.now().addMonths(-48).addDays(-1);
        invoicesToInsert.add(invoice_4_shouldGo);
        invoiceNumbers.add(invoice_4_shouldGo.EU_Invoice_Number__c);

        insert invoicesToInsert;


        Test.startTest();

        CleanupSchedulable_EuOpenInvoice.schedule();
        (new CleanupSchedulable_EuOpenInvoice()).execute(null);

        Test.stopTest();

        List<EU_Open_Invoice__c> retrievedInvoices = [
                SELECT Id, EU_Invoice_Number__c, EU_Open_Invoice__c, LastModifiedDate
                FROM EU_Open_Invoice__c
                WHERE EU_Invoice_Number__c IN :invoiceNumbers
        ];

        // All records flagged as false will be deleted because we can't alter the lastmodifieddate
        System.assertEquals(retrievedInvoices.size(), 2);

        Boolean invoiceTT_4_deleted = true;
        for(EU_Open_Invoice__c invoice : retrievedInvoices) {
            if(invoice.EU_Invoice_Number__c == invoiceTT_4.referenceInvoice.EU_Invoice_Number__c) {
                invoiceTT_4_deleted = false;
            }
        }

        System.assert(invoiceTT_4_deleted);
    }
}