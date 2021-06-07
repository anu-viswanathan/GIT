public class icRepoQuote implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		Quote getQuoteInfoById(String recordId);		
	}

	public class Impl implements IClass {

		public Quote getQuoteInfoById(String recordId) {
			List<Quote> listQuote = [SELECT	Id
							,Name
							,OpportunityId
							,Opportunity.Name
							,Opportunity.AccountId
							,BillingStreet
							,BillingCity
							,BillingState
							,BillingCountry
							,BillingPostalCode
					FROM	Quote
					WHERE	Id = :recordId
					LIMIT	1];
			if(listQuote.size() == 1) {
				return listQuote[0];
			}
			return null;
		}
	}
}