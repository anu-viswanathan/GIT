/**
 * Created by Yves Asselin on 2019-03-21.
 */
({
    init: function (component, event, helper) {
        var fileName = component.get("v.fileName");
        var action = component.get("c.getFooterContent");

        action.setParams({ staticResourceName : fileName});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.htmlCode', response.getReturnValue());
            }
        });

        $A.enqueueAction(action);
    }

})