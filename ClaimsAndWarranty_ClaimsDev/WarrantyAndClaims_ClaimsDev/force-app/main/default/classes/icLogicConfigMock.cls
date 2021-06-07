/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icLogicConfigMock implements icLogicConfig.IClass{

    public API_Configuration__mdt getAPIConfigByName(String configName) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAPIConfigByName');
        params.put('configName', configName);
        return (API_Configuration__mdt) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAPIConfigByName');
    }

    public Iko_Global_Configurations__mdt getIkoGlobalConfigByName(String configName) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getIkoGlobalConfigByName');
        params.put('configName', configName);
        return (Iko_Global_Configurations__mdt) icTestMockUtilities.Tracer.GetReturnValue(this, 'getIkoGlobalConfigByName');
    }
     //Added for IKO-360 by Dominic Boivin on 06-10-2020
    public CommunitySiteNameConfiguration__mdt getCommunitySiteNameConfigByName(String configName) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getCommunitySiteNameConfigByName');
        params.put('configName', configName);
        return (CommunitySiteNameConfiguration__mdt) icTestMockUtilities.Tracer.GetReturnValue(this, 'getCommunitySiteNameConfigByName');
    }
}