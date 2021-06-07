/**
 * Created by Anil Mannem (Incloud) on 28-July-2020
 */
@isTest
public with sharing class icTestLogicCase {

    static void initTest() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoCase', new icRepoCaseMock());
        List<Case> caseList = new List<Case>();
        Case newCase = new Case(Origin='Owner');
        caseList.add(newCase);
        icTestMockUtilities.Tracer.SetReturnValue('icRepoCaseMock', 'getCaseById', caseList);
     }
    /**
     * Ticket ClaimsV2-931
     * By Anil Mannem (Incloud) on 28-July-2020
     */
    @isTest
    static void test_getCaseById(){
        initTest();
        icLogicCase.IClass logic = (icLogicCase.IClass) icObjectFactory.GetSingletonInstance('icLogicCase');
        Set<String> s = new Set<String>{'123'};
        logic.getCaseById(s);
    }
}