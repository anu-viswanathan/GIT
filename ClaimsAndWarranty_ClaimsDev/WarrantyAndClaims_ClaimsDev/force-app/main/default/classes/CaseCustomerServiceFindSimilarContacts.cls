/**
 * @author: Aby Varghese, Birlasoft
 * @date: Nov 2020
 * @project: Customer Service Implementation
 * @description: Created for a LWC, that finds and displays contacts with a similar email id as Supplied Email (Email-To-Case).
 * The selected contact in the list will be associated with the case record, if the user clicks on the update button. 
 **/
public with sharing class CaseCustomerServiceFindSimilarContacts {
  @AuraEnabled(cacheable = true)
  // This method fetch the contacts with similar email id as Supplied Email. The parameter is the case id.
  public static List < Contact > fetchContactList(Id recordId) {
      try {
          String email = [SELECT SuppliedEmail from CASE where Id =: recordId].SuppliedEmail;
          return [SELECT Id, FirstName, LastName, Email,AccountName__c,Account_Address__c From Contact where Email =: email];
      } catch (Exception e) {
          System.debug('The following exception has occurred: ' + e.getMessage());
          return null;
      }

  }


  @AuraEnabled(cacheable = false)
  // This method associates the selected contact. The parameters are the selected contact id and the case id. 
  public static void updateContactInCase(Id caseId, Id contactId) {
      try {
          case caseRecord = new Case();
          caseRecord.Id = caseId;
          caseRecord.contactId = contactId;
          update caseRecord;
      } catch (Exception e) {
          System.debug('The following exception has occurred: ' + e.getMessage());
      }

  }
}