public with sharing class LearningTracAssignmentService {

    private static final Date electivesDueDate = Datetime.now().addDays(180).date();

    public static final String STATUS_ACTIVE            = 'Active';
    public static final String COMMUNITY_NAME           = 'IKOROOFPRO';
    public static final String CONTRACTOR_NAME          = 'IKOPRO Contractor';
    public static final String CONTRACTOR_ADMIN_NAME    = 'IKOPRO Contractor Admin';
    public static final String ELECTIVES_PLAN_NAME      = 'Electives';

    public static final Map<String,String> TIER_NAMES = new Map<String,String>{
        'ROOFPRO Preferred'         => '1',
        'ROOFPRO Select'            => '2',
        'ROOFPRO Craftsman Premier' => '3'
    };

    public static final List<String> LEARNING_TRAC_NAMES = new List<String>{
        'Learning Trac - Tier 1',
        'Learning Trac - Tier 2-CA',
        'Learning Trac - Tier 2-ST',
        'Learning Trac - Tier 3-CA',
        'Learning Trac - Tier 3-ST'
    };
    public static final Map<String, Integer> LEARNING_PLAN_DATES = new Map<String, Integer>{
        'Installation Fundamentals'         => 90,
        'Safety Fundamentals'               => 90,
        'Business Fundamentals'             => 180,
        'Performance Selling Fundamentals'  => 180,
        'LES BASES DE L’INSTALLATION'       => 90,
        'LES BASES DE LA SÉCURITÉ'          => 90,
        'LES BASES DES AFFAIRES'            => 180,
        'LES BASES DE LA VENTE EFFICACE'    => 180
    };

    public static List<List<String>> batchOrderConfig = new List<List<String>>{
        new List<String>{TIER_NAMES.values()[0], CONTRACTOR_NAME},
        new List<String>{TIER_NAMES.values()[0], CONTRACTOR_ADMIN_NAME},
        new List<String>{TIER_NAMES.values()[1], CONTRACTOR_NAME},
        new List<String>{TIER_NAMES.values()[1], CONTRACTOR_ADMIN_NAME},
        new List<String>{TIER_NAMES.values()[2], CONTRACTOR_NAME},
        new List<String>{TIER_NAMES.values()[2], CONTRACTOR_ADMIN_NAME}
    };

    public static Id communityId {
        get {
            if (communityId == null) {
                initCommunityId();
            }
            return communityId;
        }
        private set;
    }
    private static Map<String, Id> tracIdByName {
        get {
            if (tracIdByName == null) {
                initTracIdByName();
            }
            return tracIdByName;
        }
        set;
    }
    private static Map<String, Map<String, Set<String>>> configMap {
        get {
            if (configMap == null) {
                initConfigMap();
            }
            return configMap;
        }
        set;
    }

    // Form config map
    // {'Tier names on Account' => {'Community user type names' => {'Learning tracs to assign names'}}}
    private static void initConfigMap() {
        configMap = new Map<String, Map<String, Set<String>>>{
            TIER_NAMES.values()[0] => new Map<String, Set<String>>{
                CONTRACTOR_NAME => new Set<String>{
                    LEARNING_TRAC_NAMES[0]
                },
                CONTRACTOR_ADMIN_NAME => new Set<String>{
                    LEARNING_TRAC_NAMES[0]
                }
            },
            TIER_NAMES.values()[1] => new Map<String, Set<String>>{
                CONTRACTOR_ADMIN_NAME => new Set<String>{
                    LEARNING_TRAC_NAMES[1]
                },
                CONTRACTOR_NAME => new Set<String>{
                    LEARNING_TRAC_NAMES[2]
                }
            },
            TIER_NAMES.values()[2] => new Map<String, Set<String>>{
                CONTRACTOR_ADMIN_NAME => new Set<String>{
                    LEARNING_TRAC_NAMES[3]
                },
                CONTRACTOR_NAME => new Set<String>{
                    LEARNING_TRAC_NAMES[4]
                }
            }
        };
    }

    // Init community to use by its name
    private static void initCommunityId() {
        List<Network> communityIds = [SELECT Id FROM Network WHERE Name = :COMMUNITY_NAME];

        if (communityIds.size() == 1) {
            communityId = communityIds[0].Id;
        } else {
            System.debug('Couldn\'t init community id');
        }
    }

    // Get track ids by names
    private static void initTracIdByName() {
        List<redwing__Training_Track__c> trainingTracks = [
            SELECT Id, Name
            FROM redwing__Training_Track__c
            WHERE redwing__Status__c = 'Active'
            AND Name IN :LEARNING_TRAC_NAMES
        ];
        tracIdByName = new Map<String, Id>();
        for (redwing__Training_Track__c trainingTrack : trainingTracks) {
            tracIdByName.put(trainingTrack.Name, trainingTrack.Id);
        }
    }

    // Get learning trac names from config name
    private static Set<String> getLearningTracNames(String tierName, String userProfileName) {
        Map<String, Set<String>> contractorLearningTracs = configMap.get(tierName);

        if (contractorLearningTracs == null) {
            return new Set<String>();
        }

        Set<String> learningTracNames = contractorLearningTracs.get(userProfileName);

        if (learningTracNames == null) {
            return new Set<String>();
        }

        return learningTracNames;
    }

    private static  Map<Id,redwing__Training_Track__c> languageTrackMapping {
        get {
            if (languageTrackMapping == null) {
                languageTrackMapping = redwing.LMS_API.getLanguageTrackMapping(new Set<Id>(tracIdByName.values()));
            }
            return languageTrackMapping;
        }
        set;
    }

    public static void updateUserTrackAssignments(List<User> users) {
        // Init structure containing {'Track Name' => {'User ids, for which this track should be assigned to'}}
        Map<String, Set<Id>> usersForAssigmentByTracId = new Map<String, Set<Id>>();
        for (String tracName : LEARNING_TRAC_NAMES) {
            if (tracIdByName.get(tracName) != null) {
                usersForAssigmentByTracId.put(tracIdByName.get(tracName), new Set<Id>());
            }
        }
        // Iterate batch
        for (User user : users) {
            String tierName = user.Contact.Account.Present_Tier_Lookup__r.Tier_Label__c;
            String userProfileName = user.Profile.Name;
            Set<String> learningTracNames = getLearningTracNames(tierName, userProfileName);
            for (String learningTracName : learningTracNames) {
                Set<Id> usersForAssigment = usersForAssigmentByTracId.get(tracIdByName.get(learningTracName));
                if (usersForAssigment == null) {
                    System.debug('No track "' + learningTracName + '" found.');
                    continue;
                }
                usersForAssigment.add(user.Id);
            }
        }
        Set<Id> usersToBeProcessed = new Map<Id, User>(users).keySet();

        List<redwing__Training_Plan__c> electivePlan = [SELECT Id FROM redwing__Training_Plan__c WHERE Name =: ELECTIVES_PLAN_NAME LIMIT 1];
        if (!electivePlan.isEmpty()) {
            redwing.LMS_API.upsertPlanAssignments(usersToBeProcessed, electivePlan[0].Id, null, electivesDueDate);
        }
        List<redwing__Training_Track_Assignment__c> existingTrainingTrackAssignments = getTrainingTrackAssignments(usersToBeProcessed, LEARNING_TRAC_NAMES);
        Map<Id, List<redwing__Training_Plan_Assignment__c>> trainingPlanAssignmentsByUserIdMap = getTrainingPlanAssignmentsByUserIdMap(usersToBeProcessed, LEARNING_TRAC_NAMES);
        Map<String, Set<String>> planIdsByTrackId = getTrainingPlanIdsByTrainingTracIdMap(LEARNING_TRAC_NAMES);

        List<redwing__Training_Track_Assignment__c> trainingTrackAssignmentsToArchive = new List<redwing__Training_Track_Assignment__c>();
        List<redwing__Training_Plan_Assignment__c> trainingPlanAssignmentsToArchive = new List<redwing__Training_Plan_Assignment__c>();

        for (redwing__Training_Track_Assignment__c trainingTrackAssignment : existingTrainingTrackAssignments) {
            Set<Id> usersForAssigment;
            if (trainingTrackAssignment.redwing__Training_Track__r.redwing__Default_Language_Learning_Trac__c != null) {
                usersForAssigment = usersForAssigmentByTracId.get(trainingTrackAssignment.redwing__Training_Track__r.redwing__Default_Language_Learning_Trac__c);
            } else {
                usersForAssigment = usersForAssigmentByTracId.get(trainingTrackAssignment.redwing__Training_Track__c);
            }
            
            if (usersForAssigment.contains(trainingTrackAssignment.redwing__User__c)) {
                Integer userPriorTier = Integer.valueOf(TIER_NAMES.get(trainingTrackAssignment.redwing__User__r.Contact.Account.Prior_Tier__c) == null ? '0' : TIER_NAMES.get(trainingTrackAssignment.redwing__User__r.Contact.Account.Prior_Tier__c));
                Integer userPresentTier = Integer.valueOf(trainingTrackAssignment.redwing__User__r.Contact.Account.Present_Tier_Lookup__r.Tier_Label__c);

                //Archive the trac assignment in case of the Tier movement
                trainingTrackAssignmentsToArchive.add(trainingTrackAssignment);

                // If this trac assignment is from lower Tier - leave Plan assignments as it is
                if (userPriorTier < userPresentTier) {
                    continue;
                }

                //In other cases - add current plan assignments to the remove list
                if (trainingPlanAssignmentsByUserIdMap.get(trainingTrackAssignment.redwing__User__c) != null) {
                    List<redwing__Training_Plan_Assignment__c> userPlanAssignments = trainingPlanAssignmentsByUserIdMap.get(trainingTrackAssignment.redwing__User__c);
                    Set<String> planIds = planIdsByTrackId.get(trainingTrackAssignment.redwing__Training_Track__c);
                    for (redwing__Training_Plan_Assignment__c userPlanAssignment : userPlanAssignments) {
                        if (planIds.contains(userPlanAssignment.redwing__Training_Plan__c)) {
                            trainingPlanAssignmentsToArchive.add(userPlanAssignment);
                        }
                    }
                }
            }
        }

        if (trainingTrackAssignmentsToArchive.size() > 0) {
            archiveAssignments(trainingTrackAssignmentsToArchive);
        }
        if (trainingPlanAssignmentsToArchive.size() > 0) {
            archiveAssignments(trainingPlanAssignmentsToArchive);
        }

        unarchiveAssignments(usersForAssigmentByTracId);

        Set<Id> userIdToUpdatePlanAssignments = new Set<Id>();
        for (String trackId : usersForAssigmentByTracId.keySet()) {
            Set<Id> userIds = usersForAssigmentByTracId.get(trackId);
            if (!userIds.isEmpty()) {
                redwing.LMS_API.upsertTrackAssignments(userIds, trackId, null);
            }
            userIdToUpdatePlanAssignments.addAll(userIds);
        }
        
        validateAndDeleteAchievementAssignmentAndTrainingAssignment(users);  
        
        List<redwing__Training_Plan_Assignment__c> trainingPlanAssignments = getTrainingPlanAssignments(userIdToUpdatePlanAssignments, LEARNING_TRAC_NAMES);
        Map<String,Account> applicantInformation = getApplicantInformation(trainingPlanAssignments);
        for (redwing__Training_Plan_Assignment__c trainingPlanAssignment : trainingPlanAssignments) {
            trainingPlanAssignment.redwing__Due_Date__c = getAppropriateDate(
                trainingPlanAssignment.redwing__Training_Plan__r.Name,
                applicantInformation.get(trainingPlanAssignment.redwing__User__c)
            );
        }
        update trainingPlanAssignments;
    }
    
    private static void validateAndDeleteAchievementAssignmentAndTrainingAssignment(List<User> users) {
        List<User> frenchUsers = getFrenchUsers(users);
   
		validateAndDeleteAchievementAssignment(frenchUsers); 
        validateAndDeleteTrainingAssignment(frenchUsers);
        //validateAndAddBadgesToFrenchUsers(frenchUsers); 
    }
    
    /*public static void validateAndAddBadgesToFrenchUsers(List<User> frenchUsers) {
        Map<Contact, List<Id>> trainingPlanIdsByContact = new Map<Contact, List<Id>>(); 
        Set<Id> allTrainingPlanIds = new Set<Id>();
        
        for (Contact con : getContactsByUserIds(frenchUsers)) { 
            List<Id> trainingPlanIds = new List<Id>();
            for (redwing__Training_Plan_Assignment__c trainingPlanAssignment : con.redwing__Training_Plan_Assignments__r) {
                trainingPlanIds.add(trainingPlanAssignment.redwing__Training_Plan__c);
            }
            trainingPlanIdsByContact.put(con, trainingPlanIds); 
            allTrainingPlanIds.addAll(trainingPlanIds); 
        }
        
		Map<Id, List<redwing__Training_Plan_Achievement__c>> trainingPlanAchievementsByTrainingPlanIds = getTrainingPlanAchievementsByTrainingPlanIds(allTrainingPlanIds); 
        
        List<redwing__Achievement_Assignment__c> toCreateAssignment = new List<redwing__Achievement_Assignment__c>();
        
        for (Contact con :trainingPlanIdsByContact.keySet()) {
            for (Id traininigPlanId : trainingPlanIdsByContact.get(con)) {
                if (trainingPlanAchievementsByTrainingPlanIds.containsKey(traininigPlanId)) {
                    for (redwing__Training_Plan_Achievement__c trainingPlanAchievement : trainingPlanAchievementsByTrainingPlanIds.get(traininigPlanId)) {
                       
                        toCreateAssignment.add(new redwing__Achievement_Assignment__c(
                            redwing__Achievement__c = trainingPlanAchievement.redwing__Achievement__c,
                            redwing__User__c = con.Salesforce_User__c,
                            redwing__Contact__c = con.Id,
                            redwing__Training_Plan_Achievement__c = trainingPlanAchievement.Id,
                            redwing__Status__c = 'Eligible'
                        ));
                        
                    }
                }
            }
        }
        
        
        
        System.debug('size ' + toCreateAssignment.size()); 
        for (redwing__Achievement_Assignment__c ac : toCreateAssignment) {
            System.debug('toCreateAssignment ' + ac); 
        }
    }
    
    
    private static Map<Id, List<redwing__Training_Plan_Achievement__c>> getTrainingPlanAchievementsByTrainingPlanIds(Set<Id> allTrainingPlanIds) {
        List<redwing__Training_Plan__c> trainingPlans = [
            SELECT Id,
            	(	
                    SELECT Id, redwing__Achievement__c
             		FROM redwing__Training_Plan_Achievements__r
            	)
            FROM redwing__Training_Plan__c
            WHERE Id IN : allTrainingPlanIds
        ];
        
        Map<Id, List<redwing__Training_Plan_Achievement__c>> trainingPlanAchievementsByTrainingPlanIds = new Map<Id, List<redwing__Training_Plan_Achievement__c>>(); 
        
        for (redwing__Training_Plan__c trainingPlan : trainingPlans) {
            trainingPlanAchievementsByTrainingPlanIds.put(trainingPlan.Id, trainingPlan.redwing__Training_Plan_Achievements__r);
        }
        
        return trainingPlanAchievementsByTrainingPlanIds; 
    }
    
    private static List<Contact> getContactsByUserIds(List<User> frenchUsers) {
        Set<Id> ids = new Map<Id, User>(frenchUsers).keySet(); 

        return [
            SELECT Id, Name, Salesforce_User__c,
            	(
                    SELECT Id, Name, redwing__Training_Plan__c
             		FROM redwing__Training_Plan_Assignments__r
                )
            FROM Contact
            WHERE Salesforce_User__c IN : ids
        ];
    }*/
    
    private static List<User> getFrenchUsers(List<User> users) {
        List<User> frenchUsers = new List<User>(); 
        for (User us : users) {
            if (us.LanguageLocaleKey == 'fr') {
                frenchUsers.add(us);
            }
        }
        return frenchUsers; 
    }

    private static void validateAndDeleteAchievementAssignment(List<User> frenchUsers) {
        List<redwing__Achievement_Assignment__c> toDeleteAssignment = new List<redwing__Achievement_Assignment__c>();
        for (redwing__Achievement_Assignment__c ac : getAchievementAssignment(frenchUsers)) {
            if (ac.redwing__Training_Plan_Achievement__r.redwing__Training_Plan__r.redwing__Language__c != 'fr') {
                toDeleteAssignment.add(ac);
            }
        }
        delete toDeleteAssignment;  
    }
    
    private static void validateAndDeleteTrainingAssignment(List<User> frenchUsers) {
        List<redwing__Training_Plan_Assignment__c> toDeleteAssignment = new List<redwing__Training_Plan_Assignment__c>();
        for (redwing__Training_Plan_Assignment__c tr : getTrainingPlanAssignment(frenchUsers)) {
            if (tr.redwing__Training_Plan__r.redwing__Language__c != 'fr') {
                toDeleteAssignment.add(tr);
            }
        }
        delete toDeleteAssignment;  
    }
    
    private static List<redwing__Achievement_Assignment__c> getAchievementAssignment(List<User> frenchUsers) {
        return [
            SELECT Id, redwing__Training_Plan_Achievement__r.redwing__Training_Plan__r.redwing__Language__c
            FROM redwing__Achievement_Assignment__c
            WHERE redwing__User__c IN :frenchUsers
        ];
    }
    
    private static List<redwing__Training_Plan_Assignment__c> getTrainingPlanAssignment(List<User> frenchUsers) {
        return [
            SELECT Id, 
            redwing__Training_Plan__r.redwing__Language__c
            FROM redwing__Training_Plan_Assignment__c
            WHERE redwing__User__c IN :frenchUsers
        ];
    }
     
    private static Map<String,Account> getApplicantInformation(List<redwing__Training_Plan_Assignment__c> trainingPlanAssignments) {
        Map<String,Account> result = new Map<String,Account>();
        Map<String,String> accountIdByUser = new Map<String,String>();
        
        for (redwing__Training_Plan_Assignment__c assignment : trainingPlanAssignments)
            accountIdByUser.put(assignment.redwing__User__c, assignment.redwing__User__r.Contact.AccountId);
        
        Map<String, Account> accounts = new Map<String,Account>([
            SELECT Applicant_Information__r.Status_Match_Applicant__c,
            	Applicant_Information__r.Membership_Start_Date_Applicant__c
            FROM Account WHERE Id IN :accountIdByUser.values()
        ]);
        
        for (String userId : accountIdByUser.keySet())
            result.put(userId, accounts.get(accountIdByUser.get(userId)));
        
        return result;
    }

    private static Date getAppropriateDate(String planName, Account applicantInformation) {
        Boolean isStatusMatch = applicantInformation.Applicant_Information__r.Status_Match_Applicant__c;
        Date membershipStart = applicantInformation.Applicant_Information__r.Membership_Start_Date_Applicant__c;
        Set<String> tier2plans = new Set<String>{'Business Fundamentals', 'LES BASES DES AFFAIRES', 'Performance Selling Fundamentals', 'LES BASES DE LA VENTE EFFICACE'};
        Date result = membershipStart != null ? membershipStart : Date.today();
        if (isStatusMatch && tier2plans.contains(planName)) {
            result = result.addYears(3);
        }
        
        result = result.addDays(LEARNING_PLAN_DATES.get(planName));
        return result;
    }

    public static void unarchiveAssignments(Map<String, Set<Id>> usersForAssigmentByTracId) {

        Set<String> tracToSearch = new Set<String>();
        Set<Id> usersToSearch = new Set<Id>();

        for (String trackId : usersForAssigmentByTracId.keySet()) {
            Set<Id> userIds = usersForAssigmentByTracId.get(trackId);
            if (!userIds.isEmpty()) {
                tracToSearch.add(trackId);
                usersToSearch.addAll(userIds);
            }
        }

        List<redwing__Training_Track_Assignment__c> archivedTracksAssignments =  [
            SELECT Archived_User__c, redwing__User__c
            FROM redwing__Training_Track_Assignment__c
            WHERE Archived_User__c IN :usersToSearch
            AND (
                redwing__Training_Track__c IN :tracToSearch
             OR redwing__Training_Track__r.redwing__Default_Language_Learning_Trac__c IN :tracToSearch
            )
        ];
        
        List<redwing__Training_Plan_Assignment__c> archivedPlansAssignments = [
            SELECT Id, Archived_User__c, redwing__User__c
            FROM redwing__Training_Plan_Assignment__c
            WHERE Archived_User__c IN :usersToSearch
            AND redwing__Training_Plan__c IN (
                SELECT redwing__Training_Plan__c
                FROM redwing__Training_Track_Level_Item__c
                WHERE redwing__Training_Track_Level__r.redwing__Training_Track__c IN :tracToSearch
             OR redwing__Training_Track_Level__r.redwing__Training_Track__r.redwing__Default_Language_Learning_Trac__c IN :tracToSearch
            )
        ];

        for (redwing__Training_Track_Assignment__c trackAssignment : archivedTracksAssignments) {
            trackAssignment.redwing__User__c = trackAssignment.Archived_User__c;
            trackAssignment.Archived_User__c = null;
        }

        if (!archivedTracksAssignments.isEmpty()) {
            update archivedTracksAssignments;
        }

        for (redwing__Training_Plan_Assignment__c planAssignment : archivedPlansAssignments) {
            planAssignment.redwing__User__c = planAssignment.Archived_User__c;
            planAssignment.Archived_User__c = null;
        }

        if (!archivedPlansAssignments.isEmpty()) {
            update archivedPlansAssignments;
        }
    }

    //SELECTOR PART
    public static Map<Id, List<redwing__Training_Plan_Assignment__c>> getTrainingPlanAssignmentsByUserIdMap(Set<Id> userIds, List<String> trainingTrackNames) {
        Map<Id, List<redwing__Training_Plan_Assignment__c>> trainingPlanAssignmentsByUserIdsMap = new Map<Id, List<redwing__Training_Plan_Assignment__c>>();
        List<redwing__Training_Plan_Assignment__c> trainingPlanAssignments = getTrainingPlanAssignments(userIds, trainingTrackNames);
        for (redwing__Training_Plan_Assignment__c trainingPlanAssignment : trainingPlanAssignments) {
            if (trainingPlanAssignmentsByUserIdsMap.get(trainingPlanAssignment.redwing__User__c) == null) {
                trainingPlanAssignmentsByUserIdsMap.put(trainingPlanAssignment.redwing__User__c, new List<redwing__Training_Plan_Assignment__c>());
            }
            List<redwing__Training_Plan_Assignment__c> userTrainingPlanAssignments = trainingPlanAssignmentsByUserIdsMap.get(trainingPlanAssignment.redwing__User__c);
            userTrainingPlanAssignments.add(trainingPlanAssignment);
        }
        return trainingPlanAssignmentsByUserIdsMap;
    }

    public static Map<String, Set<String>> getTrainingPlanIdsByTrainingTracIdMap(List<String> trainingTrackNames) {

        Set<Id> tracToSearch = getAllLanguageTracIds(trainingTrackNames);

        List<redwing__Training_Track_Level_Item__c> trainingTrackLevelItems = [
            SELECT redwing__Training_Plan__r.Id,
                redwing__Training_Plan__c,
                redwing__Training_Track_Level__r.redwing__Training_Track__c
            FROM redwing__Training_Track_Level_Item__c
            WHERE redwing__Training_Track_Level__r.redwing__Training_Track__c IN :tracToSearch
        ];

        Map<String, Set<String>> trainingPlanIdsByTrainingId = new Map<String, Set<String>>();
        for (redwing__Training_Track_Level_Item__c item : trainingTrackLevelItems) {
            String trainingTrackId = item.redwing__Training_Track_Level__r.redwing__Training_Track__c;
            if (trainingPlanIdsByTrainingId.get(trainingTrackId) == null) {
                trainingPlanIdsByTrainingId.put(trainingTrackId, new Set<String>());
            }
            Set<String> trainingPlanIds = trainingPlanIdsByTrainingId.get(trainingTrackId);
            trainingPlanIds.add(item.redwing__Training_Plan__c);
        }
        return trainingPlanIdsByTrainingId;
    }

    public static List<redwing__Training_Plan_Assignment__c> getTrainingPlanAssignments(Set<Id> userIds, List<String> trainingTrackNames) {

        Set<Id> tracToSearch = getAllLanguageTracIds(trainingTrackNames);

        return [
            SELECT Id, Archived_User__c,
                redwing__User__c,
                redwing__User__r.Contact.AccountId,
                redwing__Due_Date__c,
                redwing__Training_Plan__r.Name
            FROM redwing__Training_Plan_Assignment__c
            WHERE redwing__User__c IN :userIds
            AND redwing__Training_Plan__c IN (
                SELECT redwing__Training_Plan__c
                FROM redwing__Training_Track_Level_Item__c
                WHERE redwing__Training_Track_Level__r.redwing__Training_Track__c IN :tracToSearch
            )
        ];
    }

    public static List<redwing__Training_Track_Assignment__c> getTrainingTrackAssignments(Set<Id> userIds, List<String> trainingTrackNames) {

        Set<Id> tracToSearch = getAllLanguageTracIds(trainingTrackNames);

        return [
            SELECT Id, Archived_User__c,
                redwing__User__c,
                redwing__Training_Track__r.Name,
                redwing__Training_Track__r.redwing__Default_Language_Learning_Trac__c,
                redwing__User__r.Contact.Account.Prior_Tier__c,
                redwing__User__r.Contact.Account.Present_Tier_Lookup__r.Tier_Label__c
            FROM redwing__Training_Track_Assignment__c
            WHERE redwing__Training_Track__c IN :tracToSearch
            AND redwing__User__c IN :userIds
        ];
    }

    public static Set<Id> getAllLanguageTracIds(List<String> trainingTrackNames) {
        Set<Id> tracIds = new Set<Id>();

        for (String tracName : trainingTrackNames) {
            tracIds.add(tracIdByName.get(tracName));
        }

        Set<Id> tracToSearch = new Set<Id>();

        for (Id tracId : languageTrackMapping.keySet()) {
            redwing__Training_Track__c trac = languageTrackMapping.get(tracId);
            if (tracIds.contains(trac.Id) || tracIds.contains(trac.redwing__Default_Language_Learning_Trac__c)) {
                tracToSearch.add(trac.Id);
            }
            
        }

        return tracToSearch;
    }

    private static void archiveAssignments(List<redwing__Training_Track_Assignment__c> learningTrackAssignments) {
        for (redwing__Training_Track_Assignment__c trackAssignment : learningTrackAssignments) {
            if (trackAssignment.redwing__User__c != null) {
                trackAssignment.Archived_User__c = trackAssignment.redwing__User__c;
                trackAssignment.redwing__User__c = null;
            }
        }
        update learningTrackAssignments;
    }
    private static void archiveAssignments(List<redwing__Training_Plan_Assignment__c> trainingPlanAssignments) { 
        for (redwing__Training_Plan_Assignment__c planAssignment : trainingPlanAssignments) {
            if (planAssignment.redwing__User__c != null) {
                planAssignment.Archived_User__c = planAssignment.redwing__User__c;
                planAssignment.redwing__User__c = null;
            }
        } 
        update trainingPlanAssignments;
    }
}