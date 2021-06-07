/*******************************************************************
*        Name        :        IMTInvoiceServiceHelper
*        Author      :        Shivram Saini
*        Date        :        14 Feb 2018
*        Description :        Helper class for IMTInvoiceService class. This class parse invoice xml data and created invoice records.
********************************************************************/
public class IMTInvoiceServiceHelper{
    
    private string requestBody;
    private string errorBody;
    private DateTime DataLastModifiedDateUTC;
    private List<ContractorWrapper>contractors;
    
    public IMTInvoiceServiceHelper(String requestBody){
        this.requestBody = requestBody; 
        this.errorBody = '';
        contractors = new List<ContractorWrapper>();   
    }
    
    /***************
    @ Shivram Saini
    @ 14 Feb 2018
    @ Process api request and return response
    ****************/
    public string processRequest(){
        String status='';
        try{
            //Parse XML data
            parseData();
            
            //Insert Invoice and Invoice Line records
            saveInvoice();
            
            status = 'SUCCESS';
            
        }catch(Exception e){
            status = e.getMessage();
        }
        
        return prepareResponse(status);
    }
    
    /*****************
    @ Shivram Saini
    @ 8 Feb 2018
    @ This method generate response XML
    ******************/
    public string prepareResponse(String status){
        String responseBody ='';
        
        String timestamp = DateTime.now().formatGMT('yyyy-MM-dd hh:mm:ss.SSS');
        timestamp = timestamp.replace(' ','T');
        
        if(status=='SUCCESS'){
            if(errorBody==''){
                responseBody += '<Status>SUCCESS</Status>';
                responseBody += '<Timestamp>'+timestamp+'</Timestamp>';    
            }else{
                responseBody += '<Status>ERROR</Status>';
                responseBody += '<Timestamp>'+timestamp+'</Timestamp>'; 
                responseBody += errorBody;
                sendEmail(responseBody);
            }
        }else{
            responseBody += '<Status>ERROR</Status>';
            responseBody += '<Timestamp>'+timestamp+'</Timestamp>';
            responseBody += '<Error>'+status+'</Error>';
            sendEmail(responseBody);
        }
        
        return '<response>'+responseBody+'</response>';
    }
    
    
    /*****************
    @ Shivram Saini
    @ 8 Feb 2018
    @ This method parse inoice XML data 
    ******************/
    public void parseData(){
        System.debug('--------- IMTInvoiceServiceHelper parseData ---------');
        XmlStreamReader reader = new XmlStreamReader(requestBody);
        
        while(reader.hasNext()){
            
            if(reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'XML') {
                DataLastModifiedDateUTC = Utility.parseDateTimeGMT(getAttValue(reader,1,'DataLastModifiedDateUTC'));           
            }
            
            if(reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'Contractor') {
                
                //Parse contractor data
                ContractorWrapper contractor = new ContractorWrapper();
                contractor.SFContractorID = getAttValue(reader,0,'SFContractorID');
                contractor.IKOContractorID = getAttValue(reader,1,'IKOContractorID');
                contractor.SalesTerritoryID = getAttValue(reader,2,'SalesTerritoryID');
                
                while(reader.hasNext()){
                    if(reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'Invoice') {
                        //parse Invoice data
                        InvoiceWrapper invoice = new InvoiceWrapper();
                        invoice.InvoiceDate = getAttValue(reader,0,'InvoiceDate');    
                        invoice.InvoiceNumber = getAttValue(reader,1,'InvoiceNumber');
                        invoice.InvoiceAmount = getAttValue(reader,2,'InvoiceAmount');
                        invoice.RebateID = getAttValue(reader,3,'RebateID');
                        invoice.Distributor = getAttValue(reader,4,'Distributor');
                        invoice.RebateStatus = getAttValue(reader,5,'RebateStatus');
                        invoice.RebateStatusDateUTC = getAttValue(reader,6,'RebateStatusDateUTC');
                        invoice.InvoiceUploadDateUTC = getAttValue(reader,7,'InvoiceUploadDateUTC');
                        
                        while(reader.hasNext()){
                            if(reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'InvoiceLine') {
                                //Parse invoice line item data
                                InvoiceItemWrapper item = new InvoiceItemWrapper();
                                item.SKU = getAttValue(reader,0,'SKU');    
                                item.ItemDescription = getAttValue(reader,1,'ItemDescription');
                                item.Bundles = getAttValue(reader,2,'Bundles');
                                item.Dollars = getAttValue(reader,3,'Dollars');
                                item.ActualSquares = getAttValue(reader,4,'ActualSquares');
                                item.RebateSquares = getAttValue(reader,5,'RebateSquares');
                                invoice.itemList.add(item);    
                            }
                            if(reader.getEventType() == XmlTag.END_ELEMENT && reader.getLocalName() == 'Invoice') {
                                break;
                            }
                            reader.next();    
                        }
                        contractor.invoiceList.add(invoice);    
                    }
                    if(reader.getEventType() == XmlTag.END_ELEMENT && reader.getLocalName() == 'Contractor') {
                        contractors.add(contractor);
                        break;        
                    }
                    reader.next();    
                }    
            } 
            reader.next();
        } 
        System.debug(contractors);
        
    }
    
