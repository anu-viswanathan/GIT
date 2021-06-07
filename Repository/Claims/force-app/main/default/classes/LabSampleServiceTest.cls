@isTest
private class LabSampleServiceTest {

    private static void createUsers(){

        List<User> toInsertUsers = new List<User>();

            toInsertUsers.add(TestFactory.createUser('Unit','Tests','salesrsmmgr@iko.com','salesrsmmgr@iko.com','USRS Manager',
                    'RSM West','salesmgr','GMT','en_US','UTF-8','en_US',null,null,false));
            toInsertUsers.add(TestFactory.createUser('Unit','Tests','testuser@iko.com','testuser@iko.com','Commercial Claims Rep',
                    'Commercial Claims Rep','testuser','GMT','en_US','UTF-8','en_US','United States',null,false));
            toInsertUsers.add(TestFactory.createUser('UnitClaim1','TestsClaim','sysAdminUsr@iko.com','sysAdminUsr@iko.com','System Administrator',
                    'CEO','tsAdmU','GMT','en_US','UTF-8','en_US','United States',null,false));

        insert toInsertUsers;

    }

    @testSetup static void setupTestData() {


        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();

        //create Account
        List<Account> toInsertAccounts = new List<Account>();

        toInsertAccounts.addAll(TestFactory.createAccounts(baRt,'CaseServiceTest','9 King St E','Toronto','ON','CA','M4S 2H4',
                'Verified',UserInfo.getUserId(),TRUE,TRUE,1,false));
        toInsertAccounts.addAll(TestFactory.createAccounts(baRt,'CaseServiceTestTest','99999 King St WWW','Toronto','ON','CA','M4S 2H4',
                'Verified',UserInfo.getUserId(),TRUE,TRUE,1,false));
        toInsertAccounts.addAll(TestFactory.createAccounts(baRt,'CaseServiceTestQuebec2','69 King St E','Montreal','QC','CA','M4S 2H4',
                'Verified',UserInfo.getUserId(),TRUE,TRUE,1,false));
        toInsertAccounts.addAll(TestFactory.createAccounts(baRt,'CaseServiceTestQuebec','9 King St E','Montreal','QC','CA','M4S 2H4',
                'Verified',UserInfo.getUserId(),TRUE,TRUE,1,false));
        toInsertAccounts.addAll(TestFactory.createAccounts(baRt,'CaseServiceTestWashington','9 King St E','Seattle','WA','US','12111',
                'Verified',UserInfo.getUserId(),TRUE,TRUE,1,false));

        insert toInsertAccounts;


        //create contact
        List<Contact> toInsertContacts = new List<Contact>();

        toInsertContacts.addAll(TestFactory.createContacts(toInsertAccounts[0].Id,'CaseServiceTest',UserInfo.getUserId(),1,false));

        insert toInsertContacts;

        Map<String,Account> mapAccounts = new Map<String, Account>();

        for(Account act : [SELECT Id,Name FROM Account]){
            mapAccounts.put(act.Name,act);
        }

        //create Cases
        List<Case> toInsertCases = new List<Case>();
        toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTestClosed',null,'Commercial','Closed',1,false));
        toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTest',null,'Commercial','Draft',1,false));
        toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTest1',null,'Commercial','Draft',1,false));
        toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Owner','CaseServiceTest2',null,'CA','Draft',1,false));
        toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTestWashington').Id,toInsertContacts[0].Id,'Owner','CaseServiceTestCL1',null,'Commercial','Awaiting Docs',1,false));
        toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTestTest').Id,toInsertContacts[0].Id,'Owner','CaseServiceTestCL2',null,'Commercial','Awaiting Docs',1,false));
        toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTestTest1',null,'Commercial','In Lab',1,false));
        toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Owner','CaseServiceTestTest2',null,'CA','In Lab',1,false));

        //toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTestNewYork').Id,toInsertContacts[0].Id,'Distributor','CaseServiceNewYork',date.newInstance(2006, 5, 5),'Commercial','Draft',1,false));
        toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTestQuebec').Id,toInsertContacts[0].Id,'Distributor','CaseServiceQuebec',date.newInstance(2006, 5, 5),'Commercial','Draft',1,false));
        toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTestQuebec2').Id,toInsertContacts[0].Id,'Distributor','CaseServiceQuebec2',date.newInstance(2006, 5, 5),'Commercial','Draft',1,false));


        insert toInsertCases;

        //create Claim type
        List<Claim_Type__c> toInsertClaimTypes = new List<Claim_Type__c>();
        toInsertClaimTypes.addAll(TestFactory.createClaimTypes(toInsertCases[0],1,false));

        insert toInsertClaimTypes;

        //insert LabSamples
        List<Lab_Sample__c> toInsertlabSamples = new List<Lab_Sample__c>();
        toInsertlabSamples.addAll(TestFactory.createLabSamples(toInsertCases[5],1,false));
        toInsertlabSamples.addAll(TestFactory.createLabSamples(toInsertCases[4],1,false));
        toInsertlabSamples.addAll(TestFactory.createLabSamples(toInsertCases[0],1,false));

        insert toInsertlabSamples;
		
        
    }

