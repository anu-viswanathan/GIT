@isTest
public with sharing class icTestLogicOrder {

	public static testMethod void test_getOrderDTOFromMapicsPayload(){
		icLogicOrder.IClass logic = (icLogicOrder.IClass) icObjectFactory.GetSingletonInstance('icLogicOrder');

		String xmlPayload = '<?xml version="1.0" encoding="UTF-8"?><Root-Element xmlns="http://xmlns.oracle.com/nxsdschema" xmlns:jca="http://xmlns.oracle.com/pcbpel/wsdl/jca/" xmlns:ns2="http://salesforce.ikomapicsgps.com/sfLoginRest_login_response" xmlns:ns1="http://xmlns.oracle.com/pcbpel/adapter/db/GPSToSalesforceApp/GPSToSalesforceProject/ExtractMapicsGPSData" xmlns:ns4="http://iko.xmltojson.com/nxsdschema" xmlns:ns3="http://salesforcegps.iko.com/insertmapicsgps" xmlns:pc="http://xmlns.oracle.com/pcbpel/" xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/" xmlns:plt="http://schemas.xmlsoap.org/ws/2003/05/partner-link/" xmlns:tns="http://xmlns.oracle.com/nxsdschema"><tns:topLevelArray><tns:dhaenb>47</tns:dhaenb><tns:fechnb>10057</tns:fechnb><tns:slsnm>BRAMPTON - HOUSE</tns:slsnm><tns:feabbj>20236712</tns:feabbj><tns:bfhitx>HYLOAD INC.</tns:bfhitx><tns:ikgrpnam>HYLOAD INC.</tns:ikgrpnam><tns:iksupnam>iksupnam</tns:iksupnam><tns:ddaitx>CTC</tns:ddaitx><tns:umstad>umstad</tns:umstad><tns:pid1Aw>Cost Recharge - Cross Border</tns:pid1Aw><tns:pid2Aw>pid2Aw</tns:pid2Aw><tns:uuccad>uuccad</tns:uuccad><tns:rcode>rcode</tns:rcode><tns:shpyear>2017</tns:shpyear><tns:shpmonth>7</tns:shpmonth><tns:ddarqt>0.000</tns:ddarqt><tns:dddpva>1508.670</tns:dddpva><tns:squares>0.000</tns:squares><tns:curid>0.000</tns:curid><tns:status>0.000</tns:status></tns:topLevelArray></Root-Element>';

		List<icDTOMapicsData> testResult = logic.getOrderDTOFromMapicsPayload(xmlPayload);
	}

	public static testMethod void test_getListExternalAccountIdsFromMapicsData() {
		icLogicOrder.IClass logic = (icLogicOrder.IClass) icObjectFactory.GetSingletonInstance('icLogicOrder');
		
		List<icDTOMapicsData> mapicsData = new List<icDTOMapicsData>();
		icDTOMapicsData mockMapicsData = new icDTOMapicsData();
		mockMapicsData.dhaenb = 'dhaenb';
		mockMapicsData.feabbj = 'feabbj';
		mockMapicsData.fechnb = 'fechnb';
		mapicsData.add(mockMapicsData);

		Set<String> resultSet = logic.getListExternalAccountIdsFromMapicsData(mapicsData);
	}

	public static testMethod void test_getOrdersFromListMapicsData() {
		icTestMockUtilities.Mocker.SetMockSingletonInstance('icMapOrder', new icMapOrderMock());
		icTestMockUtilities.Tracer.SetReturnValue('icMapOrderMock', 'getSFOrderFromDTOMapicsData', new Order());

		icLogicOrder.IClass logic = (icLogicOrder.IClass) icObjectFactory.GetSingletonInstance('icLogicOrder');

		List<icDTOMapicsData> mapicsData = new List<icDTOMapicsData>();
		icDTOMapicsData mockMapicsData1 = new icDTOMapicsData();
		mockMapicsData1.dhaenb = 'dhaenb';
		mockMapicsData1.feabbj = 'feabbj';
		mockMapicsData1.fechnb = 'fechnb';
		mapicsData.add(mockMapicsData1);

		icDTOMapicsData mockMapicsData2 = new icDTOMapicsData();
		mockMapicsData2.dhaenb = 'notdhaenb';
		mockMapicsData2.feabbj = 'notfeabbj';
		mockMapicsData2.fechnb = 'fechnb';
		mapicsData.add(mockMapicsData2);

		icDTOMapicsData mockMapicsData3 = new icDTOMapicsData();
		mockMapicsData3.dhaenb = 'notdhaenb';
		mockMapicsData3.feabbj = 'notfeabbj';
		mockMapicsData3.fechnb = 'notfechnb';
		mapicsData.add(mockMapicsData3);

		Map<String, Account> mapAccountsByMapicsExternalId = new Map<String, Account>();
		mapAccountsByMapicsExternalId.put('feabbj', new Account());
		mapAccountsByMapicsExternalId.put('99999999-fechnb', new Account());

		List<Order> resultList = logic.getOrdersFromListMapicsData(mapicsData, mapAccountsByMapicsExternalId);
	}

	public static testMethod void Test_getOrdersByMapicIdsMap(){

		icLogicOrder.IClass logic = (icLogicOrder.IClass) icObjectFactory.GetSingletonInstance('icLogicOrder');
		List<Order> orders = new List<Order>();
        orders.add(new Order(Customer_Number_Mapics__c = '11234532', 
							 EffectiveDate = System.today(), 
							 Status = 'Draft'));

		logic.getOrdersByMapicIdsMap(orders);
	}

	public static testMethod void Test_getOrdersByMapicIds(){

		icLogicOrder.IClass logic = (icLogicOrder.IClass) icObjectFactory.GetSingletonInstance('icLogicOrder');
		logic.getOrdersByMapicIds(new Set<String>{'12345678'});
	}

	
	public static testMethod void test_saveOrders() {
		icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoOrder', new icRepoOrderMock());
		List<Database.SaveResult> mockSaveResults = new List<Database.SaveResult>();
		Database.SaveResult mockSaveResult = (Database.SaveResult) JSON.deserialize('{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', Database.SaveResult.class);
		mockSaveResults.add(mockSaveResult);
		icTestMockUtilities.Tracer.SetReturnValue('icRepoOrderMock', 'createOrders', mockSaveResults);

		icLogicOrder.IClass logic = (icLogicOrder.IClass) icObjectFactory.GetSingletonInstance('icLogicOrder');
		
		List<Order> orders = new List<Order>();
		orders.add(new Order());

		logic.saveOrders(orders);
	}

	public static testMethod void test_updateOrders() {
		icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoOrder', new icRepoOrderMock());
		List<Database.SaveResult> mockSaveResults = new List<Database.SaveResult>();
		Database.SaveResult mockSaveResult = (Database.SaveResult) JSON.deserialize('{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', Database.SaveResult.class);
		mockSaveResults.add(mockSaveResult);
		icTestMockUtilities.Tracer.SetReturnValue('icRepoOrderMock', 'createOrders', mockSaveResults);

		icLogicOrder.IClass logic = (icLogicOrder.IClass) icObjectFactory.GetSingletonInstance('icLogicOrder');
		
		List<Order> orders = new List<Order>();
		orders.add(new Order());

		logic.updateOrders(orders);
	}
}