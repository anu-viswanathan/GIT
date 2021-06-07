public class Case_TriggerHandler {

 // 2019-11-12 Commented out as this will become a post launch project
  	private static List<APXTConga4__Conga_Template__c> congaTemplates;
    
    /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application - START */
    private static Map<Id, RecordType> claimRecordTypes;
    
    public static Map<Id, RecordType> getClaimRecordTypes() {
        if (Case_TriggerHandler.claimRecordTypes == null)
            Case_TriggerHandler.claimRecordTypes = new Map<Id, RecordType>([select Id, Name, DeveloperName from RecordType where SobjectType = 'Case' and Name like '%Claim%']);
        return claimRecordTypes;
    }
    /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application - END */
    
    public static void setCongaTemplates(List<Case> records) {
        
		/* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application - START */
        Map<Id, RecordType> claimRecordTypes = Case_TriggerHandler.getClaimRecordTypes();
        
        // Create a map of all of our conga templates indexed by the "friendly name" so we can grab IDs
        if(congaTemplates == null)
        {
            congaTemplates = new List<APXTConga4__Conga_Template__c>([SELECT Id,
                                                                      Name,
                                                                      APXTConga4__Name__c,
                                                                      Template_Language__c
                                                                      FROM APXTConga4__Conga_Template__c]);
        }
        Map<String, APXTConga4__Conga_Template__c> englishCongaTemplatesByName = new Map<String, APXTConga4__Conga_Template__c>();
        Map<String, APXTConga4__Conga_Template__c> frenchCongaTemplatesByName = new Map<String, APXTConga4__Conga_Template__c>();
        Map<String, APXTConga4__Conga_Template__c> allCongaTemplatesByName = new Map<String, APXTConga4__Conga_Template__c>();
        
            for(APXTConga4__Conga_Template__c t : congaTemplates) {
                String name;
                name = t.APXTConga4__Name__c;
                
                if(t.Template_Language__c == 'English') {englishCongaTemplatesByName.put(name, t); }
                if(t.Template_Language__c == 'French') {frenchCongaTemplatesByName.put(name, t); }
                allCongaTemplatesByName.put(name, t);
                
            }
        
        System.Debug(englishCongaTemplatesByName);
        
        // We need data in the Account as well, so we're going to pull it and map it
        Set<Id> accountIds = new Set<Id>();
        Set<Id> claimIds = new Set<Id>();
        for(Case c : records) { 
            /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application */
            if (claimRecordTypes.get(c.RecordTypeId) <> null){
                accountIds.add(c.AccountId); // Billing location which is all we need
                // accountIds.add(c.Contractor__c);
                // accountIds.add(c.Distributor__c);
                
                claimIds.add(c.Id);
            }
        }
        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application - START */
        if(claimIds.isEmpty())
            return;
        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application - END */
        
       
        List<Account> allAccounts = new List<Account>([SELECT Id, Name, BillingStateCode, BillingCountryCode FROM Account WHERE Id IN :accountIds]);
        System.Debug(allAccounts);
        Map<String, Account> accountsByAccountId = new Map<String, Account>();
        for(Account a : allAccounts) {
            accountsByAccountId.put(a.Id, a);
        }
        
        List<Claim_Type__c> primaryClaimTypes = new List<Claim_Type__c>([SELECT Id, Case__c, 
                                                                   Concern__c, 
                                                                   Glass_Organic__c, 
                                                                   Product_Type__c 
                                                                   FROM Claim_Type__c WHERE Case__c IN :claimIds
                                                                   AND Is_Primary__c = true]);
		Map<Id, Claim_Type__c> claimTypeByCaseId = new Map<Id, Claim_Type__c>();
        for(Claim_Type__c c : primaryClaimTypes) {
            claimTypeByCaseId.put(c.Case__c, c);
        }
        
        
        
        for(Case c : records) {
            
            // Choose all our templates
			// 1 - [Glass] Offer-Release [REG] [CS] [IKO] [EN] [CA]
            //  Glass = Glass
            //  REG = no qualifying statement
            //  CS = Cash Settlement (offer type)
            //  IKO = brand
            //  EN = English
            //  CA = Canada
              
            if (c.Sector__c == 'US')
            {
                c.Template_Name_Automatic_Generated__c = '';
                c.Conga_Template_IDs__c = '';
                return;
            }
			String templateName;
            
            // All the templates start with 1 - right now which is because they were just files on a file server
            // So, annoying...but work with it for now.
            templateName = '1 - ';
            
      // 	Organics claim types are A, C, J, K
	  //	Glass are B, D
    		String productType;
            
            // This if condition should not be needed. Basically it says "if there's no primary claim type, don't do this"
            // By definition, there should be a primary claim type at this point but Slalom wrote some test classes that don't do this
            // See line 44 of SettlementConditionServiceTest which inserts new cases with a claim stage of Assessment
            // So, we work around 
            if(claimTypeByCaseId.containsKey(c.Id) == true) {
            	productType = claimTypeByCaseId.get(c.Id).Product_Type__c.left(1);
            }
    if(productType == 'A' 
       || productType == 'C'
       || productType == 'J' 
       || productType == 'K') {
                // This is an organic class action claim
                templateName += '[Org] Offer-Release ';
                    // Next we set based on the primary claim type
                    // 2020-01-17 Added check for whether the case is qualified
                    // Qualified is set manually by the Claims agent and can only be set if
                    // the concern is Cracking or Granule Loss
                    if(claimTypeByCaseId.get(c.Id).Concern__c == 'Cracking' && c.Qualified__c == true) {
                        templateName += '[CAC] ';
                    } else if (claimTypeByCaseId.get(c.Id).Concern__c == 'Granule Loss' && c.Qualified__c == true) {
                        templateName += '[CAG] ';
                    } else { 
                        templateName += '[REG] '; 
                           }
       		} else if(productType == 'B' || productType == 'D') {

                // This is a glass claim
                templateName += '[Glass] Offer-Release [REG] ';
            }


            
		// Settlement Type is next. Settlement Type is a field on the case
		// Default
        // Hand Seal
        // Cash Settlement
        // Cash Settlement - Material Only
        // Goodwill
        // Money or Material Offer
        // PRML Martin said said if installation was done before this date then PRML
        // PRM if months used is greater than Iron Clad period and installation date after '1997-06-01'
        // FR If the months used fall within the Iron Clad period and installation date after '1997-06-01'
        // HS
        // Manual Calculation
			if(claimTypeByCaseId.containsKey(c.Id) == true && claimTypeByCaseId.get(c.Id).Concern__c == 'Fishmouthing' ) {
            	templateName += '[HS-FM] ';
            }
            else
            {
                Datetime prmlInstallDate = Date.valueOf('1997-06-01'); 
                if(c.Settlement_Type__c == 'Default') {
                    if (c.Installation_Date__c < prmlInstallDate){
                        templateName += '[PRML] ' ; 
                    } 
                    //2020-07-30 Mark B added statement for ticket 770 adding checking if the iron clad years is not set
                    else if (c.Iron_Clad_Period_Years__c != null) {
	                    if (c.Installation_Date__c > prmlInstallDate && c.Num_of_Months_Product_Used__c > c.Iron_Clad_Period_Years__c * 12){
	                        templateName += '[PRM] ';
                    	} else if (c.Installation_Date__c > prmlInstallDate && c.Num_of_Months_Product_Used__c < c.Iron_Clad_Period_Years__c * 12){
                        	templateName += '[FR] ';
                    	}
                    }
                        
                    
                    //templateName += '[DEF] ';
                } else if (c.Settlement_Type__c == 'Hand Seal') {
                    templateName += '[HS] ';
                } else if (c.Settlement_Type__c == 'Cash Settlement') {
                    templateName += '[CS] ';
                } else if (c.Settlement_Type__c == 'Cash Settlement - Material Only') {
                    templateName += '[CSMO] ';
                } else if (c.Settlement_Type__c == 'Goodwill') {
                    templateName += '[GW] ';
                } else if (c.Settlement_Type__c == 'Money or Material Offer') {
                    templateName += '[MMO] ';
                } else if (c.Settlement_Type__c == 'Manual Calculation') {
                    templateName = '';
                    c.Template_Name_Automatic_Generated__c='';
                    c.Conga_Template_IDs__c = '';
                    return;
                }
            }
            
            
            // Brand, which is redundant but is in the file name so we're going to use IKO
            templateName += '[IKO] ';
            
            // Language is determined by the Preferred Language Field
            if(c.Preferred_Language__c == 'English' ) {
                templateName += '[EN] ';
            } else if (c.Preferred_Language__c == 'Quebec French') {
                templateName += '[FR] ';
            }
            
            // Geographical location which is determined by the building address
            if(accountsByAccountId.get(c.AccountId).BillingStateCode == 'QC'
              && accountsByAccountId.get(c.AccountId).BillingCountryCode == 'CA') {
              	templateName += '[QC]';
              } else if (accountsByAccountId.get(c.AccountId).BillingCountryCode == 'CA') {
                 templateName += '[CA]';
              }
            
            System.Debug('File Name: ' + templateName);
            c.Template_Name_Automatic_Generated__c = templateName;
            if(allCongaTemplatesByName.containsKey(templateName) == true) {
            	c.Conga_Template_IDs__c = allCongaTemplatesByName.get(templateName).Id;
            } else {c.Conga_Template_IDs__c = ''; }
            
            // c.Conga_Template_Group_Extension__c = templateCode;
        }        
        
    }

	// CLAIMSV2-780
	// Transferring the functionality of a process builder (which runs after) to a BEFORE trigger
	// 2020-02-03
	// The logic here should be revised to remove the reliance on the "Conga Bundles" and Conga Labour fields
	// Conga Bundles: IF(NOT(ISBLANK(Num_of_Bundles_for_Settlement__c)), Num_of_Bundles_for_Settlement__c , Suggested_Bundles_for_Settlement__c )
	// Conga Labour Cost: IF(NOT(ISBLANK( Actual_Labour_Settlement__c )), Actual_Labour_Settlement__c , Suggested_Labour_Settlement__c )

    public static void settlementGoodwillOfferText(List<Case> allCases) {
        
        /* CLAIMSV2 - 1031 - Logic to be executed only for cases with record types belonging to the Claims application - START */
        Map<Id, RecordType> claimRecordTypes = Case_TriggerHandler.getClaimRecordTypes();
        
        for(Case c : allCases) {
            if (claimRecordTypes.get(c.RecordTypeId) <> null){
                
                if(c.Conga_Bundles__c == 0) { 
    
                    // Set the English
                    c.Settlement_Goodwill_Offer_TextEN__c =  
                        'As a Goodwill gesture, ' 
                        + c.Brand_Short_Name__c  
                        + ' is willing to pay the sum of $' 
                        + c.Conga_Cash_Settlement_Total__c   
                        + ' (plus applicable taxes), to settle your claim'; 
                    //Set the French
                    c.Settlement_Goodwill_Offer_TextFR__c =
                        'En geste de bonne volonté, ' 
                        + c.Brand_Short_Name__c  
                        + ' vous payera une somme de ' 
                        + c.Conga_Cash_Settlement_Total__c   
                        + '$ (plus les taxes en vigueur) afin de régler votre plainte';
                        
                } else if (c.Conga_Bundles__c > 0 && c.Conga_Labour_Cost__c > 0) {
                    c.Settlement_Goodwill_Offer_TextEN__c =             
                        'As a Goodwill gesture, ' 
                        + c.Brand_Short_Name__c 
                        + ' is willing to provide ' 
                        + Integer.valueOf(c.Conga_Bundles__c)   
                        + ' bundles of ' 
                        +  c.Settlement_Goodwill_Replacement_Product__c 
                        + ' shingles, and $' 
                        + c.Actual_Labor_Total__c 
                        + ' (plus applicable taxes), to settle your claim';  
    
                    c.Settlement_Goodwill_Offer_TextFR__c = 
                        'En geste de bonne volonté, ' 
                        + c.Brand_Short_Name__c 
                        + ' vous offre ' 
                        + Integer.valueOf(c.Conga_Bundles__c)  
                        + ' paquets de bardeaux ' 
                        + c.Settlement_Goodwill_Replacement_Product__c 
                        + ' et la somme de ' 
                        + c.Actual_Labor_Total__c 
                        + ' $ (plus les taxes en vigueur) afin de régler votre plainte';
                    
            } else if (c.Conga_Bundles__c > 0 && c.Conga_Labour_Cost__c == 0) {
                c.Settlement_Goodwill_Offer_TextEN__c =
                    'As a Goodwill gesture, ' 
                    + c.Brand_Short_Name__c  
                    + ' is willing to provide ' 
                    +  Integer.valueOf(c.Conga_Bundles__c)  
                    + ' bundles of '
                    +  c.Settlement_Goodwill_Replacement_Product__c  
                    + ' shingles to settle your claim';
    
                c.Settlement_Goodwill_Offer_TextFR__c =
                    'En geste de bonne volonté, ' 
                    + c.Brand_Short_Name__c  
                    + ' vous offre ' 
                    +  Integer.valueOf(c.Conga_Bundles__c)  
                    + ' paquets de bardeaux ' 
                    +  c.Settlement_Goodwill_Replacement_Product__c  
                    + ' afin de régler votre réclamation';
            }
        }
    }
        
    }

}