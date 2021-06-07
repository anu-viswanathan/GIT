public class icLogicHomeAdvisor implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		icDTOHALead getHALeadFromJSON(String jsonHALead);
		Lead getSFLeadFromHALead(icDTOHALead haLead);
		void processHALead(Lead newLead);
	}

	public class Impl implements IClass {

		icRepoHomeAdvisor.IClass repo = (icRepoHomeAdvisor.IClass) icObjectFactory.GetSingletonInstance('icRepoHomeAdvisor');
		icMapHomeAdvisor.IClass mapper = (icMapHomeAdvisor.IClass) icObjectFactory.GetSingletonInstance('icMapHomeAdvisor');

		public icDTOHALead getHALeadFromJSON(String jsonHALead) {
			icDTOHALead returnHALead;

			try {
				String cleanJSONHALead = replaceSFReservedFieldsFromJSON(jsonHALead);

				//returnHALead = (icDTOHALead)JSON.deserialize(cleanJSONHALead, icDTOHALead.Class);
				Map<String, Object> untypedMapLead = (Map<String, Object>)JSON.deserializeUntyped(jsonHALead);
				returnHALead = mapper.getDTOHALeadFromJSONMap(untypedMapLead);
			} catch(Exception ex) {
				icServiceErrorHandler.LogError('icLogicHomeAdvisor', 'getHALeadFromJSON', ex.getStackTraceString(), ex.getMessage(), jsonHALead);
			}

			return returnHALead;			 
		}

		public Lead getSFLeadFromHALead(icDTOHALead haLead) {
			Lead newLead;
			try {
				newLead = mapper.getSFLeadFromDTOHALead(haLead);				
			} catch (Exception ex) {
				icServiceErrorHandler.LogError('icLogicHomeAdvisor', 'getSFLeadFromHALead', ex.getStackTraceString(), ex.getMessage(), JSON.serialize(haLead));
			}
			return newLead;
		}

		public void processHALead(Lead newLead) {
			try {
				repo.createLead(newLead);				
			} catch (Exception ex) {
				icServiceErrorHandler.LogError('icLogicHomeAdvisor', 'processHALead', ex.getStackTraceString(), ex.getMessage(), JSON.serialize(newLead));
			}
		}

		private String replaceSFReservedFieldsFromJSON(String jsonString) {
			return jsonString.replace('"type":', '"type_HA":').replace('"end":', '"end_HA":');
		}
	}
}