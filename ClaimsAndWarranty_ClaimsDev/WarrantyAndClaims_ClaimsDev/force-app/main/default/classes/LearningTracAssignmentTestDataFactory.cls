@IsTest
public class LearningTracAssignmentTestDataFactory {

    public static final String UNIQ_MARK_FOR_SOQL = 'onlyfortest1qw2';
    private static Integer UNIQ_COUNTER = 0;
    private static Integer UNIQ_COUNTER_USER = 0;

   /* public static final String COMPANY_1 = 'company 1';
    public static final String COMPANY_2 = 'company 2';
    public static final String COMPANY_3 = 'company 3';
    public static final String COMPANY_4 = 'company 4';
    public static final String COMPANY_5 = 'company 5';
    public static final String COMPANY_6 = 'company 6';*/
    
    public static final String COMPANY_1 = 'COMPANY 1';
    public static final String COMPANY_2 = 'COMPANY 2';
    public static final String COMPANY_3 = 'COMPANY 3';
    public static final String COMPANY_4 = 'COMPANY 4';
    public static final String COMPANY_5 = 'COMPANY 5';
    public static final String COMPANY_6 = 'COMPANY 6';

    public static final String STATUS_NOT_STARTED = 'Not Started';
    public static final String STATUS_IN_PROGRESS = 'In Progress';

    public static final List<List<String>> trackSet_Tier1NotStarted = new List<List<String>>{
        new List<String>{
            LearningTracAssignmentService.LEARNING_TRAC_NAMES[0], STATUS_NOT_STARTED
        }
    };
    public static final List<List<String>> trackSet_Tier2CaAndNotStarted = new List<List<String>>{
        new List<String>{
            LearningTracAssignmentService.LEARNING_TRAC_NAMES[1], STATUS_NOT_STARTED
        }
    };
    public static final List<List<String>> trackSet_Tier2StAndNotStarted = new List<List<String>>{
        new List<String>{
            LearningTracAssignmentService.LEARNING_TRAC_NAMES[2], STATUS_NOT_STARTED
        }
    };
    public static final List<List<String>> trackSet_Tier3CaAndNotStarted = new List<List<String>>{
        new List<String>{
            LearningTracAssignmentService.LEARNING_TRAC_NAMES[3], STATUS_NOT_STARTED
        }
    };
    public static final List<List<String>> trackSet_Tier3StAndNotStarted = new List<List<String>>{
        new List<String>{
            LearningTracAssignmentService.LEARNING_TRAC_NAMES[4], STATUS_NOT_STARTED
        }
    };
    public static final List<List<String>> trackSet_Tier3CaAndInProgress = new List<List<String>>{
        new List<String>{
            LearningTracAssignmentService.LEARNING_TRAC_NAMES[3], STATUS_IN_PROGRESS
        }
    };
    public static final List<List<String>> trackSet_Tier3StAndInProgress = new List<List<String>>{
        new List<String>{
            LearningTracAssignmentService.LEARNING_TRAC_NAMES[4], STATUS_IN_PROGRESS
        }
    };

