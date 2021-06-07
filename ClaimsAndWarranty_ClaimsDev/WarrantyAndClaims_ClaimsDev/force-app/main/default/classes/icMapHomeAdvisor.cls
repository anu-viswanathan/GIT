public class icMapHomeAdvisor implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		Lead getSFLeadFromDTOHALead(icDTOHALead haLead);
		icDTOHALead getDTOHALeadFromJSONMap(Map<String, Object> untypedMapLead);
	}

	public class Impl implements IClass {

		public Lead getSFLeadFromDTOHALead(icDTOHALead haLead) {
			Lead sfLead = new Lead(
				OwnerId = haLead.crmKey
				,RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('IKO ROOFPRO Lead').getRecordTypeId()
				,LeadSource = 'Home Advisor'
				,FirstName = haLead.firstName
				,LastName = haLead.lastName
				,Street = haLead.address
				,City = haLead.city
				,StateCode = haLead.stateProvince
				,PostalCode = haLead.postalCode
				,CountryCode = 'US'
				,Phone = haLead.primaryPhone
				,Phone_Extension__c  = haLead.phoneExt
				,Secondary_Phone__c = haLead.secondaryPhone
				,Secondary_Phone_Extension__c = haLead.secondaryPhoneExt
				,Email = haLead.email
				,Service_Request_Id__c = haLead.srOid
				,Source_Lead_Id__c = haLead.leadOid
				,Source_Task_Id__c = haLead.taskOid
				,Task_Name__c = haLead.taskName
				,SPPartnerID__c = haLead.spPartnerId
				,Comments__c = haLead.comments
				,Match_Type__c = haLead.matchType
				,Source_Description__c = haLead.leadDescription
				,Source_Entity_Id__c = haLead.spEntityId
				,Source_Company_Name__c = haLead.spCompanyName
				//,JSON_Interview__c = JSON.serialize(haLead.interview)
				,JSON_Interview__c = haLead.interview
				//,JSON_Appointment__c = JSON.serialize(haLead.appointment));
				,JSON_Appointment__c = haLead.appointment);
			return sfLead;
		}
		
		public icDTOHALead getDTOHALeadFromJSONMap(Map<String, Object> untypedMapLead) {
            icDTOHALead returnDTO = new icDTOHALead();
            returnDTO.crmKey = (String)untypedMapLead.get('crmKey');
            returnDTO.firstName = (String)untypedMapLead.get('firstName');
            returnDTO.lastName = (String)untypedMapLead.get('lastName');
            returnDTO.address = (String)untypedMapLead.get('address');
            returnDTO.city = (String)untypedMapLead.get('city');
            returnDTO.stateProvince = (String)untypedMapLead.get('stateProvince');
            returnDTO.postalCode = (String)untypedMapLead.get('postalCode');
            returnDTO.primaryPhone = (String)untypedMapLead.get('primaryPhone');
            returnDTO.phoneExt = (String)untypedMapLead.get('phoneExt');
            returnDTO.secondaryPhone = (String)untypedMapLead.get('secondaryPhone');
            returnDTO.secondaryPhoneExt = (String)untypedMapLead.get('secondaryPhoneExt');
            returnDTO.email = (String)untypedMapLead.get('email');
            returnDTO.srOid = (Integer)untypedMapLead.get('srOid');
            returnDTO.leadOid = (Integer)untypedMapLead.get('leadOid');
            returnDTO.taskOid = (Integer)untypedMapLead.get('taskOid');
            returnDTO.taskName = (String)untypedMapLead.get('taskName');
            returnDTO.spPartnerId = (String)untypedMapLead.get('spPartnerId');
            returnDTO.comments = (String)untypedMapLead.get('comments');
            returnDTO.matchType = (String)untypedMapLead.get('matchType');
            returnDTO.leadDescription = (String)untypedMapLead.get('leadDescription');
            returnDTO.spEntityId = (Integer)untypedMapLead.get('spEntityId');
            returnDTO.spCompanyName = (String)untypedMapLead.get('spCompanyName');
            try {
                returnDTO.interview = (String)untypedMapLead.get('interview');
            } catch(Exception ex) {}
            try {
                returnDTO.interview = JSON.serialize((List<Object>)untypedMapLead.get('interview'));
            } catch(Exception ex) {}

            try {
                returnDTO.appointment = (String)untypedMapLead.get('appointment');
            } catch(Exception ex) {
                System.debug('String Appointment Exception: ' + ex.getMessage());
            }
            try {
                Map<String, Object> tempAppointment = (Map<String, Object>)untypedMapLead.get('appointment');
                System.debug('tempAppointment: ' + tempAppointment);
                returnDTO.appointment = JSON.serialize((Map<String, Object>)untypedMapLead.get('appointment'));
            } catch(Exception ex) {
                System.debug('Object Appointment Exception: ' + ex.getMessage());
            }
            
            //List<icDTOHAQuestion>
            //icDTOHAAppointment appointment 
                
            return returnDTO;
        }
    }
}