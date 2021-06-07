public with sharing class RelatedProductService {

    public static void blockRecordDeletion(List<Related_Product__c> records) {
        Set<Id> caseIds = new Set<Id>();
        for (Related_Product__c relatedProduct : records) {
            caseIds.add(relatedProduct.Case__c);
        }

        Map<Id, Case> caseMap = new Map<Id, Case>([
                SELECT Id, ClaimApproved__c
                FROM Case
                WHERE Id IN :caseIds
        ]);

        if (caseMap.isEmpty()) {
            return;
        }

        for (Related_Product__c relatedProduct : records) {
            if (caseMap.get(relatedProduct.Case__c).ClaimApproved__c != NULL && caseMap.get(relatedProduct.Case__c).ClaimApproved__c) {
                relatedProduct.addError('Related Product cannot be deleted after the Case has been approved');
            }
        }
    }

    /*
        Block all updates for Case when the Claim_Stage__c is Closed, *unless* it is being re-opened
    */
    public static void blockCreatedUpdateDelete(List<Related_Product__c> records) {
        User runningUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];

        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        List<Id> caseIds = new List<Id>();

        for (Related_Product__c rp : records)
            caseIds.add(rp.Case__c);

        // SOQL query modified as part of US IWCN-723
        Map<Id, Case> caseMap = new Map<Id, Case>(
        [
                SELECT Id, RecordTypeId, Claim_Stage__c, ClaimApproved__c, Claim_Sub_Stage__c
                FROM Case
                WHERE Id IN :caseIds
                AND RecordTypeId IN :claimRecordTypes.keySet()
                AND (
                        Claim_Stage__c = 'Closed' OR
                        ClaimApproved__c = true OR
                        (Claim_Stage__c = 'Assessment' AND Claim_Sub_Stage__c = 'In Approval')
                )
        ]
        );

        if (caseMap.isEmpty())
            return;

        for (Related_Product__c rp : records) {
            Case caseRecord = caseMap.get(rp.Case__c);
            if (runningUser.Profile.Name != 'System Administrator') {
                if (caseRecord.Claim_Stage__c == 'Closed') {
                    rp.addError('Case Products cannot be modified for a closed case');
                } else {
                    rp.addERror('Case Products cannot be modified after submitting for approval');
                }
            }
        }
    }

    /*
        CLAIMS -75. Populate field on related case based on quantities of related products
    */
    public static void calculateTotalCostOfSettlementItemsOnRelatedCase(List<Related_Product__c> relatedProducts) {

        Id settlementTypeId = Schema.SObjectType.Related_Product__c.getRecordTypeInfosByName().get('Settlement Items').getRecordTypeId();
        Set<Id> relatedCaseIds = new Set<Id>();
        List<Case> casesToUpdate = new List<Case>();
        Map<Id, Case> casesByIds = new Map<Id, Case>();

        for (Related_Product__c eachRelatedProduct : relatedProducts) {
            if (eachRelatedProduct.Quantity__c != NULL && eachRelatedProduct.RecordTypeId == settlementTypeId) {
                relatedCaseIds.add(eachRelatedProduct.Case__c);
            }
        }


        if (relatedCaseIds.isEmpty()) {
            return;
        }


        List<Case> casesList = new List<Case>([
                SELECT Id,Total_Cost_of_Additional_Settlement_Item__c,Bundle_Rate__c
                FROM Case
                WHERE Id IN :relatedCaseIds
        ]);

        if (casesList.isEmpty()) {
            return;
        }

        //create map from List
        for (Case tCase : casesList) {
            casesByIds.put(tCase.Id, tCase);
        }

        List<AggregateResult> agr = [
                SELECT Case__c,SUM(Quantity__c) sumOfRelatedProducts
                FROM Related_Product__c
                WHERE Case__c IN :relatedCaseIds
                GROUP BY Case__c
        ];

        if (agr.isEmpty()) {
            for (Case thisCase : casesList) {
                thisCase.Total_Cost_of_Additional_Settlement_Item__c = 0.00;
                casesToUpdate.add(thisCase);
            }
        } else {
            for (AggregateResult eachRelatedProduct : agr) {
                Case thisCase = casesByIds.get((Id) eachRelatedProduct.get('Case__c'));
                thisCase.Total_Cost_of_Additional_Settlement_Item__c = Double.valueOf(eachRelatedProduct.get('sumOfRelatedProducts'))
                        * thisCase.Bundle_Rate__c;
                casesToUpdate.add(thisCase);
            }
        }

        update casesToUpdate;

    }
}