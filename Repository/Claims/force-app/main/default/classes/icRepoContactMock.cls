/**
 * Created by Francois Poirier on 2018-12-13.
 */

@isTest
public with sharing class icRepoContactMock implements icRepoContact.IClass{

    public Contact getContactById(Id contactId){

        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getContactById');
        params.put('contactId', contactId);
        return (Contact) icTestMockUtilities.Tracer.GetReturnValue(this, 'getContactById');

    }

    public Contact getContactsForVendorEmailById(String contactId, Schema.FieldSet vendorEmailFieldSet){

        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getContactsForVendorEmailById');
        params.put('contactId', contactId);
        params.put('vendorEmailFieldSet', vendorEmailFieldSet);
        return (Contact) icTestMockUtilities.Tracer.GetReturnValue(this, 'getContactsForVendorEmailById');

    }

    public List<Contact> getPrimaryAdminContactsByContractorIds(List<String> contractorIds) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getPrimaryAdminContactsByContractorIds');
        params.put('contractorIds', contractorIds);
        return (List<Contact>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getPrimaryAdminContactsByContractorIds');
    }

    public Contact saveContact(Contact record){

        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'saveContact');
        params.put('record', record);
        return (Contact) icTestMockUtilities.Tracer.GetReturnValue(this, 'saveContact');

    }
    
}