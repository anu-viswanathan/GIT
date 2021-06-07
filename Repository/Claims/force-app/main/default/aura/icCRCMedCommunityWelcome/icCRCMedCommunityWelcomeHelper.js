({
	doInit : function(component, event) {
		var action = component.get("c.getCurrentTheme");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseValue = response.getReturnValue();
				component.set("v.currentTheme", responseValue);
			}
		});
		$A.enqueueAction(action);
	},

	doNav : function (component, urlMobile, urlDesktop) {
		var currentTheme = component.get("v.currentTheme");
		var currentURL = window.location.href;

		if(currentTheme === "Theme4t" && currentURL.includes('bridge.app') ) {
			var evt = $A.get("e.force:navigateToComponent");
			evt.setParams({
				componentDef : "one:flexipage",
				componentAttributes: {
					flexiPageDeveloperName: urlMobile
				}
			});
			evt.fire();
		} else {
			window.open(urlDesktop,'_top');
		}

	},

	doNav2 : function (component, languageCode) {
		var currentLanguage = component.get("v.fullLanguageCode");
		console.log("current language is:" + currentLanguage);

        component.set(currentLanguage, languageCode);
        var target = event.getSource();
        component.set(currentLanguage, target.get("v.fullLanguageCode"))
        console.log("current language is:" + "v.fullLanguageCode");
		// var currentLanguage = component.get("v.fullLanguageCode");
	},

	navTo1 : function (component, event) {
        var desktopUrl = $A.get("$Label.c.icCRCMemberLoginUrl");
		this.doNav(component, "IKOPRO_My_Benefits_Dashboard", desktopUrl + "/?language=en-us");	},

	navTo2 : function (component, event) {
        var desktopUrl = $A.get("$Label.c.icCRCStartApplicationUrl");
        this.doNav(component, "IKOPRO_My_Benefits_Dashboard", desktopUrl + "/?language=en-us" );
	},

	navTo3 : function (component, event) {
        var desktopUrl = $A.get("$Label.c.icCRCContinueApplicationUrl");
        this.doNav(component, "IKOPRO_My_Benefits_Dashboard", desktopUrl + "/?language=en-us" );
	},
    
    hideClass : function(component, hideClassName){
	   var cmpHideClass = component.find( hideClassName );
	   $A.util.addClass(cmpHideClass, 'hideContent');
    },
	
})