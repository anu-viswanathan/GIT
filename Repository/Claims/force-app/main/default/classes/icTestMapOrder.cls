@isTest
public with sharing class icTestMapOrder {

	public static testMethod void test_createOrders(){
		icMapOrder.IClass mapper = (icMapOrder.IClass) icObjectFactory.GetSingletonInstance('icMapOrder');

		icDTOMapicsData testDTO = new icDTOMapicsData();
                testDTO.dhaenb = 'dhaenb';
                testDTO.fechnb = 'fechnb';
                testDTO.slsnm = 'slsnm';
                testDTO.feabbj = 'feabbj';
                testDTO.bfhitx = 'bfhitx';
                testDTO.ikgrpnam = 'ikgrpnam';
                testDTO.iksupnam = 'iksupnam';
                testDTO.ddaitx = 'ddaitx';
                testDTO.umstad = 'umstad';
                testDTO.pid1Aw = 'pid1Aw';
                testDTO.pid2Aw = 'pid2Aw';
                testDTO.uuccad = 'uuccad';
                testDTO.rcode = 'rcode';
                testDTO.shpyear = '2019';
                testDTO.shpmonth = '8';
                testDTO.ddarqt = '1';
                testDTO.dddpva = '1.1';
                testDTO.squares = '1';
                testDTO.curid = 'curid';
                testDTO.status = 'status';

		Account mockAccount = new Account(Name = 'AccountName'
			,Id = icTestHelperUtility.getFakeId(Account.SObjectType)
			,OwnerId = icTestHelperUtility.getFakeId(User.SObjectType));

		String orderRecordType = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Shipping Summary').getRecordTypeId();

		Order resultOrder = mapper.getSFOrderFromDTOMapicsData(testDTO, mockAccount, orderRecordType);
	}
}