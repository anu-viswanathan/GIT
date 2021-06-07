/**
 * Created by Francois Poirier on 2019-11-29.
 */

({
    doInit : function (component, event) {

        console.log('in do Init of popup notification');

        var tag = component.get("v.tag");


        var action = component.get("c.getPopupNotificationByTag");

        action.setParams({tag: tag});

        action.setCallback(this, function(response){

            console.log('in callback');

            var state = response.getState();
            if(state === "SUCCESS") {

                var returnValue = response.getReturnValue();
                var showMessage = returnValue.showMessage;
                var message = returnValue.message;
                var notificationViewId = returnValue.notificationViewId;

                console.log('return value ===> ' + JSON.stringify(returnValue));

                component.set("v.showModal", showMessage);
                component.set("v.message", message);
                component.set("v.notificationViewId", notificationViewId);

            }
        });

        $A.enqueueAction(action);
    },

    closeModal : function (component, event) {

        component.set("v.showModal", false);
        var doNotShow = component.get("v.doNotShow");

        if(doNotShow === true){
            this.doNotShowAgain(component);
        }

    },

    doNotShowAgain : function (component) {

        var notificationViewId = component.get("v.notificationViewId");
        var action = component.get("c.stopShowingPopupNotification");

        action.setParams({notificationViewId : notificationViewId});

        $A.enqueueAction(action);

    }
});