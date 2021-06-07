/***********
 * Test Class Created to regroup all data creation in test classes. 
 * Creator : Dominic Boivin 
 * Creation Date : 2020-08-18
 ***********/
public with sharing class icTestHelperDataCreator {
    //Method moved from icTestHelperUtility
    public static Account generateAccount() {

		Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IKO ROOFPRO APPLICANTS').getRecordTypeId();
		Account newAccount = new Account(Name = 'Account Name');
		newAccount.RecordTypeId = recordTypeId;
		newAccount.BillingPostalCode = 'H3X2K8';
		//newAccount.Applicant_Information__c = newContact.Id;
		return newAccount;
    }
    //Method moved from icTestHelperUtility
	public static Account generateOtherAccount() {

		Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IKO ROOFPRO APPLICANTS').getRecordTypeId();
		Account newAccount = new Account();
		newAccount.Name = icTestHelperUtility.generateRandomString(14);
		newAccount.Customer_Type__c = 'Customer';
		newAccount.Admin_Email_Address__c = icTestHelperUtility.generateRandomString(5) + '@' + icTestHelperUtility.generateRandomString(10) + '.com';
		newAccount.BillingCountryCode = 'CA';
		newAccount.BillingCity = icTestHelperUtility.generateRandomString(10);
		newAccount.BillingStateCode = 'QC';
		newAccount.BillingStreet = '123 street';
		newAccount.BillingPostalCode = 'H3X2K8';
		newAccount.Present_Tier__c = 'Tier 1';
		newAccount.Type = 'Other';
		newAccount.Phone = '555-555-5555';
		newAccount.RecordTypeId = recordTypeId;
		//newAccount.Applicant_Information__c = newContact.Id;
		return newAccount;

	}
    //Method moved from icTestHelperUtility
	public static Account generateContractorAccount(){
		Account applicantAccount = generateAccount();
		insert applicantAccount;

		Contact newContact = new Contact();
		newContact.FirstName = 'Applicant';
		newContact.LastName = 'Contact';
		newContact.AccountId = applicantAccount.Id;
		insert newContact;

		Tier__c accountTier = createTestTier();

		Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IKOPRO Contractor').getRecordTypeId();

		Account newAccount = new Account(Name = 'Account Name');
		newAccount.RecordTypeId = recordTypeId;
		newAccount.Applicant_Information__c = newContact.Id;
		newAccount.Present_Tier_Lookup__c = accountTier.Id;
		
		return newAccount;
	}

	public static Opportunity generateOpportunityByRecordType(String recordTypeName,Id OpportunityAccountId){
		Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
		Opportunity newOpportunity = new Opportunity();
		if (recordTypeName == 'US Sales Bid'){
			newOpportunity.Name = 'Test Name' ;
			newOpportunity.RecordTypeId = recordTypeId;
			newOpportunity.CloseDate = Date.today()+90;
			newOpportunity.AccountId = OpportunityAccountId;
            newOpportunity.StageName = 'Preparing Quotes';	
            newOpportunity.Quote_Approved__c = false; 
		}
		else {
			newOpportunity = null;
		}
		return newOpportunity;        
	}

	public static Account generateAccountByRecordType(String recordTypeName){
		
		Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
		Account newAccount = new Account();
		newAccount.RecordTypeId = recordTypeId;
		String randomName = icTestHelperUtility.generateRandomString(10);
		if (recordTypeName == 'US Contractor'){
			newAccount.Name = 'Unit Test US Contractor ' + randomName;
			newAccount.BillingPostalCode = 'H3X2K8';
		}
		else if (recordTypeName == 'US Distributor'){
			newAccount.Name = 'Unit Test US Distributor' + randomName;
			newAccount.BillingPostalCode = 'H3P2K8';
		}
		else if (recordTypeName == 'Building Location'){
			newAccount.Name = 'Unit Test Building Location' +  randomName;
			newAccount.BillingPostalCode = 'H3P2P8';
		}
		else {
			newAccount = null;
		}
		return newAccount;        
	}

	public static Bidder__c generateBidder(Opportunity opportunity, Account distributor, Account contractor, String status) {
		Bidder__c newBidder = new Bidder__c();
		newBidder.Opportunity__c	= opportunity.Id;
        newBidder.Distributor_Account__c = distributor.Id;
        newBidder.Contractor_Account__c = contractor.Id;
        newBidder.Unique_ID__c = opportunity.Id + '' + distributor.Id + '' + contractor.Id;
        newBidder.Status__c = status;
		return newBidder;
	}

	public static Tier__c createTestTier(){

		Tier__c testTier = new Tier__c();
		testTier.Maximum_Squares__c = 2499;
		testTier.Minimum_Squares__c = 1;
		testTier.Percentage_Tier_Invoices__c = 20.0;
		testTier.Tier_Label__c = 'Test Tier';
		testTier.Tier_Evaluation_Date__c = Date.today().addDays(30);
		insert testTier;
		return testTier;
	}
    
    public static OpportunityLineItem createOpportunityLineItemWithoutPriceStructure(Opportunity opportunity, Boolean insertData){
        Pricebook2 priceBook = createPricebook('Example Price Book', 'This is the Price Book description.', true, true);
		opportunity.Pricebook2Id = priceBook.id;
		update Opportunity;
		Product2 product = createProduct2('Example Product', 'This is the Product description.','Product Code', true,true); 
        // Get the Standard Price Book ID
        Id StandardPriceBookId =  Test.getStandardPricebookId(); 
        // Insert the Product in the Standard Price Book (if necessary)
        PricebookEntry standardPriceBookEntry = createPriceBookEntry(StandardPriceBookId,product.Id, 0.0,false,true,true);
		// Insert the Product in the New Price Book
		
        PricebookEntry priceBookEntry = createPriceBookEntry(priceBook.Id,product.Id, 100.0,false,true,true);
        OpportunityLineItem opportunityLineItem = createOpportunityLineItem(opportunity.Id, product ,priceBookEntry.Id,3,3.50,insertData);
        return opportunityLineItem;
    }

    public static Pricebook2 createPricebook(String name, String description,Boolean isActive, Boolean insertData) {
        Pricebook2 priceBook = new Pricebook2(
            Name = name,
            Description = description,
            IsActive = isActive
        );

        if (insertData){
            insert priceBook;    
        }
        return priceBook;
    }

    public static Product2  createProduct2(String name, String description, String productCode, Boolean isActive, Boolean insertData){
        // Create a Product
        Product2 product = new Product2(
            Name =name,
            Description = description,
            ProductCode = productCode,
            Unit_of_Measure__c = 'BD',
            IsActive = true
        );
        if (insertData){
            insert product;
        }
        return product;
    }

    public static PricebookEntry createPriceBookEntry(Id priceBook2Id, Id productId, Decimal unitPrice, Boolean useStandardPrice,Boolean isActive,Boolean insertData){
         PricebookEntry priceBookEntry = new PricebookEntry(
            Pricebook2Id = priceBook2Id,
            Product2Id =productId,
            UnitPrice = unitPrice,
            UseStandardPrice = useStandardPrice,
            IsActive = isActive
        );
        if (insertData){
            insert priceBookEntry;
        }
        return priceBookEntry;
    }

    public static OpportunityLineItem createOpportunityLineItem(Id opportunityId, Product2 product, Id priceBookEntryId, Integer quantity, Decimal unitPrice, Boolean insertData ){
        //Create the LineItem for the opportunity
        OpportunityLineItem newOpportunityLineItem = new OpportunityLineItem(
            OpportunityId = opportunityId,
            PricebookEntryId = priceBookEntryId,
            Product2Id = product.Id,
            Quantity = quantity,
            UnitPrice = unitPrice
        );
        if (insertData){
            insert newOpportunityLineItem;
        }
        return newOpportunityLineItem;
    }
}