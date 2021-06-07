@isTest
private class WarrantyServiceTest {
	


	@isTest static void testThatRegistrationPrefixSet() {
		Id rt 	= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();

		Account a1 		= new Account(RecordTypeId = rt, Name = 'Test1', IAAP_Registered_Highlight__c = 'IAAP Registered', Registration__c = 'ON/2010', Registration_Sequence_Number__c = 2010, BillingStateCode = 'ON', BillingCountryCode = 'CA', IAP_Registered_Date__c = date.today(), IAP_Registration_Expiry_Date__c = date.today().addYears(3));
		Account a2 		= new Account(RecordTypeId = rt, Name = 'Test1', IAAP_Registered_Highlight__c = 'IAAP Registered', Registration__c = 'ON/2010', Registration_Sequence_Number__c = 2010, BillingStateCode = 'AB', BillingCountryCode = 'CA', IAP_Registered_Date__c = date.today(), IAP_Registration_Expiry_Date__c = date.today().addYears(3));
		Account a3 		= new Account(RecordTypeId = rt, Name = 'Test1', IAAP_Registered_Highlight__c = 'IAAP Registered', Registration__c = 'ON/2010', Registration_Sequence_Number__c = 2010, BillingStateCode = 'QC', BillingCountryCode = 'CA', IAP_Registered_Date__c = date.today(), IAP_Registration_Expiry_Date__c = date.today().addYears(3));
		insert new List<Account> { a1, a2, a3}; 

		Test.startTest();
		Warranty__c w1  = new Warranty__c(Sequence_Number__c = 10002, Warranty_Registration_Id__c = 'Golden1234', Warranty_Term__c = '10', Contractor__c = a1.Id);
		Warranty__c w2  = new Warranty__c(Sequence_Number__c = 10003, Registration_Prefix__c='AB', Warranty_Registration_Id__c = 'ON-10002-2018', Warranty_Term__c = '10', Contractor__c = a1.Id);
		insert new List<Warranty__c> {w1,w2};

		Warranty__c w1Check 		= [select Id, Registration_Prefix__c from Warranty__c where Id = :w1.Id];
		Warranty__c w2Check 		= [select Id, Registration_Prefix__c from Warranty__c where Id = :w2.Id];

		System.assertEquals(w1Check.Registration_Prefix__c, 'ON', 'Prefix not set correctly on insert');			
		System.assertEquals(w2Check.Registration_Prefix__c, 'AB', 'Trigger should not have overwritten value set');			

		w2.Registration_Prefix__c	= null;
		update w2;


		w2Check 		= [select Id, Registration_Prefix__c from Warranty__c where Id = :w2.Id];
		System.assertEquals(w2Check.Registration_Prefix__c, 'ON', 'Prefix not set correctly on update');			
		Test.stopTest();
	}



