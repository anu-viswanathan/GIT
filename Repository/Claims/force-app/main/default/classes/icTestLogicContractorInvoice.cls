/**
 * Created by incloud on 2020-05-20.
 */

@isTest
public with sharing class icTestLogicContractorInvoice {
    
    public static string siteName = 'CRCRoofPRO21';

    static void initTest() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicContractorInvoice', new icLogicContractorInvoiceMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicContractorInvoiceMock', 'getRebatePrograms', new List<icDtoPickList>());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicContractorInvoiceMock', 'getContractorInvoiceById', new Contractor_Invoice__c());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicContractorInvoiceMock', 'removeFileIdsFromContractInvoice', new List<String>());


    }
    public static testMethod void test_saveContractorInvoice() {

        icLogicContractorInvoice.IClass logic = (icLogicContractorInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicContractorInvoice');
        Contractor_Invoice__c contractorInvoice = new Contractor_Invoice__c();
        logic.saveContractorInvoice(contractorInvoice);

    }


    public static testMethod void test_createNewContractorInvoiceFromProgram_CRC() {

        icLogicContractorInvoice.IClass logic = (icLogicContractorInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicContractorInvoice');
        List<icDtoPickList> icDtoPicklistObjs = logic.getRebatePrograms();
        logic.createNewContractorInvoiceFromProgram(icDtoPicklistObjs[0].value);
        logic.createNewContractorInvoiceFromProgram(icDtoPicklistObjs[0].value, new Contractor_Invoice__c());
    }
    
    public static testMethod void test_createNewContractorInvoiceFromProgram_IKOROOF() {
		siteName = 'IKOROOFPRO_C';
        icLogicContractorInvoice.IClass logic = (icLogicContractorInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicContractorInvoice');
        List<icDtoPickList> icDtoPicklistObjs = logic.getRebatePrograms();
        logic.createNewContractorInvoiceFromProgram(icDtoPicklistObjs[0].value);
        logic.createNewContractorInvoiceFromProgram(icDtoPicklistObjs[0].value, new Contractor_Invoice__c());
    }

    public static testMethod void test_getRebatePrograms_CRC() {
        icLogicContractorInvoice.IClass logic = (icLogicContractorInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicContractorInvoice');
        logic.getRebatePrograms();
    }
    public static testMethod void test_getRebatePrograms_IKOROOF() {
		siteName = 'IKOROOFPRO_C';
        icLogicContractorInvoice.IClass logic = (icLogicContractorInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicContractorInvoice');
        logic.getRebatePrograms();
    }

    public static testMethod void test_getContractorInvoiceById() {


        icLogicContractorInvoice.IClass logic = (icLogicContractorInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicContractorInvoice');
        Contractor_Invoice__c contractorInvoice = new Contractor_Invoice__c();
        logic.saveContractorInvoice(contractorInvoice);
        logic.getContractorInvoiceById(contractorInvoice.Id);
    }

    public static testMethod void test_deleteContractorInvoiceById() {

        icLogicContractorInvoice.IClass logic = (icLogicContractorInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicContractorInvoice');
        Contractor_Invoice__c contractorInvoice = new Contractor_Invoice__c();
        logic.saveContractorInvoice(contractorInvoice);
        logic.deleteContractorInvoiceById(contractorInvoice.Id);
    }

    public static testMethod void test_removeFileIdsFromContractInvoice() {

        icLogicContractorInvoice.IClass logic = (icLogicContractorInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicContractorInvoice');
        String fileId1 = icTestHelperUtility.getFakeId(ContentDocument.SObjectType);
        String fileId2 = icTestHelperUtility.getFakeId(ContentDocument.SObjectType);

        Contractor_Invoice__c contractorInvoice = new Contractor_Invoice__c();
        contractorInvoice.Uploaded_Files_Long__c = fileId1;
        logic.saveContractorInvoice(contractorInvoice);
        logic.removeFileIdsFromContractInvoice(contractorInvoice.Id , new List<String>{fileId1});

        contractorInvoice.Uploaded_Files_Long__c = fileId1 +','+fileId2;
        logic.saveContractorInvoice(contractorInvoice);
        logic.removeFileIdsFromContractInvoice(contractorInvoice.Id , new List<String>{fileId1});
    }
    

}