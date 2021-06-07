public class IKO_LearningPlanAssignmentTriggerHandler {

public static void updateAccounts(List<redwing__Training_Plan_Assignment__c> TriggerNew,Map<Id,redwing__Training_Plan_Assignment__c> TriggerOldMap)
{
    //SOQL Query to retrieve all old values on the training plan assignment record
	  Map<ID, redwing__Training_Plan_Assignment__c> TPAssignmentMap = new Map<ID,redwing__Training_Plan_Assignment__c>
		  ([SELECT ID, redwing__contact__r.accountId, redwing__Training_Plan__r.Name, redwing__contact__r.account.No_of_Electives_Completed__c,redwing__Contact__r.account.Names_of_Elective_Courses__c,redwing__Contact__r.Account.Tier_Number__c, redwing__User__r.Profile.Name  FROM redwing__Training_Plan_Assignment__c where 
			ID IN :TriggerOldMap.keySet()]);
	  system.debug('>>TPAssignmentMap >>> ' + TPAssignmentMap.values());
	  
	  // SOQL query to retreive the Tier Number and associated elective count by tier from metadata	  
	  Map<string, IKO_Elective_Count_by_Tier__mdt> mapElectiveCountbyTier = New Map<string, IKO_Elective_Count_by_Tier__mdt>();
	  
	  For (IKO_Elective_Count_by_Tier__mdt record: [SELECT Completed_Elective_Count__c,Tier_Number__c 
													FROM IKO_Elective_Count_by_Tier__mdt])
	  {
		  mapElectiveCountbyTier.put(string.valueof(record.Tier_Number__c), record);
	  }
	  system.debug('electiveCountbyTier ' +mapelectiveCountbyTier);                                     
	  
	  string tierNumber;
	  decimal electiveCount;
	  ID accountId;
	  string courseName;
	  string profileName;
	  string nameElectiveCourses;
	  
    
	  Map<Id,Account> acctToUpdateMap = new Map<Id,Account>();
	  
	  for (redwing__Training_Plan_Assignment__c learningplan: TriggerNew){      
		  
		  /* in the below lines we are fetching the profile associated with the user of the learning plan assignment and 
if the profile name contains IKOPRO Contractor in the value then getting the values for all variables
*/                  
		  
		  Account acctToUpdate = new Account();          
		  redwing__Training_Plan_Assignment__c tpAssign = TPAssignmentMap.get(learningplan.Id);
          
		  if (tpAssign != Null){
			  profileName = TPAssignmentMap.get(learningplan.Id).redwing__User__r.Profile.Name; 
			  
			  if( profileName != Null && profileName.contains('IKOPRO Contractor')){
				  accountId =tpAssign.redwing__contact__r.accountId;
				  nameElectiveCourses = tpAssign.redwing__contact__r.account.Names_of_Elective_Courses__c;
				  courseName = tpAssign.redwing__Training_Plan__r.Name;
				  electiveCount = tpAssign.redwing__contact__r.account.No_of_Electives_Completed__c;
				  tierNumber = tpAssign.redwing__contact__r.account.Tier_Number__c;
				  
			  } 
			  else {
				  return;
			  }
		  }               
		  
		  IKO_Elective_Count_by_Tier__mdt electiveCountbyTier = mapElectiveCountbyTier.get(tiernumber);
		  system.debug('electiveCountbyTier ' +electiveCountbyTier);
          
		  
		  redwing__Training_Plan_Assignment__c oldlearningplan = TriggerOldMap.get(learningplan.ID);        
		  //      system.debug (6 +nameElectiveCourses);
		  
          if (electiveCountbyTier != Null){ 
		  
		  if (electiveCount == null){
			  electiveCount = 0;
		  }
		  system.debug (5 + ' ' +electiveCount);
		  
		  if (nameElectiveCourses == null)
		  {
			  nameElectiveCourses = '';
		  }
		  system.debug(7 + ' ' +nameElectiveCourses.contains(courseName) );  
		  
		  if( learningplan.redwing__Status__c != oldlearningplan.redwing__Status__c && 
			 !nameElectiveCourses.containsignorecase(courseName) && !courseName.containsignorecase('Fundamentals')  && 
			 !courseName.containsignorecase('Les Bases') && learningplan.redwing__Status__c == 'Completed' 
			 && electiveCount < electiveCountbyTier.Completed_Elective_Count__c && profileName.contains('Contractor') && electiveCountbyTier != null){
				 system.debug('electiveCount ' +electiveCount); 
				 system.debug('namelectivecourses ' +nameElectiveCourses);
				 
				 acctToUpdate.Id = accountId;
				 acctToUpdate.No_of_Electives_Completed__c = electiveCount+ 1.0;
				 system.debug('2 ' +courseName);  
				 
				 acctToUpdate.Names_of_Elective_Courses__c = nameElectiveCourses != '' ? nameElectiveCourses + ' , ' + courseName : courseName;      
				 system.debug(3); 
				 
				 acctToUpdateMap.put(accountId,acctToUpdate);
				 system.debug('5 ' +acctToUpdateMap);
			 }
          }
          else {
              return;
          }
	  }
	  update acctToUpdateMap.values();
	  system.debug(acctToUpdateMap);
  }    
}