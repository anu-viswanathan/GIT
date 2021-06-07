/*
 * Created by Francois Poirier on 2018-07-17.
 */

public with sharing class icLogicGreenSky implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {

        icDTOGreenSkyMerchantValidation merchantValidation();
        icDTOGreenSkyApplication asynchronousSubmit(String token, String payload);
        icDTOGreenSkyApplicationState state(icDTOGreenSkyApplication gsApplication);
        icDTOGreenSkyDecision Decision(icDTOGreenSkyApplication gsApplication);
        icDTOGreenSkyOffer offer(icDTOGreenSkyApplication gsApplication);
        icDTOGreenSkyCreate create(icDTOGreenSkyOffer gsOffer, icDTOGreenSkyApplication gsApplication);
        icDTOGreenSkyLoanAgreement loanAgreement(icDTOGreenSkyApplication gsApplication);
        icDTOGreenSkyEmail email(icDTOGreenSkyLoanAgreement loanAgreement, icDTOGreenSkyApplication gsApplication);
        icDTOGreenSkyLists getListsFromGreenSkyAPI();
        icDTOLoanForm getGreenSkyLoanForm(icDTOGreenSkyMerchantValidation merchantValidation, String opportunityId);
        Boolean isCustomerSubscribed();
        void saveSubscription(String gsSubscriptionString);
    }

    public class Impl implements IClass {


        Boolean isSandbox = [SELECT isSandbox FROM Organization LIMIT 1].isSandbox;
        String GS_ENDPOINT_URI = isSandbox ? 'https://api.uat.greensky.com/' : 'https://api.poweredby.greensky.com/';
        String GS_API_KEY = isSandbox ? 'Basic VHVybnM6NnJhZEtHUHhTVTlmNnhaZw==' : '27a338de-f15b-48ba-ae6a-389d36398225';
        String GS_PROGRAM = 'GreenSky+Consumer+Projects';
        String GS_PROGRAM_BODY = 'GreenSky Consumer Projects';
        String GS_PLAN =  '9999';
        String GS_CHANNEL = 'External-API-IKO';
        String GS_ROLE = 'Merchant';

        icRepoGreenSky.IClass GreenSkyRepo = (icRepoGreenSky.IClass) icObjectFactory.GetSingletonInstance('icRepoGreenSky');
        icLogicOpportunity.IClass opportunityLogic = (icLogicOpportunity.IClass) icObjectFactory.GetSingletonInstance('icLogicOpportunity');
        icLogicSubscription.IClass subscriptionLogic = (icLogicSubscription.IClass) icObjectFactory.GetSingletonInstance('icLogicSubscription');
        icLogicUser.IClass userLogic = (icLogicUser.Iclass) icObjectFactory.GetSingletonInstance('icLogicUser');


        public icDTOLoanForm getGreenSkyLoanForm(icDTOGreenSkyMerchantValidation merchantValidation, String opportunityId){

            Opportunity currentOpp = opportunityLogic.getOpportunityDataForGreenSky(opportunityId);
            String accountId;
            IKOPRO_Contractor_Subscription__c subscription = new IKOPRO_Contractor_Subscription__c();

            accountId = userLogic.getAccountIdFromPartnerUser(UserInfo.getUserId());
            subscription = subscriptionLogic.getGreenSkySubscriptionForCustomer(accountId);

            icDTOLoanForm newLoanForm = new icDTOLoanForm();
            newLoanForm.program = GS_PROGRAM_BODY;
            newLoanForm.channel = GS_CHANNEL;
            newLoanForm.role = 'Merchant';
            newLoanForm.product = merchantValidation.creditProduct;
            newLoanForm.referral = subscription.Membership_ID__c + '-' + GS_PLAN;
            newLoanForm.requestedLoanAmount = currentOpp.Amount;
            newLoanForm.referenceNumber = currentOpp.Id;
            newLoanForm.applicantMobileOptIn = true;
            newLoanForm.coApplicantMobileOptIn = true;
            return newLoanForm;
        }

        public icDTOGreenSkyMerchantValidation merchantValidation(){

            icDTOGreenSkyMerchantValidation response = new icDTOGreenSkyMerchantValidation();
            String accountId;
            IKOPRO_Contractor_Subscription__c subscription = new IKOPRO_Contractor_Subscription__c();
            Boolean hasError = false;
            icDTOGreenSkyError gsError = new icDTOGreenSkyError();
            accountId = userLogic.getAccountIdFromPartnerUser(UserInfo.getUserId());
            subscription = subscriptionLogic.getGreenSkySubscriptionForCustomer(accountId);

            HttpRequest req = new HttpRequest();
            String ressourceEndpoint = GS_ENDPOINT_URI + 'merchantvalidation?program=GreenSky+Consumer+Projects&dealer=' + subscription.Membership_ID__c + '&plan=' + GS_PLAN + '&channel=External-API-IKO&role=Merchant';
            req.setEndpoint(ressourceEndpoint);
            req.setMethod('GET');
            req.setHeader('Authorization', GS_API_KEY);
           /* if(String.isNotBlank(subscription.Client_Secret__c) && String.isNotBlank(subscription.Membership_ID__c)) {
                req.setHeader('Authorization', subscription.Client_Secret__c);
            }*/

            if(String.isBlank(subscription.Membership_ID__c)) {
                gsError.code = '-1';
                gsError.message = Label.icInvalid_GreenSky_Merchant_Id;
                hasError = true;
            }

            if(!hasError) {
                system.debug('req ===> ' + req);
                Http http = new Http();
                HttpResponse httpResp = http.send(req);

                system.debug('httpResp ====> ' + httpResp);
                if(httpResp.getStatusCode() == 200) {
                    response = (icDTOGreenSkyMerchantValidation) JSON.deserialize(httpResp.getBody(), icDTOGreenSkyMerchantValidation.class);
                    if (!response.isValid) {
                        response.error.code = '-1';
                        response.error.message = label.icMerchant_Validation_Failed;
                    }
                }
                else {
                    response.error = new icDTOGreenSkyError();
                    response.error.code = String.valueOf(httpResp.getStatusCode());
                    response.error.message = httpResp.getBody();
                }
            }
            else {
                response.error = gsError;
            }

            system.debug('response ====> ' + response);
            return response;
        }

        public icDTOGreenSkyApplication asynchronousSubmit(String token, String payload){

            String accountId;
            IKOPRO_Contractor_Subscription__c subscription = new IKOPRO_Contractor_Subscription__c();

            accountId = userLogic.getAccountIdFromPartnerUser(UserInfo.getUserId());
            subscription = subscriptionLogic.getGreenSkySubscriptionForCustomer(accountId);

            System.debug('token ===> ' + token);
            system.debug('payload logic ====> ' + payload);
            icDTOGreenSkyApplication response = new icDTOGreenSkyApplication();
            HttpRequest req = new HttpRequest();
            String ressourceEndpoint = GS_ENDPOINT_URI + 'asynchronoussubmit';
            req.setEndpoint(ressourceEndpoint);
            req.setMethod('POST');
            //req.setHeader('Authorization', subscription.Client_Secret__c);
            req.setHeader('Authorization', GS_API_KEY);
            req.setHeader('token', token);
            req.setHeader('Content-Type', 'application/json');
            req.setBody(payload);

            Http http = new Http();
            HttpResponse httpResp = http.send(req);
            system.debug('httpResp ====> ' + httpResp);

            if(httpResp.getStatusCode() == 200) {
                response = (icDTOGreenSkyApplication) JSON.deserialize(httpResp.getBody(), icDTOGreenSkyApplication.class);
                response = getOpportunityData(response);
                icDTOLoanForm loanForm = new icDTOLoanForm();
                loanForm = (icDTOLoanForm) JSON.deserialize(payload, icDTOLoanForm.class);
                response.requestedAmount = String.valueOf(loanForm.requestedLoanAmount);
                response.opportunityId = loanForm.referenceNumber;
                response = GreenSkyRepo.createApplication(response);
            }
            else {
                response.error = new icDTOGreenSkyError();
                response.error.code = String.valueOf(httpResp.getStatusCode());
                response.error.message = httpResp.getBody();
            }

            System.debug('SUBMIT RESPONSE ' + response);
            return response;
        }

        public icDTOGreenSkyApplicationState state(icDTOGreenSkyApplication gsApplication){

            icDTOGreenSkyApplicationState response = new icDTOGreenSkyApplicationState();
            String accountId;
            IKOPRO_Contractor_Subscription__c subscription = new IKOPRO_Contractor_Subscription__c();

            accountId = userLogic.getAccountIdFromPartnerUser(UserInfo.getUserId());
            subscription = subscriptionLogic.getGreenSkySubscriptionForCustomer(accountId);


            HttpRequest req = new HttpRequest();
            String ressourceEndpoint = GS_ENDPOINT_URI + 'state?program=' + GS_PROGRAM + '&applicationId=' + gsApplication.applicationId + '&channel=' + GS_CHANNEL + '&role=' + GS_ROLE ;
            req.setEndpoint(ressourceEndpoint);
            req.setMethod('GET');
            //req.setHeader('Authorization', subscription.Client_Secret__c);
            req.setHeader('Authorization', GS_API_KEY);
            req.setHeader('token', gsApplication.token);

            Http http = new Http();
            HttpResponse httpResp = http.send(req);
            system.debug('response body ===> ' + httpResp);
            if(httpResp.getStatusCode() == 200) {
                response = (icDTOGreenSkyApplicationState) JSON.deserialize(httpResp.getBody(), icDTOGreenSkyApplicationState.class);
                GreenSkyRepo.updateApplicationStatus(gsApplication.GreenSkyApplicationSFId, response.applicationStatus);
            }
            else {
                response.error = new icDTOGreenSkyError();
                response.error.code = String.valueOf(httpResp.getStatusCode());
                response.error.message = httpResp.getBody();
            }
            System.debug('STATE RESPONSE ' + response);
            response.nextState='Offer';
            return response;
        }

        public icDTOGreenSkyDecision decision(icDTOGreenSkyApplication gsApplication){

            icDTOGreenSkyDecision response = new icDTOGreenSkyDecision();
            String accountId;
            IKOPRO_Contractor_Subscription__c subscription = new IKOPRO_Contractor_Subscription__c();

            accountId = userLogic.getAccountIdFromPartnerUser(UserInfo.getUserId());
            subscription = subscriptionLogic.getGreenSkySubscriptionForCustomer(accountId);

            HttpRequest req = new HttpRequest();
            String ressourceEndpoint = GS_ENDPOINT_URI + 'decision?program=' + GS_PROGRAM + '&applicationId=' + gsApplication.applicationId;
            req.setEndpoint(ressourceEndpoint);
            req.setMethod('GET');
            //req.setHeader('Authorization', subscription.Client_Secret__c);
            req.setHeader('Authorization', GS_API_KEY);
            req.setHeader('token', gsApplication.token);

            Http http = new Http();
            HttpResponse httpResp = http.send(req);

            if(httpResp.getStatusCode() == 200) {
                response = (icDTOGreenSkyDecision) JSON.deserialize(httpResp.getBody(), icDTOGreenSkyDecision.class);
                GreenSkyRepo.updateApplicationFromDecision(gsApplication.GreenSkyApplicationSFId, response);
            }
            else {
                response.error = new icDTOGreenSkyError();
                response.error.code = String.valueOf(httpResp.getStatusCode());
                response.error.message = httpResp.getBody();
            }

            return response;
        }

        public icDTOGreenSkyOffer offer(icDTOGreenSkyApplication gsApplication){

            icDTOGreenSkyOffer response = new icDTOGreenSkyOffer();
            String accountId;
            IKOPRO_Contractor_Subscription__c subscription = new IKOPRO_Contractor_Subscription__c();

            accountId = userLogic.getAccountIdFromPartnerUser(UserInfo.getUserId());
            subscription = subscriptionLogic.getGreenSkySubscriptionForCustomer(accountId);

            HttpRequest req = new HttpRequest();
            String ressourceEndpoint = GS_ENDPOINT_URI + 'offer?program=' + GS_PROGRAM + '&applicationId=' + gsApplication.applicationId + '&supportMultiOffer=1';
            req.setEndpoint(ressourceEndpoint);
            req.setMethod('GET');
            req.setHeader('Authorization', GS_API_KEY);
            //req.setHeader('Authorization', subscription.Client_Secret__c);
            req.setHeader('token', gsApplication.token);

            Http http = new Http();
            HttpResponse httpResp = http.send(req);

            if(httpResp.getStatusCode() == 200) {
                String strResponse = httpResp.getBody();
                system.debug('strResponse avant ===> ' + strResponse);
                strResponse = strResponse.replace('date', 'submissionDate');
                system.debug('strResponse apres ===> ' + strResponse);
                response = (icDTOGreenSkyOffer) JSON.deserialize(strResponse, icDTOGreenSkyOffer.class);
                GreenSkyRepo.updateApplicationFromOffer(gsApplication.GreenSkyApplicationSFId, response);
            }
            else {
                response.error = new icDTOGreenSkyError();
                response.error.code = String.valueOf(httpResp.getStatusCode());
                response.error.message = httpResp.getBody();
            }

           /* response.applicantFullName='Test';
            response.applicationStatus = 'Approved';

            icDTOGreenSkyLoanOffer o = new icDTOGreenSkyLoanOffer();
            o.loanAmount = 5000;
            o.monthlyPayment = 10;

            response.offers = new List<icDTOGreenSkyLoanOffer>{o};
*/

            return response;
        }

        public icDTOGreenSkyCreate create(icDTOGreenSkyOffer gsOffer, icDTOGreenSkyApplication gsApplication){

            System.debug('token ===> ' + gsApplication.token);
            system.debug('gsOffer ===> ' + gsOffer);
            String accountId;
            IKOPRO_Contractor_Subscription__c subscription = new IKOPRO_Contractor_Subscription__c();

            accountId = userLogic.getAccountIdFromPartnerUser(UserInfo.getUserId());
            subscription = subscriptionLogic.getGreenSkySubscriptionForCustomer(accountId);

            icDTOGreenSkyLoanOffer acceptedOffer = new  icDTOGreenSkyLoanOffer();
            if(gsOffer.offers.size()>0){
                acceptedOffer = gsOffer.offers[0];
            }
            String payload = '{"program" : "' + GS_PROGRAM_BODY + '", "offerId" : "' + acceptedOffer.id + '", "applicationId" : "' + gsApplication.applicationId + '", "role" : "Merchant", "product" : "Installment"}';

            icDTOGreenSkyCreate response = new icDTOGreenSkyCreate();
            HttpRequest req = new HttpRequest();
            String ressourceEndpoint = GS_ENDPOINT_URI + 'create';
            req.setEndpoint(ressourceEndpoint);
            req.setMethod('POST');
            req.setHeader('Authorization', GS_API_KEY);
            //req.setHeader('Authorization', subscription.Client_Secret__c);
            req.setHeader('token', gsApplication.token);
            req.setHeader('Content-Type', 'application/json');
            system.debug('payload for create ===> ' + payload);
            req.setBody(payload);

            Http http = new Http();
            HttpResponse httpResp = http.send(req);
            system.debug('httpResp ====> ' + httpResp);

            if(httpResp.getStatusCode() == 200) {
                response = (icDTOGreenSkyCreate) JSON.deserialize(httpResp.getBody(), icDTOGreenSkyCreate.class);
                GreenSkyRepo.updateApplicationStatus(gsApplication.GreenSkyApplicationSFId, response.Status);
            }
            else {
                response.error = new icDTOGreenSkyError();
                response.error.code = String.valueOf(httpResp.getStatusCode());
                response.error.message = httpResp.getBody();
            }
            return response;
        }

        public icDTOGreenSkyLoanAgreement loanAgreement(icDTOGreenSkyApplication gsApplication){

            icDTOGreenSkyLoanAgreement response = new icDTOGreenSkyLoanAgreement();
            String accountId;
            IKOPRO_Contractor_Subscription__c subscription = new IKOPRO_Contractor_Subscription__c();

            accountId = userLogic.getAccountIdFromPartnerUser(UserInfo.getUserId());
            subscription = subscriptionLogic.getGreenSkySubscriptionForCustomer(accountId);

            HttpRequest req = new HttpRequest();
            String ressourceEndpoint = GS_ENDPOINT_URI + 'loanagreement?program=' + GS_PROGRAM + '&applicationId=' + gsApplication.applicationId;
            req.setEndpoint(ressourceEndpoint);
            req.setMethod('GET');
            req.setHeader('Authorization', GS_API_KEY);
            //req.setHeader('Authorization', subscription.Client_Secret__c);
            req.setHeader('token', gsApplication.token);

            Http http = new Http();
            HttpResponse httpResp = http.send(req);

            if(httpResp.getStatusCode() == 200) {
                response = (icDTOGreenSkyLoanAgreement) JSON.deserialize(httpResp.getBody(), icDTOGreenSkyLoanAgreement.class);
            }
            else {
                response.error = new icDTOGreenSkyError();
                response.error.code = String.valueOf(httpResp.getStatusCode());
                response.error.message = httpResp.getBody();
            }
            return response;
        }

        public icDTOGreenSkyEmail email(icDTOGreenSkyLoanAgreement loanAgreement, icDTOGreenSkyApplication gsApplication){

            icDTOGreenSkyEmail response = new icDTOGreenSkyEmail();
            String accountId;
            IKOPRO_Contractor_Subscription__c subscription = new IKOPRO_Contractor_Subscription__c();

            accountId = userLogic.getAccountIdFromPartnerUser(UserInfo.getUserId());
            subscription = subscriptionLogic.getGreenSkySubscriptionForCustomer(accountId);

            String payload = '{"applicationId" : "' + gsApplication.applicationId + '", "to" : "' + loanAgreement.applicantEmail + '"}';

            HttpRequest req = new HttpRequest();
            String ressourceEndpoint = GS_ENDPOINT_URI + 'email';
            req.setEndpoint(ressourceEndpoint);
            req.setMethod('POST');
            req.setHeader('Authorization', GS_API_KEY);
            //req.setHeader('Authorization', subscription.Client_Secret__c);
            req.setHeader('token', gsApplication.token);
            req.setHeader('Content-Type', 'application/json');
            system.debug('payload for create ===> ' + payload);
            req.setBody(payload);

            Http http = new Http();
            HttpResponse httpResp = http.send(req);
            system.debug('httpResp ====> ' + httpResp);

            if(httpResp.getStatusCode() == 200) {
                response = (icDTOGreenSkyEmail) JSON.deserialize(httpResp.getBody(), icDTOGreenSkyEmail.class);
            }
            else {
                response.error = new icDTOGreenSkyError();
                response.error.code = String.valueOf(httpResp.getStatusCode());
                response.error.message = httpResp.getBody();
            }
            return response;
        }

        public icDTOGreenSkyLists getListsFromGreenSkyAPI(){

            icDTOGreenSkyLists response = new icDTOGreenSkyLists();

            String GS_ENDPOINT_URI = 'https://api.uat.greensky.com/';

            String accountId;
            IKOPRO_Contractor_Subscription__c subscription = new IKOPRO_Contractor_Subscription__c();

            accountId = userLogic.getAccountIdFromPartnerUser(UserInfo.getUserId());
            subscription = subscriptionLogic.getGreenSkySubscriptionForCustomer(accountId);

            HttpRequest req = new HttpRequest();
            String ressourceEndpoint = GS_ENDPOINT_URI + '/list';
            req.setEndpoint(ressourceEndpoint);
            req.setMethod('GET');
            req.setHeader('Authorization', GS_API_KEY);
            //req.setHeader('Authorization', subscription.Client_Secret__c);

            system.debug('req ===> ' + req);
            Http http = new Http();
            HttpResponse httpResp = http.send(req);

            Map<String, Object> o = (Map<String,Object>) JSON.deserializeUntyped(httpResp.getBody());
            List<Object> threelists = (List<Object>) o.get('lists');
            List<string> stateList= new List<string> ();
            List<string> typeId= new List<string> ();
            List<string> youareL = new List<string> ();

            for(Object obj : threelists){

                Map<String, Object> p = (Map<String, Object>) obj;

                String s = String.valueof(p.get('name'));

                if(s.equals('state')){
                    List<Object> states = (List<Object>) p.get('values');

                    for(Object oL : states){
                        stateList.add( String.valueOf(oL));

                    }

                }

                if(s.equals('typeOfId')){
                    List<Object> ids = (List<Object>) p.get('values');

                    for(Object oL : ids){

                        typeId.add(String.valueOf(oL));

                    }

                }
                if(s.equals('youAre')){
                    List<Object> youare = (List<Object>) p.get('values');

                    for(Object oL : youare){

                        youareL.add(String.valueOf(oL));

                    }

                }
            }

            response.setlists(stateList,typeId,youareL);

            return response;

        }

        public Boolean isCustomerSubscribed(){

            Boolean isSubscribed = false;
            String accountId;
            IKOPRO_Contractor_Subscription__c subscription = new IKOPRO_Contractor_Subscription__c();

            accountId = userLogic.getAccountIdFromPartnerUser(UserInfo.getUserId());
            subscription = subscriptionLogic.getGreenSkySubscriptionForCustomer(accountId);
            if(String.isNotBlank(subscription.Membership_ID__c)){
                isSubscribed = true;
            }

            return isSubscribed;
        }

        public void saveSubscription(String gsSubscriptionString){

            icDTOGreenSkySubscription gsSubscriptionDTO = new icDTOGreenSkySubscription();
            gsSubscriptionDTO = (icDTOGreenSkySubscription) JSON.deserialize(gsSubscriptionString, icDTOGreenSkySubscription.class);

            system.debug('gsSubscriptionString in saveSubscription in icLogiGreenSky ===> ' + gsSubscriptionString);
            system.debug('gsSubscriptionDTO in saveSubscription in icLogiGreenSky ===> ' + gsSubscriptionDTO);

            subscriptionLogic.createGreenSkySubscription(gsSubscriptionDTO);

        }

        private icDTOGreenSkyApplication getOpportunityData(icDTOGreenSkyApplication gsApplication){

            Opportunity currentOpp = opportunityLogic.getOpportunityDataForGreenSky(gsApplication.opportunityId);

            gsApplication.accountId = currentOpp.AccountId;


            return gsApplication;
        }
    }

}