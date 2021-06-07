@isTest
private class LabSampleTapeCodeServiceTest {

    @testSetup static void setupTestData() {
        initTestData();
    }

    private static void initTestData(){
        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();
        List<Account> toInsertAccounts = new List<Account>();

        toInsertAccounts.addAll(TestFactory.createAccounts(baRt,'CaseServiceTest','9 King St E','Toronto','ON','CA','M4S 2H4',
                'Verified',UserInfo.getUserId(),TRUE,TRUE,1,false));
        insert toInsertAccounts;
        
        //create contact
        List<Contact> con = TestFactory.createContacts(toInsertAccounts[0].Id,'LabSampleTapeCodeServiceTest',UserInfo.getUserId(),1,false);
        insert con;
        
        //create Cases
        List<Case> toInsertCases = new List<Case>();

        toInsertCases.addAll(TestFactory.createCases(ccRt,toInsertAccounts[0].Id,con[0].Id,'Owner','LabSampleTapeCodeServiceTest',null,'Commercial',null,1,false));
        toInsertCases.addAll(TestFactory.createCases(ccRt,toInsertAccounts[0].Id,con[0].Id,'Distributor',null,null,'Commercial',null,5,false));
        toInsertCases[1].Subject='CaseServiceTestClosed';
        toInsertCases[1].Claim_Stage__c='Closed';
        
        toInsertCases[2].ClaimApproved__c=true;
        toInsertCases[2].Subject='CaseServiceTest1';
        
        toInsertCases[3].Subject='CaseServiceTest2';
        
        toInsertCases[4].Subject='CaseServiceTest3';
        
        toInsertCases[5].Subject='CaseServiceTest4';
        Insert toInsertCases;
        
        System.debug('toInsertCases: '+toInsertCases);
        //create ClaimTypes
        List<Claim_Type__c> toInsertClaimTypes = new List<Claim_Type__c>();
        toInsertClaimTypes.addAll(TestFactory.createClaimTypes(toInsertCases[0], 1, false));
        
                
        toInsertClaimTypes[0].Product_Type__c='Z Not IKO';
        toInsertClaimTypes[0].Concern__c='Clawing';
        toInsertClaimTypes[0].Is_Primary__c=true;
        Insert toInsertClaimTypes;
        
        List<Lab_Sample__c> toInsertLabSamples = new List<Lab_Sample__c>();
        toInsertLabSamples.addAll(TestFactory.createLabSamples(toInsertCases[1], 5, false));
        toInsertLabSamples[1].Case__c=toInsertCases[2].Id;
        toInsertLabSamples[2].Case__c=toInsertCases[3].Id;
        toInsertLabSamples[3].Case__c=toInsertCases[4].Id;
        toInsertLabSamples[4].Case__c=toInsertCases[5].Id;
        Insert toInsertLabSamples;
        
		insertLabSampleCodes();         
    }
    
    @future
    static void insertLabSampleCodes(){
        List<Lab_Sample__c> lstc = [select Id from Lab_Sample__c where Case__r.Subject in ('CaseServiceTest2', 'CaseServiceTest3', 'CaseServiceTest4')];
        List<Lab_Sample_Tape_Code__c> toInsertLabSamplesTapeCode = new List<Lab_Sample_Tape_Code__c>();
        toInsertLabSamplesTapeCode.addAll(TestFactory.createLabSampleTapCodes(lstc[0], 1, false));
        toInsertLabSamplesTapeCode.addAll(TestFactory.createLabSampleTapCodes(lstc[1], 1, false));
        toInsertLabSamplesTapeCode.addAll(TestFactory.createLabSampleTapCodes(lstc[2], 1, false));
        Insert toInsertLabSamplesTapeCode;
    }
    @isTest static void testThatLabSampleTapeCodeCannotBeInsertedPostClosure() {
        Lab_Sample__c ls = [select Id from Lab_Sample__c where Case__r.Subject = 'CaseServiceTestClosed' LIMIT 1];

        Test.startTest();
        Lab_Sample_Tape_Code__c lstc = new Lab_Sample_Tape_Code__c(Lab_Sample__c = ls.Id);
        try {
            insert lstc;
        } catch (DmlException e) {
            System.debug('Caught DML exception');
        }
        System.assertEquals(lstc.Id, null);
        Test.stopTest();
    }

