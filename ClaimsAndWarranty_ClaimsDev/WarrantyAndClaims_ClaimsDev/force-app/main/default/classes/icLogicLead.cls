public class icLogicLead implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		Integer getNewLeadsCountByAccountId(String recordId, String ownerId);
	}

	public class Impl implements IClass {

		icRepoLead.IClass repository = (icRepoLead.IClass) icObjectFactory.GetSingletonInstance('icRepoLead');

		public Integer getNewLeadsCountByAccountId(String recordId, String ownerId) {
			List<Lead> listLeads = repository.getNewLeadsByAccountId(recordId, ownerId);
			return listLeads.size();
		}
	}
}