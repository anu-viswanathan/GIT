/*******************************************************************
*        Name        :        IMTInvoiceService
*        Author      :        Shivram Saini
*        Date        :        8 Feb 2018
*        Description :        Web service to receive contractor , invoice and invoice line items
********************************************************************/
@RestResource(urlMapping='/imtinvoice/*')
global class IMTInvoiceService{
    
    
    /***************
    @ Shivram Saini
    @ 8 Feb 2018
    @ POST method
    *****************/
    @HttpPost
    global static string doPost() {
        System.debug('--------- IMTInvoiceService doPost ---------');
        //Get request body (XML)
        String reqBody = RestContext.request.requestBody.toString();
        
        IMTInvoiceServiceHelper helper = new IMTInvoiceServiceHelper(reqBody);
        String res = helper.processRequest();
        System.debug('---------response---------'+res);
        return res;
    }
    
    
}