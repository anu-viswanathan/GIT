/**
 * The icRepoOrder class is an object specific repository class for Order that is used read or write data to Salesforce.
 */
public with sharing class icRepoOrder implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		List<Order> getOrdersByMapicIds(Set<String> accountMapicsIds);
		List<Database.SaveResult> createOrders(List<Order> orders, Boolean allOrNone);
		List<Database.SaveResult> saveOrders(List<Order> orders, Boolean allOrNone);
	}

	public class Impl implements IClass {

		/**
		 * Get Orders from Salesforce
		 *
		 * @param	list of Account mapics ids to fetch the orders
		 * @return	the results of the list of orders 
		 */
		public List<Order> getOrdersByMapicIds(Set<String> accountMapicsIds) {
			return [SELECT Id
							,AccountId
							,Customer_Number_Mapics__c
					FROM  Order 
					WHERE Account.Mapics_ERP_Id__c LIKE '99999999%' 
					AND Customer_Number_Mapics__c IN: accountMapicsIds];
		}

		/**
		 * Creates new Orders in Salesforce
		 *
		 * @param	orders	a list of Order records to create in Salesforce
		 * @param	allOrNone	a flag that defines if a failure causes the whole transaction to fail
		 * @return	the results of the database transaction
		 */
		public List<Database.SaveResult> createOrders(List<Order> orders, Boolean allOrNone) {
			return Database.insert(orders, allOrNone);
		}

		/**
		 * Updates Orders in Salesforce
		 *
		 * @param	orders	a list of Order records to update in Salesforce
		 * @param	allOrNone	a flag that defines if a failure causes the whole transaction to fail
		 * @return	the results of the database transaction
		 */
		public List<Database.SaveResult> saveOrders(List<Order> orders, Boolean allOrNone) {
			return Database.update(orders, allOrNone);
		}
	}
}