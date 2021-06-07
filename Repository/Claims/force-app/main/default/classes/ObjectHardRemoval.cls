/**
 * @description scheduable batch class to remove records from the system
 * 				The constructor takes two arguments, the object name and the where clause
 * 				The where clause is mainly used if certain criteria has to match for records removal
 * @author Sinan Bunni
 * @date 10 April 2019
 *
 * Refer to WCDM-172 in Jira https://ikoussfsc.atlassian.net/browse/WCDM-172
 **/
global class ObjectHardRemoval implements Database.Batchable<sObject>, Schedulable {
	private String objectName;
	private String whereClause;

	global ObjectHardRemoval(String objectName, String whereClause) {
		// constructor
		this.objectName = objectName;
		this.whereClause = whereClause;
	}

	global Database.QueryLocator start(Database.BatchableContext bc) {
		// query to return all records eligible for removal
		String query = 'SELECT Id FROM ' + objectName + ' WHERE ' + whereClause;
		return Database.getQueryLocator(query);
	}

	global void execute(SchedulableContext sc) {
		// execute the batch
		ObjectHardRemoval batchDeletion = new ObjectHardRemoval(objectName, whereClause);
		Id batchDeletionId = Database.executeBatch(batchDeletion);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		System.debug('## deleting ' + scope.size() + ' Claim Type records');

		// delete list of records and empty recycle bin
		delete scope;
		Database.emptyRecycleBin(scope);
	}

	global void finish(Database.BatchableContext BC) {
		// no post processing
	}
} // end ObjectHardRemoval Class