    /*********************
    @ Shivram Saini
    @ 9 Feb 2018
    @ Insert Invoice and Invoice Line records 
    *********************/
    private void saveInvoice(){
    
        Set<String> contractorId = new Set<String>();
        for(ContractorWrapper con :contractors){
            if(con.SFContractorID !=null)
                contractorId.add(con.SFContractorID);        
        }
        
        Map<String,Account> contractorMap = new Map<String,Account>([select id from account where id in:contractorId]);
        
        List<Invoice__c> invoiceListToInsert = new List<Invoice__c>();
        
        Database.SaveResult[] invoiceResults;
        Database.SaveResult[] invoiceLineResults;
        
        Set<String> invNumberSet = new Set<String>();
        Set<String> contractorSet = new Set<String>();
        Set<Date> invDateSet = new Set<Date>();
        
        
        integer counter = 0;
        for(ContractorWrapper con :contractors){
            if(con.SFContractorID !=null && contractorMap.containsKey(con.SFContractorID)){
                
                //Update Sales Territory Id in Account (Contractor)
                contractorMap.get(con.SFContractorID).Sales_Territory_ID__c = con.SalesTerritoryID;
                
                for(InvoiceWrapper invWrapper : con.invoiceList){
                    invWrapper.invoice = new Invoice__c();
                    invWrapper.invoice.Contractor__c =  con.SFContractorID;
                    invWrapper.invoice.Distributor__c =  invWrapper.Distributor;
                    invWrapper.invoice.Invoice_Amount__c =  invWrapper.InvoiceAmount !=null && invWrapper.InvoiceAmount.trim() !='' ? Decimal.valueOf(invWrapper.InvoiceAmount) : null;
                    invWrapper.invoice.Invoice_Number__c =  invWrapper.InvoiceNumber;
                    invWrapper.invoice.Rebate_ID__c =  invWrapper.RebateID;
                    invWrapper.invoice.Rebate_Status__c =  invWrapper.RebateStatus;
                    invWrapper.invoice.Invoice_Date__c = Utility.parseDate(invWrapper.InvoiceDate);
                    invWrapper.invoice.Rebate_Status_Date_UTC__c = Utility.parseDateTimeGMT(invWrapper.RebateStatusDateUTC );
                    invWrapper.invoice.Invoice_Upload_Date_UTC__c = Utility.parseDateTimeGMT(invWrapper.InvoiceUploadDateUTC);
                    invWrapper.index = counter++;
                    
                    //Fill sets to query old matching invoices
                    invNumberSet.add(invWrapper.invoice.Invoice_Number__c);
                    contractorSet.add(invWrapper.invoice.Contractor__c);
                    invDateSet.add(invWrapper.invoice.Invoice_Date__c);
                    
                    invoiceListToInsert.add(invWrapper.invoice);
                }        
            }
        }
        
        //Insert IMT Invoice Log Record
        IMT_Invoice_Log__c  log = new IMT_Invoice_Log__c(Data_Last_Modified_Date_UTC__c=DataLastModifiedDateUTC);
        Database.insert(log, false);
        
        //Update accounts
        if(contractorMap.size()>0){
            Database.update(contractorMap.values(), false);
        }
        
        //Query old matching invoices
        List<Invoice__c> existingInvoices = [select id,Contractor__c,Invoice_Number__c,Invoice_Date__c 
                                             from Invoice__c
                                             where Contractor__c in:contractorSet and Invoice_Number__c in:invNumberSet and Invoice_Date__c in:invDateSet ];
                                             
        if(invoiceListToInsert.size()>0){
            
            //Insert new Invoices
            invoiceResults = Database.insert(invoiceListToInsert, false);

            counter = 0;
            List<Invoice_Line__c> invoiceLinesToInsert = new List<Invoice_Line__c>();
            for(ContractorWrapper con :contractors){
                if(con.SFContractorID !=null && contractorMap.containsKey(con.SFContractorID)){
                    for(InvoiceWrapper invWrapper : con.invoiceList){
                        if(invWrapper.invoice !=null && invWrapper.invoice.id !=null){
                            for(InvoiceItemWrapper itemWrapper :invWrapper.itemList){
                                itemWrapper.invoiceLine = new Invoice_Line__c();
                                itemWrapper.invoiceLine.Invoice__c =  invWrapper.invoice.Id;
                                itemWrapper.invoiceLine.Bundles__c =  itemWrapper.Bundles !=null && itemWrapper.Bundles.trim() !='' ? Decimal.valueOf(itemWrapper.Bundles) : null; 
                                itemWrapper.invoiceLine.Dollars__c =  itemWrapper.Dollars !=null && itemWrapper.Dollars.trim() !='' ? Decimal.valueOf(itemWrapper.Dollars) : null;
                                itemWrapper.invoiceLine.ActualSquares__c =  itemWrapper.ActualSquares !=null && itemWrapper.ActualSquares.trim() !='' ? Decimal.valueOf(itemWrapper.ActualSquares) : null;
                                itemWrapper.invoiceLine.RebateSquares__c =  itemWrapper.RebateSquares !=null && itemWrapper.RebateSquares.trim() !='' ? Decimal.valueOf(itemWrapper.RebateSquares) : null;
                                itemWrapper.invoiceLine.Item_Description__c =  itemWrapper.ItemDescription;
                                itemWrapper.invoiceLine.SKU__c =  itemWrapper.SKU;
                                itemWrapper.index = counter++;
                                
                                invoiceLinesToInsert.add(itemWrapper.invoiceLine);
                            }    
                        }
                    }        
                }
                    
            }
            
            if(invoiceLinesToInsert.size()>0){
                //Insert new Invoices line items
                invoiceLineResults = Database.insert(invoiceLinesToInsert, false);
            }
        }
        
        
        Set<String> existingInvoiceKeys = new Set<String>();
        List<Invoice__c> invoiceToDelete = new List<Invoice__c>();
        
        //Prepare response
        for(ContractorWrapper con :contractors){
            String invXML='';
            for(InvoiceWrapper invWrapper : con.invoiceList){
                String error='';
                if(invWrapper.invoice==null){
                    error = 'Invalid SFContractorID';    
                }else if(invWrapper.invoice.id==null){
                    error = invoiceResults[invWrapper.index].getErrors()[0].getMessage();
                }else{
                    for(InvoiceItemWrapper line : invWrapper.itemList){
                        if(line.invoiceLine.id==null){
                            //Delete new created invoice if realted invoice line is not inserted.
                            invoiceToDelete.add(invWrapper.invoice);
                            error = invoiceLineResults[line.index].getErrors()[0].getMessage(); 
                            break;   
                        }
                    }    
                }
                if(error !=''){
                    invXML +=  createInvioceXML(invWrapper,error);   
                }else{
                    
                    //Invoice has been Created Successfully
                    existingInvoiceKeys.add(invWrapper.invoice.Contractor__c + '-' + invWrapper.invoice.Invoice_Number__c + '-' + invWrapper.invoice.Invoice_Date__c);
                }        
            }
            if(invXML !=''){
                errorBody += '<Contractor SFContractorID="'+con.SFContractorID+'" IKOContractorID="'+con.IKOContractorID+'" SalesTerritoryID="'+con.SalesTerritoryID+'">'+invXML+'</Contractor>';    
            }    
        }
        
        //Delete Existing matching invoices
        for(Invoice__c inv:existingInvoices ){
            String key = inv.Contractor__c +'-'+inv.Invoice_Number__c +'-'+inv.Invoice_Date__c ;
            if(existingInvoiceKeys.contains(key)){
                invoiceToDelete.add(inv);    
            }
        }
        if(invoiceToDelete.size()>0)
            delete invoiceToDelete;
                    
    }
    
