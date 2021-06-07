@istest
public class Test_Case_TriggerHandler {

    @testsetup static void createTestData() {
        SandboxSetup.sandboxSetup();
    }


    @istest static void organicCrackingHandSealTest() {
        

        Test.startTest();
        Case myCase  = [SELECT Id FROM Case 
                        WHERE Account.Name = 'Art Gallery of Ontario' 
                        AND Sector__c = 'CA' 
                        LIMIT 1];
        	// Manipulate the case so the Template Selection trigger fires 
        	myCase.Claim_Stage__c = 'Assessment';
        	myCase.Settlement_Type__c = 'Hand Seal';
        	myCase.Qualified__c = true;
	        
        update myCase;
        	
        Test.stopTest();
    }

@istest static void organicCrackingCashSettlementTest() {
        
        Test.startTest();
    Case myCase  = [SELECT Id FROM Case WHERE Account.Name = 'Art Gallery of Ontario' AND Sector__c = 'CA' LIMIT 1];
        
        	// Manipulate the case so the Template Selection trigger fires 
        	myCase.Claim_Stage__c = 'Assessment';
        	myCase.Settlement_Type__c = 'Cash Settlement';
	        	update myCase;
    		// test for the PRM date, whatever that is
    		// 1997-06-01
    		// First we test before the PRM 
    		myCase.Settlement_Type__c = 'Default';
    		myCase.Installation_Date__c = Date.newInstance(1996, 6,1);
    			update myCase;
    
    		myCase.Installation_Date__c = System.today().addYears(-5);
    		myCase.Iron_Clad_Period_Years__c = 10;
    			update myCase;
    
    		myCase.Installation_Date__c = System.today().addYears(-15);
    		myCase.Iron_Clad_Period_Years__c = 10;
    			update myCase;
    		
        Test.stopTest();
    }

@istest static void organicCrackingCashSettlementMaterialOnlyTest() {
         
        Test.startTest();
    Case myCase  = [SELECT Id FROM Case WHERE Account.Name = 'Art Gallery of Ontario' AND Sector__c = 'CA' LIMIT 1];
       
        	// Manipulate the case so the Template Selection trigger fires 
        	myCase.Claim_Stage__c = 'Assessment';
        	myCase.Settlement_Type__c = 'Cash Settlement - Material Only';
	        	update myCase;
        Test.stopTest();
    }

@istest static void romProductTypeJ() {
        
        Test.startTest();
     Case myCase  = [SELECT Id FROM Case WHERE Account.Name = 'Royal Ontario Museum' AND Sector__c = 'CA' LIMIT 1];
       
        	// Manipulate the case so the Template Selection trigger fires 
        	myCase.Claim_Stage__c = 'Assessment';
        	myCase.Settlement_Type__c = 'Cash Settlement - Material Only';
	        	update myCase;
        Test.stopTest();
    }
    
// Test the Louvre for product type K
// Louvre Museum
@istest static void louvreProductTypeK() {
        
        Test.startTest();
    Case myCase  = [SELECT Id FROM Case WHERE Account.Name = 'Louvre Museum' AND Sector__c = 'CA' LIMIT 1];
        
        	// Manipulate the case so the Template Selection trigger fires 
        	myCase.Claim_Stage__c = 'Assessment';
        	myCase.Settlement_Type__c = 'Cash Settlement - Material Only';
			myCase.Qualified__c = true;
	        	update myCase;
        Test.stopTest();
    }
    
@istest static void organicCrackingGoodwillTest() {
        
        Test.startTest();
     Case myCase  = [SELECT Id FROM Case WHERE Account.Name = 'Art Gallery of Ontario' AND Sector__c = 'CA' LIMIT 1];
       
        	// Manipulate the case so the Template Selection trigger fires 
        	myCase.Claim_Stage__c = 'Assessment';
        	myCase.Settlement_Type__c = 'Goodwill';
	        	update myCase;
        Test.stopTest();
    }
    
    
@istest static void organicGranuleQuebecCanadaTest() {
        
        Test.startTest();
     Case myCase  = [SELECT Id FROM Case WHERE Account.Name = 'Quebec National Assembly' AND Account.BillingStateCode = 'QC' LIMIT 1];
       
        	// Manipulate the case so the Template Selection trigger fires 
        	myCase.Claim_Stage__c = 'Assessment';
        	myCase.Settlement_Type__c = 'Cash Settlement';
    		myCase.Qualified__c = true;
	        	update myCase;
        Test.stopTest();
    }

// Guggenheim is a glass claim with product type B
@istest static void guggenheimGlassClaim() {
        
        Test.startTest();
      Case myCase  = [SELECT Id FROM Case WHERE Account.Name = 'Guggenheim' LIMIT 1];
      
        	// Manipulate the case so the Template Selection trigger fires 
        	myCase.Claim_Stage__c = 'Assessment';
        	myCase.Settlement_Type__c = 'Cash Settlement';
	        	update myCase;
    
    		myCase.Settlement_Type__c = 'Money or Material Offer';
    			update myCase;
    
    		myCase.Settlement_Type__c = 'Manual Calculation';
    			update myCase;

    Test.stopTest();
    }

// Guggenheim is a glass claim with product type D
@istest static void bilbaoGuggenhimClaim() {
        
        Test.startTest();
    Case myCase  = [SELECT Id FROM Case WHERE Account.Name = 'Guggenheim Bilbao' LIMIT 1];
        
        	// Manipulate the case so the Template Selection trigger fires 
        	myCase.Claim_Stage__c = 'Assessment';
        	myCase.Settlement_Type__c = 'Cash Settlement';
	        	update myCase;
        Test.stopTest();
    }

    
    @istest static void usSectorYankeeStadium() {
        
        Test.startTest();
         Case myCase  = [SELECT Id FROM Case WHERE Account.Name = 'Yankee Stadium' AND Sector__c = 'US' LIMIT 1];
       
        	// Manipulate the case so the Template Selection trigger fires
        	myCase.Claim_Stage__c = 'Offered';
				update myCase;
        Test.stopTest();
    }


    @isTest static void testThatCaseTemplate_Organic_REG_CS_EN_CA()
    {
       
        Test.startTest();
         Case myCase  = [SELECT Id FROM Case WHERE Account.Name = 'Art Gallery of Ontario' AND Sector__c = 'CA' LIMIT 1];

        	// Manipulate the case so the Template Selection trigger fires 
        	myCase.Claim_Stage__c = 'Assessment';
        	myCase.Settlement_Type__c = 'Cash Settlement';
            myCase.Preferred_Language__c = 'English'; 
            myCase.Sector__c = 'CA';
            update myCase;
        	
        Test.stopTest();
    }

   
}