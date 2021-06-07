({
	saveRecord : function(component, closeModal) {
    	component.set('v.message', "");
        component.find("labSampleData").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
            	component.set('v.message', "Saved!");
                component.set('v.messageType', 'announcement');
                component.set('v.messageBackground', 'success');
                if(closeModal) {
					$A.get("e.force:closeQuickAction").fire();
                }
            } else if (saveResult.state === "INCOMPLETE") {
            	component.set('v.message', "User is offline, device doesn't support drafts.");
                component.set('v.messageType', 'warning');
                component.set('v.messageBackground', 'error');
            } else if (saveResult.state === "ERROR") {
            	component.set('v.message', 'Problem saving record, error: ' + JSON.stringify(saveResult.error));
                component.set('v.messageType', 'warning');
                component.set('v.messageBackground', 'error');
            } else {
                component.set('v.message', 'Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                component.set('v.messageType', 'warning');
                component.set('v.messageBackground', 'error');
            }
        }));

	}
})