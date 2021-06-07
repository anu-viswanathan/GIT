public class icRepoEmail implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		EmailTemplate getEmailTemplateByDevName(String templateDevName);
		OrgWideEmailAddress getOrgWideEmailByName(String orgWideEmailName);
	}

	public class Impl implements IClass {

		public EmailTemplate getEmailTemplateByDevName(String templateDevName) {
			return [SELECT Id, Body, HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName = :templateDevName LIMIT 1];
		}

		public OrgWideEmailAddress getOrgWideEmailByName(String orgWideEmailName) {
			return [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress WHERE DisplayName = :orgWideEmailName LIMIT 1];
		}
	}
}