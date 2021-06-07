trigger PRMCommentsTrigger on PRM_Comment__c (before insert,before update) {
    
    if(System.Trigger.isUpdate && System.Trigger.isBefore){
        PRMCommentsService.populateAssigneeForPlantManagerApproval(System.Trigger.New,System.Trigger.oldMap);
   }
}