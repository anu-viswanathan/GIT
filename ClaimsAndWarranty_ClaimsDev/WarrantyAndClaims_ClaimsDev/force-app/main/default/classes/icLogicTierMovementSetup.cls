public class icLogicTierMovementSetup implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		Tier_Movement_Setup__c getTierMovementSetup();
		icDtoTierMovementConfig getTierMovementConfigDto(Tier_Movement_Setup__c tierMovementSetup);
	}

	public class Impl implements IClass {

		icRepoTierMovementSetup.IClass repository = (icRepoTierMovementSetup.IClass) icObjectFactory.GetSingletonInstance('icRepoTierMovementSetup');

		public Tier_Movement_Setup__c getTierMovementSetup() {
			return repository.getTierMovementSetup();
		}

		public icDtoTierMovementConfig getTierMovementConfigDto(Tier_Movement_Setup__c tierMovementSetup) {
			icDtoTierMovementConfig returnConfig = new icDtoTierMovementConfig();

			returnConfig.sfId = tierMovementSetup.Id;
			returnConfig.adminEmail = tierMovementSetup.Admin_Email__c;
			returnConfig.runProcess = false;
			returnConfig.isSimulation = tierMovementSetup.Simulation__c;

			Date dateToday = Date.today();
			Datetime dateTimeToday = DateTime.newInstance(dateToday.year(), dateToday.month(), dateToday.day());
			String dayOfWeekToday =  dateTimeToday.format('EEEE');

			Datetime dateTimeAscendDate = DateTime.newInstance(tierMovementSetup.Tier_Advancement_Start_Date__c.year(), tierMovementSetup.Tier_Advancement_Start_Date__c.month(), tierMovementSetup.Tier_Advancement_Start_Date__c.day());
			String dayOfWeekAscend =  dateTimeAscendDate.format('EEEE');

			if(tierMovementSetup.Tier_Maintenance_Descend_Date__c == dateToday) {
				returnConfig.runProcess = true;
				returnConfig.processMode = 'DESCEND';
				returnConfig.rebateYear = tierMovementSetup.Tier_Maintenance_Descend_Invoice_Year__c;
			} else if(tierMovementSetup.Tier_Advancement_Start_Date__c == dateToday 
			|| tierMovementSetup.Tier_Advancement_End_Date__c == dateToday
			|| (tierMovementSetup.Tier_Advancement_Start_Date__c < dateToday && tierMovementSetup.Tier_Advancement_End_Date__c > dateToday && dayOfWeekToday.equals(dayOfWeekAscend))) {
				returnConfig.runProcess = true;
				returnConfig.processMode = 'ASCEND';
				returnConfig.rebateYear = tierMovementSetup.Tier_Advancement_Invoice_Year__c;
				returnConfig.startDate = tierMovementSetup.Tier_Advancement_Start_Date__c;
				returnConfig.endDate = tierMovementSetup.Tier_Advancement_End_Date__c;
			}

			return returnConfig;
		}
	}
}