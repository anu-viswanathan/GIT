/**
 * Created by Anil Mannem (Incloud) on 28-July-2020
 */
@isTest
public with sharing class icRepoCaseMock implements icRepoCase.IClass {
	/**
	 * Ticket ClaimsV2-931
	 * By Anil Mannem (Incloud) on 28-July-2020
	 */
    public List<Case> getCaseById(Set<String> caseId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getCaseById');
        params.put('caseId', caseId);
        return (List<Case>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getCaseById');
    }
}