    @isTest static void testThatLabSampleTapeCodeCannotBeUpdatedPostClosure() {
        Case caseToUpdate = [Select Id, Claim_Stage__c from Case Where Subject = 'CaseServiceTest2'];
        Lab_Sample_Tape_Code__c lstc = [select Id from Lab_Sample_Tape_Code__c where Lab_Sample__r.Case__r.Subject = 'CaseServiceTest2'];
        
        caseToUpdate.Claim_Stage__c='Closed';
        Update caseToUpdate;
        
        Boolean errorCaught = false;
		
        
        Test.startTest();
        try {
            update lstc;
        } catch (DmlException e) {
            errorCaught = true;
        }
        System.assert(errorCaught);
        Test.stopTest();

        
    }

    @isTest static void testThatLabSampleTapeCodeCannotBeDeletedPostClosure() {
        Case caseToUpdate = [Select Id, Claim_Stage__c from Case Where Subject = 'CaseServiceTest3'];
        Lab_Sample_Tape_Code__c lstc = [select Id from Lab_Sample_Tape_Code__c where Lab_Sample__r.Case__c = :caseToUpdate.Id];
        
        caseToUpdate.Claim_Stage__c='Closed';
        Update caseToUpdate;
        
        System.debug('caseToUpdate: '+caseToUpdate);
        
        Boolean errorCaught = false;

        Test.startTest();
        try {
            delete lstc;
        } catch (DmlException e) {
            errorCaught = true;
        }
        System.assert(errorCaught);
        Test.stopTest();

        
    }

    @isTest static void testThatLabSampleTapeCodeCanBeInsertedUpdatedDeletedPreClosure() {
        Case c = [select Id, Claim_Stage__c, Claim_Sub_Stage__c, ClaimApproved__c from Case where Subject = 'CaseServiceTest4'];
		        
        Test.startTest();
        Lab_Sample__c ls = new Lab_Sample__c(Case__c = c.Id);
        insert ls;
        Lab_Sample_Tape_Code__c lstc = new Lab_Sample_Tape_Code__c(Lab_Sample__c = ls.Id);
        insert lstc;
        System.assertNotEquals(lstc.Id, null);
        update lstc;
        delete lstc;
        Test.stopTest();
        
    }

    private static testMethod void populateLabSamplePRMField_CreateNewTapeCodeWithManufactureDateOneYearFromCaseCreateDate_LabSamplePRMIsChecked() {

        // Prepare the data
        Case caseRecord = [SELECT Id, Installation_Date__c,ClaimApproved__c, CreatedDate FROM Case WHERE Subject = 'CaseServiceTest1'];
        if (caseRecord.ClaimApproved__c){
            caseRecord.ClaimApproved__c=false;
        	update caseRecord;
        }
        
        
        Lab_Sample__c labSampleRecord = [SELECT Id ,PRM__c FROM Lab_Sample__c WHERE Case__c = :caseRecord.Id];

        // Test the data
        Test.startTest();
        Tape_Code__c tapeCodeRecord = new Tape_Code__c(
                Name = 'Manufacture Date within one year of Case Created Date',
                Manufacture_Date__c = Date.newInstance(caseRecord.CreatedDate.year(), caseRecord.CreatedDate.month() - 5, caseRecord.CreatedDate.day()));
        insert tapeCodeRecord;

        Lab_Sample_Tape_Code__c labSampleTapeCodeRecord = new Lab_Sample_Tape_Code__c(Lab_Sample__c = labSampleRecord.Id, Tape_Code__c = tapeCodeRecord.Id);
        insert labSampleTapeCodeRecord;
        
        labSampleRecord = [SELECT Id, PRM__c FROM Lab_Sample__c WHERE Id = :labSampleRecord.Id];
        System.assertEquals(true, labSampleRecord.PRM__c, 'Expected Lab Sample PRM field is checked as the Manufacture Date is within one year of the Case Created Date.');

        Test.stopTest();

        // Assert the data
        
    }

