public class PRMCommentsService {

    public static void populateAssigneeForPlantManagerApproval(List<PRM_Comment__c> newComments,Map<Id,PRM_Comment__c> mapOldComments){
        User runningUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
        
        for(PRM_Comment__c eachPRMComment : newComments){
            if(mapOldComments.get(eachPRMComment.Id).PRM_Approval_Submitter__c == NULL && eachPRMComment.PRM_Approval_Submitter__c != NULL){              
                if(eachPRMComment.PRM_Approval_Submitter__c == 'Plant Manager'){
                   eachPRMComment.Plant_Manager__c = runningUser.Id;
                }
            }
        }
    }
}