	@isTest static void testThatSequenceNumberSetCorrectly() {
		/* initialize some Accounts, Warranties and Sequence Numbers */

		Id rt 	= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();

		Account a1 		= new Account(RecordTypeId = rt, Name = 'Test1', IAAP_Registered_Highlight__c = 'IAAP Registered', Registration__c = 'ON/2010', Registration_Sequence_Number__c = 2010, BillingStateCode = 'ON', BillingCountryCode = 'CA', IAP_Registered_Date__c = date.today(), IAP_Registration_Expiry_Date__c = date.today().addYears(3));
		Account a2 		= new Account(RecordTypeId = rt, Name = 'Test1', IAAP_Registered_Highlight__c = 'IAAP Registered', Registration__c = 'ON/2010', Registration_Sequence_Number__c = 2010, BillingStateCode = 'AB', BillingCountryCode = 'CA', IAP_Registered_Date__c = date.today(), IAP_Registration_Expiry_Date__c = date.today().addYears(3));
		Account a3 		= new Account(RecordTypeId = rt, Name = 'Test1', IAAP_Registered_Highlight__c = 'IAAP Registered', Registration__c = 'ON/2010', Registration_Sequence_Number__c = 2010, BillingStateCode = 'QC', BillingCountryCode = 'CA', IAP_Registered_Date__c = date.today(), IAP_Registration_Expiry_Date__c = date.today().addYears(3));
		insert new List<Account> { a1, a2, a3}; 

		Test.startTest();
		Warranty__c w1  = new Warranty__c(Sequence_Number__c = 10002, Registration_Prefix__c='ON', Warranty_Registration_Id__c = 'Golden1234', Warranty_Term__c = '10', Contractor__c = a1.Id);
		Warranty__c w2  = new Warranty__c(Sequence_Number__c = 10003, Registration_Prefix__c='ON', Warranty_Registration_Id__c = 'ON-10002-2018', Warranty_Term__c = '10', Contractor__c = a1.Id);
		insert new List<Warranty__c> {w1,w2};


		Warranty__c w3 	= new Warranty__c(Warranty_Term__c = '10', Contractor__c = a2.Id);
		Warranty__c w4 	= new Warranty__c(Warranty_Term__c = '10', Contractor__c = a3.Id);
		Warranty__c w5 	= new Warranty__c(Warranty_Term__c = '10', Contractor__c = a3.Id);
		Warranty__c w6 	= new Warranty__c(Warranty_Term__c = '10', Contractor__c = a1.Id);

		upsert new List<Warranty__c> {w1, w2, w3, w4, w5, w6};


		List<Warranty__c> wCheck 		= [select Id, Warranty_Registration_Id__c from Warranty__c where Id iN : new List<Warranty__c> { w1, w2, w3, w4, w5, w6}];

		for(Warranty__c w : wCheck) {
			if(w.Id == w1.Id) 
				System.assertEquals(w.Warranty_Registration_Id__c, 'Golden1234', 'Warranty should have retained registration number');		
			if(w.Id == w2.Id) 
				System.assertEquals(w.Warranty_Registration_Id__c, 'ON-10002-2018', 'Warranty should have retained registration number');		
			if(w.Id == w3.Id) 
				System.assertEquals(w.Warranty_Registration_Id__c, 'AB-10000-'+date.today().year(), 'First AB Warranty should start at 10000');		
			if(w.Id == w4.Id) 
				System.assertEquals(w.Warranty_Registration_Id__c, 'QC-10000-'+date.today().year(), 'First QC Warranty should start at 10000');		
			if(w.Id == w5.Id) 
				System.assertEquals(w.Warranty_Registration_Id__c, 'QC-10001-'+date.today().year(), 'Second QC Warranty should be 10001');		
			if(w.Id == w6.Id) 
				System.assertEquals(w.Warranty_Registration_Id__c, 'ON-10004-'+date.today().year(), 'Third ON Warranty should increment sequence');		

		}
		Test.stopTest();
	}
	

