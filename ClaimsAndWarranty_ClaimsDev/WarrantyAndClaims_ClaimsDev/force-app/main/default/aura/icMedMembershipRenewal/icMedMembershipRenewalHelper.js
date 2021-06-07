/**
 * Created by Francois Poirier on 2019-11-01.
 */

({
    renewMembership : function (component, event) {


    },

    doInit : function (component, event) {
        var accountId = component.get("v.contractorId");
        var accountPaymentId = component.get("v.accountPaymentId");
        var action = component.get("c.getMembershipInfos");

        action.setParams(
            {
                accountId : accountId,
                accountPaymentId : accountPaymentId
            }
        );
        action.setCallback(this, function (response) {
            console.log("response ===> " + JSON.stringify(response));
            var state = response.getState();
            if(state === 'SUCCESS'){
                var responseValue = response.getReturnValue();
                console.log('response value ===> ' + JSON.stringify(responseValue));
                component.set("v.membershipRenewalInfo", responseValue);
            }
        });

        $A.enqueueAction(action);
    }
});