public with sharing class WarrantyService {
	public static final String LABORANDMEMBRANE_WARRANTYTYPE = 'Labor & Membrane';
    /*
        Used to generate a sequence number for the Warranty Registration Id value;
        uses the Contractor’s Billing Address State Code (e.g. “ON”, “AB”)
    */
    public static void setSequencePrefix(List<Warranty__c> records) {
        List<Id> accountIds = new List<Id>();

        for (Warranty__c w : records) {
			if (w.Registration_Prefix__c == null) {
				accountIds.add(w.Contractor__c);
			}
		}

        if (accountIds.isEmpty()) {
			return;
		}

        Map<Id, Account> accountMap = new Map<Id, Account>([select Id, BillingStateCode from Account where Id in :accountIds AND BillingStateCode <> null]);
        if (accountMap.isEmpty()) {
			return;
		}

        for (Warranty__c w : records) {
			if (w.Registration_Prefix__c == null) {
				w.Registration_Prefix__c = (accountMap.get(w.Contractor__c) <> null) ? accountMap.get(w.Contractor__c).BillingStateCode : null;
			}
		}
    } // end setSequencePrefix method

    /*
        Used to generate a Warranty Registration Id value,
        by determining a sequence number
        (based on the highest existing sequence for the Contractor’s Billing State Code)
        and generates a value in the format {Billing State Code}-{Sequence Number}-{YYYY},
        e.g.
        •	ON-10005-2019
        •	AB-10004-2019
        •	AB-10005-2019
    */
    public static Integer defaultRegistrationNumber = 10000;
    public static void generateRegistrationNumber(List<Warranty__c> records) {
        List<Warranty__c> registrationRecords = new List<Warranty__c>();
        List<Id> contractorIds = new List<Id>();

        for (Warranty__c w : records) {
            if (!String.isBlank(w.Contractor__c) && String.isBlank(w.Warranty_Registration_Id__c)) {
                registrationRecords.add(w);
                contractorIds.add(w.Contractor__c);
            }
        }

        if (registrationRecords.isEmpty()) {
			return;
		}

        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, BillingStateCode FROM Account WHERE Id IN :contractorIds]);

        Map<String, Integer> sequenceMap = new Map<String, Integer>();
        for (AggregateResult ar : [
				SELECT Registration_Prefix__c, MAX(Sequence_Number__c)
				FROM Warranty__c
				WHERE Registration_Prefix__c <> NULL
				GROUP BY Registration_Prefix__c]) {
			sequenceMap.put(String.valueOf(ar.get('Registration_Prefix__c')), Integer.valueOf(ar.get('expr0')));
		}

        for (Warranty__c w : registrationRecords) {
            if (accountMap.get(w.Contractor__c) <> null && accountMap.get(w.Contractor__c).BillingStateCode <> null) {
                Integer currentSequence = (sequenceMap.get(w.Registration_Prefix__c) <> null) ?
                        sequenceMap.get(w.Registration_Prefix__c) + 1 :
                        WarrantyService.defaultRegistrationNumber;

                w.Sequence_Number__c = currentSequence;
                w.Warranty_Registration_Id__c = w.Registration_Prefix__c + '-' + w.Sequence_Number__c + '-' + Date.today().year();
                sequenceMap.put(w.Registration_Prefix__c, currentSequence);

            }
        }
    } // end generateRegistrationNumber method
    
    /* Ticket CLAIMSV2-624
     * Added conditions to display error Message when submitting record for Approval,
     * By: Anil Mannem (Incloud) on 12-May-2020
     */
    public static void validateApprovalSubmission(List<Warranty__c> warrantyList, Map<Id, Warranty__c> warrantyOldMap) {
        String errMsg = '';
        for(Warranty__c thisWarranty : warrantyList) {
            Warranty__c oldWarranty = warrantyOldMap.get(thisWarranty.id);
            if(thisWarranty.Warranty_Substatus__c == 'In Approval') {
                if(thisWarranty.Warranty_Status__c != 'In Progress') {
                    errMsg += System.Label.Approval_Warranty_Status;
                }
                if(thisWarranty.Warranty_Start_Date__c == NULL) {
                    errMsg += System.Label.Approval_Warranty_StartDate;
                }
                if(thisWarranty.Type__c == 'Labor & Membrane') {
                    if(oldWarranty.Warranty_Substatus__c != 'In Review') {
                        errMsg += System.Label.Approval_Labor_Membrane_Warranty_Substatus; 
                    }    
                }
                if(thisWarranty.Type__c == 'Diamond Shield') {
                    if(oldWarranty.Warranty_Substatus__c != 'Payment Received') {
                        errMsg += System.Label.Approval_DiamondShield_Warranty_Substatus;
                    }                
                    if(thisWarranty.Installation_Deficiency_Status__c != 'No Deficiencies' && thisWarranty.Installation_Deficiency_Status__c != 'Repairs Completed') {
                        errMsg += System.Label.Approval_Warranty_InstallationDeficiencyStatus;
                    }
                }
            }
            if(String.isNotBlank(errMsg)) {
                thisWarranty.addError(errMsg);
            }
        }
    } // end of validateApprovalSubmission
    
    
    //ClaimsV2-786
    //By Vicki Tran on July 15, 2020
    public static void UpdateWarrantyExpired (List<Warranty__c> records, Map<Id, Warranty__c> oldRecords)
    {
        Integer i = 0;
        for (Warranty__c w : records) {
            i++;
            if (w.Warranty_Expiry_Date__c != null && w.Warranty_Expiry_Date__c < Date.today())
            {
                w.Expired__c = 'Yes';
                w.Warranty_Expired_Date__c = string.valueofGmt(DateTime.now()) + '_' + string.valueOf(i);
            }
            else if (w.Warranty_Substatus__c == 'Not Issued')
            {
                w.Expired__c = 'Yes';
                w.Warranty_Expired_Date__c = string.valueofGmt(DateTime.now()) + '_' + string.valueOf(i);
            }
            else 
            {
                w.Expired__c = 'No';
                w.Warranty_Expired_Date__c = null;
            }
        }
    }

    
    
    
}