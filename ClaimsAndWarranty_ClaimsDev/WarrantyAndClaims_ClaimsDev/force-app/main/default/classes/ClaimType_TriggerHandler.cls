public class ClaimType_TriggerHandler {
    // This is inappropriately named. It sets the Primary and the Secondary
    public static void setPrimaryAndSecondary(List<Claim_Type__c> newClaimTypes, Map<Id, Claim_Type__c> oldClaimTypesByIds) {
         // if(checkRecursive.runOnce()) {
        System.Debug('Setting Secondary Claim Types');
        
        List<Case> casesToUpdate = new List<Case>();

        Set<Id> caseIds = new Set<Id>();
        
		// 2020-02-04
		// add the new claim types to the list
        for(Claim_Type__c ct : newClaimTypes) {
            caseIds.add(ct.Case__c);
        }
		// Convert the trigger old map to a list and iterate through it
		// sets are unique, so we don't have to do any deduplication here
        if(oldClaimTypesByIds != null) {
            for(Claim_Type__c ct : oldClaimTypesByIds.values()) {
    	        caseIds.add(ct.Case__c);
	    	    }
        	}

        System.Debug('Getting all The Claim Types');
		// Gets a list of all the claim types related to all the cases
        list<Claim_Type__c> allRelatedClaimTypes = new list<Claim_Type__c>([SELECT Id, 
                                                                            Is_Primary__c, 
                                                                            Case__c, 
                                                                            Product_Type__c, 
                                                                            Concern__c
                                                                            FROM Claim_Type__c
                                                                            WHERE Case__c IN :caseIds
                                                                            ORDER BY Product_Type__c ASC]);

		System.Debug('Claim Types ' + allRelatedClaimTypes.size());

			// Loop through all our CaseIds. Start by clearing the current values in the fields
            for(Id caseId : caseIds) {
                Case c = new Case();
                	c.Id = caseId;
                	c.Primary_Claim_Concern__c = '';
                	c.Primary_Claim_Type__c = '';
                	c.Secondary_Claim_Types__c = '';

				// loop through claim types
				// using a nested loop to first get a claim ID then to loop throgh a claim type
				// don't love this but...alternatives? Maps are unique by ID, so...
                for(Claim_Type__c ct : allRelatedClaimTypes) {
                    if(ct.Case__c == c.Id) {
                        if(ct.Is_Primary__c == true) {
                            System.Debug('Primary');
                            c.Primary_Claim_Type__c = ct.Product_Type__c;
                            c.Primary_Claim_Concern__c = ct.Concern__c;
                        } else {
                            c.Secondary_Claim_Types__c += ct.Product_Type__c + ' - ' + ct.Concern__c + ', ';
                            System.Debug('Secondary');
                        }
                    }
					
            }
                // this just strips the final ', '
                c.Secondary_Claim_Types__c = c.Secondary_Claim_Types__c.left(c.Secondary_Claim_Types__c.length() - 2);

            casesToUpdate.add(c);
            }
        
            update casesToUpdate;
    }

}