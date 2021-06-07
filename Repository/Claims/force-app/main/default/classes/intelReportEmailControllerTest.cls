@isTest
private class intelReportEmailControllerTest {
    private static final String CONTACT_LAST_NAME1 = '793d10bdfc2a96bcff';
    private static final String CONTACT_LAST_NAME2 = '793a12bdfc2a96bcff';
    private static final String CONTACT_LAST_NAME3 = '793a13zdfc2a96bcff';
    private static final String CONTACT_LAST_NAME4 = '793a13z1fc2a96bca1';
    private static final String CONTACT_LAST_NAME5 = '793a13z1fc2a96bca2';
    private static final String CONTACT_LAST_NAME6 = '793a13z2fc2a96bca3';
    private static final String CONTACT_LAST_NAME7 = '793a13z2fc2a96bca4';
    private static final String CONTACT_LAST_NAME8 = '793a13z2fc2a96bca5';
    private static final String CONTACT_LAST_NAME9 = '793a13z2fc2a96bca6';
    private static final String CONTACT_LAST_NAME10 = '793a13z2fc2a96bca7';
    private static final String CONTACT_LAST_NAME11 = '793a13z2fc2a96bca8';
    private static final String CONTACT_LAST_NAME12 = '793a13z2fc2a96bca9';
    private static final String CONTACT_LAST_NAME13 = '793a13z2fc2a96bcaa';
    private static final String CONTACT_LAST_NAME14 = '793a13z2fc2a96bcab';
    private static final String CONTACT_LAST_NAME15 = '793a13z2fc2a96bcac';
    private static final String CONTACT_LAST_NAME16 = '793a13z2fc2a96bcad';
    private static final String CONTACT_LAST_NAME17 = '793a13z2fc2a96bcae';
    private static final String CONTACT_LAST_NAME18 = '793a13z2fc2a96bcaf';
	@istest static void testGetEmailBody_singleCommercialManufacturingManager()
    {
        //create a manager
        system.debug('create a manager');
        User uManager = TestDataFactory.createUser('System Administrator', CONTACT_LAST_NAME1, CONTACT_LAST_NAME1+'@gmail.com', null);
        
        //create a user
        system.debug('create a user');
        User uWorker = TestDataFactory.createUser('System Administrator', CONTACT_LAST_NAME2, CONTACT_LAST_NAME2+'@gmail.com', uManager.Id);
        //create an Intel User
        Intel_Report_User__c IRU =TestDataFactory.createIntelReportUser(CONTACT_LAST_NAME2, CONTACT_LAST_NAME2+'@gmail.com', uWorker.Id);
        system.debug('create an Intel User');
        //Create an Intel Role
        Intel_Report_Role__c IRR =TestDataFactory.createIntelReportRole('Commercial Manufacturing Manager', null);
        system.debug('Create an Intel Role');
        //Create an Intel User Role
        Intel_Report_Users_by_Role__c IRUR = TestDataFactory.createIntelReportUsersbyRole(IRR.ID, IRU.ID, 'Manager');
        system.debug('Create an Intel User Role');
        
        
        
        //Create an Intel report with Draft Status
        Intelligence_Report__c IR =TestDataFactory.createIntelligenceReport('Canadian Commercial',IRU.Id, 'Commercial','Test Product description');
        system.debug('Create an Intel report with Draft Status');
        //Create an Intel report Line Item
        Intelligence_Report_Line_Item__c IRLI =TestDataFactory.createIntelligenceReportLineItem(IR.Id,'Miscellaneous');
        system.debug('Create an Intel report Line Item ');
        //change the running user
        System.runAs(uWorker){
            //change the status to subitted and save
            IR.Status__c = 'Submitted';
            Intelligence_Report__c AccessIR = [select ID from Intelligence_Report__c].get(0);
            system.debug('before updating');
            system.debug(AccessIR.Id);
            system.debug(IR.Id);
            system.debug('still before updating');

            Update IR;
            system.debug(IR.Id);
        }
        
    }
    
