public class icLogicAccount implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {
        Contact getPersonAcountInfoById(String recordId);
        Account getAcountInfoById(String recordId);
        Account getAcountByHARefKey(String haRefKey);
        icDTOContactUs getContractorContactUsInfo(String customerId);
        List<Account> getContractorsWithExpiringFunds();
        Account saveAccount(Account record);
        void saveAccounts(List<Account> accounts);
        void updatePartnerAccountsByContactsIds(Set<Id> contactIds);
        Boolean hasAllRequiredFieldsForCSSync(Account thisAccount);
        List<Account> getAccountsByMapicsExternalId(Set<String> externalId);
        Map<String, Account> getMapAccountsByMapicsExternalId(List<Account> accounts);
        Boolean hasKeyFieldsChangedForCSSync(Account newAccount, Account oldAccount);
        List<Account> getAccountsForCSSync(List<Account> newAccounts, List<Account> oldAccounts);
        Boolean evaluateIsProratedYear(Account objAccount, Integer intYear);
        void sendEmailRequiredFieldsAlert(Account objAccount);
        String serializeAccount(Account accountToSync);
    }

    public class Impl implements IClass {

        icRepoAccount.IClass repo = (icRepoAccount.IClass) icObjectFactory.GetSingletonInstance('icRepoAccount');

        public Contact getPersonAcountInfoById(String recordId) {
            return repo.getPersonAcountInfoById(recordId);
        }

        public Account getAcountInfoById(String recordId) {
            return repo.getAcountInfoById(recordId);
        }

        public Account getAcountByHARefKey(String haRefKey) {
            return repo.getAcountByHARefKey(haRefKey);
        }

        public icDTOContactUs getContractorContactUsInfo(String customerId) {
            icDTOContactUs info = new icDTOContactUs();

            Account contactUsInfo = repo.getContractorContactUsInfo(customerId);

            if(contactUsInfo != null && contactUsInfo.Owner != null) {
                info.repName = contactUsInfo.Owner.Name;
                info.repPhone = contactUsInfo.Owner.Phone;
                info.repMobile = contactUsInfo.Owner.MobilePhone;
                info.repEmail = contactUsInfo.Owner.Email;
                info.repInfo = contactUsInfo.Sales_Rep_Info__c;
            }

            return info;
        }

        public List<Account> getContractorsWithExpiringFunds() {
            return repo.getContractorsWithExpiringFunds();
        }

        public Account saveAccount(Account record){
            return repo.saveAccount(record);
        }

        public void saveAccounts(List<Account> accounts) {
            List<Database.SaveResult> saveResults = repo.saveAccounts(accounts);
            Integer resultCounter = 0;
            List<IMT_Invoice_Log__c> errors = new List<IMT_Invoice_Log__c>();
            for(Database.SaveResult saveResult : saveResults) {
                if(!saveResult.isSuccess()) {
                    Account thisRecord = accounts.get(resultCounter);

                    Database.Error[] saveErrors = saveResult.getErrors();
                    String stackTrace = 'Errors:';
                    for(Database.Error upsertError : saveErrors) {
                        stackTrace += '\r\n - ' + upsertError.getMessage();
                    }

                    errors.add(icServiceErrorHandler.GenerateError('icLogicAccount', 'saveAccounts', stackTrace, saveResult.getErrors()[0].getMessage(), JSON.serialize(thisRecord)));
                }
                resultCounter++;
            }
            icServiceErrorHandler.LogErrors(errors);
        }

        public void updatePartnerAccountsByContactsIds(Set<Id> contactIds){

            List<Account> accountList = new List<Account>();

            for(Account acc : [Select id , name, IsPartner, New_Partner_Account__c  from Account where Applicant_Information__c IN: contactIds limit 50000])
            {
                system.debug('****************************Inside Account partner enablement for loop');
                acc.IsPartner = true;
                acc.New_Partner_Account__c=true;
                accountList.add(acc);
                system.debug('****************************List of Accounts partner enablement' +accountList);
            }

            try{
                if(accountList.size()>0)
                {
                    //update accountList;
                    repo.saveAccounts(accountList);
                    system.debug('****************************PARTNER ACCOUNT IS ENABLED');
                }
            }

            catch(Exception e)
            {
                System.debug('***********The following exception has occurred while ENABLING ACCOUNT A PARTNER ACCOUNT: ' + e.getMessage());
            }
        }

        /**
         * Bridge logic to repository: query salesforce for a list of Account by Mapics external Id
         *
         * @param   externalId  a unique list of Mapics external ids
         * @return  a list of accounts
         */
        public List<Account> getAccountsByMapicsExternalId(Set<String> externalId) {
            return repo.getAccountsByMapicsExternalId(externalId);
        }

        /**
         * Maps salesforce account by external id
         *
         * @param   accounts  a list of Salesforce accounts
         * @return  a map of accounts by external id Mapics_ERP_ID__c
         */
        public Map<String, Account> getMapAccountsByMapicsExternalId(List<Account> accounts) {
            Map<String, Account> returnMapAccountByMapicsExternalId = new Map<String, Account>();
            for(Account thisAccount : accounts) {
                returnMapAccountByMapicsExternalId.put(thisAccount.Mapics_ERP_ID__c, thisAccount);
            }
            return returnMapAccountByMapicsExternalId;
        }

        public Boolean hasAllRequiredFieldsForCSSync(Account thisAccount) {
            Boolean hasAllRequiredFields = true;

            system.debug('thisAccount ===> ' + thisAccount);
            if(
                    String.isBlank(thisAccount.Name) ||
                    String.isBlank(thisAccount.Phone) ||
                    String.isBlank(thisAccount.BillingStreet) ||
                   /* String.isBlank(thisAccount.BillingState) ||*/
                    String.isBlank(thisAccount.BillingStateCode__c) ||
                    String.isBlank(thisAccount.IKOPRO_QueueID__c) ||
                    String.isBlank(thisAccount.BillingPostalCode) ||
                    String.isBlank(thisAccount.BillingCountry) ||
                    String.isBlank(thisAccount.BillingCity) ||
                    String.isBlank(thisAccount.Tier_Prozone__c) ||
                    thisAccount.Tier_Prozone__c == 'No Tier Chosen'
                    ){
                hasAllRequiredFields = false;
                //sendEmailRequiredFieldsAlert(thisAccount);
            }
            system.debug('has all required Fields ====> ' + hasAllRequiredFields);
            return hasAllRequiredFields;
        }

        public Boolean hasKeyFieldsChangedForCSSync(Account newAccount, Account oldAccount) {
            Boolean hasKeyFieldsChanged = false;

            if(
                    newAccount.Name != oldAccount.Name ||
                    newAccount.DBA_Account__c != oldAccount.DBA_Account__c ||
                    newAccount.Website != oldAccount.Website ||
                    newAccount.Contractor_ID__c != oldAccount.Contractor_ID__c ||
                    newAccount.IKOPRO_QueueID__c != oldAccount.IKOPRO_QueueID__c ||
                    newAccount.Phone != oldAccount.Phone ||
                    newAccount.Fax != oldAccount.Fax ||
                    newAccount.BillingStreet != oldAccount.BillingStreet ||
                    newAccount.BillingCity != oldAccount.BillingCity ||
                    /*newAccount.BillingState != oldAccount.BillingState ||*/
                    newAccount.BillingStateCode__c != oldAccount.BillingStateCode__c ||
                    newAccount.BillingPostalCode != oldAccount.BillingPostalCode ||
                    newAccount.BillingCountry != oldAccount.BillingCountry ||
                    newAccount.IKO_com__c != oldAccount.IKO_com__c ||
                    //newAccount.Applicant_Information__r.Wants_To_Be_Listed_On_IKO_com__c != oldAccount.Applicant_Information__r.Wants_To_Be_Listed_On_IKO_com__c ||
                    newAccount.Tier_Prozone__c != oldAccount.Tier_Prozone__c ||
                    newAccount.Business_Operating_Language_ROOFPRO__c != oldAccount.Business_Operating_Language_ROOFPRO__c ||
                    //newAccount.Language_Preferences__c != oldAccount.Language_Preferences__c ||
                    newAccount.IsPartner__c != oldAccount.IsPartner__c ||
                    newAccount.IsPartner != oldAccount.IsPartner ||
                    newAccount.RecordTypeId != oldAccount.RecordTypeId
                    ){

                hasKeyFieldsChanged = true;
            }
            system.debug('has key Fields Changed ====> ' + hasKeyFieldsChanged);
            return hasKeyFieldsChanged;
        }

        public List<Account> getAccountsForCSSync(List<Account> newAccounts, List<Account> oldAccounts){

            system.debug('newAccounts ====> ' + newAccounts);
            List<Account> accountsForSync = new List<Account>();
            List<Account> accountWithChangedField = new List<Account>();
            List<Account> accountsWithDetails = new List<Account>();
            List<Id> accountIds = new List<Id>();
            Id contractorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('IKOPRO_Contractor').getRecordTypeId();

            for(Integer i=0; i<newAccounts.size(); i++){

                Account newAccount = newAccounts[i];

                if(newAccount.RecordTypeId == contractorRecordTypeId) {
                    Account oldAccount = new Account();
                    if (oldAccounts.size() > i) {
                        oldAccount = oldAccounts[i];
                    }

                    system.debug('newAccount ===> ' + newAccount);
                    system.debug('oldAccoutn ===> ' + oldAccount);
                    if (this.hasKeyFieldsChangedForCSSync(newAccount, oldAccount)) {

                        accountWithChangedField.add(newAccount);

                    }

                }
            }

            for(Account tmpAccount : accountWithChangedField){

                accountIds.add(tmpAccount.Id);

            }

            accountsWithDetails = repo.getAcountsInfoByIds(accountIds);

            for(Account tmpAccount : accountsWithDetails){

                if(this.hasAllRequiredFieldsForCSSync(tmpAccount)){
                    accountsForSync.add(tmpAccount);
                }
            }

            return accountsForSync;
        }

        public Boolean evaluateIsProratedYear(Account objAccount, Integer intYear) {
            Boolean isProrated = false;

            if(objAccount.IKOPRO_Approved_On__c.year() == intYear
                && objAccount.IKOPRO_Approved_On__c.month() != 1) {
                isProrated = true;
            }

            return isProrated;
        }

        public void sendEmailRequiredFieldsAlert(Account objAccount) {

            List<String> fieldsMissing = new List<String>();

            if(String.isBlank(objAccount.Name)) fieldsMissing.add('Name');
            if(String.isBlank(objAccount.Phone)) fieldsMissing.add('Phone');
            if(String.isBlank(objAccount.BillingStreet)) fieldsMissing.add('Billing Street');
            if(String.isBlank(objAccount.BillingStateCode__c)) fieldsMissing.add('Billing State Code');
            if(String.isBlank(objAccount.BillingPostalCode)) fieldsMissing.add('Billing Postal Code');
            if(String.isBlank(objAccount.BillingCountry)) fieldsMissing.add('Billing Country');
            if(String.isBlank(objAccount.Tier_Prozone__c)) fieldsMissing.add('Tier Prozone');
            if(String.isBlank(objAccount.IKOPRO_QueueID__c)) fieldsMissing.add('IKO PRO Queue ID');
            if(String.isBlank(objAccount.BillingCity)) fieldsMissing.add('Billing City');
            if(objAccount.Tier_Prozone__c == 'No Tier Chosen') fieldsMissing.add('No tier chosen');


            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { 'ROOFPROIT@IKO.com' };
            message.subject = 'Account Sync attempt failure';
            message.plainTextBody = 'The Account ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + objAccount.Id + ' is missing field(s): ' + String.join(fieldsMissing,', ') + ', in order to sync it with CS.';
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        }

        public String serializeAccount(Account accountToSync) {
            String jsonAccount = '{';
            jsonAccount += '"CID": "' + accountToSync.Id + '", ';
            jsonAccount += '"QID": "' + accountToSync.IKOPRO_QueueID__c + '", ';
            jsonAccount += '"Name": "' + accountToSync.Contractor_Name_Formula__c + '", ';
            jsonAccount += '"Phone": "' + accountToSync.Phone + '", ';
            jsonAccount += '"Street": "' + accountToSync.BillingStreet.escapeJava() + '", ';
            jsonAccount += '"City": "' + accountToSync.BillingCity + '", ';
            //jsonAccount += '"State": "' + accountToSync.BillingState + '", ';
            jsonAccount += '"State": "' + accountToSync.BillingStateCode__c + '", ';
            jsonAccount += '"ZIP": "' + accountToSync.BillingPostalCode + '", ';
            jsonAccount += '"Country": "' + accountToSync.BillingCountry + '", ';
            jsonAccount += '"Tier": "' + accountToSync.Tier_Prozone__c + '", ';
            if(String.isNotBlank(accountToSync.Admin_Email_Address__c)) {
                jsonAccount += '"Email": "' + accountToSync.Admin_Email_Address__c + '", ';
            }
            if(String.isNotBlank(accountToSync.DBA_Account__c)) {
                jsonAccount += '"DBA_Account": "' + accountToSync.DBA_Account__c + '", ';
            }
            if(String.isNotBlank(accountToSync.Website)) {
                jsonAccount += '"Website": "' + accountToSync.Website + '", ';
            }
            if(String.isNotBlank(accountToSync.Fax)) {
                jsonAccount += '"Fax": "' + accountToSync.Fax + '", ';
            }
            if(String.isNotBlank(accountToSync.Business_Operating_Language_ROOFPRO__c)) {
                jsonAccount += '"Language": "' + accountToSync.Business_Operating_Language_ROOFPRO__c + '", ';
            }
            jsonAccount += '"IsPartner": "' + accountToSync.IsPartner + '", ';
            jsonAccount += '"Listed_on_IKO": "' + String.valueOf(accountToSync.IKO_com__c) + '"}';
            //jsonAccount += '"Listed_on_IKO": "' + String.valueOf(accountToSync.Applicant_Information__r.Wants_To_Be_Listed_On_IKO_com__c) + '"}';


            return jsonAccount;
        }
    }
}