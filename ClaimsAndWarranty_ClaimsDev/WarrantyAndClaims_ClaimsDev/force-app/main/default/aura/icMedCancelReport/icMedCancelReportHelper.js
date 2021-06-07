({
	doInit : function(component, event) {
		component.set("v.displaySpinner", true);

		var recordId = component.get("v.recordId");

		var action = component.get("c.cancelOrder");
		action.setParams({ recordId : recordId });
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseValue = response.getReturnValue();
				component.set("v.resultMessage", responseValue);
				component.set("v.displaySpinner", false);
			}
		});

		$A.enqueueAction(action);
	}
})