({
        doInit : function (component, event) {

            if(!component.get("v.initiated")) {
                var action = component.get("c.getLists");
                var helper = this;
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var returnValue = response.getReturnValue();
                        if (returnValue.error) {
                            helper.doError(component, returnValue.error)
                        }
                        else {

                            var states = [];
                            for (var i = 0; i < returnValue.states.length; i++) {
                                var item = returnValue.states[i];
                                var state = {label: item, value: item};
                                states.push(state);
                            }
                            component.set("v.statesArray", states);

                            var typeid = [];
                            for (var i = 0; i < returnValue.typeOfId.length; i++) {
                                var itemT = returnValue.typeOfId[i];
                                var type = {label: itemT, value: itemT};
                                typeid.push(type);
                            }
                            component.set("v.typeid", typeid);


                            var youare = [];
                            for (var i = 0; i < returnValue.youAre.length; i++) {
                                var itemY = returnValue.youAre[i];
                                var you = {label: itemY, value: itemY};
                                youare.push(you);
                            }
                            component.set("v.youare", youare);

                        }
                    }
                    else {
                        console.log('Error: ' + JSON.stringify(response));
                    }
                });

                $A.enqueueAction(action);


                var initializeForm = component.get("c.initializeDTO");
                var helper = this;

                initializeForm.setParams(
                    {
                        merchantValidationString: JSON.stringify(component.get("v.merchantValidation")),
                        opportunityId: component.get("v.opportunityId")
                    });

                initializeForm.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var returnValue = response.getReturnValue();
                        if (returnValue.error) {
                            helper.doError(component, returnValue.error)
                        }
                        else {

                            component.set("v.loanForm", returnValue);
                            console.log('loanForm ===> ' + JSON.stringify(returnValue));
                            component.set("v.initiated", true);
                        }
                    }
                    else {
                        console.log('Error: ' + JSON.stringify(response));
                    }
                });
                $A.enqueueAction(initializeForm);
            }
        },

})