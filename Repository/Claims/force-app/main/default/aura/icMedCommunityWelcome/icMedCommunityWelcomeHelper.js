({
	doInit : function(component, event) {
        // new code; call diff. method in same class (success)
		var action = component.get("c.getSummitBlogAuthDetails");
        
        /* old code; old method.
         * var action = component.get("c.getCurrentTheme");
         */
        
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseValue = response.getReturnValue();
                // new code; call diff. method in same class (success)
				component.set("v.currentTheme", responseValue.theme);
                
                
                /* old code; refers to existing method in same class (page fails)
				 * To test page : https://iko--c.visualforce.com/apex/icWelcome
                 * component.set("v.currentTheme", responseValue);
                 */
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
        var desktopUrl = $A.get("$Label.c.icMemberLoginUrl");
		this.doNav(component, "IKOPRO_My_Benefits_Dashboard", desktopUrl + "/?language=en-us");	},

	navTo2 : function (component, event) {
        var desktopUrl = $A.get("$Label.c.icStartApplicationUrl");
        this.doNav(component, "IKOPRO_My_Benefits_Dashboard", desktopUrl + "/?language=en-us" );
	},

	navTo3 : function (component, event) {
        var desktopUrl = $A.get("$Label.c.icContinueApplicationUrl");
        this.doNav(component, "IKOPRO_My_Benefits_Dashboard", desktopUrl + "/?language=en-us" );
	},

	navTo1fr : function (component, event) {
        var desktopUrl = $A.get("$Label.c.icMemberLoginUrl");
        this.doNav(component, "IKOPRO_My_Benefits_Dashboard", desktopUrl + "/?language=fr" );
	},

	navTo2fr : function (component, event) {
        var desktopUrl = $A.get("$Label.c.icStartApplicationUrl");
        this.doNav(component, "IKOPRO_My_Benefits_Dashboard", desktopUrl + "/?language=fr" );
	},

	navTo3fr : function (component, event) {
        var desktopUrl = $A.get("$Label.c.icContinueApplicationUrl");
        this.doNav(component, "IKOPRO_My_Benefits_Dashboard", desktopUrl + "/?language=fr" );
	},

    hideClass : function(component, hideClassName){
	   var cmpHideClass = component.find( hideClassName );
	   $A.util.addClass(cmpHideClass, 'hideContent');
    },
	navToEnglish: function(component, event){

		var cmpHideClass = document.getElementById('VersionEN');
		var cmpShowClass = document.getElementById('VersionFR');

		cmpHideClass.style.display="none!important;";
		cmpShowClass.style.display="unset!important";

		// this.doNav2(component, 'en');
        // console.log('btn works');
	},
	navToFrench: function (component, event) {
		var cmpHideClass = document.getElementById('VersionEN');
		var cmpShowClass = document.getElementById('VersionFR');

		cmpShowClass.style.display="none!important;";
		cmpHideClass.style.display="unset!important";
	},
})