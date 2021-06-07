@istest
public class ContentDocument_Trigger_Test {

    @testSetup static void setupTestData() {
        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();

        //create Account
        List<Account> toInsertAccounts = new List<Account>();

        toInsertAccounts.addAll(TestFactory.createAccounts(baRt,'CaseServiceTest','9 King St E','Toronto','ON','CA','M4S 2H4',
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

        toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTest',null,'Commercial','Draft',1,false));
        toInsertCases.addAll(TestFactory.createCases(ccRt,mapAccounts.get('CaseServiceTest').Id,toInsertContacts[0].Id,'Distributor','CaseServiceTest1',null,'Commercial','Draft',1,false));

        insert toInsertCases;

        List<ContentVersion> cvList = new List<ContentVersion>();

        for (Integer i = 1; i <= 5; i++) {
            // Insert a document and attach it to Fred's case
            ContentVersion cv = new ContentVersion();
            cv.Title = 'Test Delete Trigger ' + i;
            cv.PathOnClient = 'Fred.jpg';
            cv.VersionData = Blob.valueOf('It can hardly be a coincidence that no language on Earth has ever produced the expression "as pretty as an airport". Airports are ugly. Some are very ugly. Some attain a degree of ugliness that can only be the result of a special effort. This ugliness arises because airports are full of people who are tired, cross, and have just discovered that their luggage has landed in Murmansk (...) and the architects have on the whole tried to reflect this in their designs.');
            cv.IsMajorVersion = true;
            cv.FirstPublishLocationId = toInsertCases[1].Id;
            cvList.add(cv);

            // Insert a document and attach it to Fred Crib account record; should be able to delete this
            ContentVersion accountDoc = new ContentVersion();
            accountDoc.Title = 'Account File ' + i;
            accountDoc.PathOnClient = 'Account.jpg';
            accountDoc.VersionData = Blob.valueOf('It can hardly be a coincidence that no language on Earth has ever produced the expression "as pretty as an airport". Airports are ugly. Some are very ugly. Some attain a degree of ugliness that can only be the result of a special effort. This ugliness arises because airports are full of people who are tired, cross, and have just discovered that their luggage has landed in Murmansk (...) and the architects have on the whole tried to reflect this in their designs.');
            accountDoc.IsMajorVersion = true;
            accountDoc.FirstPublishLocationId = mapAccounts.get('CaseServiceTest').Id;
            cvList.add(accountDoc);
        }

        insert cvlist;
        
        ContentDocument_Trigger_Test.createUsers();
    }
    
	@future
    public static void createUsers(){
        
        List<User> toInsertUsers = new List<User>();
		toInsertUsers.add(TestFactory.createUser('UnitClaim','TestsClaim','claimsManagerUsr@iko.com','claimsManagerUsr@iko.com','Claims Manager',
				'Claims Manager','tclu','GMT','en_US','UTF-8','en_US','United States',null,false));
		toInsertUsers.add(TestFactory.createUser('Unit','Tests','testuser@iko.com','testuser@iko.com','Commercial Claims Rep',
				'Commercial Claims Rep','testuser','GMT','en_US','UTF-8','en_US','United States',null,false));
		toInsertUsers.add(TestFactory.createUser('Unit','Tests','rtestuser@iko.com','rtestuser@iko.com','Residential Claims Rep',
				'Residential Claims Rep','test2','GMT','en_US','UTF-8','en_US','United States',null,false));
		toInsertUsers.add(TestFactory.createUser('Unit','Tests','salesrsmmgr@iko.com','salesrsmmgr@iko.com','USRS Manager',
				'RSM West','salesmgr','GMT','en_US','UTF-8','en_US',null,null,false));

		insert toInsertUsers;
    }
    @istest
    public static void deleteResidentialDocument() {
        Case c = [SELECT Id FROM Case WHERE Subject = 'CaseServiceTest1'];

        ContentDocument doc = [SELECT Id FROM ContentDocument WHERE Title = 'Test Delete Trigger 1'];

        Boolean caughtError = false;

        Test.startTest();
        try {
            delete doc;
        } catch (DmlException e) {
            if (e.getMessage().contains('This file is part of'))
                caughtError = true;
        }
        Test.stopTest();
        System.assert(caughtError);

        List<ContentDocument> docCheck = [select Id FROM ContentDocument WHERE Title = 'Test Delete Trigger 1'];
        System.assertEquals(docCheck.size(), 1);
    }


    @istest
    public static void deleteCommercialDocument() {
        Case c = [SELECT Id FROM Case WHERE Subject = 'CaseServiceTest1'];
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Residential Claim').getRecordTypeId();
        update c;

        ContentDocument doc = [SELECT Id FROM ContentDocument WHERE Title = 'Test Delete Trigger 1'];

        Test.startTest();
        Boolean caughtError = false;
        try {
            delete doc;
        } catch (DmlException e) {
            if (e.getMessage().contains('This file is part of'))
                caughtError = true;
        }
        Test.stopTest();
        System.assert(caughtError);

        List<ContentDocument> docCheck = [select Id FROM ContentDocument WHERE Title = 'Test Delete Trigger 1'];
        System.assertEquals(docCheck.size(), 1);
    }


    @isTest
    public static void testBulkDeleteClaimFilesCaught() {
        List<String> fileNames = new List<String>();
        for (Integer i = 1; i <= 2; i++) {
            fileNames.add('Test Delete Trigger ' + i);
        }


        List<ContentDocument> docList = [select Id from ContentDocument where Title IN :fileNames];

        Boolean caughtError = false;
        try {
            delete docList;
        } catch (DmlException e) {
            if (e.getMessage().contains('This file is part of'))
                caughtError = true;
        }

        List<ContentDocument> docListCheck = [select Id from ContentDocument where Title IN :fileNames];
        System.assertEquals(docListCheck.size(), 2);
    }


    /* ensure files on other Sobjects can be deleted as expected */
    @isTest
    public static void testThatAccountFileDeleted() {
        Account a = [SELECT Id FROM Account WHERE Name = 'CaseServiceTest'];
        ContentDocument doc = [SELECT Id FROM ContentDocument WHERE Title = 'Account File 1'];

        Boolean caughtError = false;
        Test.startTest();
        try {
            delete doc;
        } catch (DmlException e) {
            if (e.getMessage().contains('This file is part of'))
                caughtError = true;
        }
        Test.stopTest();
        System.assertEquals(caughtError, false);

        List<ContentDocument> docCheck = [select Id FROM ContentDocument WHERE Title = 'Account File 1'];
        System.assertEquals(docCheck.size(), 0);

    }

    @isTest
    public static void testBulkDeleteAccountFilesAllowed() {
        List<String> fileNames = new List<String>();
        for (Integer i = 1; i <= 3; i++) {
            fileNames.add('Account File ' + i);
        }

        List<ContentDocument> docList = [select Id from ContentDocument where Title IN :fileNames];

        Boolean caughtError = false;
        Test.startTest();
        try {
            delete docList;
        } catch (DmlException e) {
            if (e.getMessage().contains('This file is part of'))
                caughtError = true;
        }
        Test.stopTest();

        System.assertEquals(caughtError, false);

        List<ContentDocument> docListCheck = [select Id from ContentDocument where Title IN :fileNames];
        System.assertEquals(docListCheck.size(), 0);
    }


    @isTest static void testThatPlantCannotUploadFile() {
        Case c = [SELECT Id FROM Case WHERE Subject = 'CaseServiceTest1'];

        User u = TestFactory.createUser('Unit','Tests','plants@iko.com','plants@iko.com','Iko Plants',
                'Plant','ttuser','GMT','en_US','UTF-8','en_US','United States',null,true);

        Test.startTest();
        Boolean caughtError = false;

        System.runAs(u) {
            ContentVersion fredDoc = new ContentVersion();
            fredDoc.Title = 'Plant File';
            fredDoc.PathOnClient = 'Plant.jpg';
            fredDoc.VersionData = Blob.valueOf('Lorem Ipsum');
            fredDoc.IsMajorVersion = true;
            fredDoc.FirstPublishLocationId = c.Id;
            try {
                insert fredDoc;
            } catch (DmlException e) {
                if (e.getMessage().contains('You are not allowed to upload Files'))
                    caughtError = true;
            }
        }
        Test.stopTest();
        System.assert(caughtError);
    }
	
}