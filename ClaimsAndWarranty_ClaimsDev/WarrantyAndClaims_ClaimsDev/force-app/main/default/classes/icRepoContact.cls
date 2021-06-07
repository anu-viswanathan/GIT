/**
 * Created by Francois Poirier on 2018-12-07.
 */

public with sharing class icRepoContact implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {

        Contact getContactById(Id contactId);
        Contact getContactsForVendorEmailById(String contactId, Schema.FieldSet vendorEmailFieldSet);
        List<Contact> getPrimaryAdminContactsByContractorIds(List<String> contractorIds);
        Contact saveContact(Contact record);
    }

    public class Impl implements IClass {

        public Contact getContactById(Id contactId){

            List<Contact> contacts = new List<Contact>();
            Contact retour = new Contact();

            contacts = [
                    SELECT  Id,
                            AccountId,
                            Email,
                            FirstName,
                            LastName,
                            MailingStreet,
                            MailingAddress,
                            MailingCity,
                            MailingStateCode,
                            MailingCountryCode,
                            MailingPostalCode,
                            Phone
                    FROM    Contact
                    WHERE   Id =: contactId
            ];

            if(contacts.size()>0){
                retour = contacts[0];
            }

            return retour;

        }

        public Contact getContactsForVendorEmailById(String contactId, Schema.FieldSet vendorEmailFieldSet) {
            String query = 'SELECT ';
            if(vendorEmailFieldSet != null) {
                for(Schema.FieldSetMember field : vendorEmailFieldSet.getFields()) {
                    query += field.getFieldPath() + ', ';
                }
            }
            System.debug('query : ' + query);
            query += 'Id, Name,Company_Name_Applicant__c, Country_Code_Applicant__c, Account.BillingCountryCode FROM Contact WHERE Id = \'' + contactId + '\' LIMIT 1';
            //, Company_Name_Applicant__c, Primary_Contact_Name_Applicant__c, Company_Phone_Applicant__c, Company_Email_Applicant__c, Tier_Level_Applicant__c

            List<sObject> sobjList = Database.query(query);
            
            if(sobjList.size() > 0) {
                return (Contact)sobjList[0];
            } else {
                return null;
            }
        }

        public List<Contact> getPrimaryAdminContactsByContractorIds(List<String> contractorIds) {
            return [SELECT Id, AccountId
                    FROM Contact
                    WHERE Role__c = 'Primary Contact'
                    AND AccountId IN :contractorIds
                    AND Salesforce_User__r.Profile.Name = 'IKOPRO Contractor Admin'
            ];
        }

        public Contact saveContact(Contact record){

            upsert record;
            return record;

        }
    }


}