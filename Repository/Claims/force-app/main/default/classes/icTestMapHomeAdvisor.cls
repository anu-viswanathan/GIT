/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icTestMapHomeAdvisor {

    public static testMethod void test_getSFLeadFromDTOHALead() {
        icMapHomeAdvisor.IClass mp = (icMapHomeAdvisor.IClass) icObjectFactory.GetSingletonInstance('icMapHomeAdvisor');

        icDTOHALead l = new icDTOHALead();
        mp.getSFLeadFromDTOHALead(l);        
    }

	public static testMethod void test_getDTOHALeadFromJSONMap() {
        icMapHomeAdvisor.IClass mp = (icMapHomeAdvisor.IClass) icObjectFactory.GetSingletonInstance('icMapHomeAdvisor');

        String requestBody = '{"name":"Jane Perno","firstName":"Jane","lastName":"Perno","address":"81 Hixon street","city":"Bellingham","stateProvince":"MA","postalCode":"02019","primaryPhone":"7814141981","email":"kpjpcp01@comcast.net","srOid":128866227,"leadOid":310084316,"fee":106.39,"taskName":"Asphalt Shingle Roofing - Install or Replace","comments":"Need a new roof ASAP on my home. Original to the house built in 1997. Wind damage and leaking. Some gutter replacements as well as some siding . I have had many crazy quotes and then &acirc;&#128;&#156; Real &acirc;&#128;&#156; quotes. Seeking quality workmanship","matchType":"market","leadDescription":"Market Match","spEntityId":16405487,"spCompanyName":"M and J Home Improvement","crmKey":"00Gm0000001u77ZEAQ","interview":[{"question":"What is the nature of this project?","answer":"Completely replace roof"},{"question":"Special Features for Roof","answer":"No"},{"question":"Request Stage","answer":"Ready to Hire"},{"question":"Desired Completion Date","answer":"1 - 2 weeks"}],"appointment":{"appointmentOid":"0001","status":"Test","Type":"Mock"}}';
        String cleanJSONHALead = requestBody.replace('"type":', '"type_HA":').replace('"end":', '"end_HA":');

        Map<String, Object> untypedMapLead = (Map<String, Object>)JSON.deserializeUntyped(cleanJSONHALead);
        icDTOHALead returnHALead = mp.getDTOHALeadFromJSONMap(untypedMapLead);    
    }
}