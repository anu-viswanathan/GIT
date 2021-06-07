/**
 * Created by Andrea Pissinis on 2020-04-02.
 */
@isTest
public with sharing class icTestAvoidRecursion {

    static testMethod void test_runOnce(){
        Test.startTest();
        icAvoidRecursion.runOnce();
        Test.stopTest();
    }

}