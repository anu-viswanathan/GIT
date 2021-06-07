/**
 * Created by Yves Asselin on 2019-03-21.
 */
({
    init: function (component, event, helper) {

        var fullLangCode = component.get("v.fullLanguageCode");
        var langCode = fullLangCode.substring(0, 2);
        component.set("v.languageCode", langCode);


        var action = component.get("c.getFooterContent");

        var param = 'icTermsAndConditions' + '_' + langCode;

        action.setParams({ staticResourceName : param});
        //action.setParams({ staticResourceName : 'icTermsAndConditions' });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set('v.htmlCode', response.getReturnValue());
            }
        });

        $A.enqueueAction(action);

    }




})