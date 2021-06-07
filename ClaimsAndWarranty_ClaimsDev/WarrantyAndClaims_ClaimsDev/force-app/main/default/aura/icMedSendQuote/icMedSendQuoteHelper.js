({
	doInit : function(component, event) {
		component.set("v.displaySpinner", true);

		var recordId = component.get("v.recordId");

		var action = component.get("c.getQuoteFiles");
		action.setParams({ recordId : recordId });
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseValue = response.getReturnValue();
				component.set("v.fileOptions", responseValue);
				component.set("v.displaySpinner", false);
			}
		});

		$A.enqueueAction(action);
	},

	doSend : function(component, event) {
		var recordId = component.get("v.recordId");
		var selectedFileId = component.get("v.selectedFileId");

		var action = component.get("c.sendQuote");
		action.setParams({ recordId : recordId, quoteId : selectedFileId });
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseValue = response.getReturnValue();
				component.set("v.resultMessage", responseValue);
				component.set("v.displaySpinner", false);
				component.set("v.quoteSent", true);
			}
		});

		$A.enqueueAction(action);

		//$A.get('e.force:closeQuickAction').fire();
	},

	doClose : function(component, event) {
		$A.get('e.force:closeQuickAction').fire();
	}
})