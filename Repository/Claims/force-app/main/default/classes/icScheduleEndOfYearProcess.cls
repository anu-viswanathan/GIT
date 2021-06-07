global class icScheduleEndOfYearProcess implements Schedulable {
	
	String CRON_EXP = '0 0 31 12 *';        // '0 0 0/6 1/1 * ? *' every 6 hours

	global void execute(SchedulableContext SC) {
		Database.executeBatch(new icBatchExpireCoopFunds());
	}
}