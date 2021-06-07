/******
 * 
 * Class Created by Dominic Boivin (incloud) on 2020-08-31
 * 
 */
public with sharing class icLogicTask implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {
        Task insertTask(Task newtask);
        List<Task> insertTasks(List<Task> newtasks);
    }

    public class Impl implements IClass {
        icRepoTask.IClass repoTask = (icRepoTask.IClass) icObjectFactory.GetSingletonInstance('icRepoTask');

        public Task insertTask(Task newTask){
            return repoTask.insertTask(newTask);
        }

        public List<Task> insertTasks(List<Task> newTasks){
            return repoTask.insertTasks(newTasks);
        }
    }
}