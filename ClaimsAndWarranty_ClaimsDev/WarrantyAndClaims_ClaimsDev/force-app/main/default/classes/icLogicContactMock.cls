/**
 * Created by Francois Poirier on 2018-12-13.
 */

@isTest
public with sharing class icLogicContactMock implements icLogicContact.IClass{

    public Contact getContactById(Id contactId){

        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getContactById');
        params.put('contactId', contactId);
        return (Contact) icTestMockUtilities.Tracer.GetReturnValue(this, 'getContactById');

    }

    public List<Contact> getPrimaryAdminContactsByContractorIds(List<String> contractorIds) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getPrimaryAdminContactsByContractorIds');
        params.put('contractorIds', contractorIds);
        return (List<Contact>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getPrimaryAdminContactsByContractorIds');
    }

    public Map<String, Contact> getMapPrimaryAdminContactByContractorId(List<Contact> contacts) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getMapPrimaryAdminContactByContractorId');
        params.put('contacts', contacts);
        return (Map<String, Contact>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getMapPrimaryAdminContactByContractorId');
    }
    
    public Contact saveContact(Contact record){

        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'saveContact');
        params.put('record', record);
        return (Contact) icTestMockUtilities.Tracer.GetReturnValue(this, 'saveContact');

    }

    public void handleVendorEmail(String contactId){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'handleVendorEmail');
        params.put('contactId', contactId);
        //return (returnType) icTestMockUtilities.Tracer.GetReturnValue(this, 'handleVendorEmail');        
    }

}