    @istest static void testGetEmailBody_singleResidentialManufacturingManager()
    {
        //create a manager
        system.debug('create a manager');
        User uManager = TestDataFactory.createUser('System Administrator', CONTACT_LAST_NAME3, CONTACT_LAST_NAME3+'@gmail.com', null);
        
        //create a user
        system.debug('create a user');
        User uWorker = TestDataFactory.createUser('System Administrator', CONTACT_LAST_NAME4, CONTACT_LAST_NAME4+'@gmail.com', uManager.Id);
        //create an Intel User
        Intel_Report_User__c IRU =TestDataFactory.createIntelReportUser(CONTACT_LAST_NAME3, CONTACT_LAST_NAME3+'@gmail.com', uWorker.Id);
        system.debug('create an Intel User');
        //Create an Intel Role
        Intel_Report_Role__c IRR =TestDataFactory.createIntelReportRole('Regional Manufacturing Manager', null);
        system.debug('Create an Intel Role');
        //Create an Intel User Role
        Intel_Report_Users_by_Role__c IRUR = TestDataFactory.createIntelReportUsersbyRole(IRR.ID, IRU.ID, 'Manager');
        system.debug('Create an Intel User Role');
        
        
        
        //Create an Intel report with Draft Status
        Intelligence_Report__c IR =TestDataFactory.createIntelligenceReport('Canadian Residential',IRU.Id, 'Residential','Test Product description');
        system.debug('Create an Intel report with Draft Status');
        //Create an Intel report Line Item
        Intelligence_Report_Line_Item__c IRLI =TestDataFactory.createIntelligenceReportLineItem(IR.Id,'Miscellaneous');
        system.debug('Create an Intel report Line Item ');
        //change the running user
        System.runAs(uWorker){
            //change the status to subitted and save
            IR.Status__c = 'Submitted';
            Intelligence_Report__c AccessIR = [select ID from Intelligence_Report__c].get(0);
            system.debug('before updating');
            system.debug(AccessIR.Id);
            system.debug(IR.Id);
            system.debug('still before updating');

            Update IR;
            system.debug(IR.Id);
        }
        //getEmailBody(String ReportFrom, String ReportTo, Id intelReportUser,Id intelligenceReport, Boolean send, String EmailType,List<String> addresses, String subject)
    }
    @istest static void testGetEmailBody_singleProductIssueResidential()
    {
        //create a manager
        system.debug('create a manager');
        User uManager = TestDataFactory.createUser('System Administrator', CONTACT_LAST_NAME5, CONTACT_LAST_NAME5+'@gmail.com', null);
        
        //create a user
        system.debug('create a user');
        User uWorker = TestDataFactory.createUser('System Administrator', CONTACT_LAST_NAME6, CONTACT_LAST_NAME6+'@gmail.com', uManager.Id);
        //create an Intel User
        Intel_Report_User__c IRU =TestDataFactory.createIntelReportUser(CONTACT_LAST_NAME5, CONTACT_LAST_NAME5+'@gmail.com', uWorker.Id);
        system.debug('create an Intel User');
        //Create an Intel Role
        Intel_Report_Role__c IRR =TestDataFactory.createIntelReportRole('Residential Product Manager', null);
        system.debug('Create an Intel Role');
        //Create an Intel User Role
        Intel_Report_Users_by_Role__c IRUR = TestDataFactory.createIntelReportUsersbyRole(IRR.ID, IRU.ID, 'Manager');
        system.debug('Create an Intel User Role');
        
        
        
        //Create an Intel report with Draft Status
        Intelligence_Report__c IR =TestDataFactory.createIntelligenceReport('Product Issues Report',IRU.Id, 'Residential','Test Product description');
        system.debug('Create an Intel report with Draft Status');
        //change the running user
        System.runAs(uWorker){
            //change the status to subitted and save
            IR.Status__c = 'Submitted';
            Intelligence_Report__c AccessIR = [select ID from Intelligence_Report__c].get(0);
            system.debug('before updating');
            system.debug(AccessIR.Id);
            system.debug(IR.Id);
            system.debug('still before updating');

            Update IR;
            system.debug(IR.Id);
        }
        //getEmailBody(String ReportFrom, String ReportTo, Id intelReportUser,Id intelligenceReport, Boolean send, String EmailType,List<String> addresses, String subject)
    }
    @istest static void testGetEmailBody_singleProductIssueCommercial()
    {
        //create a manager
        system.debug('create a manager');
        User uManager = TestDataFactory.createUser('System Administrator', CONTACT_LAST_NAME7, CONTACT_LAST_NAME7+'@gmail.com', null);
        
        //create a user
        system.debug('create a user');
        User uWorker = TestDataFactory.createUser('System Administrator', CONTACT_LAST_NAME8, CONTACT_LAST_NAME8+'@gmail.com', uManager.Id);
        //create an Intel User
        Intel_Report_User__c IRU =TestDataFactory.createIntelReportUser(CONTACT_LAST_NAME7, CONTACT_LAST_NAME7+'@gmail.com', uWorker.Id);
        system.debug('create an Intel User');
        //Create an Intel Role
        Intel_Report_Role__c IRR =TestDataFactory.createIntelReportRole('Commercial Product Manager', null);
        system.debug('Create an Intel Role');
        //Create an Intel User Role
        Intel_Report_Users_by_Role__c IRUR = TestDataFactory.createIntelReportUsersbyRole(IRR.ID, IRU.ID, 'Manager');
        system.debug('Create an Intel User Role');
        
        
        
        //Create an Intel report with Draft Status
        Intelligence_Report__c IR =TestDataFactory.createIntelligenceReport('Product Issues Report',IRU.Id, 'Commercial','Test Product description');
        system.debug('Create an Intel report with Draft Status');
        //change the running user
        System.runAs(uWorker){
            //change the status to subitted and save
            IR.Status__c = 'Submitted';
            Intelligence_Report__c AccessIR = [select ID from Intelligence_Report__c].get(0);
            system.debug('before updating');
            system.debug(AccessIR.Id);
            system.debug(IR.Id);
            system.debug('still before updating');

            Update IR;
            system.debug(IR.Id);
        }
        //getEmailBody(String ReportFrom, String ReportTo, Id intelReportUser,Id intelligenceReport, Boolean send, String EmailType,List<String> addresses, String subject)
    }
    
