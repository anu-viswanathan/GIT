/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icTestLogicConfig {

    static void initTest() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoConfig', new icRepoConfigMock());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoConfigMock', 'getAPIConfigByName', new API_Configuration__mdt());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoConfigMock', 'getIkoGlobalConfigByName', new Iko_Global_Configurations__mdt());
        icTestMockUtilities.Tracer.SetReturnValue('icRepoConfigMock', 'getCommunitySiteNameConfigByName', new CommunitySiteNameConfiguration__mdt());
    }

    public static testMethod void test_getAPIConfigByName(){

        initTest();
        icLogicConfig.IClass BL = (icLogicConfig.IClass) icObjectFactory.GetSingletonInstance('icLogicConfig');

        BL.getAPIConfigByName('');

    }

    public static testMethod void test_getIkoGlobalConfigByName(){

        initTest();
        icLogicConfig.IClass BL = (icLogicConfig.IClass) icObjectFactory.GetSingletonInstance('icLogicConfig');

        BL.getIkoGlobalConfigByName('');

    }

    //Added for IKO-360 by Dominic Boivin on 06-10-2020
    public static testMethod void test_getCommunitySiteNameConfigByName(){

        initTest();
        icLogicConfig.IClass BL = (icLogicConfig.IClass) icObjectFactory.GetSingletonInstance('icLogicConfig');

        BL.getCommunitySiteNameConfigByName('');

    }
}