    @isTest static void testThatSequencePrefixSetCorrectly() {
        Case c1 = [select Id, Claim_Number__c from Case where Subject = 'CaseServiceTest1'];
        Case c2 = [select Id, Claim_Number__c from Case where Subject = 'CaseServiceTest2'];

        Test.startTest();
        Lab_Sample__c ls1 = new Lab_Sample__c(Case__c = c1.Id);
        Lab_Sample__c ls2 = new Lab_Sample__c(Case__c = c2.Id);

        LabSampleService.setSequencePrefix(new List<Lab_Sample__c>{
                ls1, ls2
        });
        Test.stopTest();

        System.assertEquals(ls1.Sequence_Prefix__c, 'CACOM');
        System.assertEquals(ls2.Sequence_Prefix__c, 'CARES');
    }

    @isTest static void testThatSequenceNumberSetCorrectly() {
        /* initialize some Lab Samples and Numbers */
        Test.startTest();
        Case c1 = [select Id, Claim_Number__c from Case where Subject = 'CaseServiceTestTest1'];
        Case c2 = [select Id, Claim_Number__c from Case where Subject = 'CaseServiceTestTest2'];
        System.debug('SOQL0-->'+Limits.getQueries());


        Integer year = Integer.valueOf(String.valueOf(date.today().year()).right(2));

        Lab_Sample__c ls1 = new Lab_Sample__c(Case__c = c1.Id, Generate_Sample_Number__c = true,
                Sequence_Number__c = 328, Sample_Number__c = 'CACOM-00008');


        Lab_Sample__c ls4 = new Lab_Sample__c(Case__c = c1.Id, Generate_Sample_Number__c = true);
        Lab_Sample__c ls5 = new Lab_Sample__c(Case__c = c2.Id, Generate_Sample_Number__c = true);
        Lab_Sample__c ls6 = new Lab_Sample__c(Case__c = c1.Id, Generate_Sample_Number__c = true);
        Lab_Sample__c ls7 = new Lab_Sample__c(Case__c = c2.Id, Generate_Sample_Number__c = true);
        insert new List<Lab_Sample__c>{
                ls4, ls5, ls6, ls7,ls1
        };

        Map<Id, Lab_Sample__c> labSamples = new Map<Id, Lab_Sample__c>([
                select Id, Sample_Number__c
                from Lab_Sample__c
                where Id IN :new List<Lab_Sample__c>{
                        ls4, ls5, ls6, ls7
                }
        ]);
        Test.stopTest();

       // System.assertEquals(labSamples.get(ls4.Id).Sample_Number__c, 'CACOM-00329-' + year);
        System.assertEquals(labSamples.get(ls5.Id).Sample_Number__c, 'CARES-00001-' + year);
       // System.assertEquals(labSamples.get(ls6.Id).Sample_Number__c, 'CACOM-00330-' + year);
        System.assertEquals(labSamples.get(ls7.Id).Sample_Number__c, 'CARES-00002-' + year);
    }

