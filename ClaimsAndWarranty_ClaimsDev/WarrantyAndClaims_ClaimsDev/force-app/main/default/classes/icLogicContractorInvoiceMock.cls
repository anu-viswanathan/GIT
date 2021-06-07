@isTest
public class icLogicContractorInvoiceMock  implements icLogicContractorInvoice.IClass{
    
    public void saveContractorInvoice(Contractor_Invoice__c invoice) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'saveContractorInvoice');
        params.put('invoice', invoice);
    }

    public Contractor_Invoice__c createNewContractorInvoiceFromProgram(String rebateProgram){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createNewContractorInvoiceFromProgram');
        params.put('rebateProgram', rebateProgram);
        return (Contractor_Invoice__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'createNewContractorInvoiceFromProgram');
    }

    public void removeFileIdsFromContractInvoice(Id contractorInvoiceId, List<String> fileIds){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'removeFileIdsFromContractInvoice');
        params.put('contractorInvoiceId', contractorInvoiceId);
        params.put('fileIds', fileIds);

    }

    public void deleteContractorInvoiceById(Id contractorInvoiceId){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'deleteContractorInvoiceById');
        params.put('contractorInvoiceId', contractorInvoiceId);

    }

    public Contractor_Invoice__c createNewContractorInvoiceFromProgram(String rebateProgram, Contractor_Invoice__c newInvoice){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'createNewContractorInvoiceFromProgram');
        params.put('rebateProgram', rebateProgram);
        params.put('newInvoice', newInvoice);
        return (Contractor_Invoice__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'createNewContractorInvoiceFromProgram');
    }
    
    public Contractor_Invoice__c getContractorInvoiceById(Id contractorInvoiceId){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getContractorInvoiceById');
        params.put('contractorInvoiceId', contractorInvoiceId);
        return (Contractor_Invoice__c) icTestMockUtilities.Tracer.GetReturnValue(this, 'getContractorInvoiceById');
    }
    
    public List<icDtoPickList> getRebatePrograms(){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getRebatePrograms');
        return (List<icDtoPickList>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getRebatePrograms');
    }
}