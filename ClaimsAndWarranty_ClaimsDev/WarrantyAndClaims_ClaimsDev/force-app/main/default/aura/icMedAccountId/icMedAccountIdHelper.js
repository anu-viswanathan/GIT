/**
 * Created by Francois Poirier on 2019-05-15.
 */
({
    doInit : function (component, event) {

        var action = component.get("c.getAccountId");
        action.setCallback(this, function (response) {

            var state = response.getState();
            if(state === "SUCCESS"){

                var accountId = response.getReturnValue();
                console.log('account id ===> ' + accountId);
                component.set("v.accountId", accountId);

            }
            else {
                console.log('Error : ' + JSON.stringify(response));
            }
        });

        $A.enqueueAction(action);
    }
})