/**
 * Created by Francois Poirier on 2019-06-03.
 */

({
    doInit : function (component, event) {

        var currentURL = window.location.href;
        component.set("v.isApp", currentURL.includes('bridge.app'));

        var action = component.get("c.getCurrentTheme");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                component.set("v.currentTheme", responseValue);
            }
        });

        $A.enqueueAction(action);

    }
});