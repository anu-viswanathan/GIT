/******
 * 
 * Class Created by Dominic Boivin (incloud) on 2020-08-31
 * 
 */
public with sharing class icRepoTask implements icIClass {
    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {
        Task insertTask(Task newtask);
        List<Task> insertTasks(List<Task> newtasks);
    }

    public class Impl implements IClass {   

        public Task insertTask(Task newTask){
            insert(newTask);
            return newTask ;
        }

        public List<Task> insertTasks(List<Task> newTasks){
            insert(newTasks);
            return (newTasks);
        }
    }
}