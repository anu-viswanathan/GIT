global class icScheduleTierMovementProcess implements Schedulable {

	global icLogicTierMovementSetup.IClass logicTierMovementSetup = (icLogicTierMovementSetup.IClass) icObjectFactory.GetSingletonInstance('icLogicTierMovementSetup');
	global icLogicTier.IClass logicTier = (icLogicTier.IClass) icObjectFactory.GetSingletonInstance('icLogicTier');

	global void execute(SchedulableContext SC) {
		Tier_Movement_Setup__c tierMovementSetup = logicTierMovementSetup.getTierMovementSetup();
		icDtoTierMovementConfig processConfig = logicTierMovementSetup.getTierMovementConfigDto(tierMovementSetup);

		if(processConfig.runProcess) {
			List<Tier__c> tiers = logicTier.getAllTiers();
			Map<String, Tier__c> mapTiers = logicTier.getMapTiersByName(tiers);
			Database.executeBatch(new icBatchTierMovementProcess(processConfig, mapTiers));
		}
	}
}