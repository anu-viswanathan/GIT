/**
 * Created by Francois Poirier on 2019-11-14.
 */

@isTest
public with sharing class icTestAsyncServiceCentralStation {


    @isTest
    public static void testSyncAccount(){

        test.setMock(HttpCalloutMock.class, new icHTTPCalloutServiceMock());

        icAsyncServiceCentralStation.syncAccount(icTestHelperUtility.getFakeId(Account.SObjectType), '');

    }

}