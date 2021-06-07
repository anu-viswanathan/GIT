@istest
private class Test_LearningPlanAssignmentTrigger {
    @testSetup static void setupTestData(){
        Id acctRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IKOPRO Contractor').getRecordTypeId();
        
        
        List<Tier__c> toInsertTiers = new List<Tier__c>();
        
        toInsertTiers.add(new Tier__c(Tier_Label__c = '3'));
        
        insert toInsertTiers;
        
        List<Account> toInsertAccounts = new List<Account>();
        
        toInsertAccounts.add(new Account(Name = 'Carrie Roofing and Construction', RecordTypeId = acctRT, BillingStreet = '9 King St E',
                                         BillingCity = 'Toronto', BillingStateCode =  'ON',
                                         BillingCountryCode = 'CA', BillingPostalCode = 'M4S 2H4', Present_Tier_Lookup__c = toInsertTiers[0].Id ));                    
        system.debug('account ' +toInsertAccounts);
        insert toInsertAccounts;
        
        List<Contact> toInsertContacts = new List<Contact>();        
        
        Integer i;
        List<Contact> createdContacts = new List<Contact>();
        for (i = 0; i < 2; i++) {
            createdContacts.add(new Contact(AccountId = toInsertAccounts[0].Id, LastName = 'Doe',FirstName = 'John'+i));
        }

        insert createdContacts;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='IKOPRO Contractor Admin'];
        system.debug('profile ' +p);
        
        List<User> createdUsers = new List<User>();
        for (i = 0; i < 2; i++) {
            createdUsers.add(new User(ContactId = createdContacts[i].id, Alias = 'test'+i, 
                                      Email='testlpa@iko.com',
                                      EmailEncodingKey='UTF-8',
                                      LastName='Testing' +i,
                                      LanguageLocaleKey='en_US',
                                      LocaleSidKey='en_US',
                                      ProfileId = p.Id,
                                      TimeZoneSidKey='America/Los_Angeles',
                                      Username = 'disney' + i + '@iko.com')); 
        }

        insert createdUsers;
        
        
        // Integer i;
        List<redwing__Training_Plan__c> createdLearningplans = new List<redwing__Training_Plan__c>();
        for (i = 0; i < 2; i++) {
            createdLearningplans.add(new redwing__Training_Plan__c(Name = 'Test Elective 2 ' +i));
        }

        insert createdLearningplans ;
        
        
        List<redwing__Training_Plan_Assignment__c> createdLearningPlanAssignments = new List<redwing__Training_Plan_Assignment__c>();
        for (i = 0; i < 2; i++) {
            createdLearningPlanAssignments.add(new redwing__Training_Plan_Assignment__c(redwing__Training_Plan__c = createdLearningplans[i].Id, redwing__Contact__c = createdContacts[i].Id, redwing__Status__c = 'Not Started', redwing__User__c = createdUsers[i].Id));
        }

        insert createdLearningPlanAssignments ;
        
    }
    
    @isTest static void testLearningplanAssignment() {
        Account acct = [SELECT Id, No_of_Electives_Completed__c FROM Account LIMIT 1];
                  system.debug('checjaccount ' +acct);

        system.assertNotEquals(1, acct.No_of_Electives_Completed__c);
        
        Test.startTest();
        
        List<redwing__Training_Plan_Assignment__c> getLearningPlanAssignments = [SELECT redwing__Status__c FROM redwing__Training_Plan_Assignment__c  ];
        for ( redwing__Training_Plan_Assignment__c plan : getLearningPlanAssignments){ 
            plan.redwing__Status__c = 'Completed';
        }  

        update getLearningPlanAssignments;
        
        Test.stopTest();
        // I want to check if the No. of Elective Completed field has value '1' on Account after the status is Completed on LPA.
        
        Account a = [SELECT Id, No_of_Electives_Completed__c FROM Account LIMIT 1];
        system.debug('updatedAccount ' +a);
        system.assertEquals(1, a.No_of_Electives_Completed__c);
    }
    
    
}