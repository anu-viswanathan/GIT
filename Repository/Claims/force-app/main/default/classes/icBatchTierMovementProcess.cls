global class icBatchTierMovementProcess implements Database.Batchable<sObject>, Database.Stateful {

	icLogicAccount.IClass logicAccount = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');
	icLogicAccountPayment.IClass logicAccountPayment = (icLogicAccountPayment.IClass) icObjectFactory.GetSingletonInstance('icLogicAccountPayment');
	icLogicContact.IClass logicContact = (icLogicContact.IClass) icObjectFactory.GetSingletonInstance('icLogicContact');
	icLogicInvoice.IClass logicInvoice = (icLogicInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicInvoice');
	icLogicTierMovementLog.IClass logicTierMovement = (icLogicTierMovementLog.IClass) icObjectFactory.GetSingletonInstance('icLogicTierMovementLog');

	global icDtoTierMovementConfig processConfig {get; set;}
	global Map<String, Tier__c> mapTiers {get;set;}

	global Tier__c tier1 {get;set;}
	global Tier__c tier2 {get;set;}
	global Tier__c tier3 {get;set;}
    global Tier__c tier0 {get;set;}

	global Integer intRebateYear {get;set;}
	global Double tier1High {get;set;}
	global Double tier2Low {get;set;}
	global Double tier2High {get;set;}
	global Double tier3Low {get;set;}

	global Date processDate = Date.today();

	global Map<String, List<String>> processLogs = new Map<String, List<String>>();
	global Integer totalAccountsProcessed = 0;
	
	global icBatchTierMovementProcess(icDtoTierMovementConfig processConfig, Map<String, Tier__c> mapTiers) {
		this.processConfig = processConfig;
		this.mapTiers = mapTiers;

		for(Tier__c thisTier : mapTiers.values()) {
			if(thisTier.Tier_Label__c == '1') {
				tier1 = thisTier;
				tier1High = thisTier.Maximum_Squares__c;
			}
			if(thisTier.Tier_Label__c == '2') {
				tier2 = thisTier;
				tier2Low = thisTier.Minimum_Squares__c;
				tier2High = thisTier.Maximum_Squares__c;
			}
			if(thisTier.Tier_Label__c == '3') {
				tier3 = thisTier;
				tier3Low = thisTier.Minimum_Squares__c;
			}
            if(thisTier.Tier_Label__c == '0') {
				tier0 = thisTier;
			}
		}

		this.intRebateYear = Integer.valueOf(processConfig.rebateYear);
	}

	global Database.QueryLocator start(Database.BatchableContext context) {
		Map<String, Schema.RecordTypeInfo> mapContractorRecordTypes = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
		Id contractorRecordTypeId = mapContractorRecordTypes.get('IKOPRO_Contractor').getRecordTypeId();
		Id contractorHAOKRecordTypeId = mapContractorRecordTypes.get('IKOPRO_Contractor_HA_OK').getRecordTypeId();

		return Database.getQueryLocator('SELECT Id, Name, IKOPRO_Approved_On__c, Present_Tier_Lookup__c, Present_Tier_Percentage__c, Prior_Tier__c, Prior_Tier_Percentage__c, Date_Present_Tier__c, Override_Tier_Movement__c, Owner.Email, Admin_Email_Address__c, Business_Fundamentals_Completed__c, IF_Course_Affirmation__c, Performance_Fundamentals_Completed__c, Safety_Fundamentals_Completed__c FROM Account WHERE IsPartner__c = true AND RecordTypeId IN (\'' + contractorRecordTypeId + '\',\'' + contractorHAOKRecordTypeId + '\')');
	}

	global void execute(Database.BatchableContext context, List<Account> scope) {
		totalAccountsProcessed += scope.size();

		System.debug('scope.size > ' + scope.size());
		
		List<Account> finalScope = new List<Account>();
		List<Account> updateAccounts = new List<Account>();
		// get all accountIds in scope
		// evaluate exclusions
		List<String> accountIds = new List<String>();
		for(Account thisAccount : scope) {
			Boolean isAccountInScope = true;

			if(thisAccount.Override_Tier_Movement__c) {
				isAccountInScope = false;
				addProcessLog(thisAccount, 'Omitted by manual override', 'Override_Tier_Movement__c');
			} else if(thisAccount.Present_Tier_Lookup__c == null) {
				isAccountInScope = false;
				addProcessLog(thisAccount, 'Omitted by invalid present tier', 'Present Tier is null ');
			} else if(thisAccount.IKOPRO_Approved_On__c == null || thisAccount.IKOPRO_Approved_On__c.year() > intRebateYear) {
				isAccountInScope = false;
				addProcessLog(thisAccount, 'Omitted by activation date', 'Activated on ' + thisAccount.IKOPRO_Approved_On__c);
            }else if(thisAccount.Present_Tier_Lookup__c == tier0.Id){
                isAccountInScope = false;
				addProcessLog(thisAccount, 'Omitted by Tier 1Minus', 'Excluded from movement');
            }
            else {
				
				// always check ASCEND on weekly process mode
				// TO DO: remap ASCEND mode with WEEKLY
				if(processConfig.processMode == 'ASCEND') {
					if(mapTiers.get(thisAccount.Present_Tier_Lookup__c).Tier_Label__c == '3') {
						isAccountInScope = false;
						addProcessLog(thisAccount, 'Omitted can not ascend', 'Present Tier is Tier 3, can not ascend further.');
					}
				}
			}

			if(isAccountInScope) {
				accountIds.add(thisAccount.Id);
				finalScope.add(thisAccount);
			}
		}

		System.debug('finalScope.size > ' + finalScope.size());

		//get primary admin contacts by contractor
		List<Contact> allContactsInScope = logicContact.getPrimaryAdminContactsByContractorIds(accountIds);
		Map<String, Contact> mapAdminContactByContractor = logicContact.getMapPrimaryAdminContactByContractorId(allContactsInScope);

		String strPaymentYear = processConfig.rebateYear;
		if(processConfig.processMode == 'DESCEND') {
			strPaymentYear = String.valueOf(intRebateYear + 1);
		}
		//get all paid account payments for process year
		List<IKOPRO_Account_Payment__c> allPaidRenewals = logicAccountPayment.getPaidAccountPaymentByYearAndContractorIds(strPaymentYear, accountIds);
		Map<String, IKOPRO_Account_Payment__c> mapPaidRenewalsByContractorId = logicAccountPayment.getMapPaidRenewalByContractorId(allPaidRenewals);

		//get all rebate invoices
		List<Invoice__c> scopeInvoices = logicInvoice.getAllInvoicesByAccountIdsAndRebateYear(accountIds, processConfig.rebateYear);
		Map<String, List<Invoice__c>> mapInvoicesByAccount = logicInvoice.getMapInvoicesByAccount(scopeInvoices);

		List<Account_Tier_Movement__c> listTierMovementLogs = new List<Account_Tier_Movement__c>();
		for(Account thisAccount : finalScope) {
			//validate renewal
			IKOPRO_Account_Payment__c renewalPayment = mapPaidRenewalsByContractorId.get(thisAccount.Id);
			if(renewalPayment == null) {
				addProcessLog(thisAccount, 'Omitted not renewed', 'No paid Payment for ' + strPaymentYear);
				continue;
			}
			
			Tier__c presentTier = mapTiers.get(thisAccount.Present_Tier_Lookup__c);
			Integer intPresentTier = Integer.valueOf(presentTier.Tier_Label__c);

			Double calculatedTier1High = tier1High;
			Double calculatedTier2Low = tier2Low;
			Double calculatedTier2High = tier2High;
			Double calculatedTier3Low = tier3Low;

			Boolean isProratedYear = logicAccount.evaluateIsProratedYear(thisAccount, intRebateYear);
			Integer calculatedMonth = 12;
			if(isProratedYear) {
				calculatedMonth -= thisAccount.IKOPRO_Approved_On__c.month();
				if(calculatedMonth < 3) {
					calculatedMonth = 3;
				}

				calculatedTier1High = (calculatedTier1High / 12) * calculatedMonth;
				calculatedTier2Low = (calculatedTier2Low / 12) * calculatedMonth;
				calculatedTier2High = (calculatedTier2High / 12) * calculatedMonth;
				calculatedTier3Low = (calculatedTier3Low / 12) * calculatedMonth;
			}

			//calculate total squares
			List<Invoice__c> thisAccountInvoices = mapInvoicesByAccount.get(thisAccount.Id);			
			Double totalSquares = 0;
			if(thisAccountInvoices != null) {
				totalSquares = logicInvoice.getSquaresFromInvoices(thisAccountInvoices, isProratedYear, thisAccount.IKOPRO_Approved_On__c);
			}

			Integer intTierBySquare;
			String tierBySquareId;
			if(totalSquares <= calculatedTier1High) {
				intTierBySquare = 1;
				tierBySquareId = tier1.Id;
			}
			if(totalSquares >= calculatedTier2Low && totalSquares <= calculatedTier2High) {
				intTierBySquare = 2;
				tierBySquareId = tier2.Id;
			}
			if(totalSquares >= calculatedTier3Low) {
				intTierBySquare = 3;
				tierBySquareId = tier3.Id;
			}

			Boolean logTierMovement = false;
			String tierMovement = 'MAINTAIN';
			if(intPresentTier > intTierBySquare && processConfig.processMode == 'DESCEND') {
				tierMovement = 'DESCEND';
				logTierMovement = true;
				addProcessLog(thisAccount, 'Moved', 'Descended');
			}
			// always check ASCEND
			if(intPresentTier < intTierBySquare) { // && processConfig.processMode == 'ASCEND') {
				if(((intPresentTier == 1 && intTierBySquare == 2) && (thisAccount.Safety_Fundamentals_Completed__c && thisAccount.IF_Course_Affirmation__c)) ||
                   ((intPresentTier == 2 && intTierBySquare == 3) && (thisAccount.Safety_Fundamentals_Completed__c && thisAccount.IF_Course_Affirmation__c && thisAccount.Business_Fundamentals_Completed__c && thisAccount.Performance_Fundamentals_Completed__c))||
                  ((intPresentTier == 1 && intTierBySquare == 3) && (thisAccount.Safety_Fundamentals_Completed__c && thisAccount.IF_Course_Affirmation__c))){
					
					tierMovement = 'ASCEND';
					logTierMovement = true;
					addProcessLog(thisAccount, 'Volume & Education Criteria Met', 'Ascended');
					
				}
				else{

					tierMovement = 'MAINTAIN';
					logTierMovement = false;
					addProcessLog(thisAccount, 'Educationnal Criteria Failed', 'No tier movement');
				}
				
			}
			if(tierMovement == 'MAINTAIN') {
				addProcessLog(thisAccount, 'Maintainted', 'Maintainted');
				if(processConfig.processMode == 'DESCEND') {
					logTierMovement = true;
				}
			}

			if(logTierMovement) {
				// get primary admin contact for this contractor
				Contact primaryAdmin = mapAdminContactByContractor.get(thisAccount.Id);

				thisAccount.Present_Tier_Lookup__c = tierBySquareId;
				thisAccount.Prior_Tier__c = presentTier.Tier_Label__c;
				thisAccount.Prior_Tier_Percentage__c = thisAccount.Present_Tier_Percentage__c;
				ThisAccount.Date_Present_Tier__c = processDate;
				updateAccounts.add(thisAccount);

				listTierMovementLogs.add(logicTierMovement.createNewTierMovementLog(processConfig, thisAccount, primaryAdmin, calculatedMonth, totalSquares, isProratedYear, tierMovement, calculatedTier1High, calculatedTier2Low, calculatedTier2High, calculatedTier3Low));
			}
		}

		if(updateAccounts.size() > 0 && !processConfig.isSimulation) {
			logicAccount.saveAccounts(updateAccounts);
		}

		if(listTierMovementLogs.size() > 0 ) {
			logicTierMovement.saveTierMovementLog(listTierMovementLogs);
		}

	}

	global void finish(Database.BatchableContext context) {
		String emailBodyHTML = 'Tier Movement Process ran and completed at : ' + icUtilDatetime.getLocalDateTime(Datetime.now()) + ' <br><br>';
		emailBodyHTML += '<br> Total account processed : ' + totalAccountsProcessed + ' <br><br>';
		
		for(String thisKey : processLogs.keySet()) {
			List<String> processTypeLogs = processLogs.get(thisKey);
			emailBodyHTML += 'Total account ' + thisKey + ' : ' + processTypeLogs.size() + '<br>';

			processTypeLogs.sort();
			for(String thisLog : processTypeLogs) {
				emailBodyHTML += thisLog + '<br>';
			}
			emailBodyHTML += '<br>';
		}

		Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage(); 

		emailOut.setSubject('Tier Movement Process Results');
		emailOut.setSenderDisplayName('Automated Process');
		emailOut.setToAddresses(new String[] {processConfig.adminEmail});
		emailOut.setHTMLBody(emailBodyHTML);        

		Messaging.sendEmail(new List<Messaging.Email>{emailOut});
	}

	private void addProcessLog(Account relatedAccount, String logType, String logMessage) {
		List<String> logTypeMessages = processLogs.get(logType);

		if(logTypeMessages == null) {
			logTypeMessages = new List<String>();
		}
		logTypeMessages.add(relatedAccount.Name + ' (' + relatedAccount.Id + ') : ' + logMessage);

		processLogs.put(logType, logTypeMessages);
	}
}