global class icScheduleCSSyncProcess implements Schedulable {

	global void execute(SchedulableContext SC) {
		Database.executeBatch(new icBatchCSSyncProcess(), 1);
	}
}