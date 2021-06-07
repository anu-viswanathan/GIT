public class icHandlerAccount implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
        void onBeforeUpdate(List<Account> oldAccounts, List<Account> newAccounts, Map<Id, Account> accountsMap);
		void onAfterInsert(List<Account> newAccounts, Map<Id, Account> accountsMap);
		void onAfterUpdate(List<Account> oldAccounts, List<Account> newAccounts, Map<Id, Account> accountsMap);
    }

	public class Impl implements IClass {

        icLogicAccount.IClass logicAccount = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');
        icLogicOrder.IClass logicOrder = (icLogicOrder.IClass) icObjectFactory.GetSingletonInstance('icLogicOrder');

		public void onAfterInsert(List<Account> newAccounts, Map<Id, Account> accountsMap) {
			/*
            system.debug('OnAfterInsert');
            List<Account> accountsToSync = new List<Account>();
            List<Account> oldAccounts = new List<Account>();
            accountsToSync = logicAccount.getAccountsForCSSync(newAccounts, oldAccounts);
			system.debug(accountsToSync);
            if(accountsToSync.size() == 1) {
                icAsyncServiceCentralStation.syncAccount(accountsToSync[0].Id, serializeAccount(accountsToSync[0]));
            }
            */
		}

		public void onAfterUpdate(List<Account> oldAccounts, List<Account> newAccounts, Map<Id, Account> accountsMap) {
			/*
            system.debug('onAfterUpdate');
            List<Account> accountsToSync = new List<Account>();
            accountsToSync = logicAccount.getAccountsForCSSync(newAccounts, oldAccounts);
            system.debug(accountsToSync);
            if(accountsToSync.size() == 1) {
                icAsyncServiceCentralStation.syncAccount(accountsToSync[0].Id, serializeAccount(accountsToSync[0]));
            }
            */

            reassignOrdersToNewMapicAccounts(newAccounts, accountsMap);
		}

        public void onBeforeUpdate(List<Account> oldAccounts, List<Account> newAccounts, Map<Id, Account> accountsMap) {
            system.debug('onBEFOREUpdate');
            //List<Account> accountsToSync = new List<Account>();
            Id contractorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('IKOPRO_Contractor').getRecordTypeId();

            //accountsToSync = logicAccount.getAccountsForCSSync(newAccounts, oldAccounts);
            //system.debug(accountsToSync);
            for(Account newAccount : newAccounts){
                Account oldAccount = accountsMap.get(newAccount.Id);

                if(newAccount.RecordTypeId == contractorRecordTypeId){
                    Boolean hasChanges = logicAccount.hasKeyFieldsChangedForCSSync(newAccount, oldAccount);
                    Boolean hasReq = logicAccount.hasAllRequiredFieldsForCSSync(newAccount);
                    //icServiceErrorHandler.StoreError('IKO-202 Troubleshoot', newAccount.Name, 'hasChanges : ' + hasChanges, 'hasReq : ' + hasReq, String.valueOf(Datetime.now()));

                    if(hasReq){
                        if(hasChanges) {
                            newAccount.CS_Sync_Required__c = TRUE;
                        }
                    } else {
                        newAccount.CS_Sync_Required__c = FALSE;
                    }
                }
            }
            //icServiceErrorHandler.CommitErrors();
        }

        private void reassignOrdersToNewMapicAccounts(List<Account> newAccounts, Map<Id, Account> oldAccountsMap){ 
            List<Account> assignedMapicAccount = new List<Account> ();
            for(Account newAcount : newAccounts){
                Account oldAcount = oldAccountsMap.get(newAcount.Id);

                // check if value was initialzed in MAPICS_ERP_ID__c
                if(String.isNotBlank(newAcount.MAPICS_ERP_ID__c ) && 
                   String.isBlank(oldAcount.MAPICS_ERP_ID__c )) {                       
                    assignedMapicAccount.add(newAcount);
                }
            }
            system.debug('====> ' + assignedMapicAccount);
            Map<String, Account> mapAccountByMapicsExternalId = logicAccount.getMapAccountsByMapicsExternalId(assignedMapicAccount);
            List<Order> orders = logicOrder.getOrdersByMapicIds(mapAccountByMapicsExternalId.keySet());
            
            for(Order thisOrder : orders) {      
                Account relatedAccount = mapAccountByMapicsExternalId.get(thisOrder.Customer_Number_Mapics__c);          
                if(relatedAccount != null){
                    thisOrder.AccountId = relatedAccount.Id;
                }
            }
			system.debug('====> orders :' + orders);            
            logicOrder.updateOrders(orders);
        }
    }
}