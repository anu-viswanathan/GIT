/**
 * @author: Aby Varghese, Birlasoft
 * @date: Dec 2020
 * @project: Customer Service Implementation
 * @description: 
 **/
@isTest
public class CaseCustomerServiceFindContacts_Test{
    public static testMethod void fecthConMethd() {
        Account acc = new Account();
        acc.Name ='Test Data';
        insert acc;
        
        Case cs = new case();
        cs.accountId =acc.id;
        cs.status ='Open';
        cs.SuppliedEmail = 'test@testcs.com';
        insert cs;
        
        Contact objCon = new Contact();
        objCon.FirstName= 'Test';
        objCon.LastName = ' john Contact';
        objCon.AccountId = acc.Id;
        objCon.Email = cs.SuppliedEmail;
        insert objCon;
        
        CaseCustomerServiceFindSimilarContacts.fetchContactList(cs.id);
        CaseCustomerServiceFindSimilarContacts.updateContactInCase(cs.id,objCon.id);
        
    }
    public static testMethod void fecthConMethd1() {
        Account acc = new Account();
        acc.Name ='Test Data';
        insert acc;
        
        Case cs = new case();
        cs.accountId =acc.id;
        cs.status ='Open';
        //cs.SuppliedEmail = 'test@testcs.com';
        insert cs;
        
        Contact objCon = new Contact();
        objCon.FirstName= 'Test';
        objCon.LastName = ' john Contact';
        objCon.AccountId = acc.Id;
        objCon.Email = 'test@test.com';
        insert objCon;
        
        CaseCustomerServiceFindSimilarContacts.fetchContactList(cs.id);
        CaseCustomerServiceFindSimilarContacts.updateContactInCase(objCon.id,objCon.id);
        
    }
}