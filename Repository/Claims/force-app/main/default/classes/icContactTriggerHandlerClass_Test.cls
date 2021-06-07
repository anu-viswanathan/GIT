/**********************************************************************
*        Name        :        icContactTriggerHandlerClass_Test
*        Author      :        Harsh Dhondiyal
*        Date        :        15 Dec 2018
*        Description :        Test class for icContactTriggerHandlerClass_Test
***********************************************************************/
@isTest
public class icContactTriggerHandlerClass_Test{

@isTest
    private static void testMethod1(){    
    Id recTypeID = [SELECT id from RecordType where Name ='IKO ROOFPRO APPLICANTS'].Id;
    Id recTypeID1 = [SELECT id from RecordType where Name ='IKOPRO Contractor HA OK'].Id;
    Id recTypeID2 = [SELECT id from RecordType where SObjectType = 'Contact' and Name ='IKOPRO Contractor'].Id;
    
    
    
    Tier__c tr = new Tier__c();
    tr.Maximum_Squares__c=100;
    tr.Minimum_Squares__c=10;
    tr.Tier_Label__c='3';
    tr.Tier_Evaluation_Date__c=system.Today();
    insert tr;
    
    Account acc1= new account();
    acc1.name='Harsh12456'; 
    acc1.RecordTypeId = recTypeID;
    acc1.BillingCity='Toronto';
    acc1.BillingStreet='test';
    acc1.BillingCountryCode='CA';
    acc1.BillingPostalCode='A1B2C3';
    acc1.Present_Tier_Lookup__c=tr.id; 
    insert acc1;
    
    
    Contact con1 = new Contact();
    con1.firstname='Harsh';
    con1.lastname='Dhoniyal12';
    con1.IKO_Signup_Stage__c='New'; 
    con1.email='harsh3213@gmailll.com'; 
    con1.accountid=acc1.id;
    con1.Activate_Account_Users_Applicant__c=false;
    insert con1;
      
    Account acc= new account();
    acc.name='Harsh124';
    acc.RecordTypeId = recTypeID1;
    acc.Applicant_Information__c=con1.id;  
    acc.Present_Tier_Lookup__c=tr.id; 
    acc.Business_Operating_Language_ROOFPRO__c='English';
    acc.BillingCity='Toronto';
    acc.BillingStreet='test';
    acc.BillingCountryCode='CA';
    acc.BillingPostalCode='A1B2C4';
    insert acc;    
    
       
    Contact con = new Contact();
    con.firstname='Harsh';
    con.lastname='Dhondiyal123';
    con.email='harsh321@gmailll.com';
    con.IKO_Signup_Stage__c='New';
    con.Role__c='Primary Contact';
    con.RecordTypeId = recTypeID2;
    con.accountid=acc.id;
    insert con;
    
       
    con1.IKO_Signup_Stage__c='Provision Access';
    con1.Activate_Account_Users_Applicant__c=true;
    update con1;
    
    }
}