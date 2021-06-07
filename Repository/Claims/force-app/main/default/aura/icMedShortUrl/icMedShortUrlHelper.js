({
	doInit : function(component, event) {
		var action = component.get("c.getShortUrlFromAccount");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseValue = response.getReturnValue();
				if (responseValue === null || responseValue === "") {
					responseValue = "n/a"
				}
				component.set("v.shortURL", responseValue);
			}
		});

		$A.enqueueAction(action);
	},

	doFetchShortURL : function(component, event) {
		component.set("v.displaySpinner", true);
		var action = component.get("c.getShortUrl");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseValue = response.getReturnValue();
				if (responseValue.startsWith("https://")) {
					component.set("v.shortURL", responseValue);
				}
				else {
					var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							"type": "error",
							"title": "Error!",
							"message": responseValue
						});
						toastEvent.fire();
				}
				component.set("v.displaySpinner", false);
			}
		});

		$A.enqueueAction(action);
	}
});