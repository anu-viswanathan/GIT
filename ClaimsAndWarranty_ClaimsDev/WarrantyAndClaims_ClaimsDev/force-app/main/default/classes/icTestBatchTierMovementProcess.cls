@isTest
public with sharing class icTestBatchTierMovementProcess {

    public static void initTest() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicAccount', new icLogicAccountMock());

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicAccountPayment', new icLogicAccountPaymentMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountPaymentMock', 'getPaidAccountPaymentByYearAndContractorIds', new List<IKOPRO_Account_Payment__c>());

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicContact', new icLogicContactMock());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicContactMock', 'getPrimaryAdminContactsByContractorIds', new List<Contact>());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicContactMock', 'getMapPrimaryAdminContactByContractorId', new Map<String, Contact>());

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicInvoice', new icLogicInvoiceMock());
        icLogicInvoice.IClass logicInvoice = (icLogicInvoice.IClass) icObjectFactory.GetSingletonInstance('icLogicInvoice');
        icTestMockUtilities.Tracer.SetReturnValue('icLogicInvoiceMock', 'getAllInvoicesByAccountIdsAndRebateYear', new List<Invoice__c>());

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icLogicTierMovementLog', new icLogicTierMovementLogMock());

        icTestMockUtilities.Mocker.SetMockSingletonInstance('icHandlerAccount', new icHandlerAccountMock());

        icTestMockUtilities.Tracer.SetReturnValue('icLogicTierMovementSetupMock', 'getTierMovementSetup', new Tier_Movement_Setup__c());
    }

    static testMethod void test_batchDescend_maintain() {
        initTest();

        Date mockDate = Date.newInstance(2020, 03, 24);

        icDtoTierMovementConfig processConfig = new icDtoTierMovementConfig();
        processConfig.sfId = 'configId';
        processConfig.runProcess = true;
        processConfig.isSimulation = false;
        processConfig.processMode = 'DESCEND';
        processConfig.rebateYear = '2019';
        processConfig.adminEmail = 'test@test.com';
        processConfig.startDate = mockDate;
        processConfig.endDate = mockDate;

        Map<String, Tier__c> mapTiers = new Map<String, Tier__c>();
        Tier__c tier1 = new Tier__c();
        //tier1.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier1.Tier_Label__c = '1';
        tier1.Minimum_Squares__c = 0;
        tier1.Maximum_Squares__c = 2999;
        
        Tier__c tier2 = new Tier__c();
        //tier2.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier2.Tier_Label__c = '2';
        tier2.Minimum_Squares__c = 3000;
        tier2.Maximum_Squares__c = 5999;
        
        Tier__c tier3 = new Tier__c();
        //tier3.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier3.Tier_Label__c = '3';
        tier3.Minimum_Squares__c = 6000;
        tier3.Maximum_Squares__c = 1000000;
        
        Tier__c tier0 = new Tier__c();
        //tier3.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier3.Tier_Label__c = '0';
        tier3.Minimum_Squares__c = 0;
        tier3.Maximum_Squares__c = 0;
        
        insert new List<Tier__c> {tier1, tier2, tier3, tier0};
        mapTiers.put(tier1.Id, tier1);
        mapTiers.put(tier2.Id, tier2);
        mapTiers.put(tier3.Id, tier3);
        mapTiers.put(tier0.Id, tier0);

        System.debug('tier1 : ' + tier1.id);
        System.debug('tier2 : ' + tier2.id);
        System.debug('tier3 : ' + tier3.id);

        Map<String, Schema.RecordTypeInfo> mapContractorRecordTypes = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        Id contractorRecordTypeId = mapContractorRecordTypes.get('IKOPRO_Contractor').getRecordTypeId();
        Id contractorHAOKRecordTypeId = mapContractorRecordTypes.get('IKOPRO_Contractor_HA_OK').getRecordTypeId();

        Account maintain = new Account(Name = 'maintain'
            ,IKOPRO_Approved_On__c = Date.newInstance(2019, 11, 24)
            ,Override_Tier_Movement__c = false
            ,Present_Tier_Lookup__c = tier2.Id
            ,IsPartner__c = true
            ,RecordTypeId = contractorRecordTypeId
            ,BillingPostalCode = 'h0h 0h0');
        insert new List<Account>{maintain};
            maintain.IsPartner = true;
        update maintain;

        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountMock', 'evaluateIsProratedYear', false);

        Map<String, IKOPRO_Account_Payment__c> mapPaidRenewalsByContractorIdMock = new Map<String, IKOPRO_Account_Payment__c>();
        mapPaidRenewalsByContractorIdMock.put(maintain.Id, new IKOPRO_Account_Payment__c());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountPaymentMock', 'getMapPaidRenewalByContractorId', mapPaidRenewalsByContractorIdMock);

        Map<String, List<Invoice__c>> mapInvoicesByAccountMock = new Map<String, List<Invoice__c>>();
        Invoice__c invoiceMock = new Invoice__c();
        mapInvoicesByAccountMock.put(maintain.Id, new List<Invoice__c>{invoiceMock});
        icTestMockUtilities.Tracer.SetReturnValue('icLogicInvoiceMock', 'getMapInvoicesByAccount', mapInvoicesByAccountMock);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicInvoiceMock', 'getSquaresFromInvoices', 4000);

        icBatchTierMovementProcess batchClass = new icBatchTierMovementProcess(processConfig, mapTiers);
        Database.executebatch(batchClass);
    }

    static testMethod void test_batchDescend_descend_prorated() {
        initTest();

        Date mockDate = Date.newInstance(2020, 03, 24);

        icDtoTierMovementConfig processConfig = new icDtoTierMovementConfig();
        processConfig.sfId = 'configId';
        processConfig.runProcess = true;
        processConfig.isSimulation = false;
        processConfig.processMode = 'DESCEND';
        processConfig.rebateYear = '2019';
        processConfig.adminEmail = 'test@test.com';
        processConfig.startDate = mockDate;
        processConfig.endDate = mockDate;

        Map<String, Tier__c> mapTiers = new Map<String, Tier__c>();
        Tier__c tier1 = new Tier__c();
        //tier1.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier1.Tier_Label__c = '1';
        tier1.Minimum_Squares__c = 0;
        tier1.Maximum_Squares__c = 2999;
        
        Tier__c tier2 = new Tier__c();
        //tier2.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier2.Tier_Label__c = '2';
        tier2.Minimum_Squares__c = 3000;
        tier2.Maximum_Squares__c = 5999;
        
        Tier__c tier3 = new Tier__c();
        //tier3.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier3.Tier_Label__c = '3';
        tier3.Minimum_Squares__c = 6000;
        tier3.Maximum_Squares__c = 1000000;
        
        Tier__c tier0 = new Tier__c();
        //tier3.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier3.Tier_Label__c = '0';
        tier3.Minimum_Squares__c = 0;
        tier3.Maximum_Squares__c = 0;
        
        insert new List<Tier__c> {tier1, tier2, tier3, tier0};
        mapTiers.put(tier1.Id, tier1);
        mapTiers.put(tier2.Id, tier2);
        mapTiers.put(tier3.Id, tier3);
        mapTiers.put(tier0.Id, tier0);

        Map<String, Schema.RecordTypeInfo> mapContractorRecordTypes = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        Id contractorRecordTypeId = mapContractorRecordTypes.get('IKOPRO_Contractor').getRecordTypeId();
        Id contractorHAOKRecordTypeId = mapContractorRecordTypes.get('IKOPRO_Contractor_HA_OK').getRecordTypeId();

        Account prorated = new Account(Name = 'prorated'
            ,IKOPRO_Approved_On__c = Date.newInstance(2019, 11, 24)
            ,Override_Tier_Movement__c = false
            ,Present_Tier_Lookup__c = tier3.Id
            ,IsPartner__c = true
            ,RecordTypeId = contractorRecordTypeId
            ,BillingPostalCode = 'h0h 0h0');
        insert new List<Account>{prorated};
            prorated.IsPartner = true;
        update prorated;

        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountMock', 'evaluateIsProratedYear', true);

        Map<String, IKOPRO_Account_Payment__c> mapPaidRenewalsByContractorIdMock = new Map<String, IKOPRO_Account_Payment__c>();
        mapPaidRenewalsByContractorIdMock.put(prorated.Id, new IKOPRO_Account_Payment__c());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountPaymentMock', 'getMapPaidRenewalByContractorId', mapPaidRenewalsByContractorIdMock);

        Map<String, List<Invoice__c>> mapInvoicesByAccountMock = new Map<String, List<Invoice__c>>();
        Invoice__c invoiceMock = new Invoice__c();
        mapInvoicesByAccountMock.put(prorated.Id, new List<Invoice__c>{invoiceMock});
        icTestMockUtilities.Tracer.SetReturnValue('icLogicInvoiceMock', 'getMapInvoicesByAccount', mapInvoicesByAccountMock);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicInvoiceMock', 'getSquaresFromInvoices', 10);

        icBatchTierMovementProcess batchClass = new icBatchTierMovementProcess(processConfig, mapTiers);
        Database.executebatch(batchClass);
    }

    static testMethod void test_batchDescend_ommitted() {
        initTest();

        Date mockDate = Date.newInstance(2020, 03, 24);

        icDtoTierMovementConfig processConfig = new icDtoTierMovementConfig();
        processConfig.sfId = 'configId';
        processConfig.runProcess = true;
        processConfig.isSimulation = false;
        processConfig.processMode = 'DESCEND';
        processConfig.rebateYear = '2019';
        processConfig.adminEmail = 'test@test.com';
        processConfig.startDate = mockDate;
        processConfig.endDate = mockDate;

        Map<String, Tier__c> mapTiers = new Map<String, Tier__c>();
        Tier__c tier1 = new Tier__c();
        //tier1.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier1.Tier_Label__c = '1';
        tier1.Minimum_Squares__c = 0;
        tier1.Maximum_Squares__c = 2999;
        
        Tier__c tier2 = new Tier__c();
        //tier2.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier2.Tier_Label__c = '2';
        tier2.Minimum_Squares__c = 3000;
        tier2.Maximum_Squares__c = 5999;
        
        Tier__c tier3 = new Tier__c();
        //tier3.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier3.Tier_Label__c = '3';
        tier3.Minimum_Squares__c = 6000;
        tier3.Maximum_Squares__c = 1000000;
        
        insert new List<Tier__c> {tier1, tier2, tier3};
        mapTiers.put(tier1.Id, tier1);
        mapTiers.put(tier2.Id, tier2);
        mapTiers.put(tier3.Id, tier3);

        Map<String, Schema.RecordTypeInfo> mapContractorRecordTypes = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        Id contractorRecordTypeId = mapContractorRecordTypes.get('IKOPRO_Contractor').getRecordTypeId();
        Id contractorHAOKRecordTypeId = mapContractorRecordTypes.get('IKOPRO_Contractor_HA_OK').getRecordTypeId();

        Account ommitActivatedOn = new Account(Name = 'ommitActivatedOn'
            ,IKOPRO_Approved_On__c = Date.newInstance(2020, 03, 24)
            ,Override_Tier_Movement__c = false
            ,Present_Tier_Lookup__c = tier2.Id
            ,IsPartner__c = true
            ,RecordTypeId = contractorRecordTypeId
            ,BillingPostalCode = 'h0h 0h0');
        Account manualOverride = new Account(Name = 'manualOverride'
            ,IKOPRO_Approved_On__c = Date.newInstance(2018, 03, 24)
            ,Override_Tier_Movement__c = true
            ,Present_Tier_Lookup__c = tier2.Id
            ,IsPartner__c = true
            ,RecordTypeId = contractorRecordTypeId
            ,BillingPostalCode = 'h0h 0h0');
        Account noPresentTier = new Account(Name = 'noPresentTier'
            ,IKOPRO_Approved_On__c = Date.newInstance(2018, 03, 24)
            ,Override_Tier_Movement__c = false
            ,IsPartner__c = true
            ,RecordTypeId = contractorRecordTypeId
            ,BillingPostalCode = 'h0h 0h0');
        Account canNotDescend = new Account(Name = 'canNotDescend'
            ,IKOPRO_Approved_On__c = Date.newInstance(2018, 03, 24)
            ,Override_Tier_Movement__c = false
            ,Present_Tier_Lookup__c = tier1.Id
            ,IsPartner__c = true
            ,RecordTypeId = contractorRecordTypeId
            ,BillingPostalCode = 'h0h 0h0');
        Account notRenewed = new Account(Name = 'notRenewed'
            ,IKOPRO_Approved_On__c = Date.newInstance(2019, 11, 24)
            ,Override_Tier_Movement__c = false
            ,Present_Tier_Lookup__c = tier2.Id
            ,IsPartner__c = true
            ,RecordTypeId = contractorRecordTypeId
            ,BillingPostalCode = 'h0h 0h0');        
        insert new List<Account>{ommitActivatedOn, manualOverride, noPresentTier, canNotDescend, notRenewed};

        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountPaymentMock', 'getMapPaidRenewalByContractorId', new Map<String, IKOPRO_Account_Payment__c>());

        icBatchTierMovementProcess batchClass = new icBatchTierMovementProcess(processConfig, mapTiers);
        Database.executebatch(batchClass);
    }

    static testMethod void test_batchAscend_ascend() {
        initTest();

        Date mockDate = Date.newInstance(2020, 03, 24);

        icDtoTierMovementConfig processConfig = new icDtoTierMovementConfig();
        processConfig.sfId = 'configId';
        processConfig.runProcess = true;
        processConfig.isSimulation = false;
        processConfig.processMode = 'ASCEND';
        processConfig.rebateYear = '2020';
        processConfig.adminEmail = 'test@test.com';
        processConfig.startDate = mockDate;
        processConfig.endDate = mockDate;

        Map<String, Tier__c> mapTiers = new Map<String, Tier__c>();
        Tier__c tier1 = new Tier__c();
        //tier1.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier1.Tier_Label__c = '1';
        tier1.Minimum_Squares__c = 0;
        tier1.Maximum_Squares__c = 2999;
        
        Tier__c tier2 = new Tier__c();
        //tier2.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier2.Tier_Label__c = '2';
        tier2.Minimum_Squares__c = 3000;
        tier2.Maximum_Squares__c = 5999;
        
        Tier__c tier3 = new Tier__c();
        //tier3.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier3.Tier_Label__c = '3';
        tier3.Minimum_Squares__c = 6000;
        tier3.Maximum_Squares__c = 1000000;
        
        Tier__c tier0 = new Tier__c();
        //tier3.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier3.Tier_Label__c = '0';
        tier3.Minimum_Squares__c = 0;
        tier3.Maximum_Squares__c = 0;
        
        insert new List<Tier__c> {tier1, tier2, tier3, tier0};
        mapTiers.put(tier1.Id, tier1);
        mapTiers.put(tier2.Id, tier2);
        mapTiers.put(tier3.Id, tier3);
        mapTiers.put(tier0.Id, tier0);

        Map<String, Schema.RecordTypeInfo> mapContractorRecordTypes = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        Id contractorRecordTypeId = mapContractorRecordTypes.get('IKOPRO_Contractor').getRecordTypeId();
        Id contractorHAOKRecordTypeId = mapContractorRecordTypes.get('IKOPRO_Contractor_HA_OK').getRecordTypeId();

        Account ascend = new Account(Name = 'ascend'
            ,IKOPRO_Approved_On__c = Date.newInstance(2019, 11, 24)
            ,Override_Tier_Movement__c = false
            ,Present_Tier_Lookup__c = tier2.Id
            ,IsPartner__c = true
            ,RecordTypeId = contractorRecordTypeId
            ,BillingPostalCode = 'h0h 0h0');
        insert new List<Account>{ascend};
            ascend.IsPartner = true;
            ascend.Safety_Fundamentals_Completed__c = true;
            ascend.IF_Course_Affirmation__c = true;
            ascend.Performance_Fundamentals_Completed__c = true;
            ascend.Business_Fundamentals_Completed__c = true;
        update ascend;

        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountMock', 'evaluateIsProratedYear', false);

        Map<String, IKOPRO_Account_Payment__c> mapPaidRenewalsByContractorIdMock = new Map<String, IKOPRO_Account_Payment__c>();
        mapPaidRenewalsByContractorIdMock.put(ascend.Id, new IKOPRO_Account_Payment__c());
        icTestMockUtilities.Tracer.SetReturnValue('icLogicAccountPaymentMock', 'getMapPaidRenewalByContractorId', mapPaidRenewalsByContractorIdMock);

        Map<String, List<Invoice__c>> mapInvoicesByAccountMock = new Map<String, List<Invoice__c>>();
        Invoice__c invoiceMock = new Invoice__c();
        mapInvoicesByAccountMock.put(ascend.Id, new List<Invoice__c>{invoiceMock});
        icTestMockUtilities.Tracer.SetReturnValue('icLogicInvoiceMock', 'getMapInvoicesByAccount', mapInvoicesByAccountMock);
        icTestMockUtilities.Tracer.SetReturnValue('icLogicInvoiceMock', 'getSquaresFromInvoices', 9000);

        icBatchTierMovementProcess batchClass = new icBatchTierMovementProcess(processConfig, mapTiers);
        Database.executebatch(batchClass);
    }

    static testMethod void test_batchAscend_ommitted() {
        initTest();

        Date mockDate = Date.newInstance(2020, 03, 24);

        icDtoTierMovementConfig processConfig = new icDtoTierMovementConfig();
        processConfig.sfId = 'configId';
        processConfig.runProcess = true;
        processConfig.isSimulation = false;
        processConfig.processMode = 'ASCEND';
        processConfig.rebateYear = '2020';
        processConfig.adminEmail = 'test@test.com';
        processConfig.startDate = mockDate;
        processConfig.endDate = mockDate;

        Map<String, Tier__c> mapTiers = new Map<String, Tier__c>();
        Tier__c tier1 = new Tier__c();
        //tier1.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier1.Tier_Label__c = '1';
        tier1.Minimum_Squares__c = 0;
        tier1.Maximum_Squares__c = 2999;
        
        Tier__c tier2 = new Tier__c();
        //tier2.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier2.Tier_Label__c = '2';
        tier2.Minimum_Squares__c = 3000;
        tier2.Maximum_Squares__c = 5999;
        
        Tier__c tier3 = new Tier__c();
        //tier3.Id = icTestHelperUtility.getFakeId(Tier__c.SObjectType);
        tier3.Tier_Label__c = '3';
        tier3.Minimum_Squares__c = 6000;
        tier3.Maximum_Squares__c = 1000000;
        
        insert new List<Tier__c> {tier1, tier2, tier3};
        mapTiers.put(tier1.Id, tier1);
        mapTiers.put(tier2.Id, tier2);
        mapTiers.put(tier3.Id, tier3);

        Map<String, Schema.RecordTypeInfo> mapContractorRecordTypes = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        Id contractorRecordTypeId = mapContractorRecordTypes.get('IKOPRO_Contractor').getRecordTypeId();
        Id contractorHAOKRecordTypeId = mapContractorRecordTypes.get('IKOPRO_Contractor_HA_OK').getRecordTypeId();

        Account canNotAscend = new Account(Name = 'canNotAscend'
            ,IKOPRO_Approved_On__c = Date.newInstance(2018, 03, 24)
            ,Override_Tier_Movement__c = false
            ,Present_Tier_Lookup__c = tier3.Id
            ,IsPartner__c = true
            ,RecordTypeId = contractorRecordTypeId
            ,BillingPostalCode = 'h0h 0h0');        
        insert new List<Account>{canNotAscend};

        icBatchTierMovementProcess batchClass = new icBatchTierMovementProcess(processConfig, mapTiers);
        Database.executebatch(batchClass);
    }
}