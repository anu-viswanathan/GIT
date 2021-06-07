({
    getPermissionId : function(component) {
        var action = component.get("c.getSharinPixPermissionId");
        action.setParams({ 
            "labSampleId": component.get('v.recordId')
        });

        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                component.set('v.permissionId', a.getReturnValue());
                component.set('v.showSharinPix', true);
            } else if (state === "ERROR") {
                var errors = a.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);        
    },
})