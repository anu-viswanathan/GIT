public with sharing class CaseCommentService {

    private static final String SYSTEM_ADMIN = 'System Administrator';
    private static final String ERROR_MESSAGE = 'Case Comments cannot be modified for a closed case';

    private static Profile userProfile;
    public static Profile getUserProfile() {
        if (CaseCommentService.userProfile == NULL) {
            CaseCommentService.userProfile = [
                    SELECT Id, Name
                    FROM Profile
                    WHERE Id = :UserInfo.getProfileId()
            ];
        }
        return userProfile;
    }

    Private static User runningUser;
    public static User getRunningUser() {
        if (CaseCommentService.runningUser == NULL) {
            CaseCommentService.runningUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
        }
        return runningUser;
    }

    /*
        Block Case Comments for Plant Users;
        Block Case Comments for Closed Cases, except for Claims team
    */
    public static void blockCreate(List<CaseComment> records) {
        User runningUser = getRunningUser();

        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        List<Id> caseIds = new List<Id>();

        Profile p = CaseCommentService.getUserProfile();

        if (p.Name.contains('Claims')) {
            return;
        }

        for (CaseComment record : records) {
            if (p.Name.contains('Plant') || p.Name.contains('Lab')) {
                record.addError('You are not allowed to add Comments');
            } else {
                caseIds.add(record.ParentId);
            }
        }

        if (caseIds.isEmpty()) {
            return;
        }

        Map<Id, Case> caseMap = new Map<Id, Case>([
                SELECT Id, RecordTypeId, Claim_Stage__c
                FROM Case
                WHERE Id IN :caseIds AND
                RecordTypeId IN :claimRecordTypes.keySet() AND
                Claim_Stage__c = 'Closed'
        ]);

        if (caseMap.isEmpty()) {
            return;
        }

        for (CaseComment record : records) {
            if (caseMap.get(record.ParentId) <> NULL && runningUser.Profile.Name != SYSTEM_ADMIN) {
                record.addError(ERROR_MESSAGE);
            }
        }
    }

    /*
        Block Case Comments Update/Delete for closed cases
    */
    public static void blockUpdateDelete(List<CaseComment> records) {
        User runningUser = getRunningUser();

        Map<Id, RecordType> claimRecordTypes = CaseService.getClaimRecordTypes();
        List<Id> caseIds = new List<Id>();

        for (CaseComment record : records)
            caseIds.add(record.ParentId);

        if (caseIds.isEmpty())
            return;

        Map<Id, Case> caseMap = new Map<Id, Case>([
                SELECT Id, RecordTypeId, Claim_Stage__c
                FROM Case
                WHERE Id IN :caseIds AND
                RecordTypeId IN :claimRecordTypes.keySet() AND
                Claim_Stage__c = 'Closed'
        ]);

        if (caseMap.isEmpty())
            return;

        for (CaseComment record : records) {
            if (caseMap.get(record.ParentId) <> NULL && runningUser.Profile.Name != SYSTEM_ADMIN) {
                record.addError(ERROR_MESSAGE);
            }
        }
    }

    /**
     * @description block users from modifiying case comments - IWCN573
     * @param caseComments List of new Case Comments
     */
    public static void blockEditCaseComments(List<CaseComment> caseComments) {
        User runningUser = getRunningUser();

        for (CaseComment caseComment : caseComments) {
            if (runningUser.Profile.Name != SYSTEM_ADMIN) {
                caseComment.addError('Case Comments cannot be modified.');
            }
        }
    } // end blockEditCaseComment method

    /**
     * @description block users from deleting case comments - IWCN573
     * @param caseComments List of old Case Comments
     */
    public static void blockDeletionCaseComments(List<CaseComment> caseComments) {
        User runningUser = getRunningUser();

        for (CaseComment caseComment : caseComments) {
            if (runningUser.Profile.Name != SYSTEM_ADMIN) {
                caseComment.addError('Case Comments cannot be deleted.');
            }
        }
    } // end blockDeletionCaseComment method

}