/**
 * Created by Francois Poirier on 2018-09-06.
 */

public with sharing class icRepoGreenSky implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {

        icDTOGreenSkyApplication createApplication(icDTOGreenSkyApplication application);
        void updateApplicationStatus(String sfId, String status);
        void updateApplicationFromDecision(String sfId, icDTOGreenSkyDecision decision);
        void updateApplicationFromOffer(String sfId, icDTOGreenSkyOffer offer);
    }

    public class Impl implements IClass {

        public icDTOGreenSkyApplication createApplication(icDTOGreenSkyApplication application){

            GreenSky_Application__c gsApplication = new GreenSky_Application__c();
            gsApplication.Application_Id__c = application.applicationId;
            gsApplication.Account__c = application.accountId;
            gsApplication.Opportunity__c = application.opportunityId;
            gsApplication.Application_Date__c = Date.today();
            gsApplication.Requested_Amount__c = Decimal.valueOf(application.requestedAmount);

            insert gsApplication;

            application.GreenSkyApplicationSFId = gsApplication.Id;

            return application;

        }

        public void updateApplicationStatus(String sfId, String status){

            GreenSky_Application__c gsApplication = new GreenSky_Application__c();
            gsApplication.Id = sfId;
            gsApplication.Application_Status__c = status;

            update gsApplication;
        }

        public void updateApplicationFromDecision(String sfId, icDTOGreenSkyDecision decision){

            GreenSky_Application__c greenSkyApplication = new GreenSky_Application__c();
            greenSkyApplication.Id = sfId;
            greenSkyApplication.Application_Status__c = decision.status;
            greenSkyApplication.Applicant_Name__c = decision.applicantFullName;
            greenSkyApplication.Requested_Amount__c = Decimal.valueOf(decision.requestedLoanAmount);

            update greenSkyApplication;
        }

        public void updateApplicationFromOffer(String sfId, icDTOGreenSkyOffer offer){

            GreenSky_Application__c gsApplication = new GreenSky_Application__c();
            gsApplication.Id = sfId;
            gsApplication.Applicant_Name__c = offer.applicantFullName;
            gsApplication.Application_Status__c = offer.applicationStatus;
            if(!offer.offers.isEmpty()){
                gsApplication.Loan_Amount__c = offer.offers[0].loanAmount;
            }

            update gsApplication;
        }
    }


}