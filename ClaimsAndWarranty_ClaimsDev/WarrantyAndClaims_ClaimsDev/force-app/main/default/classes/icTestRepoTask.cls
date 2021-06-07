/******
 * 
 * Class Created by Dominic Boivin (incloud) on 2020-08-31
 * 
 */
@isTest
public with sharing class icTestRepoTask {
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
    }

    public static testMethod void test_InsertTask(){
        CreateData();
        icRepoTask.IClass RepoTask = (icRepoTask.IClass) icObjectFactory.GetSingletonInstance('icRepoTask');
        
        Test.startTest();
        testTask = RepoTask.insertTask(testTask);
        Test.stopTest();
        
        System.assert(testTask.Id != null, 'No Id Created for the task inserted' );
    }
    public static testMethod void test_InsertTasks(){
        CreateData();
        icRepoTask.IClass RepoTask = (icRepoTask.IClass) icObjectFactory.GetSingletonInstance('icRepoTask');
        
        Test.startTest();
        List<Task> taskList = new List<Task>{testTask};
        taskList = RepoTask.insertTasks(taskList);
        Test.stopTest();
        
        System.assert(taskList[0].Id != null, 'No Id Created for the task inserted' );
    }
}