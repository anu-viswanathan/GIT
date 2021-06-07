/**
 * Created by Francois Poirier on 2018-12-19.
 */
({
    doLogOut : function (component, event) {

        var action = component.get("c.getBaseURL");

        var currentURL = "";

        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                currentURL = response.getReturnValue();
                console.log('response ' + response.getReturnValue());
                window.location.replace( currentURL + "/secur/logout.jsp?retUrl=https://" + currentURL + '/s/login');

            }
            else{
                console.log('Error: ' + JSON.stringify(response));
            }


        });

        $A.enqueueAction(action);




    }
})