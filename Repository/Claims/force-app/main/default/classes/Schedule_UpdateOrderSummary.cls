// Scheduling class for the GPS Data project.

global class Schedule_UpdateOrderSummary implements Schedulable {
    global void execute(SchedulableContext  sc) {
		Batch_EraseGPSRollups calc = new Batch_EraseGPSRollups();
        database.executeBatch(calc);
    }
}