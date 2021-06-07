({
    getAllRelatedAccounts : function(component) {
        
        var action = component.get("c.getAllRelatedAccounts");
        action.setParams({ 
            street : component.get("v.street"),
            city : component.get("v.city"), 
            state : component.get("v.state"), 
            country : component.get("v.country") ,
            postalCode : component.get("v.postalCode")  
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.relatedAccounts', response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });        
        $A.enqueueAction(action);
    },
    
    getRelatedAccountsByCaseId : function(component, caseId){
        var action = component.get("c.getRelatedAccountsByCaseId");
        action.setParams({ 
            caseId : caseId,
           
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.relatedAccounts', response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });        
        $A.enqueueAction(action);
    }

})