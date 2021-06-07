/**
 * Created by Francois Poirier on 2018-12-07.
 */

public with sharing class icLogicContact implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {
        Contact getContactById(Id contactId);
        List<Contact> getPrimaryAdminContactsByContractorIds(List<String> contractorIds);
        Map<String, Contact> getMapPrimaryAdminContactByContractorId(List<Contact> contacts);
        Contact saveContact(Contact record);
        void handleVendorEmail(String contactId);
    }

    public class Impl implements IClass {

        private icRepoContact.IClass repoContact = (icRepoContact.IClass) icObjectFactory.GetSingletonInstance('icRepoContact');

        public Contact getContactById(Id contactId) {

            return repoContact.getContactById(contactId);

        }

        public List<Contact> getPrimaryAdminContactsByContractorIds(List<String> contractorIds) {
            return repoContact.getPrimaryAdminContactsByContractorIds(contractorIds);
        }

        public Map<String, Contact> getMapPrimaryAdminContactByContractorId(List<Contact> contacts) {
            Map<String, Contact> returnMap = new Map<String, Contact>();

            for(Contact thisContact : contacts) {                
                if(!returnMap.containsKey(thisContact.AccountId)) {
                    returnMap.put(thisContact.AccountId, thisContact);
                }
            }

            return returnMap;
        }

        public Contact saveContact(Contact record){

            return repoContact.saveContact(record);
            
        }

        public void handleVendorEmail(String contactId) {
            icLogicTask.IClass logicTask = (icLogicTask.IClass) icObjectFactory.GetSingletonInstance('icLogicTask');
            icLogicEmail.IClass logicEmail = (icLogicEmail.IClass) icObjectFactory.GetSingletonInstance('icLogicEmail');
            icLogicConfig.IClass logicConfig = (icLogicConfig.IClass) icObjectFactory.GetSingletonInstance('icLogicConfig');
            icLogicUser.Iclass logicUser =  (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');
            Iko_Global_Configurations__mdt globalConfig = logicConfig.getIkoGlobalConfigByName('Global');

            //IKO-96
            //OrgWideEmailAddress ikoRoofProOrgWideDefault = logicEmail.getOrgWideEmailByName('IKO ROOFPRO');

            Map<String, Messaging.EmailFileAttachment> mapAttachmentByContactId = new Map<String, Messaging.EmailFileAttachment>();
            String headerColNames;

            Map<String, Schema.FieldSet> mapFieldSets = Schema.SObjectType.Contact.fieldSets.getMap();
            Schema.FieldSet vendorFieldSet = mapFieldSets.get('Vendor_Field_Set_Applicant');

            Contact thisContact = repoContact.getContactsForVendorEmailById(contactId, vendorFieldSet);

            String accountCountry = thisContact.Country_Code_Applicant__c;
            String thisVendorEmail = globalConfig.Default_Vendor_Email__c;
            if(accountCountry == 'US') {
                thisVendorEmail = globalConfig.Vendor_Email_US__c;
            }
            if(accountCountry == 'CA') {
                thisVendorEmail = globalConfig.Vendor_Email_CA__c;
            }
            
            EmailTemplate template = logicEmail.getEmailTemplateByDevName('IKO_ROOFPRO_Personalized_Marketing_Material_Request');

            if(vendorFieldSet != null) {
                for(Schema.FieldSetMember sfField : vendorFieldSet.getFields()) {
                    if(String.isBlank(headerColNames)) {
                        headerColNames = sfField.getLabel();
                    } else {
                        headerColNames += ',' + sfField.getLabel();
                    }
                }
            
                String thisContactValues;
                for(Schema.FieldSetMember sfField : vendorFieldSet.getFields()) {
                    
                    String contactFieldValue = String.valueOf(thisContact.get(sfField.getFieldPath()));
                    if(contactFieldValue == null) {
                        contactFieldValue = 'Not Entered';
                    }

                    if(String.isBlank(thisContactValues)) {
                        thisContactValues = '"' + contactFieldValue + '"';
                    } else {
                        thisContactValues += ',"' + contactFieldValue + '"';
                    }
                }
                
                //IKO-262 - Replace Curly/Smart Quote to a Single Quote, avoiding Excel to badly convert the special '’' character  when user opens a csv file in excel.    
                if(thisContactValues != null) {
                    thisContactValues = thisContactValues.replaceAll('’', '\'');
                }
                
                Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                Blob csvBlob = Blob.valueOf(headerColNames + '\n' + thisContactValues);
                String csvname = thisContact.Company_Name_Applicant__c + '.csv';    //IKO 235 - from contact name to company name
                csvAttc.setFileName(csvname);
                
                //IKO -235 Rendering the contact fields with the reference of the Contact. 
                Messaging.SingleEmailMessage renderedEmail = Messaging.renderStoredEmailTemplate(template.id, contactId, contactId);
                String emailSubject = renderedEmail.getSubject();
                String emailTextBody = renderedEmail.getPlainTextBody();
                csvAttc.setBody(csvBlob);
                

                //IKO-335 Ability to resend Welcome Kit and have the running user receive a copy
                List<String> recipients = new List<String>();
                List<String> ccRecipients = new List<String>();
                List<String> bccRecipients = new List<String>();
                recipients.add(thisVendorEmail);
                ccRecipients.add(UserInfo.getUserEmail());
                bccRecipients.add(globalConfig.Default_Vendor_Email__c);
                //IKO-96
                //logicEmail.sendPlainTextEmail(template.Subject, template.Body, new List<String> {thisVendorEmail}, new List<String>(), new List<String> {globalConfig.Default_Vendor_Email__c}, new List<String>(), new List<Messaging.EmailFileAttachment> {csvAttc}, ikoRoofProOrgWideDefault.Id);
                logicEmail.sendPlainTextEmail(emailSubject, emailTextBody, recipients, ccRecipients, bccRecipients , new List<String>(), new List<Messaging.EmailFileAttachment> {csvAttc});
                
                //IKO-335 Ability to resend Welcome Kit add task activity on the contact
                Task newTask = new Task();
                newTask.Description = 'The Personalized Marketing Material email was sent to the contact by Loyalty Agent ';
                newTask.Priority = 'Normal';
                newTask.Status = 'Completed';
                newTask.Subject = 'The personalized marketing material email was sent';
                newTask.IsReminderSet = false;
                newTask.ActivityDate = Date.today();
                newTask.TaskSubtype = 'Email';
                newTask.whoId = thisContact.Id;
                newTask.OwnerId = UserInfo.getUserId();
                newTask.WhatId = thisContact.AccountId;
                logicTask.insertTask(newTask);
            }
        }
    }
}