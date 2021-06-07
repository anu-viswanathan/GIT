/**
 * Created by Gerard van Kempen on 2019-12-10.
 * 2019 (C) 4C NV, Mechelen Belgium.
 * Last modified as part of project 'IKO SFDC'.
 */

@IsTest
private class InvoiceLineTriggerTests {
    @IsTest
    static void handlingInvoiceLineForExistingInvoiceResultsInLink() {
        SharedTestComponentFactory.AccountTestingTuple accountTT = SharedTestComponentFactory.newAccountTestingTuple();
        insert accountTT.workingAccount;

        InvoiceServicesTestComponentFactory.InvoiceLineTestingTuple invoiceLineTT
                = InvoiceServicesTestComponentFactory.newInvoiceLineTestingTuple(accountTT.workingAccount);
        final String invoiceNumber = invoiceLineTT.referenceInvoiceLine.EU_Header_Invoice_Number__c;

        List<EU_Open_Invoice_Line__c> invoiceLines = new List<EU_Open_Invoice_Line__c>();
        invoiceLines.add(invoiceLineTT.workingInvoiceLine);
        System.assert(invoiceLines.size() == 1);

        List<EU_Open_Invoice__c> generatedMatchingInvoices = (new InvoiceService()).createNewInvoicesForInvoiceLines(invoiceLines);
        System.assert(generatedMatchingInvoices.size() == 1);

        insert generatedMatchingInvoices;
        EU_Open_Invoice__c refInvoice = generatedMatchingInvoices.get(0);


        Test.startTest();

        insert invoiceLines;

        EU_Open_Invoice__c retrievedInvoice = null;
        EU_Open_Invoice_Line__c retrievedInvoiceLine = null;

        try{
            retrievedInvoice = ((List<EU_Open_Invoice__c>) [
                    SELECT Id, EU_Invoice_Number__c, EU_Account__c
                    FROM EU_Open_Invoice__c
                    WHERE EU_Invoice_Number__c = :invoiceNumber
            ]).get(0);
        } catch(Exception e) {
            System.assert(false, 'failed due to SOQL query not returning correctly');
        }

        try {
            retrievedInvoiceLine = ((List<EU_Open_Invoice_Line__c>)[
                    SELECT Id, EU_Header_Invoice_Number__c, EU_Header_Account__c, EU_Open_Invoice__c
                    FROM EU_Open_Invoice_Line__c
                    WHERE EU_Header_Invoice_Number__c = :invoiceNumber
            ]).get(0);
        } catch(Exception e) {
            System.assert(false, 'failed due to SOQL query not returning correctly');
        }

        if(retrievedInvoice != null && retrievedInvoiceLine != null) {
            System.assert(retrievedInvoice.Id == refInvoice.Id);
            System.assert(retrievedInvoice.EU_Account__c == accountTT.workingAccount.Id);
            System.assert(retrievedInvoiceLine.EU_Open_Invoice__c == retrievedInvoice.Id);
        } else {
            System.assert(false, 'failed due to unexpected NULL pointers');
        }

        Test.stopTest();
    }

    @IsTest
    static void handlingInvoiceLineForNewInvoiceResultsInCreation() {
        SharedTestComponentFactory.AccountTestingTuple accountTT = SharedTestComponentFactory.newAccountTestingTuple();
        insert accountTT.workingAccount;

        InvoiceServicesTestComponentFactory.InvoiceLineTestingTuple invoiceLineTT
                = InvoiceServicesTestComponentFactory.newInvoiceLineTestingTuple(accountTT.workingAccount);
        final String invoiceNumber = invoiceLineTT.referenceInvoiceLine.EU_Header_Invoice_Number__c;

        List<EU_Open_Invoice_Line__c> invoiceLines = new List<EU_Open_Invoice_Line__c>();
        invoiceLines.add(invoiceLineTT.workingInvoiceLine);
        System.assert(invoiceLines.size() == 1);


        Test.startTest();

        insert invoiceLines;

        EU_Open_Invoice__c retrievedInvoice = null;
        EU_Open_Invoice_Line__c retrievedInvoiceLine = null;

        try{
            retrievedInvoice = ((List<EU_Open_Invoice__c>) [
                    SELECT Id, EU_Invoice_Number__c, EU_Account__c
                    FROM EU_Open_Invoice__c
                    WHERE EU_Invoice_Number__c = :invoiceNumber
            ]).get(0);
        } catch(Exception e) {
            System.assert(false, 'failed due to SOQL query not returning correctly');
        }

        try {
            retrievedInvoiceLine = ((List<EU_Open_Invoice_Line__c>)[
                    SELECT Id, EU_Header_Invoice_Number__c, EU_Header_Account__c, EU_Open_Invoice__c
                    FROM EU_Open_Invoice_Line__c
                    WHERE EU_Header_Invoice_Number__c = :invoiceNumber
            ]).get(0);
        } catch(Exception e) {
            System.assert(false, 'failed due to SOQL query not returning correctly');
        }

        if(retrievedInvoice != null && retrievedInvoiceLine != null) {
            System.assert(retrievedInvoice.EU_Account__c == accountTT.workingAccount.Id);
            System.assert(retrievedInvoiceLine.EU_Open_Invoice__c == retrievedInvoice.Id);
        } else {
            System.assert(false, 'failed due to unexpected NULL pointers');
        }

        Test.stopTest();
    }

