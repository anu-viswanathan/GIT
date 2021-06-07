({
	doInit : function(component, event) {
		var recordId = component.get("v.recordId");
		var action = component.get("c.getProzoneRemoteAuthDetails");
		action.setParams({ recordId : recordId });
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseValue = response.getReturnValue();
				component.set("v.remoteAuth", responseValue);
			}
		});

		$A.enqueueAction(action);
	}
})