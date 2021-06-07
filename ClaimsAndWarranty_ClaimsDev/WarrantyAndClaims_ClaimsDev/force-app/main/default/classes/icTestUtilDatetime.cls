@isTest
public with sharing class icTestUtilDatetime {

    static testMethod void test_generateErrorLog() {
		Datetime resultDT = icUtilDatetime.getLocalDateTime(Datetime.now());
	}
}