    /* Ticket CLAIMSV2-624
     * Added condition to display error Message when submitting record for Approval,
     * By: Anil Mannem (Incloud) on 13-May-2020
     */
    @isTest static void testvalidateApprovalSubmission() {

        Id rt1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
		Id rt2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();

		Account a1 = new Account(RecordTypeId = rt1, Name = 'Test1', IAAP_Registered_Highlight__c = 'IAAP Registered', Registration__c = 'ON/2010', Registration_Sequence_Number__c = 2010, BillingStateCode = 'ON', BillingCountryCode = 'CA', IAP_Registered_Date__c = date.today(), Annual_Insurance_Renewal__c = date.today().addYears(1), IAP_Registration_Expiry_Date__c = date.today().addYears(3));
		Account a2 = new Account(RecordTypeId = rt2, Name = 'Test2', CurrencyIsoCode = 'CAD');
		insert new List<Account> { a1, a2};

		Warranty__c w1 = new Warranty__c(Name = 'Test1', Warranty_Status__c = 'Draft', Warranty_Term__c = '5', Contractor__c = a1.Id, Building__c = a2.Id, Type__c = 'Labor & Membrane');
        Warranty__c w2 = new Warranty__c(Name = 'Test2', Warranty_Status__c = 'Draft', Warranty_Term__c = '5', Contractor__c = a1.Id, Building__c = a2.Id, Type__c = 'Diamond Shield');
		insert new List<Warranty__c> {w1, w2};

        w1.Warranty_Status__c = 'In Progress';
        w1.Warranty_Substatus__c = 'In Review';
		w2.Warranty_Status__c = 'In Progress';
        w2.Warranty_Substatus__c = 'Payment Received';
        w2.Installation_Deficiency_Status__c = 'No Deficiencies';
        try {
	        update new List<Warranty__c> {w1, w2};
        } catch (Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.Approval_Warranty_StartDate) ? true : false;
        	//System.AssertEquals(expectedExceptionThrown, true);
		}
    } //end of testvalidateApprovalSubmission
    
    @isTest static void testUpdateWarrantyExpired() {
        Id rt      = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        
        Account a1                  = new Account(RecordTypeId = rt, Name = 'Test1', IAAP_Registered_Highlight__c = 'IAAP Registered', Registration__c = 'ON/2010', Registration_Sequence_Number__c = 2010, BillingStateCode = 'ON', BillingCountryCode = 'CA', IAP_Registered_Date__c = date.today(), IAP_Registration_Expiry_Date__c = date.today().addYears(3));
        //Account a2                = new Account(RecordTypeId = rt, Name = 'Test1', IAAP_Registered_Highlight__c = 'IAAP Registered', Registration__c = 'ON/2010', Registration_Sequence_Number__c = 2010, BillingStateCode = 'AB', BillingCountryCode = 'CA', IAP_Registered_Date__c = date.today(), IAP_Registration_Expiry_Date__c = date.today().addYears(3));
        //Account a3                = new Account(RecordTypeId = rt, Name = 'Test1', IAAP_Registered_Highlight__c = 'IAAP Registered', Registration__c = 'ON/2010', Registration_Sequence_Number__c = 2010, BillingStateCode = 'QC', BillingCountryCode = 'CA', IAP_Registered_Date__c = date.today(), IAP_Registration_Expiry_Date__c = date.today().addYears(3));
        insert new List<Account> { a1}; 
            
        //Test.startTest();
        Warranty__c w1  = new Warranty__c(Sequence_Number__c = 10002, Registration_Prefix__c='ON', Warranty_Registration_Id__c = 'Golden1234', Warranty_Term__c = '10', Contractor__c = a1.Id, Warranty_Substatus__c = 'Not Issued');
        Warranty__c w2  = new Warranty__c(Sequence_Number__c = 10003, Registration_Prefix__c='ON', Warranty_Registration_Id__c = 'ON-10002-2018', Warranty_Term__c = '10', Contractor__c = a1.Id, Warranty_Start_Date__c = Date.newInstance(2010, 7, 14));
        Warranty__c w3  = new Warranty__c(Name = 'Test1', Warranty_Status__c = 'Draft', Warranty_Term__c = '5', Contractor__c = a1.Id, Type__c = 'Diamond Shield', Warranty_Start_Date__c = null, Warranty_Substatus__c = 'Awaiting documentation');
        insert new List<Warranty__c> {w1,w2,w3};
            
            List<Warranty__c> wCheck  = [select Id, Warranty_Registration_Id__c, Expired__c, Warranty_Expired_Date__c from Warranty__c where Id iN : new List<Warranty__c> { w1, w2, w3 }];
        
        for(Warranty__c w : wCheck) {
            if(w.Id == w1.Id) 
            {
                //System.Debug ('Warranty Expired Date is w1 ' + w.Warranty_Expired_Date__c);
                System.assertEquals(w.Expired__c, 'Yes');
                        System.assertEquals(String.isEmpty(w.Warranty_Expired_Date__c), false);
                
            }
            if(w.Id == w2.Id) 
            {    
                //System.Debug ('Warranty Expired Date is w2 ' + w.Warranty_Expired_Date__c);
                System.assertEquals(w.Expired__c, 'Yes');
                        System.assertEquals(String.isEmpty(w.Warranty_Expired_Date__c), false);
                        
            }
            if(w.Id == w3.Id) 
            {
                //System.Debug ('Warranty Expired Date is w3 ' + w.Warranty_Expired_Date__c);
                System.assertEquals(w.Expired__c, 'No');
                        System.assertEquals(w.Warranty_Expired_Date__c, null);
            }
        }
        //Test.stopTest();
    }
    
}