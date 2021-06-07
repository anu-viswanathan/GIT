/**
 * Created by Anil Mannem (Incloud) on 28-July-2020
 */
public class icLogicCase implements icIClass {

        public Object GetInstance() {
            return new Impl();
        }
    
        public Interface IClass {
            List<Case> getCaseById(Set<String> caseId);
        }
    
        public class Impl implements IClass {
    
            icRepoCase.IClass repo = (icRepoCase.IClass) icObjectFactory.GetSingletonInstance('icRepoCase');
    
            /**
             * Ticket ClaimsV2-931
             * Added logic to get Cases
             * By Anil Mannem (Incloud) on 28-July-2020
             */
            public List<Case> getCaseById(Set<String> caseId) {
                return repo.getCaseById(caseId);
            }
        }
    }