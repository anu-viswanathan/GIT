global class icBatchCSSyncProcess implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts  {

	
	icServiceCentralStation.IClass csService = (icServiceCentralStation.IClass) icObjectFactory.GetSingletonInstance('icServiceCentralStation');
	icLogicAccount.IClass logicAccount = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');

	global Integer totalAccountsProcessed = 0;
	global Integer totalFailedSync = 0;

	global Database.QueryLocator start(Database.BatchableContext context) {
		return Database.getQueryLocator('SELECT Id, IKOPRO_QueueID__c, Contractor_Name_Formula__c, Phone, BillingStreet, BillingCity, BillingState, BillingStateCode__c, BillingPostalCode, BillingCountry, Tier_Prozone__c, Admin_Email_Address__c, DBA_Account__c, Website, Fax, Business_Operating_Language_ROOFPRO__c, IsPartner, IKO_com__c, CS_Sync_Required__c FROM Account WHERE CS_Sync_Required__c = true');
	}

	global void execute(Database.BatchableContext context, List<Account> scope) {
		totalAccountsProcessed += scope.size();

		for(Account thisAccount : scope) {
			String jsonAccont = logicAccount.serializeAccount(thisAccount);
			Boolean syncSuccessful = csService.syncAccount(thisAccount.Id, jsonAccont);
			if(syncSuccessful) {
				thisAccount.CS_Sync_Required__c = false;
				logicAccount.saveAccount(thisAccount);
			} else {
				totalFailedSync++;
			}
		}
	}

	global void finish(Database.BatchableContext context) {
		String emailBodyHTML = 'Central Station Sync Process ran and completed at : ' + icUtilDatetime.getLocalDateTime(Datetime.now()) + ' <br><br>';
		emailBodyHTML += '<br> Total account sync\'d : ' + totalAccountsProcessed + ' <br><br>';
		emailBodyHTML += '<br> Total failed sync\'d : ' + totalFailedSync + ' <br><br>';
		emailBodyHTML += '<br> Review the error logs for more information (IMT_Incoice_Log) <br><br>';

		Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage(); 

		emailOut.setSubject('Central Station Sync Process Results');
		emailOut.setSenderDisplayName('Automated Process');
		emailOut.setToAddresses(new String[] {'ROOFPROIT@iko.com'});
		emailOut.setHTMLBody(emailBodyHTML);        

		Messaging.sendEmail(new List<Messaging.Email>{emailOut});
	}
}