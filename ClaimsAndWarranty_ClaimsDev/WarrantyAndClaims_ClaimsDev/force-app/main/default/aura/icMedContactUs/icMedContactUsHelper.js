({
	doInit : function(component,event,secId) {
		
		var action = component.get("c.getContactUsInfo");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseValue = response.getReturnValue();
				component.set("v.info", responseValue);
			} else {
				console.log('erreur : ' + JSON.stringify(response));
			}
		});

		$A.enqueueAction(action);
	}
})