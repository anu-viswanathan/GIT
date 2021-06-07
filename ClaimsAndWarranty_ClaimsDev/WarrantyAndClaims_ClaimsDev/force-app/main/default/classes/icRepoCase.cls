/**
 * Created by Anil Mannem (Incloud) on 28-July-2020
 */
public class icRepoCase implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		List<Case> getCaseById(Set<String> caseId);
	}

	public class Impl implements IClass {
		/** Ticket ClaimsV2-931
		 *  Added Repo to query Cases
		 *  By Anil Mannem (Incloud) on 28-July-2020
		 */
		public List<Case> getCaseById(Set<String> caseId) {
            return [SELECT  Id,
                            Claim_Number__c,
                            Claim_Stage__c
                    FROM Case
                    WHERE Id =:caseId];
		}
	}
}