@isTest
public class TestDataFactory {
	public static Intel_Report_User__c createIntelReportUser(String Name, String Email, Id IKOuser)
    {
        Intel_Report_User__c IRU = new Intel_Report_User__c(
            Name=Name,
            Email_Address__c=Email,
            IKO_User__c=IKOuser
        );
        Insert IRU;
        return IRU;
    }
    static public Intel_Report_Role__c createIntelReportRole(String Name, ID ParentId)
    {
        Intel_Report_Role__c IRR = new Intel_Report_Role__c(
            Name = Name,
            Parent_Role__c = ParentId
        );
        insert IRR;
        return IRR;
    }
    public static Intelligence_Report__c createIntelligenceReport(String RecordTypeName,ID IntelReportUser, String ReportType,String Product)
    {
        system.debug([Select ID, RecordTypeId__c from intelEmailRecordType__mdt].size());
        ID RecordTypeID = [Select ID, RecordTypeId__c from intelEmailRecordType__mdt where Label=:RecordTypeName].get(0).RecordTypeId__c;
        Intelligence_Report__c IR = new Intelligence_Report__c(Intel_Report_User__c=IntelReportUser,
                                                              Product__c='Test Product',
                                                              Report_Type__c=ReportType,
                                                              RecordTypeId=RecordTypeID);
        insert IR;
        system.debug('IR was created');
        system.debug(IR.Id);
        return IR;
    }
    public static User createUser(String ProfileName, String LastName, String Email, Id ManagersId)
    {
        String alias = String.valueOf(System.currentTimeMillis());
        alias = alias.substring(alias.length() - 8,alias.length());
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = :ProfileName].Id,
            LastName = LastName,
            Email = Email,
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = alias,
            ManagerId = ManagersId,
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        Insert u;
        return u;
    }
    public static Intel_Report_Users_by_Role__c createIntelReportUsersbyRole(ID IntelReportRole, ID IntelReportUser, String RoleType)
    {
        Intel_Report_Users_by_Role__c IRUR = new Intel_Report_Users_by_Role__c(Intel_Report_Role__c = IntelReportRole,
                                                                               Intel_Report_User__c = IntelReportUser,
                                                                               Role_Type__c = RoleType);
        insert IRUR;
        return IRUR;
    }
    public static Intelligence_Report_Line_Item__c createIntelligenceReportLineItem(ID IntelligenceReportId, String LineItemType)
    {
		Intelligence_Report_Line_Item__c IRLI = new Intelligence_Report_Line_Item__c(Intelligence_Report__c=IntelligenceReportId,Type__c=LineItemType);
        insert IRLI;
        return IRLI;
    }
    
    public static ContentDocument getContentDocument()
    {
        ContentDocument CD ;
        Integer sizeList = [Select ID from ContentDocument].size();
        system.debug(sizeList);
        return CD;
    }
    
    public static ContentVersion createContentVersion()
    {
        ContentVersion CV = new ContentVersion(Title = 'Penguins',
                                               PathOnClient = 'Penguins.jpg',
                                               VersionData = Blob.valueOf('Test Content'),
                                               IsMajorVersion = true);
        insert CV;
        return CV;
    }
    public static Attachment createAttachment(ID objectId)
    {
        
        Attachment attach=new Attachment(   	
            Name='Unit Test Attachment',
            body=Blob.valueOf('Unit Test Attachment Body'),
            parentId=objectId);
        insert attach;
        return attach;
    }
        
    public static ContentDocumentLink createContentDocumentLink(ID IntelligenceReportId, Id ContentDocumentId )
    {
		ContentDocumentLink CDL = new ContentDocumentLink();
        insert CDL;
        return CDL;
    }
}