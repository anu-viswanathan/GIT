/******
 * 
 * Class Created by Dominic Boivin (incloud) on 2020-08-31
 * 
 */
  @isTest
public with sharing class icTestLogicTask {
   
        static Contact testContact; 
        static Task testTask;
    
        static void CreateData() {
            Account a = icTestHelperUtility.generateOtherAccount();
            insert (a);
            testContact = new Contact(LastName='TEST', AccountId= a.Id);
            insert(testContact);
            testTask = new Task();
            testTask.Description = 'Description';
            testTask.Priority = 'Normal';
            testTask.Status = 'Completed';
            testTask.Subject = 'Subject';
            testTask.IsReminderSet = false;
            testTask.ActivityDate = Date.today();
            testTask.TaskSubtype = 'Email';
            testTask.whoId = testContact.Id;
            testTask.OwnerId = UserInfo.getUserId();
            testTask.WhatId = testContact.AccountId;
            
            icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoTask', new icRepoTaskMock());
            icTestMockUtilities.Tracer.SetReturnValue('icRepoTaskMock', 'insertTask', new Task());
            icTestMockUtilities.Tracer.SetReturnValue('icRepoTaskMock', 'insertTasks', new List<Task>());
            }

    public static testMethod void test_insertTask(){
        CreateData();
        icLogicTask.IClass BL = (icLogicTask.IClass) icObjectFactory.GetSingletonInstance('icLogicTask');
        BL.insertTask(testTask);
    }

    public static testMethod void test_insertTasks(){
        CreateData();
        icLogicTask.IClass BL = (icLogicTask.IClass) icObjectFactory.GetSingletonInstance('icLogicTask');
        List<Task> taskList = new List<Task>{testTask};
        BL.insertTasks(taskList);
    }
}