    public static Map<Id, Profile> profileMap {
        get {
            if (profileMap == null) {
                initProfileFields();
            }
            return profileMap;
        }
        set;
    }
    public static Id systemAdminProfileId {
        get {
            if (systemAdminProfileId == null) {
                initProfileFields();
            }
            return systemAdminProfileId;
        }
        set;
    }
    public static Id contractorProfileId {
        get {
            if (contractorProfileId == null) {
                initProfileFields();
            }
            return contractorProfileId;
        }
        set;
    }
    public static Id contractorAdminProfileId {
        get {
            if (contractorAdminProfileId == null) {
                initProfileFields();
            }
            return contractorAdminProfileId;
        }
        set;
    }
    public static User adminUser {
        get {
            if (adminUser == null) {
                adminUser = new User(
                    ProfileId = systemAdminProfileId,
                    Username = 'itmustbeunique@onlyfortest.com',
                    Alias = 'testadm',
                    Email = 'testadmin@onlyfortest.com',
                    EmailEncodingKey = 'UTF-8',
                    Firstname = 'testadminname',
                    Lastname = 'testadminlastname',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    TimeZoneSidKey = 'America/Chicago'
                );
                insert adminUser;
            }
            return adminUser;
        }
        set;
    }
    public static User accountOwner {
        get {
            if (accountOwner == null) {
                UserRole userRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
                accountOwner = new User(
                    UserRoleId = userRole.Id,
                    ProfileId = systemAdminProfileId,
                    Username = getUniqString('accountowner@onlyfortest.test'),
                    Alias = 'altest',
                    Email = 'a@wayneenterprises.test',
                    EmailEncodingKey = 'UTF-8',
                    Firstname = 'ownerFirstNameTest',
                    Lastname = 'ownerLastNameTest',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    TimeZoneSidKey = 'America/Chicago'
                );
                insert accountOwner;
            }
            return accountOwner;
        }
        set;
    }
    public static Map<String, Id> learningTrackIdByName {
        get {
            if (learningTrackIdByName == null) {
                learningTrackIdByName = new Map<String, Id>();
                List<redwing__Training_Track__c> trainingTracks = [
                    SELECT Id, Name
                    FROM redwing__Training_Track__c
                    WHERE redwing__Status__c = :LearningTracAssignmentService.STATUS_ACTIVE
                ];
                for (redwing__Training_Track__c track : trainingTracks) {
                    learningTrackIdByName.put(track.Name, track.Id);
                }
            }
            return learningTrackIdByName;
        }
        set;
    }
    public static Map<String, Map<String, Id>> userIdByCompanyNameAndUserProfileName {
        get {
            if (userIdByCompanyNameAndUserProfileName == null) {
                userIdByCompanyNameAndUserProfileName = new Map<String, Map<String, Id>>();
                List<User> users = [
                    SELECT Id, Contact.Account.Name, Profile.Name
                    FROM User
                    WHERE Username LIKE :'%' + UNIQ_MARK_FOR_SOQL + '%'
                ];
                for (User user : users) {
                    if (userIdByCompanyNameAndUserProfileName.get(user.Contact.Account.Name) == null) {
                        userIdByCompanyNameAndUserProfileName.put(user.Contact.Account.Name, new Map<String, Id>());
                    }
                    Map<String, Id> userIdByProfileName = userIdByCompanyNameAndUserProfileName.get(user.Contact.Account.Name);
                    userIdByProfileName.put(user.Profile.Name, user.Id);
                }
            }
            return userIdByCompanyNameAndUserProfileName;
        }
        set;
    }
    public static Map<Id, List<List<String>>> actualTrackNamesAndStatusesByUserId {
        get {
            if (actualTrackNamesAndStatusesByUserId == null) {
                actualTrackNamesAndStatusesByUserId = new Map<Id, List<List<String>>>();
                List<redwing__Training_Track_Assignment__c> assignments = [
                    SELECT redwing__User__c, redwing__Training_Track__r.Name, redwing__Status__c
                    FROM redwing__Training_Track_Assignment__c
                    WHERE redwing__User__r.Username LIKE :'%' + UNIQ_MARK_FOR_SOQL + '%'
                    ORDER BY redwing__Training_Track__r.Name
                ];
                for (redwing__Training_Track_Assignment__c assignment : assignments) {
                    if (actualTrackNamesAndStatusesByUserId.get(assignment.redwing__User__c) == null) {
                        actualTrackNamesAndStatusesByUserId.put(assignment.redwing__User__c, new List<List<String>>());
                    }
                    List<List<String>> trackNamesAndStatuses = actualTrackNamesAndStatusesByUserId.get(assignment.redwing__User__c);
                    trackNamesAndStatuses.add(new List<String>{
                        assignment.redwing__Training_Track__r.Name, assignment.redwing__Status__c
                    });
                }
            }
            return actualTrackNamesAndStatusesByUserId;
        }
        set;
    }

