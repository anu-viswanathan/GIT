@isTest(SeeAllData=true)
public with sharing class icTestCtrlSelfRegistration {

	public static testMethod void test_registerNew() {
		icCtrlSelfRegistration.registerNew('firstName', 'lastName', 'email@email.com', 'Password!1234', 'Password!1234');
	}

}