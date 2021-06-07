/**
 * @author: Aby Varghese, Birlasoft
 * @date: Dec 2020
 * @project: Customer Service Implementation
 * @description: 
 **/
@isTest
public class CaseCustomerServiceSearchAccount_Test{
    public static testMethod void retriveAccsMethd() {
        Account acc = new Account();
        acc.Name ='Test Data';
        insert acc;
        
        Case cs = new case();
        cs.accountId =acc.id;
        cs.status ='Open';
        insert cs;
        
        CaseCustomerServiceSearchAccount.retriveAccs('Test');
        CaseCustomerServiceSearchAccount.updateCase(cs.id,acc.id);
        
    }
    public static testMethod void retriveAccsMethdCatch() {
        Account acc = new Account();
        acc.Name ='Test Data';
        insert acc;
        
        Case cs = new case();
        cs.accountId =acc.id;
        cs.status ='Open';
        insert cs;
        
        CaseCustomerServiceSearchAccount.retriveAccs('KT');
        CaseCustomerServiceSearchAccount.updateCase(cs.id,acc.id);
        
    }
}