public class icLogicQuote implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		Quote getQuoteInfoById(String recordId);		
	}

	public class Impl implements IClass {

		icRepoQuote.IClass repo = (icRepoQuote.IClass) icObjectFactory.GetSingletonInstance('icRepoQuote');

		public Quote getQuoteInfoById(String recordId) {
			return repo.getQuoteInfoById(recordId);
		}
	}
}