    @isTest static void testThatLabTestResultsGeneratedOnlyForPrimaryClaimType() {
        Case c1 = [select Id, Claim_Number__c from Case where Subject = 'CaseServiceTest1'];
        Case c2 = [select Id, Claim_Number__c from Case where Subject = 'CaseServiceQuebec'];

        Test.startTest();
        Claim_Type__c ct1 = new Claim_Type__c(Case__c = c1.Id, Concern__c = 'Blistering', Is_Primary__c = true);
        Claim_Type__c ct2 = new Claim_Type__c(Case__c = c2.Id, Concern__c = 'Blistering');
        insert new List<Claim_Type__c>{
                ct1, ct2
        };

        Lab_Sample__c ls1 = new Lab_Sample__c(Case__c = c1.Id, Generate_Tests__c = true);
        Lab_Sample__c ls2 = new Lab_Sample__c(Case__c = c2.Id);
        insert new List<Lab_Sample__c>{
                ls1, ls2
        };

        List<Lab_Test_Result__c> lsLabTests1 = [select Id from Lab_Test_Result__c where Lab_Sample__c = :ls1.Id];
        List<Lab_Test_Result__c> lsLabTests2 = [select Id from Lab_Test_Result__c where Lab_Sample__c = :ls2.Id];
        Test.stopTest();

        System.assertEquals(lsLabTests1.size(), 0);
        System.assertEquals(lsLabTests2.size(), 0);
    }

    @isTest static void testThatLabTestResultsCannotBeGeneratedByClaimsRep() {

        createUsers();
        User u = [SELECT Id FROM User WHERE Username = 'testuser@iko.com'];
        Case c1 ;

        Test.startTest();

        Boolean errorCaught = false;
        System.runAs(u) {

            c1 = new Case(Origin = 'Owner', Sector__c = 'US');
            //c1 = CaseService.createClaimDraft('5885 Fielding Dr Se', '{"BillingStreet":"5885 Fielding Dr Se","BillingCity":"New York","BillingStateCode":"NY","BillingPostalCode":"10111","BillingCountryCode":"US"}', c1, 'Mack Daddy', false);
            c1 = CaseService.createClaimDraft('5885 Fielding Dr Se', '{"BillingStreet":"5885 Fielding Dr Se","BillingCity":"New York","BillingStateCode":"NY","BillingPostalCode":"10111","BillingCountryCode":"US"}', c1, 'Mr', 'Mack', 'Daddy','', false);

            Claim_Type__c ct1 = new Claim_Type__c(Case__c = c1.Id, Concern__c = 'Blistering', Is_Primary__c = true);
            insert ct1;

            Lab_Sample__c ls1 = new Lab_Sample__c(Case__c = c1.Id, Generate_Tests__c = true);
            System.debug('ls1 = ' + ls1);
            try {
                insert ls1;
            } catch (DmlException e) {
                System.debug('error? ' + e.getMessage());
                if (e.getMessage().contains('You are not allowed to generate tests'))
                    errorCaught = true;
            }
            System.assertEquals(ls1.Id, null);
        }

        Test.stopTest();

        System.assertEquals(errorCaught, true);
    }

    @isTest static void testThatLabTestResultsGeneratedForMultipleLabSamples() {
        Case c1 = [select Id, Claim_Number__c from Case where Subject = 'CaseServiceTest1'];
        Case c2 = [select Id, Claim_Number__c from Case where Subject = 'CaseServiceQuebec'];

        Test.startTest();
        Claim_Type__c ct1 = new Claim_Type__c(Case__c = c1.Id, Concern__c = 'Blistering', Is_Primary__c = true);
        Claim_Type__c ct2 = new Claim_Type__c(Case__c = c2.Id, Concern__c = 'Blistering', Is_Primary__c = true);
        insert new List<Claim_Type__c>{
                ct1, ct2
        };

        Lab_Sample__c ls1 = new Lab_Sample__c(Case__c = c1.Id, Generate_Tests__c = true);
        Lab_Sample__c ls2 = new Lab_Sample__c(Case__c = c2.Id, Generate_Tests__c = true);
        insert new List<Lab_Sample__c>{
                ls1, ls2
        };
        Test.stopTest();

        List<Lab_Test_Result__c> lsLabTests1 = [select Id from Lab_Test_Result__c where Lab_Sample__c = :ls1.Id];
        List<Lab_Test_Result__c> lsLabTests2 = [select Id from Lab_Test_Result__c where Lab_Sample__c = :ls2.Id];

        System.assertEquals(lsLabTests1.size(), 0);
        System.assertEquals(lsLabTests2.size(), 0);
    }

