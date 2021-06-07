trigger IKO_LearningPlanAssignmentTrigger on redwing__Training_Plan_Assignment__c (before insert, 
                                                                                   before update, 
                                                                                   before delete, 
                                                                                   after insert,
                                                                                   after update, 
                                                                                   after delete, 
                                                                                   after undelete)
{
    system.debug('hello');
    if ( trigger.isafter && trigger.isupdate){
        IKO_LearningPlanAssignmentTriggerHandler.updateAccounts(Trigger.New, Trigger.OldMap);    
        
    }
}