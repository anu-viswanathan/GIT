/**
 * Created by Francois Poirier on 2019-11-01.
 */

({
    handleRenewalBtnClick : function (component, event, helper) {

        helper.renewMembership(component, event);

    },

    doInit : function (component, event, helper) {

        helper.doInit(component, event);

    }
});