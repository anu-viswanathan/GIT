({
	doInit: function(component, event, helper) {
		helper.doInit(component, event);
	},
	
	navTo1 : function(component, event, helper) {
		helper.navTo1(component, event);
	},

	navTo2 : function(component, event, helper) {
		helper.navTo2(component, event);
	},

	navTo3 : function(component, event, helper) {
		helper.navTo3(component, event);
	},


	navTo1fr : function(component, event, helper) {
		helper.navTo1fr(component, event);
	},

	navTo2fr : function(component, event, helper) {
		helper.navTo2fr(component, event);
	},

	navTo3fr : function(component, event, helper) {
		helper.navTo3fr(component, event);
	},


	navToEnglish: function(component, event, helper){
		var cmpHideClass = component.find('VersionFR');
		var cmpShowClass = component.find('VersionEN');

		$A.util.addClass(cmpHideClass, 'hideContent');
		$A.util.removeClass(cmpShowClass, 'hideContent');


	},
	navToFrench: function (component, event, helper) {
		var cmpHideClass = component.find('VersionEN');
		var cmpShowClass = component.find('VersionFR');


		$A.util.addClass(cmpHideClass, 'hideContent');
		$A.util.removeClass(cmpShowClass, 'hideContent');

	}
})