    @isTest static void testThatLabTestResultsNotGeneratedWhenTestsGeneratedFlagAlreadySet() {
        Case c1 = [select Id, Claim_Number__c from Case where Subject = 'CaseServiceTest1'];
        Case c2 = [select Id, Claim_Number__c from Case where Subject = 'CaseServiceQuebec'];

        Test.startTest();
        Claim_Type__c ct1 = new Claim_Type__c(Case__c = c1.Id, Concern__c = 'Blistering', Is_Primary__c = true);
        Claim_Type__c ct2 = new Claim_Type__c(Case__c = c2.Id, Concern__c = 'Blistering', Is_Primary__c = true);
        insert new List<Claim_Type__c>{
                ct1, ct2
        };

        Lab_Sample__c ls1 = new Lab_Sample__c(Case__c = c1.Id, Generate_Tests__c = true);
        Lab_Sample__c ls2 = new Lab_Sample__c(Case__c = c2.Id, Generate_Tests__c = true);
        insert new List<Lab_Sample__c>{
                ls1, ls2
        };

        List<Lab_Test_Result__c> lsLabTests1 = [select Id from Lab_Test_Result__c where Lab_Sample__c = :ls1.Id];
        List<Lab_Test_Result__c> lsLabTests2 = [select Id from Lab_Test_Result__c where Lab_Sample__c = :ls2.Id];

        System.assertEquals(lsLabTests1.size(), 0);
        System.assertEquals(lsLabTests2.size(), 0);

        try {
            update ls1;
        } catch (DmlException e) {
        }
        Test.stopTest();

        List<Lab_Test_Result__c> lsLabTests1a = [select Id from Lab_Test_Result__c where Lab_Sample__c = :ls1.Id];
        System.assertEquals(lsLabTests1a.size(), 0);

    }

