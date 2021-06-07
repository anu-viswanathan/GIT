/**
* Created by Francois Poirier on 2019-11-18.
*/

public with sharing class icLogicContractorInvoice implements icIClass {
    
    public Object GetInstance() {
        return new Impl();
    }
    
    public Interface IClass {
        
        void saveContractorInvoice(Contractor_Invoice__c invoice);
        Contractor_Invoice__c createNewContractorInvoiceFromProgram(String rebateProgram, Contractor_Invoice__c newInvoice);
        Contractor_Invoice__c createNewContractorInvoiceFromProgram(String rebateProgram);
        List<icDtoPickList> getRebatePrograms();
        
        Contractor_Invoice__c getContractorInvoiceById(Id contractorInvoiceId);
        void removeFileIdsFromContractInvoice(Id contractorInvoiceId,  List<String> fileIds);
        void deleteContractorInvoiceById(Id contractorInvoiceId);
    }
    
    public class Impl implements IClass {
        
        private icRepoContractorInvoice.IClass repoContractorInvoice = (icRepoContractorInvoice.IClass) icObjectFactory.GetSingletonInstance('icRepoContractorInvoice');
        private icLogicUser.IClass logicUser = (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');
        private icUtilSchema.IClass utilSchema = (icUtilSchema.IClass) icObjectFactory.GetSingletonInstance('icUtilSchema');
        private icLogicConfig.IClass logicConfig = (icLogicConfig.IClass) icObjectFactory.GetSingletonInstance('icLogicConfig');
        public void saveContractorInvoice(Contractor_Invoice__c invoice){
            
            
            Id uploadedRecordTypeId = Schema.SObjectType.Contractor_Invoice__c.getRecordTypeInfosByDeveloperName().get('Uploaded_Invoice').getRecordTypeId();
            invoice.Status__c = 'Uploaded';
            invoice.RecordTypeId = uploadedRecordTypeId;
            
            repoContractorInvoice.saveContractorInvoice(invoice);
            
        }
        
        public Contractor_Invoice__c createNewContractorInvoiceFromProgram(String rebateProgram){
            return createNewContractorInvoiceFromProgram(rebateProgram, new Contractor_Invoice__c());
        }
        
        public Contractor_Invoice__c createNewContractorInvoiceFromProgram(String rebateProgram, Contractor_Invoice__c newInvoice){
            //Contractor_Invoice__c newInvoice = new Contractor_Invoice__c();
            //TODO: remove hard coded id
            User currentUser = logicUser.getUserAndAccountFromPartnerUser(UserInfo.getUserId());
            
            
            //            User currentUser = logicUser.getUserAndAccountFromPartnerUser('0051F000002KbBkQAK');
            newInvoice.Contractor__c = currentUser.Contact.AccountId;
            
             String communityName;
            if(System.Test.isRunningTest()){
               communityName = icTestLogicContractorInvoice.siteName;
            }
            else{
               communityName = Site.getName();
                
            }
            CommunitySiteNameConfiguration__mdt communityConfig = logicConfig.getCommunitySiteNameConfigByName(communityName);
            if(communityConfig.CommunityNameGlobalSetValue__c == 'CRC_C'){
                newInvoice.Rebate_Program_CRC_c__c = rebateProgram;
            } else if(communityConfig.CommunityNameGlobalSetValue__c == 'IKOROOFPRO_C'){
                
                if(currentUser.Contact.Account.BillingCountry == 'Canada'){
                    newInvoice.Rebate_Program_CA__c = rebateProgram;
                }
                else {
                    newInvoice.Rebate_Program_US__c = rebateProgram;
                }
            }
                
            
            newInvoice.Invoice_Date__c = System.today();
            newInvoice.User_FirstName__c = currentUser.Contact.FirstName;
            newInvoice.User_LastName__c = currentUser.Contact.LastName;
            newInvoice.User_Email__c = currentUser.Contact.Email;
            newInvoice.User_Mobile__c = currentUser.Contact.MobilePhone;
            newInvoice.User_Phone__c = currentUser.Contact.Phone;
            
            repoContractorInvoice.saveContractorInvoice(newInvoice);
            newInvoice = getContractorInvoiceById(newInvoice.Id);
            
            return newInvoice;
        }
        
        public List<icDtoPickList> getRebatePrograms(){
            
            List<icDtoPickList> rebatePrograms = new List<icDtoPickList>();
            //TODO: remove hard coded Id
            
            String communityName;
            if(System.Test.isRunningTest()){
               communityName = icTestLogicContractorInvoice.siteName;
            }
            else{
               communityName = Site.getName();
                
            }
            CommunitySiteNameConfiguration__mdt communityConfig = logicConfig.getCommunitySiteNameConfigByName(communityName);
            
            if(communityConfig.CommunityNameGlobalSetValue__c == 'CRC_C')
            {
                rebatePrograms = utilSchema.getPickListValues('Contractor_Invoice__c', 'Rebate_Program_CRC_c__c');
            }
            else if(communityConfig.CommunityNameGlobalSetValue__c == 'IKOROOFPRO_C'){
                User currentUser = logicUser.getUserAndAccountFromPartnerUser(UserInfo.getUserId());
                //            User currentUser = logicUser.getUserAndAccountFromPartnerUser('0051F000002KbBkQAK');
                system.debug('currentUser.Contact.Account.BillingCountry ===> ' + currentUser.Contact.Account.BillingCountry);
                
                if(currentUser.Contact.Account.BillingCountry == 'Canada'){
                    rebatePrograms = utilSchema.getPickListValues('Contractor_Invoice__c', 'Rebate_Program_CA__c');
                }
                else{
                    rebatePrograms = utilSchema.getPickListValues('Contractor_Invoice__c', 'Rebate_Program_US__c');
                }
            }
            
            
            system.debug('rebate programs ====> ' + rebatePrograms);
            return rebatePrograms;
        }
        
        public Contractor_Invoice__c getContractorInvoiceById(Id contractorInvoiceId){
            
            return repoContractorInvoice.getContractorInvoiceById(contractorInvoiceId);
            
        }
        
        public void removeFileIdsFromContractInvoice(Id contractorInvoiceId, List<String> fileIds){
            
            List<Contractor_Invoice__c> contractInvoices = [SELECT Id, Uploaded_Files_Long__c FROM Contractor_Invoice__c WHERE ID = :contractorInvoiceId];
            List<String> documentIds = new List<String>();
            
            if(contractInvoices[0].Uploaded_Files_Long__c != null){
                for(String documentId : contractInvoices[0].Uploaded_Files_Long__c.split(',')){
                    if(String.isNotBlank(documentId) && !fileIds.contains(documentId.trim())){
                        documentIds.add(documentId);
                    }
                }
                if(documentIds.isEmpty()){
                    contractInvoices[0].Uploaded_Files_Long__c = '';
                    contractInvoices[0].File_s_Attached__c = false;
                }else{
                    contractInvoices[0].Uploaded_Files_Long__c = String.join(documentIds, ',');
                    contractInvoices[0].Uploaded_Files_Long__c += ',';
                    contractInvoices[0].File_s_Attached__c = true;
                }
                update contractInvoices;
            }
        }
        
        public void deleteContractorInvoiceById(Id contractorInvoiceId){
            
            List<Contractor_Invoice__c> contractInvoices = new List<Contractor_Invoice__c>();
            contractInvoices.add(new Contractor_Invoice__c(Id = contractorInvoiceId));
            DELETE contractInvoices;
        }
        
    }
    
}