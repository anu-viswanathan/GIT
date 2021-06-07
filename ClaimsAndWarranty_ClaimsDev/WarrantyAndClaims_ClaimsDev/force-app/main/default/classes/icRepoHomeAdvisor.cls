public class icRepoHomeAdvisor implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		void createLead(Lead newLead);
	}

	public class Impl implements IClass {

		public void createLead(Lead newLead) {
			insert newLead;
		}
	}
}