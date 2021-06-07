({
	handleSubscribeClick : function (component, event) {

		console.log("in handle subscribe click in helper");
		//component.set("v.displaySpinner", true);
		this.waiting(component);

		component.set("v.resultMessage", "");

		var eagleViewUserName = component.get("v.eagleViewUserName");
		var eagleViewPassword = component.get("v.eagleViewPassword");

		if(eagleViewUserName != undefined && eagleViewPassword != undefined
			&& eagleViewUserName != "" && eagleViewPassword != "") {
			var action = component.get("c.subscribe");
			action.setParams({ eagleviewUsername : eagleViewUserName, eagleviewPassword : eagleViewPassword });
			action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var responseValue = response.getReturnValue();
					if(responseValue.isSuccess) {
						component.set("v.subscribeResponse", responseValue.message);
					} else {
						component.set("v.resultMessage", responseValue.message);
					}
				}
				else {
					console.log('erreur : ' + JSON.stringify(response));
					component.set("v.resultMessage", JSON.stringify(response));
				}
				this.waiting(component);
			});

			$A.enqueueAction(action);
		} else {
			component.set("v.resultMessage", $A.get("$Label.c.icPlease_fill_in_your_eagle_view_username_and_password"));
			this.waiting(component);
		}
	},

	handleBackToOpportunityClick : function (component, event) {
        var recordId = decodeURIComponent(window.location.search.substring(1)).split('=')[1];
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/opportunity/' + recordId,
            "isredirect" :false
        });
        urlEvent.fire();
    },

	waiting : function(component) {
        var spinner = component.find("objSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    }
})

/*var recordId = decodeURIComponent(window.location.search.substring(1)).split('=')[1];*/