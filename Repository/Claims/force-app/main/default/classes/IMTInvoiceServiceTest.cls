/**********************************************************************
*        Name        :        IMTInvoiceServiceTest
*        Author      :        Shivram Saini
*        Date        :        12 Feb 2018
*        Description :        Test class for IMTInvoiceService class
***********************************************************************/
@isTest
public class IMTInvoiceServiceTest{
    
    /***************
    @ Shivram
    @ 12 Feb 2018
    @ Created this test method to verify invoice is created with valid xml
    ****************/
    @isTest
    private static void testValid(){
        
        // Insert account record
        // 2019-08-27
        // Billing postal code was updated below to be only five digits long. This meets requirements for a US postal code.
        // It was formerly six digits -- Skooter
        Account contractor = new Account(Name='Test Contractor',
                                         Type='Contractor',
                                         recordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId(),
                                         BillingStreet = 'test',
                                         BillingCity = '123 test',
                                         BillingState = 'Pennsylvania',
                                         BillingCountry='United States',
                                         BillingPostalCode='12345',
                                         Phone='1234567890',
                                         Customer_Type__c='Customer'
                                         );
        insert contractor;
        
        //Create XML request body
        String requestBody = '<XML Version="Version 1.0" DataLastModifiedDateUTC="2018-02-06T15:00:01.090">' +
                                 '<Contractor SFContractorID="'+contractor.Id+'" IKOContractorID="IKO678708" SalesTerritoryID="60311">' +
                                     '<Invoice InvoiceDate="2017-01-01" InvoiceNumber="REB340233 - E3L" InvoiceAmount="0.0" RebateID="2017USAPRO4PLUS" Distributor="ABC SUP-FORT MYERS #217" RebateStatus="Approved" RebateStatusDateUTC="2018-01-04T11:52:27.420" InvoiceUploadDateUTC="2018-01-04T11:52:27.420">'+
                                         '<InvoiceLine SKU="4220062" ItemDescription="CAM AR Dual Grey Shingles" Bundles="12.0000" Dollars="0.0" />'+
                                     '</Invoice>'+
                                 '</Contractor>' +
                             '</XML>';
                             
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/imtinvoice';  //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(requestBody);
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        
        //Call web service class
        IMTInvoiceService.doPost();
        
        Test.stopTest();
        
        //Asert to verify invoice in inserted
        //System.assertEquals(1,[select id from invoice__c where contractor__c=:contractor.Id].size());
    
    }
    
    
    /***************
    @ Shivram
    @ 12 Feb 2018
    @ Created this test method to verify error response for invalid SFContractorID
    ****************/
    @isTest
    private static void testInValidContractor(){
        //Create XML request body
        String requestBody = '<XML Version="Version 1.0" DataLastModifiedDateUTC="2018-02-06T15:00:01.090">' +
                                 '<Contractor SFContractorID="123454645" IKOContractorID="IKO678708" SalesTerritoryID="60311">' +
                                     '<Invoice InvoiceDate="2017-01-01" InvoiceNumber="REB340233 - E3L" InvoiceAmount="0.0" RebateID="2017USAPRO4PLUS" Distributor="ABC SUP-FORT MYERS #217" RebateStatus="Approved" RebateStatusDateUTC="2018-01-04T11:52:27.420" InvoiceUploadDateUTC="2018-01-04T11:52:27.420">'+
                                         '<InvoiceLine SKU="4220062" ItemDescription="CAM AR Dual Grey Shingles" Bundles="12.0000" Dollars="0.0" />'+
                                     '</Invoice>'+
                                 '</Contractor>' +
                             '</XML>';
                             
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/imtinvoice';  //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(requestBody);
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        
        //Call web service class
        String response = IMTInvoiceService.doPost();
        
        Test.stopTest();
        
        //Asert to verify invoice in inserted
        System.assertEquals(true,response.contains('Invalid SFContractorID'));
    
    }
}