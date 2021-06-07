/**
 * @description Sharinpix images controller based on the Logged in User profile and the Claim Stage and Sub Stage
 * @author Sinan Bunni
 * @date 16/09/2019
 */
public with sharing class SharinPixPermissionsController {

    private static final String EMPTY = '';
    private static final String CASEOBJECT = 'Case';
    private static final String LABSAMPLEOBJECT = 'Lab_Sample__c';

    private static String profileName {
        get {
            if (profileName == NULL) {
                profileName = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name;
            }

            return profileName;
        }
        set;
    }

    /**
     * @description Security: Determine SharinPix permission set to apply to Case/ Lab Sample
     * Leverages the Claims_Config__c custom setting to determine the
     * appropriate permission id to return to the sharinPixWrapper component.
     * Returns the sharinPix permissions (annotate, read only or upload) based on
     * Claim Stage, Claim Sub Stage and logged in profile name
     *
     * @param recordId object Id passed in by the @see sharinPixWrapper lightning component
     * @param objectName object name passed in by the @see sharinPixWrapper lightning component
     *
     * @return String represents the sharingPix permissions Id
     */
    @AuraEnabled
    public static String getSharinPixPermissions(final Id recordId, final String objectName) {

        String sharinPixPermission = EMPTY;

        if (objectName == CASEOBJECT) {
            Case caseRecord = [
                    SELECT Id, Claim_Stage__c, Claim_Sub_Stage__c
                    FROM Case
                    WHERE Id = :recordId
            ];
            sharinPixPermission = getSharinPixPermissionId(caseRecord.Claim_Stage__c, caseRecord.Claim_Sub_Stage__c);
        } else if (objectName == LABSAMPLEOBJECT) {
            Lab_Sample__c labSample = [
                    SELECT Case__c, Case__r.Claim_Stage__c, Case__r.Claim_Sub_Stage__c
                    FROM Lab_Sample__c
                    WHERE Id = :recordId
                    LIMIT 1
            ];
            String claimStage = labSample.Case__r.Claim_Stage__c;
            String claimSubStage = labSample.Case__r.Claim_Sub_Stage__c;

            sharinPixPermission = getSharinPixPermissionId(claimStage, claimSubStage);
        }

        return sharinPixPermission;

    } // end getSharinPixPermissionId method

    /**
     * @description Get the CaseId associatd with the Lab Sample
     * @param labSampleId Lab Sample Id
     * @return parent CaseId to the Lab Sample record
     */
    @AuraEnabled
    public static String getCaseIdByLabSampleId(String labSampleId) {
        if (labSampleId == NULL) {
            return EMPTY;
        }

        return [SELECT Case__c FROM Lab_Sample__c WHERE Id = :labSampleId LIMIT 1].Case__c;
    } // end getCaseIdByLabSampleId method

    /**
     * @description Retrieve the SharinPix Permission Id
     *
     * @param recordId object Id passed in by the @see sharinPixWrapper lightning component
     * @param claimStage object name passed in by the @see sharinPixWrapper lightning component
     *
     * @return String resprests the sharingPix Permission Id
     */
    private static String getSharinPixPermissionId(final String claimStage, final String claimSubStage) {

        String sharinPixPermission = EMPTY;

        try {
            if (claimStage == 'Draft') {
                //ClaimsV2-1029 Nov 30, 2020 Vicki Tran..Plant users can only 'read' at 'Draft' stage
                if (profileName.contains('Plant')) {
                    sharinPixPermission = Claims_Config__c.getOrgDefaults().SharinPix_Read_Only_Permission__c;
                }
                else
                {
                	sharinPixPermission = Claims_Config__c.getOrgDefaults().SharinPix_Annotate_Permission_Id__c;
                }
            }

            if (claimStage == 'Submitted' || claimStage == 'Awaiting Docs' || claimStage == 'In Kankakee' ||
                    (claimStage == 'In Lab' && (claimSubStage != 'In Approval' || claimSubStage != 'Approved'))) {
                if (profileName.contains('Lab')) {
                    sharinPixPermission = Claims_Config__c.getOrgDefaults().SharinPix_Annotate_Permission_Id__c;
                } else if (profileName.contains('Claim')) {
                    sharinPixPermission = Claims_Config__c.getOrgDefaults().SharinPix_Upload_Only_Permission__c;
                } else {
                    sharinPixPermission = Claims_Config__c.getOrgDefaults().SharinPix_Read_Only_Permission__c;
                }
            }

            if (claimStage == 'File Preparation' || claimStage == 'Assessment' || claimStage == 'Offered' || claimStage == 'Payment' ||
                    (claimStage == 'In Lab' && (claimSubStage == 'In Approval' || claimSubStage == 'Approved'))) {
                if (profileName.contains('Claim')) {
                    sharinPixPermission = Claims_Config__c.getOrgDefaults().SharinPix_Upload_Only_Permission__c;
                } else {
                    sharinPixPermission = Claims_Config__c.getOrgDefaults().SharinPix_Read_Only_Permission__c;
                }
            }

            if (claimStage == 'Closed') {
                sharinPixPermission = Claims_Config__c.getOrgDefaults().SharinPix_Read_Only_Permission__c;
            }
        } catch (Exception exp) {
            System.debug('getSharinPixPermissionId: error = ' + exp.getMessage());
        }

        return sharinPixPermission;
    } // end getSharinPixPermissionId method

} // end SharinPixPermissionsController class