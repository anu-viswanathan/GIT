/**
 * @description Handler for all the Contact Trigger actions
 * @author Sinan Bunni
 * @date 25/04/2019
 */
public class ContactService {

    /**
     * @description Throw validation error message when any user (except System Administrator or Claims Manager)
     * 		tries to update an Contact associated with Submitted Cases
     * @param accounts Trigger.new account list
     */
    public static void validateBuildingLocationContactsWithNotInDraftCaseStatus(List<Contact> contacts) {
        User runningUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];

        Map<Id, Case> casesByIdsMap = new Map<Id, Case>([
                SELECT Id, Claim_Stage__c, ContactId
                FROM Case
                WHERE ContactId IN :contacts AND Claim_Stage__c = 'Submitted'
        ]);

        if (casesByIdsMap.isEmpty()) {
            return;
        }

        Map<Id, Case> contactIdsByCases = new Map<Id, Case>();

        for (Case caseRecord : casesByIdsMap.values()) {
            contactIdsByCases.put(caseRecord.ContactId, caseRecord);
        }

        for (Contact contactRecord : contacts) {
            if (runningUser.Profile.Name == 'System Administrator' ||
                    runningUser.Profile.Name.contains('Claims') ||
                    !contactIdsByCases.containsKey(contactRecord.Id)) {
                return;
            } else {
                contactRecord.addError('This record cannot be edited because it is associated with a submitted Case');
            }
        }
    }// validateBuildingLocationContactsWithNotInDraftCaseStatus method

} // end ContactService class