    private static testMethod void populateLabSamplePRMField_CreateNewTapeCodeWithManufactureDateTwoYearFromCaseCreateDate_LabSamplePRMIsUnchecked() {

        // Prepare the data
        Case caseRecord = [SELECT Id, Installation_Date__c,ClaimApproved__c, CreatedDate FROM Case WHERE Subject = 'CaseServiceTest1'];
        Lab_Sample__c labSampleRecord = [SELECT Id ,PRM__c FROM Lab_Sample__c WHERE Case__c = :caseRecord.Id];
		
        if (caseRecord.ClaimApproved__c){
            caseRecord.ClaimApproved__c=false;
        	update caseRecord;
        }
        // Test the data
        Test.startTest();
        Tape_Code__c tapeCodeRecord = new Tape_Code__c(
                Name = 'Manufacture Date within two years of Case Created Date',
                Manufacture_Date__c = Date.newInstance(caseRecord.CreatedDate.year() - 2, caseRecord.CreatedDate.month(), caseRecord.CreatedDate.day()));
        insert tapeCodeRecord;

        Lab_Sample_Tape_Code__c labSampleTapeCodeRecord = new Lab_Sample_Tape_Code__c(Lab_Sample__c = labSampleRecord.Id, Tape_Code__c = tapeCodeRecord.Id);
        insert labSampleTapeCodeRecord;
        Test.stopTest();

        // Assert the data
        labSampleRecord = [SELECT Id, PRM__c FROM Lab_Sample__c WHERE Id = :labSampleRecord.Id];
        System.assertEquals(false, labSampleRecord.PRM__c, 'Expected Lab Sample PRM field is unchecked as the Manufacture Date is within two year of the Case Created Date.');

    }

    private static testMethod  void populateLabSampleRecentManufactureDate_CreateNewTapeCodesWithDifferentManufatureDates_PopulateRecentManufactureDateWithRecentDate() {

        // Prepare the data
        Case caseRecord = [SELECT Id, Installation_Date__c,ClaimApproved__c, CreatedDate FROM Case WHERE Subject = 'CaseServiceTest1'];
        Lab_Sample__c labSampleRecord = [SELECT Id ,PRM__c FROM Lab_Sample__c WHERE Case__c = :caseRecord.Id];
		if (caseRecord.ClaimApproved__c){
            caseRecord.ClaimApproved__c=false;
        	update caseRecord;
        }
        // Test the data
        Test.startTest();
        Tape_Code__c tapeCodeRecord1 = new Tape_Code__c(
                Name = 'Manufacture Date within two years of Case Created Date',
                Manufacture_Date__c = Date.newInstance(caseRecord.CreatedDate.year() - 2, caseRecord.CreatedDate.month(), caseRecord.CreatedDate.day()));

        Tape_Code__c tapeCodeRecord2 = new Tape_Code__c(
                Name = 'Manufacture Date within two years of Case Created Date',
                Manufacture_Date__c = Date.newInstance(caseRecord.CreatedDate.year() - 1, caseRecord.CreatedDate.month(), caseRecord.CreatedDate.day()));

        insert new List<Tape_Code__c> { tapeCodeRecord1, tapeCodeRecord2 };

        Lab_Sample_Tape_Code__c labSampleTapeCodeRecord1 = new Lab_Sample_Tape_Code__c(Lab_Sample__c = labSampleRecord.Id, Tape_Code__c = tapeCodeRecord1.Id);
        Lab_Sample_Tape_Code__c labSampleTapeCodeRecord2 = new Lab_Sample_Tape_Code__c(Lab_Sample__c = labSampleRecord.Id, Tape_Code__c = tapeCodeRecord2.Id);
        System.debug('@@@ labSampleTapeCodeRecord1: ' + labSampleTapeCodeRecord1);
        System.debug('@@@ labSampleTapeCodeRecord2: ' + labSampleTapeCodeRecord2);

        insert new List<Lab_Sample_Tape_Code__c> { labSampleTapeCodeRecord1, labSampleTapeCodeRecord2 };
        Test.stopTest();

        // Assert the data
        labSampleRecord  = [SELECT Id, Recent_Manufacture_Date__c FROM Lab_Sample__c WHERE Id = :labSampleRecord.Id];
        System.debug('@@@ labSampleRecord: ' +  labSampleRecord);
        System.assert(labSampleRecord.Recent_Manufacture_Date__c != NULL, 'Expected Recent Manufacture date is recent manufacture date of the Lab Sample Tape Code record');

    }

}