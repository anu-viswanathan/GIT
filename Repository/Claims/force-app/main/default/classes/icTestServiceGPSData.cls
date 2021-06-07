@isTest
public with sharing class icTestServiceGPSData {

	static void initTest() {
		icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicOrder', new icLogicOrderMock());
		icTestMockUtilities.Tracer.SetReturnValue('icLogicOrderMock', 'getOrderDTOFromMapicsPayload', new List<icDTOMapicsData>());
		icTestMockUtilities.Tracer.SetReturnValue('icLogicOrderMock', 'getListExternalAccountIdsFromMapicsData', new Set<String>());
		icTestMockUtilities.Tracer.SetReturnValue('icLogicOrderMock', 'getOrdersFromListMapicsData', new List<Order>());

		icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicAccount', new icLogicAccountMock());
		icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountMock', 'getAccountsByMapicsExternalId', new List<Account>());
		icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountMock', 'getMapAccountsByMapicsExternalId', new Map<String, Account>());
	}

	public static testMethod void testPost() {
		initTest();

		RestContext.request = new RestRequest();
		RestContext.request.requestBody = Blob.valueOf('<?xml version="1.0" encoding="UTF-8"?><Root-Element xmlns="http://xmlns.oracle.com/nxsdschema" xmlns:jca="http://xmlns.oracle.com/pcbpel/wsdl/jca/" xmlns:ns2="http://salesforce.ikomapicsgps.com/sfLoginRest_login_response" xmlns:ns1="http://xmlns.oracle.com/pcbpel/adapter/db/GPSToSalesforceApp/GPSToSalesforceProject/ExtractMapicsGPSData" xmlns:ns4="http://iko.xmltojson.com/nxsdschema" xmlns:ns3="http://salesforcegps.iko.com/insertmapicsgps" xmlns:pc="http://xmlns.oracle.com/pcbpel/" xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/" xmlns:plt="http://schemas.xmlsoap.org/ws/2003/05/partner-link/" xmlns:tns="http://xmlns.oracle.com/nxsdschema"><tns:topLevelArray><tns:dhaenb>47</tns:dhaenb><tns:fechnb>10057</tns:fechnb><tns:slsnm>BRAMPTON - HOUSE</tns:slsnm><tns:feabbj>20236712</tns:feabbj><tns:bfhitx>HYLOAD INC.</tns:bfhitx><tns:ikgrpnam>HYLOAD INC.</tns:ikgrpnam><tns:iksupnam>iksupnam</tns:iksupnam><tns:ddaitx>CTC</tns:ddaitx><tns:umstad>umstad</tns:umstad><tns:pid1Aw>Cost Recharge - Cross Border</tns:pid1Aw><tns:pid2Aw>pid2Aw</tns:pid2Aw><tns:uuccad>uuccad</tns:uuccad><tns:rcode>rcode</tns:rcode><tns:shpyear>2017</tns:shpyear><tns:shpmonth>7</tns:shpmonth><tns:ddarqt>0.000</tns:ddarqt><tns:dddpva>1508.670</tns:dddpva><tns:squares>0.000</tns:squares><tns:curid>0.000</tns:curid><tns:status>0.000</tns:status></tns:topLevelArray></Root-Element>');
				
		icServiceGPSData.doPost();
	}
}