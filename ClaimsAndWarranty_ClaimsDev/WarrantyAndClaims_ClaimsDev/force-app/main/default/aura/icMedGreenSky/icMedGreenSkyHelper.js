/**
 * Created by Francois Poirier on 2018-08-01.
 */
({
    initCreds : function(component){

        var credForm = {};
        credForm.merchantId = '';
        credForm.userName = '';
        credForm.password = '';
        credForm.apiKey = '';

        component.set("v.credentialsForm", credForm);
    },

    doInit : function (component, event) {

        this.showSpinner(component);

        this.initCreds(component);

        var action = component.get("c.isCustomerSubscribed");
        var helper = this;

        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.isCustomerSubscribed", response.getReturnValue());
                console.log('response ' + response.getReturnValue());
            }
            else{
                console.log('Error: ' + JSON.stringify(response));
            }

            helper.hideSpinner(component);

        });

        $A.enqueueAction(action);
 /*       component.set("v.isCustomerSubscribed", true);
        this.hideSpinner(component);*/

    },

    doMerchantValidation : function (component, event) {

        this.showSpinner(component);
        this.clearError(component);
        var action = component.get("c.merchantValidation");
        var helper = this;
        action.setCallback(this, function (response) {
           var state = response.getState();
           if(state === "SUCCESS"){
               var returnValue = response.getReturnValue();
               if(returnValue.error){
                   helper.doError(component, returnValue.error)
               }
               else {
                   component.set("v.merchantValidation", returnValue);
                   component.set("v.currentStep", "asynchSubmit");
               }
           }
           else{
               console.log('Error: ' + JSON.stringify(response));
           }
           helper.hideSpinner(component);
        });

        $A.enqueueAction(action);
    },

    doAsynchronousSubmit : function (component, event) {

        this.showSpinner(component);
        this.clearError(component);
        component.find('applicationF').handleValidation();

        //THE APPLICATION FORM IN DTO COMING FROM CREDITAPPLICATIONFORM COMPONENT
        var formvar = component.get("v.AsyncSubmitForm");
        var requiredFields = component.get("v.requiredFieldsFormFilled");

        if(requiredFields) {

            var action = component.get("c.asyncSubmit");
            action.setParams(
                {
                    merchantValidation: JSON.stringify(component.get("v.merchantValidation")),
                    payload: JSON.stringify(formvar)
                }
            );
            var helper = this;
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var returnValue = response.getReturnValue();
                    if (returnValue.error) {
                        helper.doError(component, returnValue.error);
                    }
                    else {
                        component.set("v.application", returnValue);
                        component.set("v.currentStep", "State");
                        setTimeout($A.getCallback(function (){helper.doState(component, event)}), 5000);
                    }
                }
                else {
                    console.log('Error: ' + JSON.stringify(response));
                    helper.hideSpinner(component);
                }

            });

            $A.enqueueAction(action);

        }
        else {
            var errorObj = {};
            errorObj.code = '-1';
            errorObj.message = $A.get("$Label.c.icPlease_make_sure_all_required_fields_are_filled_properly");

            this.doError(component, errorObj);
        }
    },

    doState : function (component, event) {

        this.showSpinner(component);
        this.clearError(component);
        var action = component.get("c.state");
        var app = component.get("v.application");
        var helper = this;

        action.setParams(
            {
                gsApplication : JSON.stringify(app)
            }
        );
        action.setCallback(this, function (response) {

            var state = response.getState();
            if(state === "SUCCESS"){

                var returnValue = response.getReturnValue();
                console.log('state return value ===> ' + JSON.stringify(returnValue));
                if(returnValue.error){
                    helper.doError(component, returnValue.error);
                }
                else {
                    component.set("v.applicationState", returnValue);
                    if(returnValue.nextState === 'None'){
                        returnValue.nextState = 'nextState';
                        helper.hideSpinner(component);
                    }
                    component.set("v.currentStep", returnValue.nextState);
                    if(returnValue.nextState === 'Offer'){
                        if(returnValue.applicationState != 'Declined') {
                            helper.doOffer(component, event);
                        }
                        else {
                            helper.hideSpinner(component);
                        }
                    }
                }
            }
            else{
                console.log('Error: ' + JSON.stringify(response));
                helper.hideSpinner(component);
            }


        });

        $A.enqueueAction(action);
    },

    doDecision : function(component, event){

        this.showSpinner(component);
        this.clearError(component);
        var action = component.get("c.decision");
        var helper = this;
        action.setParams(
            {
                gsApplication : JSON.stringify(component.get("v.application"))
            }
        );
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var returnValue = response.getReturnValue();
                if(returnValue.error){
                    helper.doError(component, returnValue.error);
                }
                else {
                    component.set("v.decision", returnValue);
                    component.set("v.currentStep", "showDecision");
                }
            }
            else{
                console.log('Error: ' + JSON.stringify(response));
            }
            helper.hideSpinner(component);
        });

        $A.enqueueAction(action);
    },

    doOffer : function(component, event){

        this.showSpinner(component);
        this.clearError(component);
        var action = component.get("c.offer");
        var helper = this;
        action.setParams(
            {
                gsApplication : JSON.stringify(component.get("v.application"))
            }
        );
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var returnValue = response.getReturnValue();
                if(returnValue.error){
                    helper.doError(component, returnValue.error);
                }
                else {
                    console.log('offer ===> ' + JSON.stringify(returnValue));

                    component.set("v.offer", returnValue);
                    component.set("v.currentStep", "Create");
                }
            }
            else{
                console.log('Error: ' + JSON.stringify(response));
            }
            helper.hideSpinner(component);
        });

        $A.enqueueAction(action);

    },

    doCreate : function(component, event){

        this.showSpinner(component);
        this.clearError(component);
        var action = component.get("c.create");
        var helper = this;
        action.setParams(
            {
                gsOffer : JSON.stringify(component.get("v.offer")),
                gsApplication : JSON.stringify(component.get("v.application"))
            }
        );
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var returnValue = response.getReturnValue();
                if(returnValue.error){
                    helper.doError(component, returnValue.error);
                }
                else {
                    component.set("v.currentStep", "Loan Agreement");
                    helper.doLoanAgreement(component, event);
                }
            }
            else{
                console.log('Error: ' + JSON.stringify(response));
            }
            helper.hideSpinner(component);
        });

        $A.enqueueAction(action);
    },

    doLoanAgreement : function(component, event){

        this.showSpinner(component);
        this.clearError(component);
        var action = component.get("c.loanAgreement");
        var helper = this;
        action.setParams(
            {
                gsApplication : JSON.stringify(component.get("v.application"))
            }
        );
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var returnValue = response.getReturnValue();
                if(returnValue.error){
                    helper.doError(component, returnValue.error);
                }
                else {
                    component.set("v.loanAgreement", returnValue);
                    component.set("v.currentStep", "showLoanAgreement");
                    helper.doEmail(component, event);
                }
            }
            else{
                console.log('Error: ' + JSON.stringify(response));
            }
            this.hideSpinner(component);
        });

        $A.enqueueAction(action);
    },

    doEmail : function (component, event){

        this.showSpinner(component);
        this.clearError(component);
        var action = component.get("c.email");
        var helper = this;
        action.setParams(
            {
                loanAgreement : JSON.stringify(component.get("v.loanAgreement")),
                gsApplication : JSON.stringify(component.get("v.application"))
            }
        );
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var returnValue = response.getReturnValue();
                if(returnValue.error){
                    helper.doError(component, returnValue.error);
                }
                else {
                    component.set("v.emailNotSent", false);
                }
            }
            else{
                console.log('Error: ' + JSON.stringify(response));
            }
            helper.hideSpinner(component);
        });

        $A.enqueueAction(action);
    },

    doError : function (component, errorObject) {


        component.set("v.error", errorObject);
        component.set("v.hasError", true);
        window.scrollTo(0,0);
        this.hideSpinner(component);

    },

    retryPrevious : function (component, event) {

        component.set("v.currentStep", component.get("v.previousStep"));

    },

    clearError : function (component) {

        component.set("v.hasError", false);
        component.set("v.error", null);
    },

    showSpinner : function (component) {

        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    hideSpinner : function (component) {

        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    cancelApplication : function (component, event) {

        component.set("v.currentStep", "init");

    },

    doEnterCredentials : function (component, event) {

        component.set("v.showCredentialsForm", true);

    },

    doCreateCredentials : function (component, event) {

        this.showSpinner(component);
        this.clearError(component);
        var action = component.get("c.createGreenSkySubscription");
        var helper = this;
        var credentialsForm = component.get("v.credentialsForm");
        var credentialsFormString = JSON.stringify(credentialsForm);
        console.log('credentialsForm in helper ===> ' + credentialsFormString);

        action.setParams(
            {
                gsSubscriptionString : credentialsFormString
            }
        );
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === "SUCCESS"){

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": $A.get("$Label.c.icSuccess"),
                    "message": $A.get("$Label.c.icCredentials_Successfully_Created"),
                    "type" : "success"
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire()
            }
            else{
                console.log('Error: ' + JSON.stringify(response));
            }
            helper.hideSpinner(component);
        });

        $A.enqueueAction(action);

    }


})