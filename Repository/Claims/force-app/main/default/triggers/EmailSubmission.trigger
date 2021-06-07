trigger EmailSubmission on Intelligence_Report__c (before update) {
	
    // loop over each of the individuall in Trigger.New
	for(Intelligence_Report__c IR : Trigger.New) {
    //check if the status is submitted
        If(IR.Status__c != 'Submitted')
        {
            //if not break
            continue;
        }
    //assign a Intel report User
        //get current salesforce user// there is a look up on the Intel report user
        ID currentUserID = UserInfo.getUserId();
        String IntelUserName = UserInfo.getName();
        //get Manager's name in the roll hierarchy
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
        
        List<Intel_Report_User__c> IRUs = [select ID , Email_Address__c
                                    From Intel_Report_User__c 
                                    Where  IKO_User__c= :currentUserID];
        if(IRUs.size() == 0)
        {
            system.debug('There is an issue with your Intelligence Report user configuration, please contact your administrator');
            throw new intelReportEmailException('There is an issue with your Intelligence Report user configuration, please contact your administrator');
        }
        Intel_Report_User__c IRU = IRUs.get(0);
        //already in the trigger of Intel report 
        //assign the Intel report user to the record 
        IR.Intel_Report_User__c = IRU.ID;
    //Get the RecordTypeId of the Intelligence report
        Id RecordTypeId  = IR.RecordTypeId;
        //need a custom setting to compare against them
        //query the custom metadatatypes Name and IDs
        intelEmailRecordType__mdt intelEmailRecordType = [Select label 
                                                          From intelEmailRecordType__mdt 
                                                          Where RecordTypeId__c=:RecordTypeId][0];//'012f0000000FKLP'
        //compare against them
        //get the RecordTypename
        String recordTypeName = intelEmailRecordType.label;
        String EmailContent;
        system.debug('Send email to Sales Org hierarchy - based on submitter');
        //query for all of the roles of a Intel report user
        Set<ID> iRLidsSet = new Set<ID>();
        for(Intel_Report_Users_by_Role__c iRUR : [Select Intel_Report_Role__r.ID 
                                                  From Intel_Report_Users_by_Role__c
                                                  Where Intel_Report_User__c=:IRU.ID])
        {
            iRLidsSet.add(iRUR.Intel_Report_Role__r.ID);
        }
        system.debug('all of the roles of a Intel report user');
        system.debug(iRLidsSet);
        List<ID> currentTemp = new List<ID>(iRLidsSet);
        List<ID> parentTemp = new List<ID>();
        //user roles of the user to get all the 10 roles above
        for(Integer i=0; i<10; i++)
        {
            //get parent roles of each role
            for(Intel_Report_Role__c iRR : [SELECT Parent_Role__c
                                            FROM Intel_Report_Role__c
                                            Where Id IN :currentTemp])
            {
                parentTemp.add(iRR.Parent_Role__c);
            }
            //Break the loop if no more parents exist
            If(parentTemp.size() == 0)
            {
                break;
            }
            //clear the Parrent List and add Temp to the role IDs 
            iRLidsSet.addAll(currentTemp);
            currentTemp.clear();
            currentTemp.addAll(parentTemp);
            parentTemp.clear();
        }
        List<ID> iRLidsList = new List<ID>(iRLidsSet);
        //get a list of users with role of manager on the "Intel Report User by Role"
        Set<String> FullEmailDistributionSet = new Set<String>();
        For (Intel_Report_Users_by_Role__c iRUR : [Select Intel_Report_User__r.Email_Address__c
                                                   From Intel_Report_Users_by_Role__c
                                                   Where Intel_Report_Role__c IN :iRLidsList and Role_Type__c = 'Manager'])
        {
            FullEmailDistributionSet.add(iRUR.Intel_Report_User__r.Email_Address__c);
        }
        //add the user herself to the email list
        FullEmailDistributionSet.add(IRU.Email_Address__c);
        //assumption: we dont care if managers have multiple roles
        system.debug('FullEmailDistributionSet is:');
        system.debug(FullEmailDistributionSet);
        //get full email
        
        EmailContent = intelReportEmailController.getEmailBody(IntelUserName,
                                                               ManagerName,
                                                               currentUserID,
                                                               IR.Id,
                                                               True,
                                                               recordTypeName == 'Product Issues Report' ? 'Product Issues':'Full',
                                                               new List<String>(FullEmailDistributionSet),
                                                               recordTypeName == 'Product Issues Report' ? 'IKO Intelligence Reports - Product Issues Report - Submitted by '+UserInfo.getUserEmail():'IKO Intelligence Reports - Full Intel Report - Submitted by '+UserInfo.getUserEmail());
        system.debug('Email COntent for product intel report is :'+ EmailContent);
    //Branching Starts here
    	//Is the record type Name "Product Issues Report"
    	If (recordTypeName == 'Product Issues Report')
        {
            system.debug('Its a product Issue report');
            Set<String> productIssueEmailDistributionSet = new Set<String>();
            //Remove
            If(IR.Report_Type__c == 'Commercial')
                {
                    //it is commercial
                    for(Intel_Report_Users_by_Role__c IRUR :[Select Intel_Report_User__r.Email_Address__c
                                                             From Intel_Report_Users_by_Role__c
                                                             Where Intel_Report_Role__r.Name = 'Commercial Product Manager'])
                    {
                        productIssueEmailDistributionSet.add(IRUR.Intel_Report_User__r.Email_Address__c);
                    }
                    productIssueEmailDistributionSet.add(IRU.Email_Address__c);
                    //send email Commercial Product Manager
                    EmailContent = intelReportEmailController.getEmailBody(IntelUserName,
                                                                                  ManagerName,
                                                                                  currentUserID,
                                                                                  IR.Id,
                                                                                  True,
                                                                                  'Product Issues',
                                                                                  new List<String>(productIssueEmailDistributionSet),
                                                                                  'IKO Intelligence Reports - Commercial Product Issues Report - Submitted by '+UserInfo.getUserEmail());
                    system.debug('Email recipients are:');
                    system.debug(productIssueEmailDistributionSet);
                    system.debug('Email COntent is :' );
                    system.debug(EmailContent);
                }
                else if(IR.Report_Type__c == 'Residential')
                {
                    //It is residential
                    system.debug('It is a residential');
                    //Is the region states or canada
                    
                    system.debug('Getting US residential product managers');
                    for(Intel_Report_Users_by_Role__c IRUR :[Select Intel_Report_User__r.Email_Address__c
                                                             From Intel_Report_Users_by_Role__c
                                                             Where Intel_Report_Role__r.Name = 'Residential Product Manager'])
                    {
                        productIssueEmailDistributionSet.add(IRUR.Intel_Report_User__r.Email_Address__c);
                    }
                    productIssueEmailDistributionSet.add(IRU.Email_Address__c);
                    system.debug('List of all Email receivers');
                    system.debug(productIssueEmailDistributionSet);
                    //send email Residential Product Manager
                    EmailContent = intelReportEmailController.getEmailBody(IntelUserName,
                                                                                  ManagerName,
                                                                                  currentUserID,
                                                                                  IR.Id,
                                                                                  True,
                                                                                  'Product Issues',
                                                                                  new List<String>(productIssueEmailDistributionSet),
                                                                                  'IKO Intelligence Reports - Residential Product Issues Report - Submitted by '+UserInfo.getUserEmail());
                    system.debug('Email Content is :'+ EmailContent);
                }
            
        }
        else
        {
            system.debug('Its not a Product Issue report');
    		//NO : It is not a product Issues report
    		system.debug('Product information is available');
            Set<String> productEmailDistributionSet = new Set<String>();
            List<String> productEmailDistributionList;
            if(IR.Report_Type__c == 'Residential')
            {
                //Yes It is residential	
                //get email of "Intel Report users" from "User roles" that have their "Intel report role" as "Regional Manufacturing Managers"
                for (Intel_Report_Users_by_Role__c intelUserRole : [Select Intel_Report_User__r.Email_Address__c
                                                                    From Intel_Report_Users_by_Role__c
                                                                    Where Intel_Report_Role__r.Name In ('Regional Manufacturing Manager')])
                {
                    productEmailDistributionSet.add(intelUserRole.Intel_Report_User__r.Email_Address__c);
                }
                productEmailDistributionSet.add(IRU.Email_Address__c);
                productEmailDistributionList = new List<String>(productEmailDistributionSet);
                system.debug('email distribution list:');
                system.debug(productEmailDistributionList);
                EmailContent = intelReportEmailController.getEmailBody(IntelUserName,
                                                                       ManagerName,
                                                                       currentUserID,
                                                                       IR.Id,
                                                                       True,
                                                                       'Residential Product',
                                                                       new List<String>(productEmailDistributionList),
                                                                       'IKO Intelligence Reports - Residential Product Intel Report - Submitted by '+UserInfo.getUserEmail());
                system.debug('Email Content is :'+ EmailContent);                                
            }else
            {
                //No It is Regional Manufacturing
                //get email of "Intel Report users" from "User roles" that have their "Intel report role" as "Commercial Manufacturing Managers"
                for (Intel_Report_Users_by_Role__c intelUserRole : [Select Intel_Report_User__r.Email_Address__c
                                                                    From Intel_Report_Users_by_Role__c
                                                                    Where Intel_Report_Role__r.Name In ('Regional Manufacturing Manager','Commercial Manufacturing Manager')])
                {
                    productEmailDistributionSet.add(intelUserRole.Intel_Report_User__r.Email_Address__c);
                }
                productEmailDistributionSet.add(IRU.Email_Address__c);
                productEmailDistributionList = new List<String>(productEmailDistributionSet);
                system.debug('email distribution list:');
                system.debug(productEmailDistributionList);
                EmailContent = intelReportEmailController.getEmailBody(IntelUserName,
                                                                       ManagerName,
                                                                       currentUserID,
                                                                       IR.Id,
                                                                       True,
                                                                       'Commercial Product',
                                                                       new List<String>(productEmailDistributionList),
                                                                       'IKO Intelligence Reports - Commercial Product Intel Report - Submitted by '+UserInfo.getUserEmail());
                system.debug('Email Content is :'+ EmailContent);                   
            }
        } 
    }		
}