    /*********************
    @ Shivram Saini
    @ 15 Feb 2018
    @ Send Emails to Admins if Error occured while processing invoices
    *********************/
    public void sendEmail(String responseBody){
        List<user> usersToNotify = [select id,FirstName,email from user where profile.name='System Administrator' or profile.name='IKOPRO Loyalty Admin' ]; //id='00536000004NMtl'
        responseBody = '<response>'+responseBody+'</response>';
        responseBody = responseBody.replace('><','>\n<');
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setFileName('Response.txt');
        attach.setBody(blob.valueOf(responseBody));
        
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for(user u:usersToNotify){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('IMT Invoice Error Log');
            String htmlBody = 'Hi '+u.FirstName+'<br/><br/>Please find attached error log for IMT Invoices.<br/><br/>Thanks';
            email.setHTMLBody(htmlBody);
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
            email.setTargetObjectId(u.Id);
            email.setSaveAsActivity(false);
            emailList.add(email);
        }
        
        Messaging.sendEmail(emailList);
    }
    
    
    /*********************
    @ Shivram Saini
    @ 15 Feb 2018
    @ Create Invoice XML with error
    *********************/
    private string createInvioceXML(InvoiceWrapper invWrapper,String error){
        String invXML = '';
        invXML += '<Invoice InvoiceDate="'+invWrapper.InvoiceDate+'" InvoiceNumber="'+invWrapper.InvoiceNumber+'" InvoiceAmount="'+invWrapper.InvoiceAmount+'" RebateID="'+invWrapper.RebateID+'" Distributor="'+invWrapper.Distributor+'" RebateStatus="'+invWrapper.RebateStatus+'" RebateStatusDateUTC="'+invWrapper.RebateStatusDateUTC+'" InvoiceUploadDateUTC="'+invWrapper.InvoiceUploadDateUTC+'">';
        for(InvoiceItemWrapper line : invWrapper.itemList){
            invXML += '<InvoiceLine SKU="'+line.SKU+'" ItemDescription="'+line.ItemDescription+'" Bundles="'+line.Bundles+'" Dollars="'+line.Dollars+'" ActualSquares="'+line.ActualSquares+'" RebateSquares="'+line.RebateSquares+'"/>';
        }
        invXML += '<Error>'+error+'</Error>';
        invXML += '</Invoice>';
        return invXML;            
    }
    