    @istest static void getEmailBodyPreview_singleProductIssueCommercial()
    {
        //create a manager
        system.debug('create a manager');
        User uManager = TestDataFactory.createUser('System Administrator', CONTACT_LAST_NAME9, CONTACT_LAST_NAME9+'@gmail.com', null);
        
        //create a user
        system.debug('create a user');
        User uWorker = TestDataFactory.createUser('System Administrator', CONTACT_LAST_NAME10, CONTACT_LAST_NAME10+'@gmail.com', uManager.Id);
        //create an Intel User
        Intel_Report_User__c IRU =TestDataFactory.createIntelReportUser(CONTACT_LAST_NAME9, CONTACT_LAST_NAME9+'@gmail.com', uWorker.Id);
        system.debug('create an Intel User');
        //Create an Intel Role
        Intel_Report_Role__c IRR =TestDataFactory.createIntelReportRole('Commercial Product Manager', null);
        system.debug('Create an Intel Role');
        //Create an Intel User Role
        Intel_Report_Users_by_Role__c IRUR = TestDataFactory.createIntelReportUsersbyRole(IRR.ID, IRU.ID, 'Manager');
        system.debug('Create an Intel User Role');
        
        //Create an Intel report with Draft Status
        Intelligence_Report__c IR =TestDataFactory.createIntelligenceReport('Product Issues Report',IRU.Id, 'Commercial','Test Product description');
        system.debug('Create an Intel report with Draft Status');
        
        
        //set visual force parameter
        ApexPages.currentPage().getParameters().put('IRId', IR.Id);
        
        //change the running user
        System.runAs(uWorker){
            //change the status to subitted and save
            IR.Status__c = 'Submitted';
            Intelligence_Report__c AccessIR = [select ID from Intelligence_Report__c].get(0);
            system.debug('before updating');
            system.debug(AccessIR.Id);
            system.debug(IR.Id);
            system.debug('still before updating');
			intelReportEmailController.getEmailBodyPreview();
            system.debug(IR.Id);
        }
        //getEmailBody(String ReportFrom, String ReportTo, Id intelReportUser,Id intelligenceReport, Boolean send, String EmailType,List<String> addresses, String subject)
    }
    
