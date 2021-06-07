global class Warranty_SchedulerUpdateExpired implements Schedulable{
	global void execute(SchedulableContext  sc) {
		Warranty_BatchUpdateExpired warrantyExpired = new Warranty_BatchUpdateExpired();
        database.executeBatch(warrantyExpired);
    }
}