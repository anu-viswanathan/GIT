@isTest
public class PRMCommentServiceTest {
private static void createUsers(){

        List<User> toInsertUsers = new List<User>();

            toInsertUsers.add(TestFactory.createUser('Unit','Tests','plantMgr@iko.com','plantMgr@iko.com','Plant Manager',
                    'Plant','plant','GMT','en_US','UTF-8','en_US',null,null,false));        

        insert toInsertUsers;

    }
    
    @testSetup static void setupTestData(){
        Id baRt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Building Location').getRecordTypeId();
        Id ccRt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Claim').getRecordTypeId();
        
        List<Account> a = TestFactory.createAccounts(baRt,'CaseServiceTest','9 King St E','Toronto','ON','CA','M4S 2H4','Verified',UserInfo.getUserId(),TRUE,TRUE,1,true);
        List<Contact> con = TestFactory.createContacts(a[0].Id,'CaseServiceTest',UserInfo.getUserId(),1,true);
        
        List<Case> cases = TestFactory.createCases(ccRt,a[0].Id,con[0].Id,'Distributor','CaseServiceTest',null,'Commercial','Draft',1,true);
        TestFactory.createClaimTypes(cases[0],1,true);
     	TestFactory.createLabSamples(cases[0],1,true);
    }
    
    @isTest
    public static void testPopulateAssigneeForPlantManagerApproval(){
       createUsers();
        User runningUser = [SELECT Id, Profile.Name FROM User WHERE UserName = 'plantMgr@iko.com'];
        Lab_Sample__c ls = [SELECT Id FROM Lab_Sample__c WHERE Case__r.Subject = 'CaseServiceTest'];  
        
        Test.startTest();
        System.runAs(runningUser){
            PRM_Comment__c prmComment = new PRM_Comment__c(Lab_Sample__c = ls.Id);
            insert prmComment;
            
            prmComment.PRM_Approval_Submitter__c = 'Plant Manager';
            update prmComment;
        }      
        Test.stopTest();
        
        PRM_Comment__c prmCommentResult = [SELECT Id,Plant_Manager__c FROM PRM_Comment__c WHERE Lab_Sample__c = :ls.Id];
        System.assertEquals(runningUser.Id, prmCommentResult.Plant_Manager__c);
        
    }
}