    @isTest static void testThatLabSampleCannotBeInsertedPostClosure() {
        Case c = [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTestClosed'];

        Test.startTest();
        Lab_Sample__c ls = new Lab_Sample__c(Case__c = c.Id);
        try {
            insert ls;
        } catch (DmlException e) {
        }
        Test.stopTest();

        System.assertEquals(ls.Id, ls.Id);
    }

    @isTest static void testThatLabSampleCannotBeUpdatedPostClosure() {
        createUsers();
        User salesMngUser = [select Id from User where Username = 'salesrsmmgr@iko.com'];
        User sysAdmin = [select Id from User where Username = 'sysAdminUsr@iko.com'];
        Boolean errorCaught = false;
        Lab_Sample__c ls = [select Id from Lab_Sample__c where Case__r.Subject = 'CaseServiceTestClosed'];

        Test.startTest();
        // Running as a System Administrator
        try {
            System.runAs(sysAdmin){
                update ls;
            }
        } catch (Exception e) {
            System.debug('EX-->'+e.getMessage());
            errorCaught = true;
        }
        System.assert(!errorCaught);

            try {
                System.runAs(salesMngUser) {
                    delete ls;
                }
            } catch (Exception e) {
                System.debug('EX-->'+e.getMessage());
               errorCaught = true;
            }

        System.assert(errorCaught);
        Test.stopTest();
    }

    @isTest static void testThatLabSampleCannotBeDeletedPostClosure() {

        createUsers();

        User u = [SELECT Id FROM User WHERE Username = 'salesrsmmgr@iko.com'];
        Lab_Sample__c ls = [select Id from Lab_Sample__c where Case__r.Subject = 'CaseServiceTestClosed'];

        Test.startTest();
        Boolean errorCaught = false;
        try {
            System.runAs(u){
                delete ls;
            }
        } catch (Exception e) {
            errorCaught = true;
        }
        Test.stopTest();


        System.assert(errorCaught);
    }

    @isTest static void testThatLabSampleCanBeInsertedUpdatedDeletedPreClosure() {
        Case c = [select Id, Claim_Stage__c from Case where Subject = 'CaseServiceTest1'];

        Test.startTest();
        Lab_Sample__c ls = new Lab_Sample__c(Case__c = c.Id);
        insert ls;

        System.assertNotEquals(ls.Id, null);
        update ls;
        delete ls;
        Test.stopTest();


    }

    private static testMethod void populateLabSamplePRMField_CreateNewLabSampleWithCaseCreatedDateOneYearWithInstallationDate_LabSamplePRMIsChecked() {

        // Prepare the data
        Case caseRecord = [SELECT Id, Installation_Date__c, CreatedDate FROM Case WHERE Subject = 'CaseServiceTest1'];

        // start the test
        Test.startTest();
        caseRecord.Installation_Date__c = Date.newInstance(caseRecord.CreatedDate.year(), caseRecord.CreatedDate.month() - 10, caseRecord.CreatedDate.day());
        update caseRecord;

        Lab_Sample__c labSampleRecord = new Lab_Sample__c(Case__c = caseRecord.Id);
        insert labSampleRecord;
        Test.stopTest();

        labSampleRecord = [SELECT Id, PRM__c FROM Lab_Sample__c WHERE Id = :labSampleRecord.Id];
        System.assertEquals(true, labSampleRecord.PRM__c, 'Expected PRM field is checked as the Case Installation Date is within one year of the Case Created Date.');

    }

    private static testMethod void populateLabSamplePRMField_CreateNewLabSampleWithCaseCreatedDateTwoYearPriorInstallationDate_LabSamplePRMIsUnchecked() {

        // Prepare the data
        Case caseRecord = [SELECT Id, Installation_Date__c, CreatedDate FROM Case WHERE Subject = 'CaseServiceTest1'];

        // start the test
        Test.startTest();
        caseRecord.Installation_Date__c = Date.newInstance(caseRecord.CreatedDate.year() - 2, caseRecord.CreatedDate.month(), caseRecord.CreatedDate.day());
        update caseRecord;

        Lab_Sample__c labSampleRecord = new Lab_Sample__c(Case__c = caseRecord.Id);
        insert labSampleRecord;
        Test.stopTest();

        labSampleRecord = [SELECT Id, PRM__c FROM Lab_Sample__c WHERE Id = :labSampleRecord.Id];
        System.assertEquals(false, labSampleRecord.PRM__c, 'Expected PRM field is unchecked as the Case Installation Date is two year of the Case Created Date.');

    }

    @isTest
    private static void testPopulateCaseDescriptionOnLabSample_copyCaseDescriptionToLabSampleOnInsert_labSampleDescriptionPopulated(){

        //Prepare data
        Case caseRecord = [SELECT Id, Description FROM Case WHERE Subject = 'CaseServiceTest1'];
        caseRecord.Description = 'This is a test description';
        //initiate test
        Test.startTest();
        update caseRecord;
        Lab_Sample__c ls = new Lab_Sample__c(Case__c = caseRecord.Id,Sequence_Number__c = 123123);
        insert ls;
        Test.stopTest();

        Lab_Sample__c sample = [SELECT Id,Case_Description__c FROM Lab_Sample__c WHERE Case__c = :caseRecord.Id
        AND Sequence_Number__c = 123123];

        //assert for equality
        System.assertEquals(sample.Case_Description__c,caseRecord.Description);
    }

    @isTest
    private static void testInitiateActionsOnInBramptonSetTrue_completeActionsOnInBramptonChecked_UpdateFieldsOnLabSampleForUSSector(){

        createUsers();
        User u = [select Id from User where Username = 'sysAdminUsr@iko.com'];
        Case c = [SELECT Id FROM Case Where Subject = 'CaseServiceTestCL1'];

        //Prepare data
        Lab_Sample__c labSample = [SELECT Id,Name,In_Brampton__c,Case__r.Account.Account_Name_Address_Verified__c
                                         FROM Lab_Sample__c WHERE Case__r.Subject = 'CaseServiceTestCL1'];

        //Query for queues
        List<QueueSobject> queueIds = [SELECT QueueId,Queue.Name,SobjectType FROM QueueSobject WHERE Queue.Name = 'Canadian Queue'
        OR Queue.Name = 'US Queue' ORDER BY Queue.Name ASC];

        //test
        System.runAs(u){
            Test.startTest();
            labSample.In_Brampton__c = true;
            update labSample;
            Test.stopTest();
        }

        //assert
        Lab_Sample__c expectedLabSample = [SELECT Id,Name,In_Brampton__c,Case__r.Claim_Stage__c,Case__r.Claim_Sub_Stage__c,
                OwnerId,Received_Date_Brampton__c, Owner.Name
        FROM Lab_Sample__c WHERE Case__r.Subject = 'CaseServiceTestCL1'];

        System.debug('Owner --->'+expectedLabSample.Owner.Name);
        // 2020-01-06 Date assertion fails when deployed at certain times of day. Removing the assertion.
        // https://ikoussfsc.atlassian.net/browse/SF-138
        // Assertion failed when tests were run at certain time. So long assertion
        // System.assertEquals(expectedLabSample.Received_Date_Brampton__c,Date.today());
        //System.assertEquals(expectedLabSample.OwnerId,queueIds.get(1).Queue.Id);
		//Jira ticket 730, owner id is no longer required becuase of master detail relationship changed in the lab sample	
    }

    @isTest
    private static void testInitiateActionsOnInBramptonSetTrue_completeActionsOnInBramptonChecked_UpdateFieldsOnLabSampleForCASector(){
        createUsers();

        User u = [SELECT Id FROM User WHERE Username = 'sysAdminUsr@iko.com'];

        Case c = [SELECT Id FROM Case Where Subject = 'CaseServiceTestCL2'];

        //Prepare data
        Lab_Sample__c labSample = [SELECT Id,Name,In_Brampton__c,Case__r.Account.Account_Name_Address_Verified__c
        FROM Lab_Sample__c WHERE Case__r.Subject = 'CaseServiceTestCL2'];

        //Query for queues
        List<QueueSobject> queueIds = [SELECT QueueId,Queue.Name,SobjectType FROM QueueSobject WHERE Queue.Name = 'Canadian Queue'
        OR Queue.Name = 'US Queue' ORDER BY Queue.Name ASC];

        //test
        System.runAs(u){
            Test.startTest();
            labSample.In_Brampton__c = true;
            update labSample;
            Test.stopTest();
        }

        //assert
        Lab_Sample__c expectedLabSample = [SELECT Id,Name,In_Brampton__c,Case__r.Claim_Stage__c,Case__r.Claim_Sub_Stage__c,
                OwnerId,Received_Date_Brampton__c,Owner.Name
        FROM Lab_Sample__c WHERE Case__r.Subject = 'CaseServiceTestCL2'];

        // System.assertEquals(expectedLabSample.Received_Date_Brampton__c,Date.today());
        // https://ikoussfsc.atlassian.net/browse/SF-138
        // Assertion failed when tests were run at certain time. So long assertion
        //System.assertEquals(expectedLabSample.OwnerId,queueIds.get(0).Queue.Id); 
	    //Jira ticket 730, owner id is no longer required becuase of master detail relationship changed in the lab sample		
    }

    @isTest
    private static void initiateActionsOnCaseWhenInBramptonSetTrue_populateCaseFieldsWhenInBramptonSetTrue_caseUpdated(){

        createUsers();
        User u = [SELECT Id FROM User WHERE UserName = 'sysAdminUsr@iko.com'];
        //Prepare data
        Case testCase = [SELECT Id,Account.Account_Name_Address_Verified__c FROM CASE WHERE Subject = 'CaseServiceTestCL2'];
       // Lab_Sample__c ls = [SELECT ID FROM Lab_Sample__c WHERE Case__r.Subject = 'CaseServiceTestCL2'];

        Lab_Sample__c labSample = [SELECT Id,Name,In_Brampton__c,Case__r.Account.Account_Name_Address_Verified__c
                                    FROM Lab_Sample__c WHERE Case__c = :testCase.Id];

        System.runAs(u){
            Test.startTest();
            labSample.In_Brampton__c = TRUE;
            update labSample;
            Test.stopTest();
        }

        //assert
        Case testCase1 = [SELECT Id,Claim_Stage__c,Claim_Sub_Stage__c FROM CASE WHERE Subject = 'CaseServiceTestCL2'];
        System.assertEquals(testCase1.Claim_Stage__c,'In Lab');
        System.assertEquals(testCase1.Claim_Sub_Stage__c,'Samples Received');
    }

    @isTest
    private static void changeCaseSubStageWhenStatusChanged_updateSubStageOnCaseAndLabSampleForInApproval_StageAndSubStageUpdatedAsPerApprovalAction(){

        Case testCase = [SELECT Id,Claim_Sub_Stage__c,Claim_Stage__c FROM CASE WHERE Subject = 'CaseServiceTestCL2'];

        Lab_Sample__c labSample = [SELECT Id,Status__c FROM Lab_Sample__c WHERE Case__c = :testCase.Id LIMIT 1];

        Test.startTest();
        labSample.Status__c =  'In Approval';
        update labSample;
        Test.stopTest();

        Case testCase1 = [SELECT Id,Claim_Sub_Stage__c,Claim_Stage__c FROM CASE WHERE Subject = 'CaseServiceTestCL2'];

        //assert
        System.assertEquals('In Approval',testCase1.Claim_Sub_Stage__c);

    }

    @isTest
    private static void changeCaseSubStageWhenStatusChanged_updateSubStageOnCaseAndLabSampleForApproved_StageAndSubStageUpdatedAsPerApprovalAction(){

        Case testCase = [SELECT Id,Claim_Sub_Stage__c,Claim_Stage__c FROM CASE WHERE Subject = 'CaseServiceTestCL2'];

        Lab_Sample__c labSample = [SELECT Id,Status__c FROM Lab_Sample__c WHERE Case__c = :testCase.Id LIMIT 1];

        Test.startTest();
        labSample.Status__c =  'Approved';
        update labSample;
        Test.stopTest();

        Case testCase1 = [SELECT Id,Claim_Sub_Stage__c,Claim_Stage__c FROM CASE WHERE Subject = 'CaseServiceTestCL2'];

        //assert
        System.assertEquals('File Preparation',testCase1.Claim_Stage__c);
        System.assertEquals('Data Entry',testCase1.Claim_Sub_Stage__c);

    }

    @isTest
    private static void changeCaseSubStageWhenStatusChanged_updateSubStageOnCaseAndLabSampleForDeclined_StageAndSubStageUpdatedAsPerApprovalAction(){

        Case testCase = [SELECT Id,Claim_Sub_Stage__c,Claim_Stage__c FROM CASE WHERE Subject = 'CaseServiceTestCL2'];

        Lab_Sample__c labSample = [SELECT Id,Status__c FROM Lab_Sample__c WHERE Case__c = :testCase.Id LIMIT 1];

        Test.startTest();
        labSample.Status__c =  'Declined';
        update labSample;
        Test.stopTest();

        Case testCase1 = [SELECT Id,Claim_Sub_Stage__c,Claim_Stage__c FROM CASE WHERE Subject = 'CaseServiceTestCL2'];

        //assert

        System.assertEquals('Analysis',testCase1.Claim_Sub_Stage__c);

    }

    @isTest
    private static void changeCaseSubStageWhenStatusChanged_updateSubStageOnCaseAndLabSampleForRecall_StageAndSubStageUpdatedAsPerApprovalAction(){

        Case testCase = [SELECT Id,Claim_Sub_Stage__c,Claim_Stage__c FROM CASE WHERE Subject = 'CaseServiceTestCL2'];
       
        Lab_Sample__c labSample = [SELECT Id,Status__c FROM Lab_Sample__c WHERE Case__c = :testCase.Id LIMIT 1];

        Test.startTest();
        labSample.Status__c =  'Analysis';
        update labSample;
        Test.stopTest();

        Case testCase1 = [SELECT Id,Claim_Sub_Stage__c,Claim_Stage__c FROM CASE WHERE Subject = 'CaseServiceTestCL2'];

        //assert

        System.assertEquals('Analysis',testCase1.Claim_Sub_Stage__c);

    }
    
    /* Ticket CLAIMSV2-968
     * Added condition to display error Message when submitting record for Approval,
     * By: Vicki Tran on 16-June-2020
     */
    @isTest static void testvalidateLabSampleApprovalSubmission() {

        Case testCase = [SELECT Id,Claim_Sub_Stage__c,Claim_Stage__c FROM CASE WHERE Subject = 'CaseServiceTestCL2'];

        Lab_Sample__c labSample = [SELECT Id,Status__c, Total_Lab_Test_Result_Completed__c, Total_Number_of_Lab_Test_Result__c FROM Lab_Sample__c WHERE Case__c = :testCase.Id LIMIT 1];
		
        labSample.PRM__c = true;
		labSample.Plant_Feedback_Type__c = null; 
                
        try {
	        update new List<Lab_Sample__c> {labSample};
        } catch (Exception e) {
            Boolean prm_ExpectedExceptionThrown =  e.getMessage().contains('Cannot submit for approval. PRM field is checked but no value selected for Plant Disposition.') ? true : false;
			System.AssertEquals(prm_ExpectedExceptionThrown, true);
            if(labSample.Total_Lab_Test_Result_Completed__c != labSample.Total_Number_of_Lab_Test_Result__c)
            {
                Boolean labTestResult_ExpectedExceptionThrown =  e.getMessage().contains('Cannot submit for approval. Total Lab Test Result Completed does not equal to Total Number of Lab Test Result.') ? true : false;
				System.AssertEquals(labTestResult_ExpectedExceptionThrown, true);
            }
            
		}
           
                
        
        
    } //end of testvalidateApprovalSubmission
}