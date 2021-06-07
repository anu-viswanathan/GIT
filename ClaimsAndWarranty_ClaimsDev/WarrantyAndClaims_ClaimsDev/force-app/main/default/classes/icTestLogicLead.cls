/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestLogicLead {

    public static testMethod void test_getNewLeadsCountByAccountId(){
        icLogicLead.IClass BL = (icLogicLead.IClass) icObjectFactory.GetSingletonInstance('icLogicLead');

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoLead', new icRepoLeadMock());
        Lead l = new Lead();
        Lead l2 = new Lead();
        icTestMockUtilities.Tracer.SetReturnValue('icRepoLeadMock', 'getNewLeadsByAccountId', new List<Lead>{l,l2});

        BL.getNewLeadsCountByAccountId('','');

    }

}