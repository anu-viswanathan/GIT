/**
 * Created by Anil Mannem (Incloud) on 03-Aug-2020
 */
({
	doInit : function(cmp, event, helper) {
		let action = cmp.get("c.generatePDFandEmail");
		action.setParams({recordId: cmp.get('v.recordId')});
		action.setCallback(this, function(response) {
			let state = response.getState();
			if (state === "SUCCESS") {
				let msg = response.getReturnValue();
				console.log("Attachment saved successfully: "+ msg);
				if (!$A.util.isEmpty(msg)) {
					cmp.set("v.displaySpinner", false);
					cmp.set("v.msg", msg);
				} else {
					window.setTimeout(
						$A.getCallback(function() {
							cmp.set("v.msg", "Email Generated ...");
							// Close the action panel
							$A.get("e.force:closeQuickAction").fire();
						}), 600
					);
					window.setTimeout(
						$A.getCallback(function() {
							cmp.set("v.displaySpinner", false);
							// Close the action panel
							$A.get("e.force:closeQuickAction").fire();
						}), 1100
					);
				}
			} else if (state === "ERROR") {
				cmp.set("v.displaySpinner", false);
				let errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						cmp.set("v.msg", "An error encountered while process - " + errors[0].message);
						console.log("Error message: " +  errors[0].message);
					}
				}
			}
		});
		$A.enqueueAction(action);
		cmp.set("v.displaySpinner", true);
	}
})