    private static void initProfileFields() {
        List<String> profileNames = new List<String>{
            LearningTracAssignmentService.CONTRACTOR_NAME,
            LearningTracAssignmentService.CONTRACTOR_ADMIN_NAME,
            'System Administrator'
        };
        List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Name IN :profileNames];
        profileMap = new Map<Id, Profile>(profiles);
        for (Profile profile : profiles) {
            if (profile.Name.equals('System Administrator')) {
                systemAdminProfileId = profile.Id;
            } else if (profile.Name.equals(LearningTracAssignmentService.CONTRACTOR_NAME)) {
                contractorProfileId = profile.Id;
            } else if (profile.Name.equals(LearningTracAssignmentService.CONTRACTOR_ADMIN_NAME)) {
                contractorAdminProfileId = profile.Id;
            }
        }
    }

    public static void createCompanies() {

        Id ikoProContractorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(LearningTracAssignmentService.CONTRACTOR_NAME).getRecordTypeId();
        Id contractorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();

        Map<Id, List<List<String>>> userProfileIdsAndTrackSets1 = new Map<Id, List<List<String>>>{
            contractorAdminProfileId => null,
            contractorProfileId => null
        };

        Map<Id, List<List<String>>> userProfileIdsAndTrackSets2 = new Map<Id, List<List<String>>>{
            contractorAdminProfileId => trackSet_Tier3CaAndInProgress,
            contractorProfileId => trackSet_Tier3StAndInProgress
        };

        List<CommunityCompany> companies = new List<CommunityCompany>{
            new CommunityCompany(COMPANY_1, accountOwner, ikoProContractorRecordTypeId, LearningTracAssignmentService.TIER_NAMES.values()[0], userProfileIdsAndTrackSets1),
            new CommunityCompany(COMPANY_2, accountOwner, ikoProContractorRecordTypeId, LearningTracAssignmentService.TIER_NAMES.values()[1], userProfileIdsAndTrackSets1),
            new CommunityCompany(COMPANY_3, accountOwner, ikoProContractorRecordTypeId, LearningTracAssignmentService.TIER_NAMES.values()[2], userProfileIdsAndTrackSets1),
            new CommunityCompany(COMPANY_4, accountOwner, ikoProContractorRecordTypeId, LearningTracAssignmentService.TIER_NAMES.values()[2], userProfileIdsAndTrackSets2),
            new CommunityCompany(COMPANY_5, accountOwner, ikoProContractorRecordTypeId, LearningTracAssignmentService.TIER_NAMES.values()[0], userProfileIdsAndTrackSets2),
            new CommunityCompany(COMPANY_6, accountOwner, contractorRecordTypeId, null, userProfileIdsAndTrackSets1)
        };

        List<Account> accounts = new List<Account>();
        for (CommunityCompany company : companies) {
            accounts.add(company.getCompanyAccount());
        }
        insert accounts;

        List<Contact> contacts = new List<Contact>();
        for (CommunityCompany company : companies) {
            contacts.addAll(company.getCompanyContacts());
        }
        insert contacts;

        List<User> users = new List<User>();
        for (CommunityCompany company : companies) {
            users.addAll(company.getCompanyUsers());
        }
        insert users;

        List<redwing__Training_Track_Assignment__c> assignments = new List<redwing__Training_Track_Assignment__c>();
        for (CommunityCompany company : companies) {
            assignments.addAll(company.getUserTrackAssignments());
        }
        insert assignments;
    }

    public static List<redwing__Training_Track__c> createLearningTracks() {
        List<List<String>> trackNamesAndStatuses = new List<List<String>>{
            new List<String>{
                LearningTracAssignmentService.LEARNING_TRAC_NAMES[0], 'Inactive'
            }
        };
        for (String tracName : LearningTracAssignmentService.LEARNING_TRAC_NAMES) {
            trackNamesAndStatuses.add(
                new List<String>{
                    tracName, LearningTracAssignmentService.STATUS_ACTIVE
                }
            );
        }

        List<redwing__Training_Track__c> trainingTracks = new List<redwing__Training_Track__c>();
        for (List<String> trackNameAndStatus : trackNamesAndStatuses) {
            redwing__Training_Track__c trainingTrack = new redwing__Training_Track__c(
                Name = trackNameAndStatus[0],
                redwing__Status__c = trackNameAndStatus[1]
            );
            trainingTracks.add(trainingTrack);
        }
        insert trainingTracks;
        return trainingTracks;
    }

    private static String getUniqString(String value) {
        return value + System.now().millisecond() + '-' + UNIQ_COUNTER++;
    }

    private class CommunityCompany {

        public String companyName { get; private set; }
        private User accountOwner;
        public String tierName { get; private set; }
        private Id companyRecordTypeId;
        private Map<Id, List<List<String>>> userProfileIdsAndTrackSets;

        private Account companyAccount;
        private List<Contact> companyContacts;
        private List<User> companyUsers;
        private List<Id> userProfileIds;

        public CommunityCompany(String companyName, User accountOwner, Id accountRecordTypeId, String tierName, Map<Id, List<List<String>>> userProfileIdsAndTrackSets) {
            this.companyName = companyName;
            this.accountOwner = accountOwner;
            this.companyRecordTypeId = accountRecordTypeId;
            this.tierName = tierName;
            this.userProfileIdsAndTrackSets = userProfileIdsAndTrackSets;
            userProfileIds = new List<Id>(userProfileIdsAndTrackSets.keySet());
        }

        public Tier__c getTier() {
            List<Tier__c> tiers = [SELECT Id FROM Tier__c WHERE Tier_Label__c = :tierName];
            if (tiers == null || tiers.isEmpty()) {
                tiers = new List<Tier__c> { new Tier__c(Tier_Label__c = tierName) };
                insert tiers;
            }
            return tiers[0];
        }

        public Account getCompanyAccount() {
            companyAccount = new Account(
                Name = companyName,
                OwnerId = accountOwner.Id,
                Present_Tier_Lookup__c = getTier().Id,
                RecordTypeId = companyRecordTypeId
            );
            return companyAccount;
        }

        public List<Contact> getCompanyContacts() {
            if (companyAccount != null && companyAccount.Id != null && companyContacts == null) {
                companyContacts = new List<Contact>();
                for (Integer i = 0; i < userProfileIdsAndTrackSets.size(); i++) {
                    Contact contact = new Contact(
                        FirstName = '<' + companyName +'>',
                        Lastname = '<' + tierName +'>',
                        AccountId = companyAccount.Id,
                        Email = getUniqString(UNIQ_MARK_FOR_SOQL) + '@testcontemail.com',
                        RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(LearningTracAssignmentService.CONTRACTOR_NAME).getRecordTypeId()
                    );
                    companyContacts.add(contact);
                }
            }
            return companyContacts;
        }

        public List<User> getCompanyUsers() {
            if (companyContacts != null && companyUsers == null) {
                companyUsers = new List<User>();
                for (Integer i = 0; i < userProfileIdsAndTrackSets.size(); i++) {
                    User user = new User(
                        Username = getUniqString(UNIQ_MARK_FOR_SOQL) + '@username.com',
                        ContactId = companyContacts[i].Id,
                        ProfileId = userProfileIds[i],
                        Alias = 'ali' + UNIQ_COUNTER_USER++,
                        Email = getUniqString(UNIQ_MARK_FOR_SOQL) + '@testusemail.com',
                        EmailEncodingKey = 'UTF-8',
                        FirstName = '<' + companyName +'>',
                        LastName = '<' + tierName + '>',
                        CommunityNickname = getUniqString('nick'),
                        TimeZoneSidKey = 'America/Los_Angeles',
                        LocaleSidKey = 'en_US',
                        LanguageLocaleKey = 'en_US'
                    );
                    companyUsers.add(user);
                }
            }
            return companyUsers;
        }

        public List<redwing__Training_Track_Assignment__c> getUserTrackAssignments() {
            List<redwing__Training_Track_Assignment__c> assignments = new List<redwing__Training_Track_Assignment__c>();
            if (companyUsers != null && userProfileIdsAndTrackSets != null) {
                for (User user : companyUsers) {
                    List<List<String>> trackNamesAndStatuses = userProfileIdsAndTrackSets.get(user.ProfileId);
                    if (trackNamesAndStatuses != null) {
                        for (List<String> trackNameAndStatus : trackNamesAndStatuses) {
                            redwing__Training_Track_Assignment__c assignment = new redwing__Training_Track_Assignment__c(
                                redwing__Training_Track__c = learningTrackIdByName.get(trackNameAndStatus[0]),
                                redwing__Status__c = trackNameAndStatus[1],
                                redwing__User__c = user.Id,
                                redwing__Contact__c = user.ContactId
                            );
                            assignments.add(assignment);
                        }
                    }
                }
            }
            return assignments;
        }

        public List<redwing__Achievement_Assignment__c> getUserAchievements() {
            List<redwing__Achievement_Assignment__c> assignments = new List<redwing__Achievement_Assignment__c>();


            
            return assignments;
        }
    }
}