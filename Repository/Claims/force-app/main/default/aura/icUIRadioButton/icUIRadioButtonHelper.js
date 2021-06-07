({
	doClick : function(component, event) {
		var thisValue = component.get("v.value");
		component.set("v.selected", thisValue);
	}
})