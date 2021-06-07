@isTest
public without sharing class TestFactory {

    /*
        Used to generate test data for various test classes,
        to initialize various types of Accounts, Contacts, Users, Cases, etc.
    */


    private static Map<String, Profile> getProfileMap() {
        Map<String, Profile> profileMap = new Map<String, Profile>();
        for (Profile p : [
                select Id, Name
                from Profile
//	2020-04-15 Why is this restriction needed? Query all profiles. Profile names are unique anyway.
//                where Name IN ('Commercial Claims Rep', 'System Administrator', 'Lab Manager',
//                        'USRS Sales Rep', 'USRS Manager', 'Lab Technician', 'Iko Plants', 'Claims Manager','System Administrator',
//                        'Residential Claims Rep','Plant Manager')
        ])
            profileMap.put(p.Name, p);

        return profileMap;
    }

    private static Map<String, UserRole> getRoleMap() {

        Map<String, UserRole> roleMap = new Map<String, UserRole>();
          for (UserRole ur : [
                select Id, Name
                from UserRole
// 2020-04-15 Remove restriction here that just results in limiting the roles that can be used
//                where Name IN ('Plant', 'Commercial Claims Rep', 'TSR West', 'Claims Manager',
//                        'RSM West', 'Director US Field Sales', 'VP US Sales', 'US National Account Manager',
//                        'US Director National Accounts', 'Lab Manager', 'Lab Tech','CEO','Residential Claims Rep','Plant')
        ])
            roleMap.put(ur.Name, ur);
			System.Debug(roleMap);
        return roleMap;
    }

    private static Map<String, Profile> userProfileMap = getProfileMap();
    private static Map<String, UserRole> userRoleMap = getRoleMap();

    //get recordtype Ids
    Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();
    Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();


    public static User createUser(String firstName, String lastName, String userName, String email,
            String profile, String role, String alias, String timeZoneSidKey, String localeSidKey,
            String emailEncodingKey, String languageLocaleKey, String country, User manager,Boolean isInsert) {

        User u = new User();
        if(manager != NULL){
             u = new User(UserRoleId = userRoleMap.get(role).Id,
                    ProfileId = userProfileMap.get(profile).Id, Username = userName,
                    Email = email, FirstName = firstName, LastName = lastName, TimeZoneSidKey = timeZoneSidKey,
                    LocaleSidKey = localeSidKey, Alias = alias, EmailEncodingKey = emailEncodingKey, LanguageLocaleKey = languageLocaleKey,
                    Country = country, ManagerId = manager.Id);
        }else{
             u = new User(UserRoleId = userRoleMap.get(role).Id,
                    ProfileId = userProfileMap.get(profile).Id, Username = userName,
                    Email = email, FirstName = firstName, LastName = lastName, TimeZoneSidKey = timeZoneSidKey,
                    LocaleSidKey = localeSidKey, Alias = alias, EmailEncodingKey = emailEncodingKey, LanguageLocaleKey = languageLocaleKey,
                    Country = country);
        }

        if(isInsert){
            insert u;
        }
        return u;
    }


    // create multiple accounts
    public static List<Account> createAccounts(Id recordTypeId, String accountName, String bStreet, String bCity, String bStateCode,
            String bCountryCode, String bPostalCode, String AddVerifiedStatus,
            Id ownerId, Boolean nmVerificationStatus, Boolean actVerifiedStatus,Integer numOfAccounts,Boolean isInsert) {
        Integer i = 0;
        List<Account> createdAccounts = new List<Account>();
        if(numOfAccounts == 1){
            createdAccounts.add(new Account(Name = accountName, RecordTypeId = recordTypeId, BillingStreet = bStreet,
                    BillingCity = bCity, BillingStateCode = bStateCode,
                    BillingCountryCode = bCountryCode, BillingPostalCode = bPostalCode,
                    Address_Verification_Status__c = addVerifiedStatus, OwnerId = ownerId,
                    Name_Verification_Status__c = nmVerificationStatus, Account_Name_Verified__c = actVerifiedStatus));
        }else{
            for (i = 0; i < numOfAccounts; i++) {
                createdAccounts.add(new Account(Name = accountName + String.valueOf(i), RecordTypeId = recordTypeId, BillingStreet = bStreet,
                        BillingCity = bCity, BillingStateCode = bStateCode,
                        BillingCountryCode = bCountryCode, BillingPostalCode = bPostalCode,
                        Address_Verification_Status__c = addVerifiedStatus, OwnerId = ownerId,
                        Name_Verification_Status__c = nmVerificationStatus, Account_Name_Verified__c = actVerifiedStatus));
            }
        }

        if(isInsert){
            insert createdAccounts;
        }
        return createdAccounts;
    }


    //create multiple contacts
    public static List<Contact> createContacts(Id relatedAct, String lastName, Id ownerId, Integer numOfContacts,Boolean isInsert) {

        Integer i;
        List<Contact> createdContacts = new List<Contact>();
        for (i = 0; i < numOfContacts; i++) {
            createdContacts.add(new Contact(AccountId = relatedAct, LastName = lastName, OwnerId = ownerId,FirstName = 'FirstName'+i));
        }

        if(isInsert){
            insert createdContacts;
        }
        return createdContacts;
    }


    public static List<Case> createCases(Id recordTypeId, Id actId, Id contactId, String origin, String subject, Date installationDate,
            String sector, String claimStage, Integer numOfCases,Boolean isInsert) {

        Integer i;
        List<Case> cases = new List<Case>();
        for (i = 0; i < numOfCases; i++) {
            cases.add(new Case(RecordTypeId = recordTypeId, AccountId = actId, ContactId = contactId, Origin = origin,
                    Subject = subject, Installation_Date__c = installationDate, Sector__c = sector, Claim_Stage__c = claimStage));
        }

        if(isInsert){
            insert cases;
        }
        return cases;
    }

    /**
     * ClaimsV2-926
     * By Anil Mannem(Incloud)
     * Added logic to create cases for Goodwill Claims
     */ 
    public static List<Case> createGoodwillCases(Id recordTypeId, Id actId, Id contactId, String origin, String subject, Date installationDate,
            String sector, String claimStage, Integer numOfCases, Boolean isInsert, Integer amount) {

        Integer i;
        List<Case> cases = new List<Case>();
        for (i = 0; i < numOfCases; i++) {
            cases.add(new Case(RecordTypeId = recordTypeId, AccountId = actId, ContactId = contactId, Origin = origin,
                    Subject = subject, Installation_Date__c = installationDate, Sector__c = sector, Claim_Stage__c = claimStage,
                    GoodwillClaimAmount__c = amount));
        }

        if(isInsert){
            insert cases;
        }
        return cases;
    }

    public static sharinpix__SharinPixPermission__c createSharinPixPermissions(String sharingPixName,Boolean isInsert) {

        if(isInsert){
            insert new sharinpix__SharinPixPermission__c(Name = sharingPixName);
        }
        return new sharinpix__SharinPixPermission__c(Name = sharingPixName);
    }

    public static Claims_Config__c createClaimsConfig(sharinpix__SharinPixPermission__c sharinPixPermission,Boolean isInsert) {

        Claims_Config__c claimsConfig = new Claims_Config__c();

        if (sharinPixPermission.Name.equals('Annotate')) {
            claimsConfig.SharinPix_Annotate_Permission_Id__c = sharinPixPermission.Id;
        } else if (sharinPixPermission.Name.equals('ReadOnly')) {
            claimsConfig.SharinPix_Upload_Only_Permission__c = sharinPixPermission.Id;
        } else if (sharinPixPermission.Name.equals('UploadOnly')) {
            claimsConfig.SharinPix_Read_Only_Permission__c = sharinPixPermission.Id;
        }

        if(isInsert){
            insert claimsConfig;
        }
        return claimsConfig;

    }


    public static List<Lab_Test__c> createLabTests(String testReason, String testDescription, Integer numOfLabTests,Boolean isInsert) {

        Integer i;
        List<Lab_Test__c> labTests = new List<Lab_Test__c>();
        for (i = 0; i < numOfLabTests; i++) {
            labTests.add(new Lab_Test__c(Test_Reason__c = testReason, Test_Description__c = testDescription));
        }

        if(isInsert){
            insert labTests;
        }
        return labTests;
    }


    public static List<Payment_Request__c> createPaymentRequests(Case aCase, Integer numOfPaymentRequests,Boolean isInsert) {
        Integer i;
        List<Payment_Request__c> payRequests = new List<Payment_Request__c>();
        for (i = 0; i < numOfPaymentRequests; i++) {
            payRequests.add(new Payment_Request__c(Case__c = aCase.Id));
        }

        if(isInsert){
            insert payRequests;
        }
        return payRequests;
    }


    public static List<Payment_Request_Line_Item__c> createPaymentRequestLineItems(Payment_Request__c aPaymentRequest,
                                                                                 Integer numOfPaymentRequests,Boolean isInsert) {
        Integer i;
        List<Payment_Request_Line_Item__c> payRequests = new List<Payment_Request_Line_Item__c>();
        for (i = 0; i < numOfPaymentRequests; i++) {
            payRequests.add(new Payment_Request_Line_Item__c(Payment_Request__c = aPaymentRequest.Id));
        }

        if(isInsert){
            insert payRequests;
        }
        return payRequests;
    }


    public static List<Lab_Sample__c> createLabSamples(Case aCase, Integer numOfLabSamples,Boolean isInsert) {
        Integer i;
        List<Lab_Sample__c> labSamples = new List<Lab_Sample__c>();
        for (i = 0; i < numOfLabSamples; i++) {
            labSamples.add(new Lab_Sample__c(Case__c = aCase.Id, Sequence_Number__c = 0));
        }

        if(isInsert){
            insert labSamples;
        }
        return labSamples;
    }

    public static List<Warranty__c> createWarranties(Id accountId, Integer numOfWarranties, Boolean isInsert) {
        Integer i;
        List<Warranty__c> warranties = new List<Warranty__c>();
        for (i = 0; i < numOfWarranties; i++) {
            warranties.add(new Warranty__c(Name = 'Test Warranty' + i,
                    Warranty_Status__c = 'Draft',
                    Type__c = 'Labor & Membrane', Building__c = accountId,
                    Warranty_Registration_Id__c = i + '111111111'));
        }

        if(isInsert){
            insert warranties;
        }
        return warranties;
    }

    public static List<Lab_Sample_Tape_Code__c> createLabSampleTapCodes(Lab_Sample__c labSample, Integer numOfLabSampleTapCodes,Boolean isInsert) {
        Integer i;
        List<Lab_Sample_Tape_Code__c> labSampleTapCodes = new List<Lab_Sample_Tape_Code__c>();
        for (i = 0; i < numOfLabSampleTapCodes; i++) {
            labSampleTapCodes.add(new Lab_Sample_Tape_Code__c(Lab_Sample__c = labSample.Id));
        }

        if(isInsert){
            insert labSampleTapCodes;
        }
        return labSampleTapCodes;
    }

    public static List<Claim_Type__c> createClaimTypes(Case aCase, Integer numOfClaimTypes,Boolean isInsert) {
        Integer i;
        List<Claim_Type__c> claimTypes = new List<Claim_Type__c>();
        for (i = 0; i < numOfClaimTypes; i++) {
            claimTypes.add(new Claim_Type__c(Case__c = aCase.Id));
        }
		// 2019-11-11 Adding this because Slalom has left out two required fielsd on claim type
		// So we need to put them back in
		// The counter is because we need to test glass and not
        Decimal counter = 1;
        for(Claim_Type__c ct : claimTypes) {
            if(counter/2 == math.floor(counter)) {
                ct.Product_Type__c = 'A Organic';
                ct.Concern__c = 'Cracking';
            } else {
                ct.Product_Type__c = 'A Organic';
                ct.Concern__c = 'Granule Loss';
                
            }
        }
        
        if(isInsert){
            insert claimTypes;
        }
        return claimTypes;
    }


    public static List<CaseComment> createCaseComments(Case aCase, Integer numOfCaseComments,Boolean isInsert) {
        Integer i;
        List<CaseComment> caseComments = new List<CaseComment>();
        for (i = 0; i < numOfCaseComments; i++) {
            CaseComment cc = new CaseComment(ParentId = aCase.Id);
            caseComments.add(cc);
        }

        if(isInsert){
            insert caseComments;
        }
        return caseComments;
    }

    public static List<Lab_Test_Result__c> createlabTestResults(Lab_Sample__c labSample, Lab_Test__c labTest, Integer numOfLabTestResults,Boolean isInsert) {
        Integer i;
        List<Lab_Test_Result__c> labSampleResults = new List<Lab_Test_Result__c>();
        for (i = 0; i < numOfLabTestResults; i++) {
            labSampleResults.add(new Lab_Test_Result__c(Lab_Sample__c = labSample.Id, Lab_Test__c = labTest.Id));
        }

        if(isInsert){
            insert labSampleResults;
        }


        return labSampleResults;
    }


    public static List<Settlement_Condition__c> createlabTestResults(Case aCase, String conditionTemplate, Integer numOfSettlementConditions,Boolean isInsert) {
        Integer i;
        List<Settlement_Condition__c> settlementConditions = new List<Settlement_Condition__c>();
        for (i = 0; i < numOfSettlementConditions; i++) {
            settlementConditions.add(new Settlement_Condition__c(Case__c = aCase.Id, Condition_Template__c = conditionTemplate));
        }

        if(isInsert){
            insert settlementConditions;
        }


        return settlementConditions;
    }


    public static List<Product2> createProducts(String name, Boolean isActive, String pCode, String sector, String pFamily,
                                                    Integer numOfProducts,Boolean isInsert) {
        Integer i;
        List<Product2> products = new List<Product2>();
        for (i = 0; i < numOfProducts; i++) {
            products.add(new Product2(Iko_Product_Family__c = pFamily, IsActive = isActive, Name = name,
                    ProductCode = pCode, Sectors__c = sector));
        }

        if(isInsert){
            insert products;
        }

        return products;
    }

    public static List<Related_Product__c> createRelatedProducts(Case aCase, Product2 product, Integer numOfRelatedProducts,Boolean isInsert) {
        Integer i;
        List<Related_Product__c> relatedProducts = new List<Related_Product__c>();
        for (i = 0; i < numOfRelatedProducts; i++) {
            relatedProducts.add(new Related_Product__c(Case__c = aCase.Id, Product__c = product.id));
        }

        if(isInsert){
            insert relatedProducts;
        }

        return relatedProducts;
    }

    public static List<ContentVersion> createContentVersion(String cvTitle, String pathOnClient, String versionData,
                                                                Boolean isMajorVersion,Id firstPublishLocationId,
                                                                    Integer numOfFiles,Boolean isInsert) {

        List<ContentVersion> cvList = new List<ContentVersion>();
        for (Integer i = 0; i < numOfFiles; i++) {
            cvList.add(new ContentVersion(Title = cvTitle + String.valueOf(i), PathOnClient = pathOnClient, VersionData = Blob.valueOf(versionData),
                    IsMajorVersion = isMajorVersion, FirstPublishLocationId = firstPublishLocationId));
        }

        if(isInsert){
            insert cvList;
        }

        return cvList;
    }
}