@isTest
public class icTestCtrlInvoiceUpload {

    public static testMethod void test_newContractorInvoice(){

        Test.startTest();
        
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicContractorInvoice', new icLogicContractorInvoiceMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicContractorInvoiceMock', 'newContractorInvoice', new Contractor_Invoice__c());
        String rebateProgram = getActiveRebateProgram();
        icCTRLinvoiceUpload.newContractorInvoice(rebateProgram, new Contractor_Invoice__c());
        Test.stopTest();
    }

    public static testMethod void test_saveInvoice(){

        Test.startTest();
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicContractorInvoice', new icLogicContractorInvoiceMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicContractorInvoiceMock', 'newContractorInvoice', new Contractor_Invoice__c());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicContractorInvoiceMock', 'saveContractorInvoice', new Contractor_Invoice__c());
        String rebateProgram = getActiveRebateProgram();
        Contractor_Invoice__c contractObj = icCTRLinvoiceUpload.newContractorInvoice(rebateProgram, new Contractor_Invoice__c());
        icCTRLinvoiceUpload.saveInvoice(contractObj);
        Test.stopTest();
    }


    public static testMethod void test_getRebatePrograms(){
        icCTRLinvoiceUpload.getRebatePrograms();
    }

    public static testMethod void test_getComponentDetails()
    {
        String rebateProgram = getActiveRebateProgramCRC();
        Contractor_Invoice__c contractObj = icCTRLinvoiceUpload.newContractorInvoice(rebateProgram, new Contractor_Invoice__c());
        icCTRLinvoiceUpload.getComponentDetails(contractObj.Id);
    }

    public static testMethod void test_deleteUploadedFiles(){

        Test.startTest();

        String rebateProgram = getActiveRebateProgramCRC();
        Contractor_Invoice__c contractObj = icCTRLinvoiceUpload.newContractorInvoice(rebateProgram, new Contractor_Invoice__c());
        icCTRLinvoiceUpload.deleteUploadedFiles(new List<String>(), contractObj.Id);

        Test.stopTest();

    }

    public static testMethod void test_deleteContractInvoice(){

        Test.startTest();

        String rebateProgram = getActiveRebateProgramCRC();
        Contractor_Invoice__c contractObj = icCTRLinvoiceUpload.newContractorInvoice(rebateProgram, new Contractor_Invoice__c());
        icCTRLinvoiceUpload.deleteContractInvoice(contractObj.Id);

        Test.stopTest();

    }

    static String getActiveRebateProgram(){
        String rebateProgram = '';
        Schema.DescribeFieldResult fieldResult =
            Contractor_Invoice__c.Rebate_Program_US__c .getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            if(f.isActive()){
                rebateProgram = f.getValue();
                break;
            }
            
        } 
        return rebateProgram;
        
    }
    
     static String getActiveRebateProgramCRC(){
        String rebateProgram = '';
        Schema.DescribeFieldResult fieldResult =
            Contractor_Invoice__c.Rebate_Program_CRC_c__c .getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            if(f.isActive()){
                rebateProgram = f.getValue();
                break;
            }
            
        } 
        return rebateProgram;
        
    }
                
}