/******
 * 
 * Class Created by Dominic Boivin (incloud) on 2020-08-31
 * 
 */
@isTest
public with sharing class icLogicTaskMock implements icLogicTask.IClass{

    public Task insertTask(Task newTask){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'insertTask');
        params.put('newTask', newTask);
        return (Task) icTestMockUtilities.Tracer.GetReturnValue(this, 'insertTask');
    }

    public List<Task> insertTasks(List<Task> newTasks){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'insertTasks');
        params.put('newTasks', newTasks);
        return (List<Task>) icTestMockUtilities.Tracer.GetReturnValue(this, 'insertTasks');
    }
}