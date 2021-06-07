/**
 * @author: Aby Varghese, Birlasoft
 * @date: Nov 2020
 * @project: Customer Service Implementation
 * @description: Created for a LWC, that provides an option to search accounts and display in a list.
 * The selected account in the list will be associated with the case record, if the user clicks on the update button. 
 **/
public with sharing class CaseCustomerServiceSearchAccount {

    @AuraEnabled(Cacheable = true)
    // This method provides an option to search accounts. The parameter is the search string.
    public static list < Account > retriveAccs(String strAccName) {
        try {
            strAccName = '%' + strAccName + '%';
            list < Account > lstAccs = [SELECT Id, Name, Customer_Type__c, Phone, Type From Account WHERE Name LIKE: strAccName];

            if (lstAccs.isEmpty()) {
                throw new AuraHandledException('No Record Found..');
            }
            return lstAccs;
        } catch (Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            return null;
        }


    }

    @AuraEnabled(cacheable = false)
    // This method associates the selected account. The parameters are the selected account id and the case id.
    public static void updateCase(Id caseId, Id accountId) {
        try {
            case caseRecord = new Case();
            caseRecord.Id = caseId;
            caseRecord.accountId = accountId;
            update caseRecord;
        } catch (Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());

        }
    }
}