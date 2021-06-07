({
	doInit : function(component, event) {
		var userId = $A.get("$SObjectType.CurrentUser.Id");
		component.set("v.userId", userId);
	},

	doClick : function(component, event) {
		var firstName = component.get("v.firstName");
		var lastName = component.get("v.lastName");
		var email = component.get("v.email");
		var password = component.get("v.password");
		var confPassword = component.get("v.confPassword");

		if(this.validateForm(component, firstName, lastName, email, password, confPassword)) {
			var action = component.get("c.registerNew");

			action.setParams(
				{firstName:firstName
				,lastName:lastName
				,email:email
				,password:password
				,confirmPassword:confPassword}
			);

	        action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var responseValue = response.getReturnValue();

					var resultMessages = [];
					resultMessages.push(responseValue);
					component.set("v.resultMessages", resultMessages);
				}
	        });

	        $A.enqueueAction(action);
		}
	},

	validateForm : function(component, firstName, lastName, email, password, confPassword) {
		var isValid = true;
		var resultMessages = [];

		if(firstName === null || firstName === undefined) {
			resultMessages.push($A.get("$Label.c.icFirstNameRequired"));
			isValid = false;
		}

		if(lastName === null || lastName === undefined) {
			resultMessages.push($A.get("$Label.c.icLastNameRequired"));
			isValid = false;
		}

		if(email === null || email === undefined) {
			resultMessages.push($A.get("$Label.c.icEmailUserRequired"));
			isValid = false;
		}
        

		if(password === null || password === undefined
			|| confPassword === null || confPassword === undefined) {
			resultMessages.push($A.get("$Label.c.icPasswordRequired"));
			isValid = false;
		} else {
			if(password !== confPassword) {
				resultMessages.push($A.get("$Label.c.icPasswordsNoMatch"));
				isValid = false;
			}	
		}

		component.set("v.resultMessages", resultMessages);

		return isValid;
	}
})