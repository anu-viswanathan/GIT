@isTest
public class Case_TriggerHandler_Test {
	 @testSetup static void setupTestData() {
        initData();
        initUser();
    }

    @future
    private static void initUser() {
        User salesManagerUser = TestFactory.createUser('Unit', 'Tests', 'salesrsmmgr@iko.com', 'salesrsmmgr@iko.com', 'USRS Manager',
                'RSM West', 'salesmgr', 'GMT', 'en_US', 'UTF-8', 'en_US', null, null, false);
        insert salesManagerUser;
    }
    
    private static void initData() {

        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();
        List<Account> toInsertAccounts = new List<Account>();

        toInsertAccounts.addAll(TestFactory.createAccounts(baRt, 'AccountCA', '9 King St E', 'Toronto', 'ON', 'CA', 'M4S 2H4',
                'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));
        //insert toInsertAccounts;

        toInsertAccounts.addAll(TestFactory.createAccounts(baRt, 'AccountQC', '9 King St E', 'Toronto', 'QC', 'CA', 'M4S 2H4',
                'Verified', UserInfo.getUserId(), TRUE, TRUE, 1, false));
        insert toInsertAccounts;
        
        Product2 p = new Product2(
        	Name = 'IKO CAMBRIDGE',
            Sectors__c = 'CA',
            Is_Legacy__c = false,
            Unit_of_Measure__c = 'BD'
        );
        insert p;
        
        
        //create contact
        List<Contact> con = TestFactory.createContacts(toInsertAccounts[0].Id, 'ClaimTypeServiceTest', UserInfo.getUserId(), 1, false);
        insert con;

        
    }
	 
    @isTest static void testThatCaseTemplate_ManualCalculation() {
        Test.startTest();
        Account caAccount = [select Id from Account where BillingCountryCode = :'CA' limit 1];
		Contact contact = [select Id from Contact limit 1];        
        Case c1 = new Case(
            Description = 'Residential Claim created by Test Case',
        	RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId(),
            Claim_Stage__c = 'Assessment',
            Settlement_Type__c = 'Manual Calculation',
            Preferred_Language__c = 'English', 
            AccountId = caAccount.Id,
            ContactId = contact.Id,
            Template_Name_Automatic_Generated__c = '',
            Sector__c = 'CA'
        );
        //system.debug('c1: ' + c1);
        insert c1;
        
        Claim_Type__c ct = new Claim_Type__c(
        	case__c = c1.Id,
            Concern__c = 'Clawing',
            Product_Type__c = 'B Glass',
            Is_Primary__c = true
        );
        insert ct;
        
        Case cCheck		= [select Id, Template_Name_Automatic_Generated__c from Case where Id = :c1.Id limit 1];
        //system.debug('c1: ' + c1);
        System.assertEquals( null, cCheck.Template_Name_Automatic_Generated__c );                                 
        Test.stopTest();
        
    }
    
    @isTest static void testThatCaseTemplate_Glass_REG_MMO_EN_CA() {
         Test.startTest();
        Account caAccount = [select Id from Account where BillingCountryCode = :'CA' limit 1];
		Contact contact = [select Id from Contact limit 1];        
        Case c1 = new Case(
            Description = 'Residential Claim created by Test Case',
        	RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId(),
            Claim_Stage__c = 'Assessment',
            Settlement_Type__c = 'Money or Material Offer',
            Preferred_Language__c = 'English', 
            AccountId = caAccount.Id,
            ContactId = contact.Id,
            Template_Name_Automatic_Generated__c = '',
            Sector__c = 'CA'
        );
        //system.debug('c1: ' + c1);
        insert c1;
        
        Claim_Type__c ct = new Claim_Type__c(
        	case__c = c1.Id,
            Concern__c = 'Clawing',
            Product_Type__c = 'B Glass',
            Is_Primary__c = true
        );
        insert ct;
        
        Case cCheck		= [select Id, Template_Name_Automatic_Generated__c from Case where Id = :c1.Id limit 1];
        //system.debug('c1: ' + c1);
        System.assertEquals( '1 - [Glass] Offer-Release [REG] [MMO] [IKO] [EN] [CA]', cCheck.Template_Name_Automatic_Generated__c );                                 
        Test.stopTest();
        
    }
    
    @isTest static void testThatCaseTemplate_Glass_REG_CS_EN_CA() {
         Test.startTest();
        Account caAccount = [select Id from Account where BillingCountryCode = :'CA' limit 1];
		Contact contact = [select Id from Contact limit 1];        
        Case c1 = new Case(
            Description = 'Residential Claim created by Test Case',
        	RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId(),
            Claim_Stage__c = 'Assessment',
            Settlement_Type__c = 'Cash Settlement',
            Preferred_Language__c = 'English', 
            AccountId = caAccount.Id,
            ContactId = contact.Id,
            Template_Name_Automatic_Generated__c = '',
            Sector__c = 'CA'
        );
        //system.debug('c1: ' + c1);
        insert c1;
        
        Claim_Type__c ct = new Claim_Type__c(
        	case__c = c1.Id,
            Concern__c = 'Clawing',
            Product_Type__c = 'B Glass',
            Is_Primary__c = true
        );
        insert ct;
        
        Case cCheck		= [select Id, Template_Name_Automatic_Generated__c from Case where Id = :c1.Id limit 1];
        //system.debug('c1: ' + c1);
        System.assertEquals( '1 - [Glass] Offer-Release [REG] [CS] [IKO] [EN] [CA]', cCheck.Template_Name_Automatic_Generated__c );                                 
        
        Test.stopTest();
    }
    
    @isTest static void testThatCaseTemplate_Glass_REG_CSMO_EN_QC() {
         Test.startTest();
        Account caAccount = [select Id from Account where BillingStateCode = :'QC' limit 1];
		Contact contact = [select Id from Contact limit 1];        
        Case c1 = new Case(
            Description = 'Residential Claim created by Test Case',
        	RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId(),
            Claim_Stage__c = 'Assessment',
            Settlement_Type__c = 'Cash Settlement - Material Only',
            Preferred_Language__c = 'English', 
            AccountId = caAccount.Id,
            ContactId = contact.Id,
            Template_Name_Automatic_Generated__c = '',
            Sector__c = 'CA'
        );
        //system.debug('c1: ' + c1);
        insert c1;
        
        Claim_Type__c ct = new Claim_Type__c(
        	case__c = c1.Id,
            Concern__c = 'Clawing',
            Product_Type__c = 'B Glass',
            Is_Primary__c = true
        );
        insert ct;
        
        Case cCheck		= [select Id, Template_Name_Automatic_Generated__c from Case where Id = :c1.Id limit 1];
        System.assertEquals( '1 - [Glass] Offer-Release [REG] [CSMO] [IKO] [EN] [QC]', cCheck.Template_Name_Automatic_Generated__c );  
    	Test.stopTest();
    }
    /*
    @isTest static void testThatCaseTemplate_Glass_REG_FR_FR_CA() {
        Account caAccount = [select Id from Account where BillingCountryCode = :'CA' limit 1];
		Contact contact = [select Id from Contact limit 1];        
        Case c1 = new Case(
            Description = 'Residential Claim created by Test Case',
        	RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId(),
            Claim_Stage__c = 'Assessment',
            Settlement_Type__c = 'Cash Settlement - Material Only',
            Preferred_Language__c = 'French', 
            Installation_Date__c = Date.valueOf('1998-06-01'),
            Num_of_Months_Product_Used__c = 6,
            Conga_Iron_Clad_Period_Months__c = 8,
            AccountId = caAccount.Id,
            ContactId = contact.Id,
            Template_Name_Automatic_Generated__c = '',
            Sector__c = 'CA'
        );
        //system.debug('c1: ' + c1);
        insert c1;
        
        Claim_Type__c ct = new Claim_Type__c(
        	case__c = c1.Id,
            Concern__c = 'Clawing',
            Product_Type__c = 'B Glass',
            Is_Primary__c = true
        );
        insert ct;
        
        Case cCheck		= [select Id, Template_Name_Automatic_Generated__c from Case where Id = :c1.Id limit 1];
        System.assertEquals( '1 - [Glass] Offer-Release [REG] [CSMO] [IKO] [EN] [QC]', cCheck.Template_Name_Automatic_Generated__c );  
    }
    */
    @isTest static void testThatCaseTemplate_Glass_REG_GW_FR_QC() {
         Test.startTest();
        Account caAccount = [select Id from Account where BillingStateCode = :'QC' limit 1];
        Contact contact = [select Id from Contact limit 1];        
        Case c1 = new Case(
            Description = 'Residential Claim created by Test Case',
        	RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId(),
            Claim_Stage__c = 'Assessment',
            Settlement_Type__c = 'Goodwill',
            Preferred_Language__c = 'Quebec French', 
            AccountId = caAccount.Id,
            ContactId = contact.Id,
            Template_Name_Automatic_Generated__c = '',
            Sector__c = 'CA'
        );
        //system.debug('c1: ' + c1);
        insert c1;
        
        Claim_Type__c ct = new Claim_Type__c(
        	case__c = c1.Id,
            Concern__c = 'Clawing',
            Product_Type__c = 'B Glass',
            Is_Primary__c = true
        );
        insert ct;
        
        Case cCheck		= [select Id, Template_Name_Automatic_Generated__c from Case where Id = :c1.Id limit 1];
        System.debug('template name = ' + cCheck.Template_Name_Automatic_Generated__c); 
        System.assertEquals( '1 - [Glass] Offer-Release [REG] [GW] [IKO] [FR] [QC]', cCheck.Template_Name_Automatic_Generated__c );  
    	Test.stopTest();
    }
    
    @isTest static void testThatCaseTemplate_Glass_REG_HS_EN_CA() {
         Test.startTest();
       Account caAccount = [select Id from Account where BillingCountryCode = :'CA' limit 1];
		Contact contact = [select Id from Contact limit 1];        
        Case c1 = new Case(
            Description = 'Residential Claim created by Test Case',
        	RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId(),
            Claim_Stage__c = 'Assessment',
            Settlement_Type__c = 'Hand Seal',
            Preferred_Language__c = 'English', 
            AccountId = caAccount.Id,
            ContactId = contact.Id,
            Template_Name_Automatic_Generated__c = '',
            Sector__c = 'CA'
        );
        //system.debug('c1: ' + c1);
        insert c1;
        
        Claim_Type__c ct = new Claim_Type__c(
        	case__c = c1.Id,
            Concern__c = 'Clawing',
            Product_Type__c = 'B Glass',
            Is_Primary__c = true
        );
        insert ct;
        
        Case cCheck		= [select Id, Template_Name_Automatic_Generated__c from Case where Id = :c1.Id limit 1];
        //system.debug('c1: ' + c1);
        System.assertEquals( '1 - [Glass] Offer-Release [REG] [HS] [IKO] [EN] [CA]', cCheck.Template_Name_Automatic_Generated__c );                                 
         Test.stopTest();
    }
    
    @isTest static void testThatCaseTemplate_Glass_REG_HSFM_EN_QC() {
         Test.startTest();
        Account caAccount = [select Id from Account where BillingStateCode = :'QC' limit 1];
		Contact contact = [select Id from Contact limit 1];        
        Case c1 = new Case(
            Description = 'Residential Claim created by Test Case',
        	RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId(),
            Claim_Stage__c = 'Assessment',
            Settlement_Type__c = 'Cash Settlement - Material Only',
            Preferred_Language__c = 'English', 
            AccountId = caAccount.Id,
            ContactId = contact.Id,
            Template_Name_Automatic_Generated__c = '',
            Sector__c = 'CA'
        );
        //system.debug('c1: ' + c1);
        insert c1;
        
        Claim_Type__c ct = new Claim_Type__c(
        	case__c = c1.Id,
            Concern__c = 'Fishmouthing',
            Product_Type__c = 'B Glass',
            Is_Primary__c = true
        );
        insert ct;
        
        Case cCheck		= [select Id, Template_Name_Automatic_Generated__c from Case where Id = :c1.Id limit 1];
        System.debug('Template name = ' + cCheck.Template_Name_Automatic_Generated__c );
        System.assertEquals( '1 - [Glass] Offer-Release [REG] [HS-FM] [IKO] [EN] [QC]', cCheck.Template_Name_Automatic_Generated__c );  
    	Test.stopTest();
    }
    /*
    @isTest static void testThatCaseTemplate_Glass_REG_PRM_FR_CA() {
                                   
         
    }
    */
    @isTest static void testThatCaseTemplate_Glass_REG_PRML_FR_QC() {
         Test.startTest();
        Account caAccount = [select Id from Account where BillingStateCode = :'QC' limit 1];
		Contact contact = [select Id from Contact limit 1];        
        Case c1 = new Case(
            Description = 'Residential Claim created by Test Case',
        	RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId(),
            Claim_Stage__c = 'Assessment',
            Settlement_Type__c = 'Default',
            Preferred_Language__c = 'Quebec French', 
            Installation_Date__c = Date.valueOf('1997-05-01'),
            AccountId = caAccount.Id,
            ContactId = contact.Id,
            Template_Name_Automatic_Generated__c = '',
            Sector__c = 'CA'
        );
        //system.debug('c1: ' + c1);
        insert c1;
        
        Claim_Type__c ct = new Claim_Type__c(
        	case__c = c1.Id,
            Concern__c = 'Clawing',
            Product_Type__c = 'B Glass',
            Is_Primary__c = true
        );
        insert ct;
        
        Case cCheck		= [select Id, Template_Name_Automatic_Generated__c from Case where Id = :c1.Id limit 1];
        //system.debug('c1: ' + c1);
        System.assertEquals( '1 - [Glass] Offer-Release [REG] [PRML] [IKO] [FR] [QC]', cCheck.Template_Name_Automatic_Generated__c );      
   		Test.stopTest();
    }
    
    @isTest static void testThatCaseTemplate_ORGANIC_CAC_CS_EN_CA() {
         Test.startTest();
        Account caAccount = [select Id from Account where BillingCountryCode = :'CA' limit 1];
		Contact contact = [select Id from Contact limit 1];        
        Product2 product = [select Id from Product2 limit 1];
        Case c1 = new Case(
            Description = 'Residential Claim created by Test Case',
        	RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId(),
            Claim_Stage__c = 'Assessment',
            Settlement_Type__c = 'Cash Settlement',
            Preferred_Language__c = 'English', 
            AccountId = caAccount.Id,
            ContactId = contact.Id,
            Template_Name_Automatic_Generated__c = '',
            Product__c = product.Id,
            Sector__c = 'CA'
        );
        system.debug('c1: ' + c1);
        insert c1;
        
        Claim_Type__c ct = new Claim_Type__c(
        	case__c = c1.Id,
            Concern__c = 'Cracking',
            Product_Type__c = 'A Organic',
            Is_Primary__c = true
        );
        insert ct;
                
        c1.Qualified__c = true;
        update c1;
        
        //Claim_Type__c claimtype = [select Id, Product_Type__c from Claim_Type__c where Id = : ct.Id limit 1];
        Case cCheck		= [select Id, Template_Name_Automatic_Generated__c from Case where Id = :c1.Id limit 1];
        System.assertEquals( '1 - [Org] Offer-Release [CAC] [CS] [IKO] [EN] [CA]', cCheck.Template_Name_Automatic_Generated__c );        
   		Test.stopTest();
    }
    
    @isTest static void testThatCaseTemplate_ORGANIC_CAG_CS_EN_CA() {
         Test.startTest();
        Account caAccount = [select Id from Account where BillingCountryCode = :'CA' limit 1];
		Contact contact = [select Id from Contact limit 1];        
        Product2 product = [select Id from Product2 limit 1];
        System.debug('product id is ' + product.Id);
        Case c1 = new Case(
            Description = 'Residential Claim created by Test Case',
        	RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId(),
            Claim_Stage__c = 'Assessment',
            Settlement_Type__c = 'Cash Settlement',
            Preferred_Language__c = 'English', 
            AccountId = caAccount.Id,
            ContactId = contact.Id,
            Template_Name_Automatic_Generated__c = '',
            Product__c = product.Id,
            Sector__c = 'CA'
        );
        system.debug('c1: ' + c1);
        insert c1;
        
        Claim_Type__c ct = new Claim_Type__c(
        	case__c = c1.Id,
            Concern__c = 'Granule Loss',
            Product_Type__c = 'A Organic',
            Is_Primary__c = true
        );
        insert ct;
                
        c1.Qualified__c = true;
        update c1;
        
        Case cCheck		= [select Id, Template_Name_Automatic_Generated__c from Case where Id = :c1.Id limit 1];
                
        System.assertEquals( '1 - [Org] Offer-Release [CAG] [CS] [IKO] [EN] [CA]', cCheck.Template_Name_Automatic_Generated__c );        
   		Test.stopTest();
    }
    
    
}