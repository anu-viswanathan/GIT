global with sharing class icCTRLQuickShot {

	static icLogicUser.IClass logicUser = (icLogicUser.IClass) icObjectFactory.GetSingletonInstance('icLogicUser');
	static icLogicAccount.IClass logicAccount = (icLogicAccount.IClass) icObjectFactory.GetSingletonInstance('icLogicAccount');	
	static icLogicLead.IClass logicLead = (icLogicLead.IClass) icObjectFactory.GetSingletonInstance('icLogicLead');
	static icLogicOpportunity.IClass logicOpportunity = (icLogicOpportunity.IClass) icObjectFactory.GetSingletonInstance('icLogicOpportunity');
	static icLogicInvoice.IClass logicInvoice = (icLogicInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicInvoice');

	@AuraEnabled
	global static icDTOQuickShotInfo getQuickShotInfo(){
		icDTOQuickShotInfo info = new icDTOQuickShotInfo();

		String customerId = logicUser.getAccountIdFromPartnerUser(UserInfo.getUserId());
		Account customer = logicAccount.getAcountInfoById(customerId);
		if(String.isNotBlank(customerId)) {
			info.newLeads = logicLead.getNewLeadsCountByAccountId(customerId, customer.IKOPRO_QueueID__c);
			info.currentOpportunities = logicOpportunity.getCurrentOpportunitiesCountByAccountId(customerId);

			List<Invoice__c> ytdInvoices = logicInvoice.getAllYTDInvoicesByAccountId(customerId);

			info.squaresYTD = logicInvoice.getSquaresFromInvoices(ytdInvoices, false, customer.IKOPRO_Approved_On__c);
			info.pro4Rewards = logicInvoice.getPro4RewardsFromInvoices(ytdInvoices);

			info.coopRewards = customer.Available_COOP_Funds__c == null ? 0 : customer.Available_COOP_Funds__c;
			info.tierLevel = customer.Present_Tier_Formula__c == null ? 0 : Integer.valueOf(customer.Present_Tier_Formula__c);

			info.hideUpcomingCoopRewards = customer.Hide_Upcoming_Coop_Rewards__c;
			info.upcomingCoopRewards = logicInvoice.getUpcomingCoopRewardsFromInvoices(ytdInvoices);
		}

		
		return info;
	}

}