    /*********************
    @ Shivram Saini
    @ 8 Feb 2018
    @ Get attribute value from XML node
    *********************/
    private string getAttValue(XmlStreamReader reader,integer index,String attName){
        if(reader.getAttributeLocalName(index) == attName){
            return reader.getAttributeValueAt(index); 
        }
        return null;    
    }
    

    /*********************
    @ Shivram Saini
    @ 8 Feb 2018
    @ Wrapper class for contractor
    *********************/
    public class ContractorWrapper{
        public string SFContractorID;
        public string IKOContractorID;
        public string SalesTerritoryID;
        
        public List<InvoiceWrapper> invoiceList;
        public ContractorWrapper(){
            invoiceList = new List<InvoiceWrapper>();    
        }
    }
    
    
    
    /*********************
    @ Shivram Saini
    @ 8 Feb 2018
    @ Wrapper class for invoice
    *********************/
    public class InvoiceWrapper{
        public Invoice__c invoice;
        
        public integer index;
        
        public string InvoiceDate;
        public string InvoiceNumber;
        public string InvoiceAmount;
        public string RebateID;
        public string Distributor;
        public string RebateStatus;
        public string RebateStatusDateUTC ;
        public string InvoiceUploadDateUTC;
        
        public List<InvoiceItemWrapper> itemList; 
        public InvoiceWrapper(){
            itemList = new List<InvoiceItemWrapper>();    
        } 
    }
    
    
    
    /*********************
    @ Shivram Saini
    @ 8 Feb 2018
    @ Wrapper class for invoice line item
    *********************/
    public class InvoiceItemWrapper{
        public Invoice_Line__c invoiceLine;
        public string SKU;
        public string ItemDescription;
        public string Dollars;
        public string Bundles;
        public string ActualSquares;
        public string RebateSquares;
        
        public integer index;
    }    
}