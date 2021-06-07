({
    getNotes : function(component) {
        var action = component.get("c.getContentNotes");
        action.setParams({ 
            "recordId" : component.get('v.recordId')
        });

        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                component.set('v.recordNotes', a.getReturnValue());
            } else if (state === "ERROR") {
                var errors = a.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);        
    }
})