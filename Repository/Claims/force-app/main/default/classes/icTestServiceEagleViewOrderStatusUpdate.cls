/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestServiceEagleViewOrderStatusUpdate {

    public static testMethod void test_doGet(){

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicEagleViewReport', new icLogicEagleViewReportMock());

        icServiceEagleViewOrderStatusUpdate.doGet();

    }

}