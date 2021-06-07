public class intelReportEmailController {
    Static public String emailVisualForce { get; set; }
    Static public void getEmailBodyPreview()
    {
        system.debug('Get userinfo');
        ID currentUserID = UserInfo.getUserId();
        system.debug('Get userinfo');
        String IntelUserName = UserInfo.getName();
        //get Manager's name in the roll hierarchy
        system.debug('Get manager');
        ID ManagerId = [Select ManagerId from User where ID =:currentUserID][0].ManagerId;
        String ManagerName;
        If(ManagerId != null)
        {
            ManagerName = [Select Name from User where ID =:ManagerId][0].Name;    
        }
        else
        {
            ManagerName = '--';
        }
        
        
        ID IntelRecordID = ApexPages.currentPage().getParameters().get('IRId');
        //get Record type ID 
        ID RecordTypeId = [Select RecordTypeId from Intelligence_Report__c where ID= :IntelRecordID].get(0).RecordTypeId; 
        //emailVisualForce=getEmailBody('hello', 'world', null, 'a01f0000006pVxDAAU', False, 'Full',null,null);
        intelEmailRecordType__mdt intelEmailRecordType = [Select label from intelEmailRecordType__mdt where RecordTypeId__c=:RecordTypeId][0];//'012f0000000FKLP'
        //compare against them
        //get the RecordTypename
        String recordTypeName = intelEmailRecordType.label;
        
        if(recordTypeName == 'Product Issues Report' )
        {
            system.debug('Its a product Issues report');
            emailVisualForce=getEmailBody(IntelUserName,
                                          ManagerName,
                                          null,
                                          IntelRecordID,
                                          False,
                                          'Product Issues',
                                          null,
                                          null);
        }else{
            emailVisualForce=getEmailBody(IntelUserName,
                                          ManagerName,
                                          null,
                                          IntelRecordID,
                                          False,
                                          'Full',
                                          null,
                                          null);    
        }
        
    }
    Static public String getEmailBody(String ReportFrom, String ReportTo, Id intelReportUser,Id intelligenceReport, Boolean send, String EmailType,List<String> addresses, String subject)
    {
        String emailBody ='';
        MAP<String,List<String>> mapEmailSections = new MAP<String,List<String>>();
        
        //add Report From and Report to 
        emailBody += '<p><strong><big>IKO Intelligence Reports</big></strong></p>';
        emailBody += '<p><strong>'+EmailType+' Intel Report</strong></p><br><br>';
        emailBody += '<p><strong>Submitted By: </strong>'+ReportFrom+'';
        emailBody += '<p><strong>Reports To: </strong>'+ReportTo+'</p><br><br>';
         
        
        // get all the Intelligence_Report_Line_Item__c of the Intelligence_Report__c ID to be considered for fetching the Attachments
        // Attachment of the Intelligence report is considered aswell
        List<ID> listIntelligenceReportsLineItemIDs = new List<ID>{intelligenceReport};
        //Can Fetch the list of sections in different Metadata Types in some custom meta data or ...
        //no filtering on EmailType 'Full'
        if(EmailType=='Full')
        {
            system.debug('Its a full email type');
            for (Intelligence_Report_Line_Item__c iRLI : [Select Id,Details__c,Type__c
                                                          From Intelligence_Report_Line_Item__c 
                                                          where Intelligence_Report__c=:intelligenceReport])
            {
                List<String> sections= new List<String>(mapEmailSections.get(iRLI.Type__c));
                sections.add(iRLI.Details__c);
                
                mapEmailSections.put(iRLI.Type__c,sections);
                listIntelligenceReportsLineItemIDs.add(iRLI.Id);
            }
        }else if(EmailType=='Residential Product')
        {
            system.debug('Its a Residential Product email type');
            
            List<String> AllowedTypes = new List<String>();
            For (intelEmailResidential__mdt iER : [ Select label from intelEmailResidential__mdt] )
            {
                AllowedTypes.add(iER.label);
            }
            system.debug(AllowedTypes);
            for (Intelligence_Report_Line_Item__c iRLI : [Select Id,Details__c,Type__c
                                                          From Intelligence_Report_Line_Item__c 
                                                          where Intelligence_Report__c=:intelligenceReport and Type__c IN :AllowedTypes])
            {
                List<String> sections= new List<String>(mapEmailSections.get(iRLI.Type__c));
                sections.add(iRLI.Details__c);
                mapEmailSections.put(iRLI.Type__c,sections);
                listIntelligenceReportsLineItemIDs.add(iRLI.Id);
            }
        }else if(EmailType=='Commercial Product')
        {
            system.debug('Its a Commercial Product email type');
            List<String> AllowedTypes = new List<String>();
            For (intelEmailCommercial__mdt iEC : [ Select label from intelEmailCommercial__mdt] )
            {
                system.debug(iEC);
                system.debug(iEC.label);
                AllowedTypes.add(iEC.label);
            }
            
            for (Intelligence_Report_Line_Item__c iRLI : [Select Id,Details__c,Type__c
                                                          From Intelligence_Report_Line_Item__c 
                                                          where Intelligence_Report__c=:intelligenceReport and Type__c IN :AllowedTypes])
            {
                List<String> sections= new List<String>(mapEmailSections.get(iRLI.Type__c));
                sections.add(iRLI.Details__c);
                mapEmailSections.put(iRLI.Type__c,sections);
                listIntelligenceReportsLineItemIDs.add(iRLI.Id);
            }
        }else if(EmailType=='Product Issues')
        {
            system.debug('Its a Product Issues email type');
            Intelligence_Report__c IR =[Select ID , Producing_Plant__c, Product__c ,Colour__c, Category__c, Description__c, Run_Tape_Code__c
                                        From Intelligence_Report__c
                                        Where ID = : intelligenceReport].get(0);
            mapEmailSections.put('Producing Plant',new List<String>{IR.Producing_Plant__c});
            mapEmailSections.put('Run number or Tape Code',new List<String>{IR.Run_Tape_Code__c});
            mapEmailSections.put('Product',new List<String>{IR.Product__c});                                 
            mapEmailSections.put('Colour ',new List<String>{IR.Colour__c});                                 
            mapEmailSections.put('Category',new List<String>{IR.Category__c});
            mapEmailSections.put('Description',new List<String>{IR.Description__c});              
        }
        system.debug('done with metadata');
        
        List<String> emailSections = new List<String>(mapEmailSections.keySet());
        if(emailSections.size()==0)
        {
            return null;
        }
        Boolean Attachments = False;
        List<ID> conVersions = new List<ID>();
        
        if (EmailType == 'Product Issues')
        {
            for( String section: emailSections)
            {
                emailBody += '<strong>'+section+':</strong>';
                
                for (String description : mapEmailSections.get(section))
                {
                    emailBody+=description+';';
                }
                emailBody +='<br>';
            }
        }else
        {
            for( String section: emailSections)
            {
                emailBody += '<p><strong>'+section+':</strong></p>';
                emailBody += '<ul>';
                for (String description : mapEmailSections.get(section))
                {
                    emailBody+='<li>'+description+'</li>';
                }
                emailBody +='</ul><br>';
                //use section name to get the content documents titles, ..
            }
        }
            
        //get IDs of Content Documents and versions
        List<ID> listContentDocumentIDs = new List<ID>();
        for (ContentDocumentLink cdl : [Select  Id, LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId IN :listIntelligenceReportsLineItemIDs])
        {
            listContentDocumentIDs.add(cdl.ContentDocumentId);
        }
        
        Map <Id,ContentDocumentLink> mapContentDocumentLinks = new Map <Id,ContentDocumentLink>([Select  Id, LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId IN :listIntelligenceReportsLineItemIDs]);
        
        
        for (ContentVersion cv: [select ID from ContentVersion where ContentDocumentId IN :listContentDocumentIDs])
        {
            conVersions.add(cv.Id);
        }
        
        system.debug('List of document IDs');
        system.debug(listContentDocumentIDs);
        
        //get size of the Content Documents
        List<ContentDocument> listContentDocuments= new List<ContentDocument>([Select Id, ContentSize, Title,FileType 
                                                                               From ContentDocument 
                                                                               WHERE Id in :listContentDocumentIDs]);
        //system.debug('List of Content Documents');
        //system.debug(listContentDocuments);
        //get total size of the documents
        Decimal totalAttachmentSizeMB= 0;
        for (ContentDocument cd : listContentDocuments)
        {
            totalAttachmentSizeMB += (Integer)cd.get('ContentSize')/math.pow(10,6); 
        }
        
        //if larger than 3MB append get links of each of the objects and store them and append them into the string 
        // should make this a config variable
         //Below conditions were changed by VL dd. 14 Nov 2018: Change from "3" to "100", so attachments would never be transformed into Salesforce links, but (default behaviour) into content delivery links
          //Content Delivery can be accessed also by non-Salesforce users. They receive a link that - when clicked on - lets them view attachments and download them without having to login to Salesforce. 
        
        if(totalAttachmentSizeMB > 0)
        {
            if (totalAttachmentSizeMB < 100)
            {
                //this message should be a lable to be translated
                Attachments= True;
                emailBody += '<p>Please check the attachments<p><br><ul>';
                for (ContentDocument contentdoc: listContentDocuments)
                {   
                    emailBody += '<li><strong>Attachment:</strong>'+ contentdoc.Title+'.'+contentdoc.FileType.toLowerCase()+'</li>';
                }
                emailBody += '</ul>';
            }
            else
            {
                emailBody += '<p>Attachments are Larger than 3MB <p><br><ul>';
                for (ContentDocument contentdoc: listContentDocuments)
                {   
                    emailBody += '<li><strong>Attachment:</strong><a href="'+ URL.getSalesforceBaseUrl().toExternalForm() +'/' + contentdoc.Id+'">'+contentdoc.Id+'</a></li>';
                }
                emailBody += '</ul>';
            }
        }
        
        //If In preview mode
        if(send == False)
        {
            return emailBody;
        }
        else
        {
            system.debug('creating email class');
            Messaging.SingleEmailMessage [] emails = new Messaging.SingleEmailMessage[]{};
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject(subject);
            if(addresses.size()==0)
            {
                throw new intelReportEmailException('There are no recipients for "'+ subject +'" email');
            }
            email.setToAddresses(addresses );
            If (Attachments)
            {
                email.setEntityAttachments(conVersions);
            }
            email.setHtmlBody(emailBody);
            emails.add(email);
            if(Test.isRunningTest()){
                system.debug('@test: returning email body');
                return (emailBody);
            }
            Messaging.SendEmailResult[] emailresults = Messaging.sendEmail(emails);
            if (emailresults[0].success) {
                //Create an Intelligence_Report_History__c 
                {
                    insert new Intelligence_Report_History__c(Email_Recipients__c=string.join(addresses,','),Email_Subject__c = subject, Email_Body__c = emailBody, Intelligence_Report__c = intelligenceReport);
                }
                return('The email was sent successfully.');
            } else {
                return ('The email failed to send: '
                      + emailresults[0].errors[0].message);
            }            
        }
    }
    
}