    @istest static void getEmailBodyPreview_singleProductIssueResidential()
    {
        //create a manager
        system.debug('create a manager');
        User uManager = TestDataFactory.createUser('System Administrator', CONTACT_LAST_NAME11, CONTACT_LAST_NAME11+'@gmail.com', null);
        
        //create a user
        system.debug('create a user');
        User uWorker = TestDataFactory.createUser('System Administrator', CONTACT_LAST_NAME12, CONTACT_LAST_NAME12+'@gmail.com', uManager.Id);
        //create an Intel User
        Intel_Report_User__c IRU =TestDataFactory.createIntelReportUser(CONTACT_LAST_NAME11, CONTACT_LAST_NAME11+'@gmail.com', uWorker.Id);
        system.debug('create an Intel User');
        //Create an Intel Role
        Intel_Report_Role__c IRR =TestDataFactory.createIntelReportRole('Regional Product Manager', null);
        system.debug('Create an Intel Role');
        //Create an Intel User Role
        Intel_Report_Users_by_Role__c IRUR = TestDataFactory.createIntelReportUsersbyRole(IRR.ID, IRU.ID, 'Manager');
        system.debug('Create an Intel User Role');
        
        //Create an Intel report with Draft Status
        Intelligence_Report__c IR =TestDataFactory.createIntelligenceReport('Product Issues Report',IRU.Id, 'Residential','Test Product description');
        system.debug('Create an Intel report with Draft Status');
        
        
        //set visual force parameter
        ApexPages.currentPage().getParameters().put('IRId', IR.Id);
        
        //change the running user
        System.runAs(uWorker){
            //change the status to subitted and save
            IR.Status__c = 'Submitted';
            Intelligence_Report__c AccessIR = [select ID from Intelligence_Report__c].get(0);
            system.debug('before updating');
            system.debug(AccessIR.Id);
            system.debug(IR.Id);
            system.debug('still before updating');
			intelReportEmailController.getEmailBodyPreview();
            system.debug(IR.Id);
        }
        //getEmailBody(String ReportFrom, String ReportTo, Id intelReportUser,Id intelligenceReport, Boolean send, String EmailType,List<String> addresses, String subject)
    }
    
    @istest static void getEmailBodyPreview_singleResidentialManufacturingManger()
    {
        //create a manager
        system.debug('create a manager');
        User uManager = TestDataFactory.createUser('System Administrator', CONTACT_LAST_NAME13, CONTACT_LAST_NAME13+'@gmail.com', null);
        
        //create a user
        system.debug('create a user');
        User uWorker = TestDataFactory.createUser('System Administrator', CONTACT_LAST_NAME14, CONTACT_LAST_NAME14+'@gmail.com', uManager.Id);
        //create an Intel User
        Intel_Report_User__c IRU =TestDataFactory.createIntelReportUser(CONTACT_LAST_NAME13, CONTACT_LAST_NAME13+'@gmail.com', uWorker.Id);
        system.debug('create an Intel User');
        //Create an Intel Role
        Intel_Report_Role__c IRR =TestDataFactory.createIntelReportRole('Regional Manufacturing Manager', null);
        system.debug('Create an Intel Role');
        //Create an Intel User Role
        Intel_Report_Users_by_Role__c IRUR = TestDataFactory.createIntelReportUsersbyRole(IRR.ID, IRU.ID, 'Manager');
        system.debug('Create an Intel User Role');
        
        //Create an Intel report with Draft Status
        Intelligence_Report__c IR =TestDataFactory.createIntelligenceReport('Canadian Commercial',IRU.Id, 'Residential','Test Product description');
        system.debug('Create an Intel report with Draft Status');
        
        
        //set visual force parameter
        ApexPages.currentPage().getParameters().put('IRId', IR.Id);
        
        //change the running user
        System.runAs(uWorker){
            //change the status to subitted and save
            IR.Status__c = 'Submitted';
            Intelligence_Report__c AccessIR = [select ID from Intelligence_Report__c].get(0);
            system.debug('before updating');
            system.debug(AccessIR.Id);
            system.debug(IR.Id);
            system.debug('still before updating');
			intelReportEmailController.getEmailBodyPreview();
            system.debug(IR.Id);
        }
        //getEmailBody(String ReportFrom, String ReportTo, Id intelReportUser,Id intelligenceReport, Boolean send, String EmailType,List<String> addresses, String subject)
    }
    
