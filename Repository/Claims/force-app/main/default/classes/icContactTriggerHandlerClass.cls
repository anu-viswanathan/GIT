public class icContactTriggerHandlerClass {


public static void createUserFromContact(Set<Id> contactIds)
{
     system.debug('****************************Inside createUserFromContact method');
     List<User> newUserList = new List<User>();
     List<User> deactivatedUserList = new List<User>();
     List<Account> accountList= new List<Account>();
     Set<String> setUserNames = new Set<String>();
     
       
     List<Profile> profileList = [Select Id from Profile where Name=: 'IKOPRO Contractor Admin' limit 1];
     List<Profile> profileListCRC = [Select Id from Profile where Name= 'CRCPRO Contractor Admin' limit 1];
     
    
     for(Account acc : [Select id , name, IsPartner, New_Partner_Account__c  from Account where Applicant_Information__c IN: contactIds limit 50000])
            {
                system.debug('****************************Inside Account partner enablement for loop');
                system.debug('****************************Before IsPartner'+acc.IsPartner+'   '+acc.New_Partner_Account__c);
                acc.IsPartner = true;
                system.debug('****************************After IsPartner, Before New_Partner_Account__c'+acc.IsPartner+'   '+acc.New_Partner_Account__c);
                acc.New_Partner_Account__c=true;
                system.debug('****************************After New_Partner_Account__c'+acc.IsPartner+'   '+acc.New_Partner_Account__c);
                accountList.add(acc);
                system.debug('****************************List of Accounts partner enablement' +accountList);
            }

            try{
                if(accountList.size()>0)
                {
                    update accountList;                   
                    system.debug('****************************PARTNER ACCOUNT IS ENABLED');
                }
            }

            catch(Exception e)
            {
                System.debug('***********The following exception has occurred while ENABLING ACCOUNT A PARTNER ACCOUNT: ' + e.getMessage());
            } 
     
        
        
      for(User u : [Select id, isactive, Username, Email, CommunityNickname from User Limit 50000])     
            {                     
               setUserNames.add(u.Username);                     
            }
         
      system.debug('****************************Total Users in Org' +setUserNames.size());

    
    for(Contact contactObj : [Select Id, FirstName, LastName, Name, Loyalty_Program_Type__c, Email,Role__c , Account.Name, account.Applicant_Information__r.Salesforce_User__r.ROOFPRO_Portal_Language__c  from Contact where Account.Applicant_Information__c IN: contactIds and Role__c='Primary Contact' limit 1])
        {
         
        
            User uObj = new User();
           
              if(setUserNames.contains(contactObj.Email))
            {
            system.debug('****************************Inside IF loop to check existing user');
            uObj.Username = contactObj.Email+'.1';
            uObj.CommunityNickname= contactObj.FirstName +'.'+ contactObj.LastName+'.1';
            }
            else
            {
            system.debug('****************************Inside Else loop to check existing user');
            uObj.Username = contactObj.Email;
            uObj.CommunityNickname= contactObj.FirstName +'.'+ contactObj.LastName;
            }
            
            
            
            if(contactObj.account.Applicant_Information__r.Salesforce_User__r.ROOFPRO_Portal_Language__c =='Quebec French')
            {
              uObj.ROOFPRO_Portal_Language__c='Quebec French';
              uObj.LanguageLocaleKey='fr';
              uObj.LocaleSidKey='fr_CA';
            }
            else if (contactObj.account.Applicant_Information__r.Salesforce_User__r.ROOFPRO_Portal_Language__c =='Spanish')
            {
              uObj.ROOFPRO_Portal_Language__c='Spanish';
              uObj.LanguageLocaleKey='es';
              uObj.LocaleSidKey='es_MX';
            }
            else if (contactObj.account.Applicant_Information__r.Salesforce_User__r.ROOFPRO_Portal_Language__c =='English')
            {
            uObj.ROOFPRO_Portal_Language__c='English';
            uObj.LanguageLocaleKey='en_US';
            uObj.LocaleSidKey='en_CA';
            }     
            
            uObj.FirstName = contactObj.FirstName;
            uObj.LastName = contactObj.LastName;
            uObj.Email = contactObj.Email;
            uObj.Alias = contactObj.FirstName.substring(0,1).toUppercase() + contactObj.LastName.substring(0,1).toUppercase();
            
            //IKO-238  Amendment for CRC Profile for CRC community User
            if(contactObj.Loyalty_Program_Type__c == 'CRC'){
              uObj.ProfileId = profileListCRC[0].Id;
            }else uObj.ProfileId = profileList[0].Id;
            
            uObj.IsActive = true; 
            uObj.TimeZoneSidKey = 'GMT';           
            uObj.EmailEncodingKey = 'UTF-8';         
            uObj.ContactId = contactObj.Id;
            uObj.IsPrmSuperUser=true;
            system.debug('****************************printing details' + uObj);
            newUserList.add(uObj); 
        }
        
     
        
        
        try{
               if(newUserList.size()>0)
                  {
                       insert newUserList;  // insert the user record
                       system.debug('****************************record inserted successfully');
                   }
           }     
                   
        catch(Exception e)
           {
                System.debug('***********The following exception has occurred while CREATING USER: ' + e.getMessage());  
                
              
           }
           
                              
    /* for(User u : newUserList)
           {
           if(u.id != NULL && newUserList.size()>0)
            {                
             system.resetpassword(u.id, true);   
               //system.resetPasswordWithEmailTemplate(u.id, true, 'IKO_ROOFPRO_Password_Change_Request_from_User');
             //system.resetPasswordWithEmailTemplate(u.id, true, 'SFDC_VF_Email_Template');
               
              
             }  
            } */
          
                
}
}