/**
 * The icLogicOrder class is an object specific business logic class for Order that is used to manipulate, transform and otherwise perform all business logic on an order record.
 * This is the only class that should use the repository or map utility class for Order
 */
public with sharing class icLogicOrder implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		List<icDTOMapicsData> getOrderDTOFromMapicsPayload(String mapicsPayload);
		Set<String> getListExternalAccountIdsFromMapicsData(List<icDTOMapicsData> mapicsData);
		List<Order> getOrdersFromListMapicsData(List<icDTOMapicsData> mapicsData, Map<String, Account> mapAccountsByMapicsExternalId);
		List<Order> getOrdersByMapicIds(Set<String> accountMapicsIds);
		Map<String, List<Order>> getOrdersByMapicIdsMap(List<Order> orders);
		void saveOrders(List<Order> orders);
		void updateOrders(List<Order> orders);
	}

	public class Impl implements IClass {

		/**
		 * Singleton patter:
		 * Initiate repository and map utility class
		 */
		icRepoOrder.IClass repo = (icRepoOrder.IClass) icObjectFactory.GetSingletonInstance('icRepoOrder');
		icMapOrder.IClass mapper = (icMapOrder.IClass) icObjectFactory.GetSingletonInstance('icMapOrder');

		/**
		 * Parse the Mapics XML payload and convert it to a list of icDTOMapicsData
		 *
		 * @param	mapicsPayload	the string value of the XML payload
		 * @return	returnOrderDTO	a list of icDTOMapicsData
		 */
		public List<icDTOMapicsData> getOrderDTOFromMapicsPayload(String mapicsPayload) {
			List<icDTOMapicsData> returnOrderDTO = new List<icDTOMapicsData>();

			Dom.Document doc = new Dom.Document();
			doc.load(mapicsPayload);
			Dom.XMLNode root = doc.getRootElement();

			icDTOMapicsData newOrderDTO;
			for(Dom.XMLNode childNode : root.getChildElements()) {
				newOrderDTO = new icDTOMapicsData();
				
				Dom.XMLNode dhaenbNode = childNode.getChildElement('dhaenb', 'http://xmlns.oracle.com/nxsdschema');
				if(dhaenbNode != null) {
					newOrderDTO.dhaenb = dhaenbNode.getText();
				}
				
				Dom.XMLNode fechnbNode = childNode.getChildElement('fechnb', 'http://xmlns.oracle.com/nxsdschema');
				if(fechnbNode != null) {
					newOrderDTO.fechnb = fechnbNode.getText();
				}
				
				Dom.XMLNode slsnmNode = childNode.getChildElement('slsnm', 'http://xmlns.oracle.com/nxsdschema');
				if(slsnmNode != null) {
					newOrderDTO.slsnm = slsnmNode.getText();
				}
				
				Dom.XMLNode feabbjNode = childNode.getChildElement('feabbj', 'http://xmlns.oracle.com/nxsdschema');
				if(feabbjNode != null) {
					newOrderDTO.feabbj = feabbjNode.getText();
				}
				
				Dom.XMLNode bfhitxNode = childNode.getChildElement('bfhitx', 'http://xmlns.oracle.com/nxsdschema');
				if(bfhitxNode != null) {
					newOrderDTO.bfhitx = bfhitxNode.getText();
				}
				
				Dom.XMLNode ikgrpnamNode = childNode.getChildElement('ikgrpnam', 'http://xmlns.oracle.com/nxsdschema');
				if(ikgrpnamNode != null) {
					newOrderDTO.ikgrpnam = ikgrpnamNode.getText();
				}
				
				Dom.XMLNode iksupnamNode = childNode.getChildElement('iksupnam', 'http://xmlns.oracle.com/nxsdschema');
				if(iksupnamNode != null) {
					newOrderDTO.iksupnam = iksupnamNode.getText();
				}
				
				Dom.XMLNode ddaitxNode = childNode.getChildElement('ddaitx', 'http://xmlns.oracle.com/nxsdschema');
				if(ddaitxNode != null) {
					newOrderDTO.ddaitx = ddaitxNode.getText();
				}
				
				Dom.XMLNode umstadNode = childNode.getChildElement('umstad', 'http://xmlns.oracle.com/nxsdschema');
				if(umstadNode != null) {
					newOrderDTO.umstad = umstadNode.getText();
				}
				
				Dom.XMLNode pid1AwNode = childNode.getChildElement('pid1Aw', 'http://xmlns.oracle.com/nxsdschema');
				if(pid1AwNode != null) {
					newOrderDTO.pid1Aw = pid1AwNode.getText();
				}
				
				Dom.XMLNode pid2AwNode = childNode.getChildElement('pid2Aw', 'http://xmlns.oracle.com/nxsdschema');
				if(pid2AwNode != null) {
					newOrderDTO.pid2Aw = pid2AwNode.getText();
				}
				
				Dom.XMLNode uuccadNode = childNode.getChildElement('uuccad', 'http://xmlns.oracle.com/nxsdschema');
				if(uuccadNode != null) {
					newOrderDTO.uuccad = uuccadNode.getText();
				}
				
				Dom.XMLNode rcodeNode = childNode.getChildElement('rcode', 'http://xmlns.oracle.com/nxsdschema');
				if(rcodeNode != null) {
					newOrderDTO.rcode = rcodeNode.getText();
				}
				
				Dom.XMLNode shpyearNode = childNode.getChildElement('shpyear', 'http://xmlns.oracle.com/nxsdschema');
				if(shpyearNode != null) {
					newOrderDTO.shpyear = shpyearNode.getText();
				}
				
				Dom.XMLNode shpmonthNode = childNode.getChildElement('shpmonth', 'http://xmlns.oracle.com/nxsdschema');
				if(shpmonthNode != null) {
					newOrderDTO.shpmonth = shpmonthNode.getText();
				}
				
				Dom.XMLNode ddarqtNode = childNode.getChildElement('ddarqt', 'http://xmlns.oracle.com/nxsdschema');
				if(ddarqtNode != null) {
					newOrderDTO.ddarqt = ddarqtNode.getText();
				}
				
				Dom.XMLNode dddpvaNode = childNode.getChildElement('dddpva', 'http://xmlns.oracle.com/nxsdschema');
				if(dddpvaNode != null) {
					newOrderDTO.dddpva = dddpvaNode.getText();
				}
				
				Dom.XMLNode squaresNode = childNode.getChildElement('squares', 'http://xmlns.oracle.com/nxsdschema');
				if(squaresNode != null) {
					newOrderDTO.squares = squaresNode.getText();
				}
				
				Dom.XMLNode curidNode = childNode.getChildElement('curid', 'http://xmlns.oracle.com/nxsdschema');
				if(curidNode != null) {
					newOrderDTO.curid = curidNode.getText();
				}
				
				Dom.XMLNode statusNode = childNode.getChildElement('status', 'http://xmlns.oracle.com/nxsdschema');
				if(statusNode != null) {
					newOrderDTO.status = statusNode.getText();
				}
				returnOrderDTO.add(newOrderDTO);
			}

			return returnOrderDTO;
		}

		/**
		 * Extracts the external account Ids from the list of icDTOMapicsData
		 * Also adds hardcoded default account and generated default account by sales rep
		 *
		 * @param	mapicsData	a list of data transfer objects that represents Mapics data
		 * @return	returnListExternalAccountId	a unique list of external account Id
		 */
		public Set<String> getListExternalAccountIdsFromMapicsData(List<icDTOMapicsData> mapicsData) {
			Set<String> returnListExternalAccountId = new Set<String>();

			returnListExternalAccountId.add('99999999');
			for(icDTOMapicsData thisMapicsData : mapicsData) {
				returnListExternalAccountId.add(thisMapicsData.feabbj);
				returnListExternalAccountId.add('99999999-' + thisMapicsData.fechnb);
			}

			return returnListExternalAccountId;
		}

		/**
		 * Convert a list of icDTOMapicsData into a list of Salesforce Orders
		 *
		 * @param	mapicsData	a list of data transfer objects that represents Mapics data
		 * @param	mapAccountsByMapicsExternalId	a map of accounts by mapics external id
		 * @return	returnListOrders	a list of Salesforce Order Records
		 */
		public List<Order> getOrdersFromListMapicsData(List<icDTOMapicsData> mapicsData, Map<String, Account> mapAccountsByMapicsExternalId) {
			List<Order> returnListOrders = new List<Order>();

			// get the Record Type to assign to all Order records
			String orderRecordType = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Shipping Summary').getRecordTypeId();

			for(icDTOMapicsData thisMapicsData : mapicsData) {
				Account thisAccount = mapAccountsByMapicsExternalId.get(thisMapicsData.feabbj);
				if(thisAccount == null) {
					thisAccount = mapAccountsByMapicsExternalId.get('99999999-' + thisMapicsData.fechnb);
					if(thisAccount == null) {
						thisAccount = mapAccountsByMapicsExternalId.get('99999999');
					}
				}
				returnListOrders.add(mapper.getSFOrderFromDTOMapicsData(thisMapicsData, thisAccount, orderRecordType));
			}

			return returnListOrders;
		}

		/**
		 * Bridge logic to repository: query salesforce for a list of Orders by Mapics external Id
		 *
		 * @param	list of Account mapics ids to fetch the orders
		 * @return	the results of the list of orders 
		 */
		public List<Order> getOrdersByMapicIds(Set<String> accountMapicsIds) {
			return repo.getOrdersByMapicIds(accountMapicsIds);
		}

		/**
		 * @param	list of Orders to prepare the map of orders by customer number mapics
		 * @return	the results of the map of Orders by Mapics erp Id 
		 */
		public Map<String, List<Order>> getOrdersByMapicIdsMap(List<Order> orders){
			Map<String, List<Order>> ordersByMapicsIdMap = new Map<String, List<Order>>();
			System.debug('orders===' + orders);
			for(Order thisOrder : orders){

				if(!ordersByMapicsIdMap.containsKey(thisOrder.Customer_Number_Mapics__c)){
					ordersByMapicsIdMap.put(thisOrder.Customer_Number_Mapics__c, new List<Order>());
				}

				ordersByMapicsIdMap.get(thisOrder.Customer_Number_Mapics__c).add(thisOrder);
			}

			return ordersByMapicsIdMap;
		}

		/**
		 * Creates a list of Salesforce Orders and handles the result by saving individual error logs
		 *
		 * @param	orders	a list of Salesforce Orders
		 */
		public void saveOrders(List<Order> orders) {
			List<Database.SaveResult> saveResults = repo.createOrders(orders, false);
			Id jobID = System.enqueueJob(new icQueueableSaveResultHandler(saveResults, orders));
		}
		
		/**
		 * Updates a list of Salesforce Orders and handles the result by saving individual error logs
		 *
		 * @param	orders	a list of Salesforce Orders
		 */
		public void updateOrders(List<Order> orders) {
			List<Database.SaveResult> saveResults = repo.saveOrders(orders, false);
			Id jobID = System.enqueueJob(new icQueueableSaveResultHandler(saveResults, orders));
        }
	}
}