    @istest static void testGetEmailBody_singleCommercialManufacturingManagerWithAttachmentsNoManager()
    {
        //create a manager
        system.debug('create a manager');
        User uManager = TestDataFactory.createUser('System Administrator', CONTACT_LAST_NAME15, CONTACT_LAST_NAME15+'@gmail.com', null);
        
        //create a user
        system.debug('create a user');
        User uWorker = TestDataFactory.createUser('System Administrator', CONTACT_LAST_NAME16, CONTACT_LAST_NAME16+'@gmail.com', uManager.Id);
        //create an Intel User
        Intel_Report_User__c IRU =TestDataFactory.createIntelReportUser(CONTACT_LAST_NAME16, CONTACT_LAST_NAME16+'@gmail.com', uWorker.Id);
        system.debug('create an Intel User');
        //Create an Intel Role
        Intel_Report_Role__c IRR =TestDataFactory.createIntelReportRole('Commercial Manufacturing Manager', null);
        system.debug('Create an Intel Role');
        //Create an Intel User Role
        Intel_Report_Users_by_Role__c IRUR = TestDataFactory.createIntelReportUsersbyRole(IRR.ID, IRU.ID, 'Manager');
        system.debug('Create an Intel User Role');
        
        
        
        //Create an Intel report with Draft Status
        Intelligence_Report__c IR =TestDataFactory.createIntelligenceReport('Canadian Commercial',IRU.Id, 'Commercial','Test Product description');
        system.debug('Create an Intel report with Draft Status');
        //Create an Intel report Line Item
        Intelligence_Report_Line_Item__c IRLI =TestDataFactory.createIntelligenceReportLineItem(IR.Id,'Miscellaneous');
        system.debug('Create an Intel report Line Item ');
        
        //insert attachment
        Attachment attach = TestDataFactory.createAttachment(IRLI.Id);
        
        //fetch a ContentDocument
        //system.debug('Fetch a content document');
        //ContentDocument CD = TestDataFactory.getContentDocument();
        //Create ContentVersion
        //system.debug('Create a Content Version');
        //ContentVersion CV = TestDataFactory.createContentVersion();
        //Create a ContentDocumentLink
        //system.debug('Create a Content document link');
        //ContentDocumentLink CDL = TestDataFactory.createContentDocumentLink(IRLI.Id, CV.Id);
        
        //change the running user
        System.runAs(uWorker){
            //change the status to subitted and save
            IR.Status__c = 'Submitted';
            Intelligence_Report__c AccessIR = [select ID from Intelligence_Report__c].get(0);
            system.debug('before updating');
            system.debug(AccessIR.Id);
            system.debug(IR.Id);
            system.debug('still before updating');

            Update IR;
            system.debug(IR.Id);
        }
        //getEmailBody(String ReportFrom, String ReportTo, Id intelReportUser,Id intelligenceReport, Boolean send, String EmailType,List<String> addresses, String subject)
    }
    
}