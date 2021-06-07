/**
 * Created by Andrea Pissinis on 2018-09-27.
 */
@isTest
public with sharing class icTestDTOCommunityNavigationAuth {

    public static testMethod void testNavAuth(){

        icDTOCommunityNavigationAuth a = new icDTOCommunityNavigationAuth();
    a.accountId = null;
    a.sessionId = null;
        System.assertEquals( a.accountId , null);
        System.assertEquals( a.sessionId , null);

    }

}