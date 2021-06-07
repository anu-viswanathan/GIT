/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestLogicHomeAdvisor {

    static void initTest() {
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icRepoHomeAdvisor', new icREPOHomeAdvisorMock());
        icTestMockUtilities.Tracer.SetReturnValue('icREPOHomeAdvisorMock', 'XXXX', new Contact());
        icTestMockUtilities.Tracer.SetReturnValue('icREPOHomeAdvisorMock', 'XXXX', new Account());
        icTestMockUtilities.Tracer.SetReturnValue('icREPOHomeAdvisorMock', 'XXXX',new Account());
        icTestMockUtilities.Mocker.SetMockSingletonInstance('icMapHomeAdvisor', new icMapHomeAdvisorMock());

        //icTestMockUtilities.Mocker.SetMockSingletonInstance('icMapAccount', new icMapAccountMock());
        //icTestMockUtilities.Tracer.SetReturnValue('icMapAccountMock', 'convertCustomerDTOToAccountWithRecordType', new Account());

    }

    public static testMethod void test_getHALeadFromJSON_Success(){
        initTest();
        icLogicHomeAdvisor.IClass BL = (icLogicHomeAdvisor.IClass) icObjectFactory.GetSingletonInstance('icLogicHomeAdvisor');

        String requestBody = '{"name":"Jane Perno","firstName":"Jane","lastName":"Perno","address":"81 Hixon street","city":"Bellingham","stateProvince":"MA","postalCode":"02019","primaryPhone":"7814141981","email":"kpjpcp01@comcast.net","srOid":128866227,"leadOid":310084316,"fee":106.39,"taskName":"Asphalt Shingle Roofing - Install or Replace","comments":"Need a new roof ASAP on my home. Original to the house built in 1997. Wind damage and leaking. Some gutter replacements as well as some siding . I have had many crazy quotes and then &acirc;&#128;&#156; Real &acirc;&#128;&#156; quotes. Seeking quality workmanship","matchType":"market","leadDescription":"Market Match","spEntityId":16405487,"spCompanyName":"M and J Home Improvement","crmKey":"00Gm0000001u77ZEAQ","interview":[{"question":"What is the nature of this project?","answer":"Completely replace roof"},{"question":"Special Features for Roof","answer":"No"},{"question":"Request Stage","answer":"Ready to Hire"},{"question":"Desired Completion Date","answer":"1 - 2 weeks"}],"appointment":{"appointmentOid":"0001","status":"Test","Type":"Mock"}}';
        BL.getHALeadFromJSON(requestBody);
    }

    public static testMethod void test_getHALeadFromJSON_Exception(){
        initTest();
        icLogicHomeAdvisor.IClass BL = (icLogicHomeAdvisor.IClass) icObjectFactory.GetSingletonInstance('icLogicHomeAdvisor');
        String requestBody = '';
        BL.getHALeadFromJSON(requestBody);
    }

    public static testMethod void test_getSFLeadFromHALead_Success(){
        initTest();
        icLogicHomeAdvisor.IClass BL = (icLogicHomeAdvisor.IClass) icObjectFactory.GetSingletonInstance('icLogicHomeAdvisor');

        BL.getSFLeadFromHALead(new icDTOHALead());
    }

    public static testMethod void test_getSFLeadFromHALead_Exception(){
        initTest();
        icLogicHomeAdvisor.IClass BL = (icLogicHomeAdvisor.IClass) icObjectFactory.GetSingletonInstance('icLogicHomeAdvisor');

        BL.getSFLeadFromHALead(null);
    }

    public static testMethod void test_processHALead_Sucess(){
        initTest();
        icLogicHomeAdvisor.IClass BL = (icLogicHomeAdvisor.IClass) icObjectFactory.GetSingletonInstance('icLogicHomeAdvisor');

        BL.processHALead(new Lead());
    }

    public static testMethod void test_processHALead_Exception(){
        initTest();
        icLogicHomeAdvisor.IClass BL = (icLogicHomeAdvisor.IClass) icObjectFactory.GetSingletonInstance('icLogicHomeAdvisor');

        BL.processHALead(null);
    }
}