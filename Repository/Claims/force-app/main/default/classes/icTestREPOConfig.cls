/**
 * Created by Andrea Pissinis on 2018-09-12.
 */
@isTest
public with sharing class icTestREPOConfig {

    public static testMethod void test_getAPIConfigByName(){

        icRepoConfig.IClass repository = (icRepoConfig.IClass) icObjectFactory.GetSingletonInstance('icRepoConfig');
        
        repository.getAPIConfigByName('');

    }

    public static testMethod void test_getIkoGlobalConfigByName(){

        icRepoConfig.IClass repository = (icRepoConfig.IClass) icObjectFactory.GetSingletonInstance('icRepoConfig');
        
        repository.getIkoGlobalConfigByName('');

    }
     
    //Added for IKO-360 by Dominic Boivin on 06-10-2020
    public static testMethod void test_getCommunitySiteNameConfigByName(){

        icRepoConfig.IClass repository = (icRepoConfig.IClass) icObjectFactory.GetSingletonInstance('icRepoConfig');
        
        repository.getCommunitySiteNameConfigByName('');

    }
}