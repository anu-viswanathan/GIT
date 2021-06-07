/**
 * Created by Andrea Pissinis on 2018-09-27.
 */
@isTest
public with sharing class icTestDTOGreenSkySubscription {

    public static testMethod void testDTOSub(){

        icDTOGreenSkySubscription sub = new icDTOGreenSkySubscription();
        sub.merchantId = null;
        sub.userName = null;
        sub.password = null;
        sub.apiKey = null;
        System.assertEquals(sub.merchantId , null);
        System.assertEquals(sub.userName , null);
        System.assertEquals(sub.password , null);
        System.assertEquals(sub.apiKey , null);
    }

}