    @IsTest
    static void closedInvoiceLineResultsInClosedInvoice() {

        SharedTestComponentFactory.AccountTestingTuple accountTT = SharedTestComponentFactory.newAccountTestingTuple();
        insert accountTT.workingAccount;

        InvoiceServicesTestComponentFactory.InvoiceLineTestingTuple invoiceLineTT = InvoiceServicesTestComponentFactory.newInvoiceLineTestingTuple(accountTT.workingAccount);
        final String invoiceNumber = invoiceLineTT.referenceInvoiceLine.EU_Header_Invoice_Number__c;

        List<EU_Open_Invoice_Line__c> invoiceLines = new List<EU_Open_Invoice_Line__c>();
        invoiceLines.add(invoiceLineTT.workingInvoiceLine);
        System.assert(invoiceLines.size() == 1);

        List<EU_Open_Invoice__c> generatedMatchingInvoices = (new InvoiceService()).createNewInvoicesForInvoiceLines(invoiceLines);
        System.assert(generatedMatchingInvoices.size() == 1);

        insert generatedMatchingInvoices;

        EU_Open_Invoice__c refInvoice = generatedMatchingInvoices.get(0);
        System.assert(refInvoice.EU_Open_Invoice__c == true);

        insert invoiceLines;

        List<EU_Open_Invoice__c> retrievedInvoices = (List<EU_Open_Invoice__c>)[
                SELECT Id, EU_Invoice_Number__c, EU_Account__c, EU_Open_Invoice__c
                FROM EU_Open_Invoice__c
                WHERE EU_Invoice_Number__c = :invoiceNumber
        ];

        List<EU_Open_Invoice_Line__c> retrievedInvoiceLines = (List<EU_Open_Invoice_Line__c>)[
                SELECT Id, EU_Header_Invoice_Number__c, EU_Header_Account__c, EU_Open_Invoice__c, EU_Header_Open_Invoice__c
                FROM EU_Open_Invoice_Line__c
                WHERE EU_Header_Invoice_Number__c = :invoiceNumber
        ];

        System.assert(retrievedInvoices.size() == 1);
        System.assert(retrievedInvoiceLines.size() == 1);

        EU_Open_Invoice__c retrievedOrder = retrievedInvoices.get(0);
        EU_Open_Invoice_Line__c retrievedOrderLinePreUpdate = retrievedInvoiceLines.get(0);

        System.assert(retrievedOrderLinePreUpdate.EU_Open_Invoice__c == retrievedOrder.Id);


        Test.startTest();

        retrievedOrderLinePreUpdate.EU_Header_Open_Invoice__c = false;
        update retrievedOrderLinePreUpdate;
        System.assert(retrievedOrderLinePreUpdate.EU_Header_Open_Invoice__c == false);

        EU_Open_Invoice__c retrievedOpenInvoicePostUpdate = ((List<EU_Open_Invoice__c>)[
                SELECT Id, EU_Invoice_Number__c, EU_Account__c, EU_Open_Invoice__c
                FROM EU_Open_Invoice__c
                WHERE EU_Invoice_Number__c = :invoiceNumber
        ]).get(0);

        System.assert(retrievedOpenInvoicePostUpdate.EU_Open_Invoice__c == false);

        Test.stopTest();
    }
}