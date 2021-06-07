/**
 * The icMapOrder class is an object specific utility class for Order that is used to map/convert a data transfer object to a Salesforce record.
 * In this case icDTOMapicsData to Order.
 */
public with sharing class icMapOrder implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		Order getSFOrderFromDTOMapicsData(icDTOMapicsData mapicsData, Account account, String orderRecordType);
	}

	public class Impl implements IClass {

		/**
		 * Converts a single icDTOMapicsData into a Salesforce Order record
		 *
		 * @param	mapicsData	the data transfer objects that represents Mapics data to convert
		 * @param	account	the Salesforce Account identified by feabbj
		 * @param	orderRecordType	the RecordTypeId for the new Salesforce Order record
		 * @return	thisOrder	the Salesforce Order record
		 */
		public Order getSFOrderFromDTOMapicsData(icDTOMapicsData mapicsData, Account account, String orderRecordType) {
			Order thisOrder = new Order();

			Datetime invoiceDate = Date.newInstance(Integer.valueOf(mapicsData.shpyear), Integer.valueOf(mapicsData.shpmonth), 15);
            
			thisOrder.Name = account.Name + ' - ' + invoiceDate.format('MMMM') + ', ' + mapicsData.shpyear; 
			//Company Name – MMMM, YYYY : (e.g. Bill’s Roofing – July 2019.)

			thisOrder.RecordTypeId = orderRecordType;
			thisOrder.AccountId = account.Id;
			// Account.Mapics_ERP_ID__c = feabbj

			thisOrder.OwnerId = account.OwnerId;
			// Account Owner Id

			thisOrder.Status = 'Draft';
            thisOrder.EffectiveDate = invoiceDate.date().toStartOfMonth();
			thisOrder.Amount_MAPICS__c = Double.valueOf(mapicsData.dddpva);
			// thisOrder.CurrencyIsoCode (TBD)
			thisOrder.Product_Name__c = mapicsData.pid1Aw;
			thisOrder.Product_Colour__c = mapicsData.pid2Aw;
			thisOrder.MAPICS_Product_ID__c = mapicsData.ddaitx;
			thisOrder.Unit_of_Measure__c = mapicsData.umstad;
			thisOrder.Shipped_Quantity_MAPICS__c = Double.valueOf(mapicsData.ddarqt);
			thisOrder.Squares_MAPICS__c = Double.valueOf(mapicsData.squares);
			thisOrder.Company_Number_MAPICS__c = mapicsData.dhaenb;
			thisOrder.Customer_Number_Mapics__c = mapicsData.feabbj;
			thisOrder.Customer_Name_Mapics__c = mapicsData.bfhitx;
			thisOrder.Sales_Rep_Number_MAPICS__c = mapicsData.fechnb;
			thisOrder.Sales_Rep_Name_MAPICS__c = mapicsData.slsnm;
			thisOrder.Rebate_Group_Family__c = mapicsData.uuccad;
			thisOrder.Rebate_Code__c = mapicsData.rcode;
			thisOrder.Corporate_Head_Office__c = mapicsData.ikgrpnam;
			thisOrder.Regional_Head_Office__c = mapicsData.iksupnam;

			return thisOrder;
		}
	}
}