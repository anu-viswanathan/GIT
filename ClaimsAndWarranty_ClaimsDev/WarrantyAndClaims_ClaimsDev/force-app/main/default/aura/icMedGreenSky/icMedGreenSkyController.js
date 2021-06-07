/**
 * Created by Francois Poirier on 2018-08-01.
 */
({
    doInit : function (component, event, helper) {
        helper.doInit(component, event);
    },

    doMerchantValidation : function (component, event, helper) {
        console.log('GS Merchant Validation');
        helper.doMerchantValidation(component, event);
    },

    doSubscribe : function (component, event, helper) {
        helper.doSubscribe(component, event);
    },

    doAsynchronousSubmit : function (component, event, helper) {

        helper.doAsynchronousSubmit(component, event);

    },

    doState : function (component, event, helper) {

        helper.doState(component, event);
    },

    doDecision : function (component, event, helper) {

        helper.doDecision(component, event);
    },

    doOffer : function (component, event, helper) {

        helper.doOffer(component, event);
    },

    doCreate : function(component, event, helper){

        helper.doCreate(component, event);
    },

    doLoanAgreement : function (component, event, helper) {

        helper.doLoanAgreement(component, event);

    },

    doEmail : function (component, event, helper) {

        helper.doEmail(component, event);

    },

    retryPrevious : function (component, event, helper) {

        helper.retryPrevious(component, event);

    },

    cancelApplication : function (component, event, helper) {

        helper.cancelApplication(component, event);

    },

    doSubscribe : function (component, event, helper) {

        helper.doSubscribe(component, event);

    },

    doEnterCredentials : function (component, event, helper) {

        helper.doEnterCredentials(component, event);

    },

    doCreateCredentials : function (component, event, helper) {

        console.log("in controller do create creds");
        helper.doCreateCredentials(component, event);

    },

    test : function (component, event, helper) {

        var testForm = component.get("v.credentialsForm");
        console.log('test form ===> ' + JSON.stringify(testForm));
        
    }

})