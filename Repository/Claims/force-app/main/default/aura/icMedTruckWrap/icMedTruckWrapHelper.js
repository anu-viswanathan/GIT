/**
 * Created by Dongliang Zhang on 2020-04-03.
 */

({
    doInit : function(component, event) {

        var fullLangCode = component.get("v.fullLanguageCode");
        var langCode = fullLangCode.substring(0, 2);
        component.set("v.languageCode", langCode);

        var recordId = component.get("v.recordId");
        var action = component.get("c.getProzoneRemoteAuthDetails");
        action.setParams({ recordId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                console.log('response value prozone ===> ' + JSON.stringify(responseValue));
                component.set("v.remoteAuth", responseValue);
            }
        });

        $A.enqueueAction(action);
    }
})