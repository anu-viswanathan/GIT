public with sharing class ClaimTypeService {

    /*
        Block all updates for Case when the Claim_Stage__c is Closed, *unless* it is being re-opened
    */
    public static void blockCreatedUpdateDelete(List<Claim_Type__c> records) {
        User runningUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        List<Id> caseIds = new List<Id>();

        for (Claim_Type__c rp : records)
            caseIds.add(rp.Case__c);

        // SOQL query modified as part of US IWCN-723
        Map<Id, Case> caseMap = new Map<Id, Case>(
        [
                SELECT Id, RecordTypeId, Claim_Stage__c, Claim_Sub_Stage__c, ClaimApproved__c
                FROM Case
                WHERE Id IN :caseIds
                AND RecordTypeId IN :claimRecordTypes.keySet()
                AND
                (
                        Claim_Stage__c = 'Closed' OR
                        ClaimApproved__c = true OR
                        (Claim_Stage__c = 'Assessment' AND Claim_Sub_Stage__c = 'In Approval')
                )
        ]
        );

        if (caseMap.isEmpty()) {
            return;
        }

        for (Claim_Type__c rp : records) {
            Case caseRecord = caseMap.get(rp.Case__c);
            if (runningUser.Profile.Name != 'System Administrator') {
                if (caseRecord.Claim_Stage__c == 'Closed') {
                    rp.addError('Claim Types cannot be modified for a closed case');
                } else {
                    rp.addERror('Case Claim Types cannot be modifed after submitting for approval');
                }
            }
        }
    }


    // If the claim type being inserted is _not_ primary, make sure there
    // is a primary claim type related to the claim. If there isn't, set
    // this one to the Primary Claim Type
    // End result: there will always one primary claim type
    public static void setPrimary(List<Claim_Type__c> records) {

		System.Debug('Setting Primary Claim Type');
        
        Set<Id> caseIds = new Set<Id>();
        Set<Id> claimTypeIds = new Set<Id>();
        
        for (Claim_Type__c c : records) {
            caseIds.add(c.Case__c);
            claimTypeIds.add(c.Id);
        }
        // Build a list of claim types related to these cases that ARE primary
        // We're going to use list size to figure out whether to make this one primary
        List<Claim_Type__c> isPrimary = new List<Claim_Type__c>([
                SELECT Id, Case__c, Is_Primary__c, Product_Type__c, Concern__c, Case__r.Claim_Stage__c, Case__r.ClaimApproved__c, Case__r.Claim_Sub_Stage__c
                FROM Claim_Type__c
                WHERE Case__c IN :caseIds
                AND Is_Primary__c = TRUE
        ]);

        // if (isPrimary.isEmpty()) {
        //    return;
        // }
        // Turn this into a map so we can can use Contains Key

        // Loop through records and see check to see if there's an existing primary match in the map
        // if the map doesn't contain anything related to the case, there is no primary claim type so
        // we should set this one to be it

        // This is going to store the list of things we need to set to not primary
        // we're using the set because we get a duplicate ID error when more than one
        // Primary is loaded. Sets don't have duplicates. The problem relates only
        // mass data loads and will not happen in the real world, but this helped
        List<Claim_Type__c> otherClaimTypes = new List<Claim_Type__c>();
        Set<Claim_Type__c> uniqueClaim = new Set<Claim_Type__c>();

        for (Claim_Type__c c : records) {

            // If the insert of update is set to primary, we set any
            // other primary claims to false and update those records
            if (c.Is_Primary__c == true) {
                for (Claim_Type__c ct : isPrimary) {
                    // we're going to skip this record
                    if (ct.Id != c.Id) {
                        ct.Is_Primary__c = false;
                        uniqueClaim.add(ct);
                    }
                }

            } else {
                // If the insert or update is set to NOT primary, we check to make sure
                // a primary claim type exists. If it doesn't, make it so.
                Map<Id, Claim_Type__c> primaryClaimsbyCaseId = new Map<Id, Claim_type__c>();
                for (Claim_Type__c ct : isPrimary) {
                    primaryClaimsbyCaseId.put(c.Case__c, c);
                }

                if (primaryClaimsbyCaseId.containsKey(c.Case__c) == false) {
                    c.Is_Primary__c = true;
                }
            }

        }

        // Fun deduplication trick: convert the list to a set, which contains no duplicates, then convert it back to
        otherClaimTypes.addAll(uniqueClaim);
        Database.update(otherClaimTypes, false);
    }
    
    // This is inappropriately named. It sets the Primary and the Secondary
    public static void setPrimaryAndSecondary(List<Claim_Type__c> newClaimTypes, Map<Id, Claim_Type__c> oldClaimTypesByIds) {
         // if(checkRecursive.runOnce()) {
        System.Debug('Setting Secondary Claim Types');
        
        List<Case> casesToUpdate = new List<Case>();

        Set<Id> caseIds = new Set<Id>();
        
		// 2020-02-04
		// This is needed to accomodate a delete, which means the OLD claimtype IDs would have this
		// but not the new
        if (oldClaimTypesByIds != NULL) {
            caseIds = caseIdsBeforeUpdate(newClaimTypes, oldClaimTypesByIds);
        } else {
            caseIds = caseIdsBeforeInsert(newClaimTypes);
        }

        // 2019-02-04
        // This should not be needed. If it's empty, nothing will happen
        // if (caseIds.isEmpty()) {
        //     return;
        // }
	
        System.Debug('Getting all Secondary Claim Types');
		// Gets a list of all the claim types related to all the cases
        /* 
         * Map<Id, Claim_Type__c> relatedClaimTypes = new Map<Id, Claim_Type__c> ([
                SELECT Id, Is_Primary__c, Case__c, Product_Type__c, Concern__c
                FROM Claim_Type__c
                WHERE Case__c IN :caseIds
        ]);
*/		
        list<Claim_Type__c> allRelatedClaimTypes = new list<Claim_Type__c>([SELECT Id, 
                                                                            Is_Primary__c, 
                                                                            Case__c, 
                                                                            Product_Type__c, 
                                                                            Concern__c
                                                                            FROM Claim_Type__c
                                                                            WHERE Case__c IN :caseIds
                                                                            ORDER BY Product_Type__c ASC]);

		System.Debug('Claim Types ' + allRelatedClaimTypes.size());

            if (allRelatedClaimTypes.isEmpty()) {
            // It is the last Claim Type record that was deleted
            // update the Case Secondary Claim Type to NULL
            for (Id caseId : caseIds) {
                Case c = new Case();
                	c.Id = caseId;
                    c.Primary_Claim_Type__c = null;
                    c.Primary_Claim_Concern__c = null;
                    c.Secondary_Claim_Types__c = null;
                casesToUpdate.add(c);
            }
        } else {

            for(Id caseId : caseIds) {
                Case c = new Case();
                	c.Id = caseId;
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
            /* 2020-02-02 I have no idea what the purpose of this is - Skooter
             * Map<Id, List<Claim_Type__c>> caseToClaimTypes = new Map<Id, List<Claim_Type__c>>();
            for (Claim_Type__c claimTypeRecord : relatedClaimTypes.values()) {
                if (!caseToClaimTypes.containsKey(claimTypeRecord.Case__c)) {
                    caseToClaimTypes.put(claimTypeRecord.Case__c, new List<Claim_Type__c>());
                }
                caseToClaimTypes.get(claimTypeRecord.Case__c).add(claimTypeRecord);
            }
			*/

            /*or (Id caseId : caseToClaimTypes.keySet()) {
                Case caseRecord = new Case(Id = caseId);
                caseRecord.Secondary_Claim_Types__c = '';
                for (Claim_Type__c claimType : caseToClaimTypes.get(caseId)) {
                    caseRecord.Secondary_Claim_Types__c += claimType.Product_Type__c + ' - ' + claimType.Concern__c + ',';
                }
                caseRecord.Secondary_Claim_Types__c = caseRecord.Secondary_Claim_Types__c.removeEnd(',');
                casesToUpdate.add(caseRecord);
            }*/
        }
		// 2020-01-29 This isn't needed. An update with an empty list just does nothing
        // if (!casesToUpdate.isEmpty()) {
            update casesToUpdate;
        // }
        // }
    }
    
    // 2020-01-29 I have no idea what the original ticket for this 
    // but Prashanth says it's CLAIMSV2-379
    // which is imposssible to read

    //Populate the primary type field on the case record when the claim type record is changed/added    
    // George's original description ^^^^^^^^^^^^^^^^^^^^

    public static void setPrimaryTypeOnCaseRecords(final List<Claim_Type__c> allClaimTypes) {
		
        // check to prevent recurs
        if(checkRecursive.runOnce()) {

        // Build a set of all the IDs of related cases
        Set<Id> caseIds = new Set<Id>();
			// Changed the variable name from newClaimTypes to allClaimTypes because that's more accurate
			// This is an after update as well, so the claimtype isn't new
            for (Claim_Type__c claimTypeRecord : allClaimTypes) {
                if(claimTypeRecord.Is_Primary__c)
                {
                    caseIds.add(claimTypeRecord.Case__c);
                }
            }
        	System.Debug('Set Size: ' + caseIds.size());
        
		// Get all the related cases and create a map
		// This means each case will appear only once
		// 2020-01-29 I believe this query is not needed at all. We already have all of the claimsIDs
        // Map<Id, Case> casesByCaseId = new Map<Id, Case>([SELECT Id, Primary_Claim_Type__c, Primary_Claim_Concern__c 
        //                                                 FROM Case WHERE Id =:caseIds]);
			// System.Debug('Map Size: ' + casesByCaseId.size());
        
        // Create a list to add cases to so we can do an update
        List<Case> casesToUpdate = new List<Case>();
		Set<Id> casesToUpdateIds = new Set<Id>();
        
        for (Claim_Type__c ct : allClaimTypes) {
            // This will never be null (it throws an error if it's missing)
            // it's also based on a query that's not needed
            	// Case c = casesByCaseId.get(claimTypeRecord.Case__c);
            	// if(c != null)

            // We only up date the case if the Claim Type is:
           	// - Primary
           	// - We haven't already updated it (because duplicate IDs aren't allowed in lists)
			if(ct.Is_Primary__c == true && casesToUpdateIds.contains(ct.Case__c) == false) {
                Case c = new Case();
                	c.Id = ct.Case__c;
                	c.Primary_Claim_Type__c = ct.Product_Type__c;
                	c.Primary_Claim_Concern__c = ct.Concern__c;
                casesToUpdate.add(c);
                // Add it to the set so we know we've already done this one
                // This means the _first_ primary inserted will be the one
                // that sets the case
                casesToUpdateIds.add(ct.Case__c);
            }
        }
        
        // This isn't needed. It won't run if the list is zero
        // if(casesToUpdate.size() > 0)
        // {
        	update casesToUpdate;    
        // }
        }
    }

    private static Set<Id> caseIdsBeforeInsert(final List<Claim_Type__c> newClaimTypes) {

        Set<Id> caseIds = new Set<Id>();

        for (Claim_Type__c claimTypeRecord : newClaimTypes) {
            caseIds.add(claimTypeRecord.Case__c);
        }

        return caseIds;
    } // end caseIdsBeforeInsert method

    private static Set<Id> caseIdsBeforeUpdate(final List<Claim_Type__c> newClaimTypes, final Map<Id, Claim_Type__c> oldClaimTypesByIds) {

        Set<Id> caseIds = new Set<Id>();

        for (Claim_Type__c claimTypeRecord : newClaimTypes) {
            String oldProductType = oldClaimTypesByIds.get(claimTypeRecord.Id).Product_Type__c;
            String oldConcern = oldClaimTypesByIds.get(claimTypeRecord.Id).Concern__c;
			Boolean isPrimary = oldClaimTypesByIds.get(claimTypeRecord.Id).Is_Primary__c;
            if (claimTypeRecord.Product_Type__c != oldProductType || claimTypeRecord.Concern__c != oldConcern || claimTypeRecord.Is_Primary__c != isPrimary ) {
                caseIds.add(claimTypeRecord.Case__c);
            }
        }

        return caseIds;

    } // end caseIdsBeforeUpdate method
    
    }