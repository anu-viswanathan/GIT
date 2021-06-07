trigger icCreatePartnerUser on Contact (after insert, after update) {

  private icLogicContact.IClass logicContact = (icLogicContact.IClass) icObjectFactory.GetSingletonInstance('icLogicContact');
    private icLogicAccount.IClass logicAccount = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

  if(trigger.isInsert) {
    if(trigger.isafter) {

      //Vendor Email Feature
      if(Trigger.New.size() == 1) {
        Contact newContact = Trigger.New[0];

        if(newContact.Send_Mrktng_Material_Request_Applicant__c == true) {
          logicContact.handleVendorEmail(newContact.Id);
        }
      }
      
    }
  }



  if(trigger.isupdate) {
     
    if(trigger.isafter) {

      //Vendor Email Feature
      if(Trigger.New.size() == 1) {
        Contact newContact = Trigger.New[0];
        Contact oldContact = Trigger.oldMap.get(newContact.Id);
        if(oldContact.Send_Mrktng_Material_Request_Applicant__c == false 
        && newContact.Send_Mrktng_Material_Request_Applicant__c == true) {
          logicContact.handleVendorEmail(newContact.Id);
        }
      } 
      
      
      Set<Id> contactIds = new Set<Id>();
        for(Contact newContact: Trigger.New)
             {
                Contact oldCon = Trigger.oldMap.get(newContact.Id);
                
                 system.debug('****************************OLD VALUE' + oldCon.Activate_Account_Users_Applicant__c );
                 system.debug('****************************NEW VALUE' + newContact.Activate_Account_Users_Applicant__c );
               
                    if (!oldCon.Activate_Account_Users_Applicant__c && newContact.Activate_Account_Users_Applicant__c )                   
                    
                      {
                      system.debug('****************************Inside old and new Comparision');
                        contactIds.add(newContact.id);
                      }
               
               }
               
                if(contactIds.size() > 0) 
        {
            system.debug('****************************Contacts are available' + contactIds.size());
            icContactTriggerHandlerClass.createUserFromContact(contactIds);
        }
      
      
      
      
      
             }  
                
       
      
  }
}