({
	doInit : function(component, event) {
        var today = new Date();
        
        component.set('v.thisYear', today.getFullYear());
	}
})